import smplx
import pdb
import torch
import pickle
import trimesh
import tqdm
import pyrender
import numpy as np
import time
import glob
import argparse
import os
from copy import deepcopy
import matplotlib.cm as cm
from matplotlib import pyplot as plt
from matplotlib import colors
from matplotlib import cm as cmx
jet = plt.get_cmap('twilight')
cNorm  = colors.Normalize(vmin=0, vmax=1)
scalarMap = cmx.ScalarMappable(norm=cNorm, cmap=jet)

unity_to_zup = np.array(
            [[-1, 0, 0, 0],
             [0, 0, -1, 0],
             [0, 1, 0, 0],
             [0, 0, 0, 1]]
        )

shapenet_to_zup = np.array(
            [[1, 0, 0, 0],
             [0, 0, -1, 0],
             [0, 1, 0, 0],
             [0, 0, 0, 1]]
        )
def params2torch(params, dtype=torch.float32):
    return {k: torch.cuda.FloatTensor(v) if type(v) == np.ndarray else v for k, v in params.items()}
def params2numpy(params):
    return {k: v.detach().cpu().numpy() if type(v) == torch.Tensor else v for k, v in params.items()}

# visualize generated sequences given same start and target points


from scipy.spatial.transform import Rotation
def rollout_primitives(motion_primitives):
    smplx_param_list = []
    gender = motion_primitives[0]['gender']
    body_model = smplx.create(model_path=model_path,
                              model_type='smplx',
                              gender=gender,
                              use_pca=False,
                              batch_size=20,
                              ).to(device='cuda')
    for idx, motion_primitive in enumerate(motion_primitives):
        pelvis_original = body_model(betas=torch.cuda.FloatTensor(motion_primitive['betas']).repeat(20, 1)).joints[:, 0, :].detach().cpu().numpy()  # [10, 3]
        smplx_param = motion_primitive['smplx_params'][0]  #[10, 96]

        rotation = motion_primitive['transf_rotmat'].reshape((3, 3)) # [3, 3]
        transl = motion_primitive['transf_transl'].reshape((1, 3)) # [1, 3]
        smplx_param[:, :3] = np.matmul((smplx_param[:, :3] + pelvis_original), rotation.T) - pelvis_original + transl
        r_ori = Rotation.from_rotvec(smplx_param[:, 3:6])
        r_new = Rotation.from_matrix(np.tile(motion_primitive['transf_rotmat'], [20, 1, 1])) * r_ori
        smplx_param[:, 3:6] = r_new.as_rotvec()

        if idx == 0:
            start_frame = 0
        elif motion_primitive['mp_type'] == '1-frame':
            start_frame = 1
        elif motion_primitive['mp_type'] == '2-frame':
            start_frame = 2
        else:
            print(motion_primitive['mp_type'])
            # crowd-env use 1 frame model at the moment
            start_frame = 1
        smplx_param = smplx_param[start_frame:, :]
        smplx_param_list.append(smplx_param)


    return  np.concatenate(smplx_param_list, axis=0)  # [t, 96]


def vis_results_new(result_paths, vis_marker=False, vis_pelvis=True, vis_object=False,
                vis_navmesh=True, start_frame=0,
                slow_rate=1, save_path=None, add_floor=True):
    scene = pyrender.Scene()
    viewer = pyrender.Viewer(scene, use_raymond_lighting=True, run_in_thread=True,
                             record=True if save_path is not None else False)
    axis_node = pyrender.Node(mesh=pyrender.Mesh.from_trimesh(trimesh.creation.axis(), smooth=False), name='axis')
    viewer.render_lock.acquire()
    scene.add_node(axis_node)
    viewer.render_lock.release()
    # assume all have same wpath
    motions_list = []
    wpath = []
    wpath_orients = None
    target_orient = None
    object_mesh = None
    floor_height = 0
    for input_path in result_paths:
        with open(input_path, 'rb') as f:
            data = pickle.load(f)
            motions = data['motion']
            gender = motions[0]['gender']
            motions_list.append(motions)
            wpath.append(data['wpath'] if vis_pelvis else None)
            wpath_orients = data['wpath_orients'] if 'wpath_orients' in data else None
            target_orient = data['target_orient'] if 'target_orient' in data else None
            floor_height = data['floor_height'] if 'floor_height' in data else 0
            box = data['box'] if 'box' in data else None
            if vis_marker:
                if 'goal_markers' in data: # only target markers
                    markers = data['goal_markers']
                elif 'markers' in data: # start and target markers
                    markers = data['markers'].reshape(-1, 3)
                else:
                    markers = None
            else:
                markers = None
            if vis_object and object_mesh is None:
                if 'obj_path' in data:
                    y_up_to_z_up = np.eye(4)
                    y_up_to_z_up[:3, :3] = np.array(
                        [[1, 0, 0],
                         [0, 0, 1],
                         [0, 1, 0]]
                    )
                    object_mesh = trimesh.load(
                        data['obj_path']
                    )
                    object_mesh.apply_transform(y_up_to_z_up)
                elif 'scene_path' in data:
                    obj_path = data['scene_path']
                    if 'exploration' in str(obj_path):
                        obj_path = '/home/genli/Desktop/cvpr/gamma_interaction/data/scenes/test_exploration/7.80_6.34_1_1700921858.7392697.ply' 
                    object_mesh = trimesh.load(obj_path)
                    if 'obj_transform' in data:
                        object_mesh.apply_transform(data['obj_transform'])
                    if 'floor_height' in data:
                        object_mesh.vertices[:, 2] -= data['floor_height']
                else:
                    obj_id = data['obj_id']
                    transform = data['obj_transform']
                    if type(transform) == torch.Tensor:
                        transform = transform.detach().cpu().numpy()
                    if type(transform) == tuple:
                        transform = transform[0]
                    object_mesh = trimesh.load(
                        os.path.join(*([shapenet_dir] + (obj_id.split('-') if '-' in obj_id else obj_id.split('_')) + ['models', 'model_normalized.obj'])),
                        force='mesh'
                    )
                    # print(type(transform))
                    # print(transform)
                    object_mesh.apply_transform(transform)

                m = pyrender.Mesh.from_trimesh(object_mesh)
                object_node = pyrender.Node(mesh=m, name='object')
                viewer.render_lock.acquire()
                scene.add_node(object_node)
                viewer.render_lock.release()
                if 'navmesh_path' in data and vis_navmesh:
                    navmesh = trimesh.load(data['navmesh_path'], force='mesh')
                    if 'obj' in str(data['navmesh_path']):
                        navmesh.apply_transform(unity_to_zup)
                    else:
                        # navmesh.vertices[:, 2] += 0.2
                        pass
                    navmesh.visual.vertex_colors = np.array([0, 0, 200, 20])
                    navmesh_node = pyrender.Node(mesh=pyrender.Mesh.from_trimesh(navmesh), name='navmesh')
                    viewer.render_lock.acquire()
                    scene.add_node(navmesh_node)
                    viewer.render_lock.release()
                # TODO
                # path = path_find(navmesh, np.array([data['wpath'][0][0], data['wpath'][0][1], 0]), np.array([data['wpath'][1][0], data['wpath'][1][1], 0]))
                # path_len = 0
                # for idx in range(len(path) - 1):
                #     path_len += np.linalg.norm(path[idx + 1] - path[idx])
                # print('path finding: ', path_len)

    if add_floor:
        viewer.render_lock.acquire()
        floor = trimesh.creation.box(extents=np.array([20, 20, 0.01]),
                                     transform=np.array([[1.0, 0.0, 0.0, 0],
                                                         [0.0, 1.0, 0.0, 0],
                                                         [0.0, 0.0, 1.0, floor_height-0.005],
                                                         [0.0, 0.0, 0.0, 1.0],
                                                         ]),
                                     )
        floor.visual.vertex_colors = [0.8, 0.8, 0.8]
        floor_node = pyrender.Node(mesh=pyrender.Mesh.from_trimesh(floor), name='floor')
        scene.add_node(floor_node)
        viewer.render_lock.release()

    body_model = smplx.create(model_path=model_path,
                              model_type='smplx',
                              gender=gender,
                              use_pca=False,
                              batch_size=len(motions_list),
                              ).to(device)
    pelvis_nodes = []
    if vis_pelvis:
        for idx, ww in enumerate(wpath): 
            sm = trimesh.creation.uv_sphere(radius=0.05)
            sm.visual.vertex_colors = np.asarray(scalarMap.to_rgba(idx / len(wpath))[:3]) * 255#color[idx]
            tfs = np.tile(np.eye(4), (1, 1, 1))
            tfs[:, :3, 3] = ww[0]
            m = pyrender.Mesh.from_trimesh(sm, poses=tfs)
            start_node = pyrender.Node(mesh=m, name='start')
            sm = trimesh.creation.uv_sphere(radius=0.05)
            sm.visual.vertex_colors = np.asarray(scalarMap.to_rgba(idx / len(wpath))[:3]) * 255# color[idx]
            tfs = np.tile(np.eye(4), (1, 1, 1))
            tfs[:, :3, 3] = ww[-1]
            m = pyrender.Mesh.from_trimesh(sm, poses=tfs)
            target_node = pyrender.Node(mesh=m, name='target')
            pelvis_nodes = [start_node, target_node]
            if len(ww) > 2:
                sm = trimesh.creation.uv_sphere(radius=0.05)
                sm.visual.vertex_colors = [1.0, 0.0, 0.0]
                tfs = np.tile(np.eye(4), (len(ww) - 2, 1, 1))
                tfs[:, :3, 3] = ww[1:-1]
                m = pyrender.Mesh.from_trimesh(sm, poses=tfs)
                middle_node = pyrender.Node(mesh=m, name='middle')
                pelvis_nodes.append(middle_node)
            if wpath_orients is not None:
                from scipy.spatial.transform import Rotation as R
                for point_idx in range(len(wpath_orients)):
                    trans_mat = np.eye(4)
                    trans_mat[:3, 3] = ww[point_idx]
                    trans_mat[:3, :3] = R.from_rotvec(wpath_orients[point_idx]).as_matrix()
                    point_axis = trimesh.creation.axis(transform=trans_mat)
                    pelvis_nodes.append(pyrender.Node(mesh=pyrender.Mesh.from_trimesh(point_axis, smooth=False)))
            if target_orient is not None:
                from scipy.spatial.transform import Rotation as R
                trans_mat = np.eye(4)
                trans_mat[:3, 3] = ww[-1]
                trans_mat[:3, :3] = R.from_rotvec(target_orient).as_matrix()
                point_axis = trimesh.creation.axis(transform=trans_mat)
                pelvis_nodes.append(pyrender.Node(mesh=pyrender.Mesh.from_trimesh(point_axis, smooth=False)))

            viewer.render_lock.acquire()
            for pelvis_node in pelvis_nodes:
                scene.add_node(pelvis_node)
            viewer.render_lock.release()

    if vis_marker and markers is not None:
        sm = trimesh.creation.uv_sphere(radius=0.02)
        sm.visual.vertex_colors = [1.0, 0.0, 0.0]
        tfs = np.tile(np.eye(4), (len(markers), 1, 1))
        tfs[:, :3, 3] = markers
        m = pyrender.Mesh.from_trimesh(sm, poses=tfs)
        marker_node = pyrender.Node(mesh=m, name='goal_markers')
        # goal_node = pyrender.Node(mesh=pyrender.Mesh.from_points(goal_markers, colors=np.ones_like(goal_markers) * np.array([0.0, 0.0, 1.0])), name='goal_markers')
        viewer.render_lock.acquire()
        scene.add_node(marker_node)
        viewer.render_lock.release()

    if box is not None:
        extents = box[1] - box[0]
        transform = np.eye(4)
        transform[:3, 3] = 0.5 * (box[0] + box[1])
        box_mesh = trimesh.creation.box(extents=extents,
                             transform=transform,
                                        vertex_color=(255, 255, 0))
        m = pyrender.Mesh.from_trimesh(box_mesh)
        box_node = pyrender.Node(mesh=m, name='box')
        viewer.render_lock.acquire()
        scene.add_node(box_node)
        viewer.render_lock.release()

    num_sequences = len(motions_list)
    rollout_frames_list = [rollout_primitives(motions) for motions in motions_list]
    print(np.array([len(frames) for frames in rollout_frames_list]))
    max_frame = np.array([len(frames) for frames in rollout_frames_list]).max()

    rollout_frames_pad_list = []  # [T_max, 93], pad shorter sequences with last frame
    for idx in range(len(rollout_frames_list)):
        frames = rollout_frames_list[idx]
        rollout_frames_pad_list.append(np.concatenate([frames, np.tile(frames[-1:, :], (max_frame + 1 - frames.shape[0], 1))], axis=0))
    smplx_params = np.stack(rollout_frames_pad_list, axis=0)  # [S, T_max, 93]
    betas = [motions[0]['betas'] for motions in motions_list]
    betas = np.stack(betas, axis=0)  # [S, 10]
    body_node = None
    transls = []
    global_orients = []
    body_poses = []
    for frame_idx in tqdm.tqdm(range(start_frame, max_frame)):
        transls.append(smplx_params[:, frame_idx, :3])
        global_orients.append(smplx_params[:, frame_idx, 3:6])
        body_poses.append(smplx_params[:, frame_idx, 6:69])
        smplx_dict = {
            'betas': betas,
            'transl': smplx_params[:, frame_idx, :3],
            'global_orient': smplx_params[:, frame_idx, 3:6],
            'body_pose': smplx_params[:, frame_idx, 6:69],
        }
        smplx_dict = params2torch(smplx_dict)

        output = body_model(**smplx_dict)
        vertices = output.vertices.detach().cpu().numpy()
        body_meshes = []
        for seq_idx in range(vertices.shape[0]):
            m = trimesh.Trimesh(vertices=vertices[seq_idx], faces=body_model.faces, process=False)
            m.visual.vertex_colors[:, 3] = 160
            # m.visual.vertex_colors[:, :3] = int((seq_idx / vertices.shape[0]) * 255)
            m.visual.vertex_colors[:, :3] = np.asarray(scalarMap.to_rgba(seq_idx / vertices.shape[0])[:3]) * 255
            # print('seq ', result_paths[seq_idx], np.asarray(scalarMap.to_rgba(seq_idx / vertices.shape[0])[:3]) * 255)
            body_meshes.append(m)
            # m.export("/home/genli/Desktop/egogenhumanmeshes/%d.ply" % frame_idx)
        body_mesh = pyrender.Mesh.from_trimesh(body_meshes, smooth=False)
        viewer.render_lock.acquire()
        if body_node is not None:
            scene.remove_node(body_node)
        body_node = pyrender.Node(mesh=body_mesh, name='body')
        scene.add_node(body_node)
        viewer.render_lock.release()
        time.sleep(0.025 * slow_rate)
    # with open('/home/genli/Desktop/HOOD/hood_data/aux_data/egogen2.pkl', 'wb') as f:
    #     pickle.dump({"body_pose": np.array(body_poses)[:,0,:],
    #                  "global_orient": np.array(global_orients)[:,0,:],
    #                  "transl": np.array(transls)[:,0,:],
    #                  "betas": betas[0]}, f)
    print("max depth: ", len(motions_list[0]))
    dist = 0.
    speed = []
    for kk in range(len(transls) - 1):
        dist += np.linalg.norm(transls[kk+1] - transls[kk])
        speed.append(np.linalg.norm(transls[kk+1] - transls[kk]) / 0.025)
    print("walking dist : ", dist)


    if save_path is not None:
        viewer.close_external()
        viewer.save_gif(os.path.join(save_path, "%s.gif" % time.time()))

def vis_optim():
    input_dir = "/home/kaizhao/projects/gamma/results/tmp123/GAMMAVAECombo_optim/MPVAE_babel_gen"
    file_paths = sorted(glob.glob(input_dir + '/motion*.pkl'))
    vis_results(result_paths=file_paths[:args.max_vis], vis_marker=True, vis_pelvis=False)

def vis_tree_search():
    input_dir = "/home/kaizhao/projects/gamma/results/tmp222/GAMMAVAEComboPolicy_PPO_demo/MPVAE_babel_gen/"
    file_paths = sorted(glob.glob(input_dir + '/*/*.pkl'))
    vis_results(result_paths=file_paths[:args.max_vis], vis_pelvis=True, vis_marker=False)

def vis_policy_train(epoch=0):
    # input_dir = "/home/kaizhao/projects/gamma/results/exp_GAMMAPrimitive/MPVAEPolicy_babel_collision/general_noclip_depth30/results/epoch" + str(epoch)
    # input_dir = "/home/kaizhao/projects/gamma/results/exp_GAMMAPrimitive/MPVAEPolicy_babel_marker/sit_2frame_test/results/epoch" + str(epoch)
    # input_dir = "/home/kaizhao/projects/gamma/results/exp_GAMMAPrimitive/MPVAEPolicy_lie_marker/bidir_lie_newmp_pene0.2_kl10_vel2_1/results/epoch" + str(epoch)
    # input_dir = "/home/kaizhao/projects/gamma/results/exp_GAMMAPrimitive/MPVAEPolicy_babel_locomotion/locomotion_dense_sigma1_newvp/results/epoch" + str(epoch)
    # input_dir = "/mnt/atlas_root/vlg-nfs/kaizhao/gamma/results/exp_GAMMAPrimitive/MPVAEPolicy_lie_marker/bidir_lie_newmp_pene0_kl10/results/epoch" + str(epoch)
    input_dir = "/mnt/atlas_root/vlg-nfs/kaizhao/gamma/results/exp_GAMMAPrimitive/MPVAEPolicy_babel_marker/overfit_sit_down_far/results/epoch" + str(epoch)
    # input_dir = "/home/kaizhao/projects/gamma/results/exp_GAMMAPrimitive/MPVAEPolicy_babel_walk_collision/map_babel_walk/results/epoch" + str(epoch)
    # input_dir = "/mnt/atlas_root/vlg-nfs/kaizhao/gamma/results/exp_GAMMAPrimitive/MPVAEPolicy_samp_collision/box_far_samp_batchfix_pene4/results/epoch" + str(epoch)
    result_paths = sorted(glob.glob(input_dir + '/*.pkl'))
    save_path = os.path.join(input_dir, str(epoch) + '.gif')
    print(save_path)
    vis_results(result_paths=result_paths[:args.max_vis], vis_marker='marker' in input_dir,
                slow_rate=args.slow_rate,
                vis_pelvis=True,
                vis_object='collision' in input_dir or 'sitting' in input_dir or 'marker' in input_dir,
                add_floor=True,
                # save_path=save_path
                )

def vis_policy_test(env_id='0'):
    input_dir = "/home/kaizhao/projects/gamma/results/exp_GAMMAPrimitive/MPVAEPolicy_babel_orient/orient0_early_stop/results/"
    # input_dir = "/mnt/atlas_root/vlg-nfs/kaizhao/gamma/results/exp_GAMMAPrimitive/MPVAEPolicy_babel/checkpoints/sit_close_sequence/results/epoch" + str(epoch)
    result_paths = sorted(glob.glob(input_dir + 'env' + str(env_id) + '/*.pkl'))
    save_path = os.path.join(input_dir, str(env_id) + '.gif')
    vis_results(result_paths=result_paths[:args.max_vis], vis_marker=False,
                slow_rate=args.slow_rate,
                vis_pelvis=True, vis_object=False,
                # save_path=save_path
                )

def vis_interaction():
    # input_dir = "/home/kaizhao/projects/gamma/results/two_stage/pene1_16_8_64/"
    input_dir = "/home/kaizhao/projects/gamma/results/interaction_test/test_lie"
    result_paths = sorted(glob.glob(input_dir + '/*/*.pkl'))
    vis_results(result_paths=result_paths[:args.max_vis], vis_marker=True, vis_pelvis=True, vis_object=True)

def compare_search_optim():
    input_dir = "/home/kaizhao/projects/gamma/results/two_stage/search2/randseed000_seq000_sit/"
    result_paths = sorted(glob.glob(input_dir + '/*/*.pkl'))
    print(result_paths)
    vis_results(result_paths=result_paths, slow_rate=1,
                vis_marker=False, vis_pelvis=True, vis_object=True)

def vis_follow_path_search():
    input_dir = "/home/kaizhao/projects/gamma/results/two_stage/orient_test_3/randseed000_seq000_sit/"
    result_paths = sorted(glob.glob(input_dir + '/*/*.pkl'))
    print(result_paths)
    vis_results(result_paths=result_paths, slow_rate=1,
                vis_marker=False, vis_pelvis=True, vis_object=True)

def vis_scene_nav():
    input_dir = '/home/kaizhao/projects/gamma/results/locomotion/room_0/door_to_stool/MPVAEPolicy_samp_collision/reward_fix/policy_only'
    # input_dir = '/home/kaizhao/projects/gamma/results/locomotion/6.19_9.29_0_1675853250.9970315/MPVAEPolicy_samp_collision/reward_fix/path9/policy_only'
    # input_dir = '/home/kaizhao/projects/gamma/results/locomotion/room_0/MPVAEPolicy_samp_collision/reward_fix/path_behind/policy_search'
    # input_dir = "/home/kaizhao/projects/gamma/results/locomotion/room_0/MPVAEPolicy_babel_locomotion/locomotion_nonstatic1_sigma5e-1/path_turn/policy_only"
    # input_dir = "/home/kaizhao/projects/gamma/results/locomotion/room_0/MPVAEPolicy_babel_orient/path_turn/policy_trained"
    # input_dir = "/home/kaizhao/projects/gamma/results/interaction/room_0/MPVAEPolicy_babel_sitting/sit_orient_general/path_turn/randseed000_seq003"
    # input_dir = "/home/kaizhao/projects/gamma/results/interaction/room_0/MPVAEPolicy_babel_sitting/sit_orient_general/path_turn/randseed000_seq002"
    result_paths = sorted(glob.glob(input_dir + '/*/*.pkl'))
    print(result_paths)
    vis_results(result_paths=result_paths, slow_rate=1,
                vis_navmesh=True,
                vis_marker=False, vis_pelvis=True, vis_object=True, add_floor=False)

parser = argparse.ArgumentParser()
parser.add_argument('--epoch', type=int, default=0)
parser.add_argument('--env', type=str, default='0')
parser.add_argument('--slow_rate', type=int, default=1)
parser.add_argument('--path', type=str, default='')
parser.add_argument('--start_frame', type=int, default=0)
parser.add_argument('--max_vis', type=int, default=8, help="maximum number of sequences to be visualized")
args = parser.parse_args()

model_path = "data/smplx/models"
shapenet_dir = '/mnt/atlas_root/vlg-data/ShapeNetCore.v2/'
device = torch.device('cuda')

# vis_optim()
# vis_tree_search()
# vis_policy_train(epoch=args.epoch)
# vis_policy_test(env_id=args.env)
# for env_id in range(16):
#     vis_policy_test(env_id=str(env_id))
# vis_interaction()
# compare_search_optim()
# vis_follow_path_search()
# vis_scene_nav()

vis_results_new(
list(glob.glob(
    # 'results/exp_GAMMAPrimitive/MPVAEPolicy_samp_collision/box_obstacle_samp/results/epoch7000/motion_00.pkl'
    # '/home/genli/Desktop/gamma_interaction/results/exp_GAMMAPrimitive/MPVAEPolicy_samp_collision/map_kl10_batchfix_pene1/results/epoch0/motion_00.pkl'
    # '/home/genli/Desktop/gamma_interaction/results/crowd/MPVAEPolicy_samp_collision/collision_test/results/test/motion_263278.pkl'
    # "/home/genli/Desktop/gamma_interaction/results/crowd_ppo/MPVAEPolicy_samp_collision/collision_test/results/test-ppo-body-pene-skate0.3-newrdist-suc0.5/motion_%s.pkl" % args.path
    # "/home/genli/Desktop/gamma_interaction/results/crowd_ppo/MPVAEPolicy_samp_collision/collision_test/results/test-look-at/motion_%s.pkl" % args.path
    # "/home/genli/Desktop/gamma_interaction/results/crowd_ppo/MPVAEPolicy_samp_collision/collision_test/results/test-egobody/motion_egobody_0.pkl"
    # "/home/genli/Desktop/gamma_2f_kaifeng/log_crowd2f/collision-avoidance/ppo/lookat/0/230517-001845/test-2f-success/%s" % args.path
    # "/mnt/scratch/genli/crowd-eval-results/1/*"
    # "/home/genli/Desktop/eval_model/8/results/crowd_ppo/MPVAEPolicy_samp_collision/collision_test/results/demo/*.pkl"
    # "/mnt/scratch/genli/eval-results-new/1/motion_%s.pkl" % args.path
    # "/home/genli/Desktop/eval_model/replica_2/results/crowd_ppo/MPVAEPolicy_samp_collision/collision_test/results/demo/*%s.pkl" % args.path
    # "/home/genli/Desktop/ablate/time.pkl"
    # "/home/genli/Desktop/siggraphasia/rebuttal/EgoGen/2f_ego/results/crowd_ppo/MPVAEPolicy_samp_collision/collision_test/results/test-2frame-egosensing-eval/motion_*%s.pkl" % args.path
    # '/home/genli/Desktop/siggraphasia/rebuttal/EgoGen/2f_random_shape/results/crowd_ppo/MPVAEPolicy_amass_collision/results/test-2frame-amass-dep11/motion_*%s.pkl' % args.path
    # "/home/genli/Desktop/siggraphasia/rebuttal/EgoGen/2f/tmp/test-2frame-egosensing-biggerdep/motion_*%s.pkl" % args.path
    # "/mnt/scratch/genli/vis_res/motion_*%s.pkl" % args.path
    # "/home/genli/Desktop/siggraphasia/rebuttal/EgoGen/2f_ego/results/crowd_ppo/MPVAEPolicy_samp_collision/collision_test/results/test-2frame-egosensing-box-eval/motion*%s.pkl" % args.path
    # "/home/genli/Desktop/siggraphasia/rebuttal/EgoGen/2f_random_shape/results/crowd_ppo/MPVAEPolicy_amass_collision/results/test-2frame-amass-dep11/motion*%s.pkl" % args.path
    # "/mnt/scratch/genli/test-2frame-amass-dep11/*%s.pkl" % args.path
    # "/home/genli/Desktop/siggraphasia/rebuttal/EgoGen/2f_random_shape/results/crowd_ppo/MPVAEPolicy_amass_collision/results/test-2frame-amass-dep11-strange-neck/motion*%s.pkl" % args.path
    # "/mnt/scratch/genli/test-2frame-egosensing-box-sac/motion*%s.pkl" % args.path
    # "/home/genli/Desktop/cvpr/EgoGen/2f_ego/results/crowd_ppo/MPVAEPolicy_samp_collision/collision_test/results/test-2frame-egosensing-box-notime/motion*%s.pkl" % args.path
    # "/mnt/scratch/genli/vis_res_room0/motion*%s.pkl" % args.path
    # "/home/genli/Desktop/svae/*/motion_*%s.pkl" % args.path
    args.path
    # "%s" %args.path
    # "/home/genli/Desktop/demo/*.pkl"
    # "/home/genli/Desktop/ablate/motion_egobody_1684703635.3525717.pkl"
    
    # 'results/locomotion/apartment_1/through_door/MPVAEPolicy_samp_collision/*_kl10_*/policy_search/seq000/*.pkl'
    # 'results/locomotion/apartment_1/around_table/MPVAEPolicy_samp_collision/*_kl10_*/policy_search/seq000/*.pkl'
    # 'results/exp_GAMMAPrimitive/MPVAEPolicy_samp_collision/map_kl10_*/policy_search/seq000/*.pkl'
    # '/home/kaizhao/projects/gamma/results/interaction/Sofas_277231dcb7261ae4a9fe1734a6086750/compare_2_lie_up_6/MPVAEPolicy_lie_marker/bidir_lie_newmp_pene0.2_kl10_batchfix/policy_search/seq000/results_ssm2_67_condi_marker_inter_0.pkl'

    # 'results/interaction/apartment_1/sit_sofa_7_*_down/MPVAEPolicy_babel_marker/sit_2frame_test/policy_search/seq000/results_ssm2_67_condi_marker_inter_0.pkl'
    # 'results/interaction/apartment_1/lie_sofa_7_0_down/MPVAEPolicy_lie_marker/bidir_lie_newmp_pene0.2_kl10_batchfix/policy_search/seq000/results_ssm2_67_condi_marker_inter_0.pkl'
    # 'results/locomotion/apartment_1/around_table_*/MPVAEPolicy_samp_collision/map_kl10_batchfix_pene1/policy_search/seq000/results_ssm2_67_condi_marker_map_0.pkl'

    # '/home/kaizhao/projects/gamma/results/interaction/room_0/sit_sofa_9_8_down/MPVAEPolicy_babel_marker/sit_2frame_test/policy_search/seq000/results_ssm2_67_condi_marker_inter_0.pkl'
    # '/results/interaction/room_0/sit_sofa_9_12_down/MPVAEPolicy_babel_marker/sit_2frame_test/policy_search/seq000/results_ssm2_67_condi_marker_inter_0.pkl'
    # 'results/interaction/room_0/lie_sofa_77_0_down/MPVAEPolicy_lie_marker/bidir_lie_newmp_pene0.2_kl10_batchfix/policy_search/seq000/results_ssm2_67_condi_marker_inter_0.pkl'
    # 'results/interaction/StraightChairs_68dc37f167347d73ea46bea76c64cc3d/compare_new_0_sit_up_6/MPVAEPolicy_babel_marker/bidir_contactfeet2_kl10_batchfix/policy_search/seq000/results_ssm2_67_condi_marker_inter_0.pkl'
))[:args.max_vis],
            start_frame=args.start_frame,
            vis_navmesh=False,
            vis_marker=True, vis_pelvis=True, vis_object=True, add_floor=True,
            slow_rate=args.slow_rate
            )

# vis_results_new(
#     list(glob.glob('results/locomotion/loco_demo/to_bed/MPVAEPolicy_samp_collision/map_kl10_batchfix_pene1/policy_search/seq002/*.pkl')),
# start_frame=args.start_frame,
#             vis_navmesh=True,
#             vis_marker=False, vis_pelvis=True, vis_object=True, add_floor=False,
#             slow_rate=args.slow_rate
#                 )
