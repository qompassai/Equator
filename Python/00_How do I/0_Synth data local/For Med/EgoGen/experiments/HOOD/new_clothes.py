import os
from utils.mesh_creation import add_garment_to_garments_dict, add_pinned_verts
from utils.defaults import DEFAULTS

pinned = {
    "rp_aaron_posed_009": [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 145, 161, 162, 163, 164, 165, 166, 167, 191, 209, 216, 217, 218, 220, 231, 239, 245, 778, 807],
    "rp_aaron_posed_013": [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 128, 191, 192, 193, 194, 210, 211, 212, 213, 216, 222, 223, 232, 233, 239, 241, 251, 272, 273, 274, 275, 276, 329, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 355, 356, 374, 387, 388],
    "rp_ethan_posed_015": [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 43, 44, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 573, 574, 603, 654, 656, 657, 662, 666, 696, 713, 718, 720, 740, 746, 747, 748, 754, 755, 775, 776, 777, 786, 793, 795, 803, 804, 816, 824, 825, 838, 860, 865, 884, 885, 904, 927, 3203, 3204, 3246, 3252, 3253, 3256, 3263, 3265, 3271, 3311, 3312, 3401, 3576, 3582, 3620, 3621, 3622, 3643, 3685, 3694, 3699, 3717, 3722, 3724, 3801, 3802, 3814, 3836, 3880],
    "rp_henry_posed_001": [12397, 12423, 12424, 12425, 12426, 12427, 12428, 12429, 12430, 12431, 12432, 12433, 12434, 12435, 12436, 12437, 12438, 12439, 12440, 12441, 12442, 12443, 12444, 12445, 12446, 12447, 12448, 12449, 12450, 12451, 12452, 12453, 12454, 12455, 12456, 12457, 12458, 12459, 12460, 12461, 12462, 12463, 12464, 12467, 12468, 12469, 12470, 12471, 12472, 12473, 12474, 12475, 12476, 12477, 12478, 12479, 12480, 12481, 12482, 12483, 12484, 12485, 12486, 12487, 12488, 12489, 12490, 12491, 12492, 12493, 12494, 12495, 12496, 12497, 12498, 12499, 12500, 12501, 12502, 12592, 12593, 12594, 12595, 12596, 12597, 12598, 12599, 12611, 12612, 12613, 12614, 12615, 12616, 12629, 12630, 12631, 12632, 12656, 12657, 12663, 12687, 12692, 12733, 12738, 12741, 12743, 12745, 12751, 12752, 12754, 12757, 12758, 12778, 12780, 12781, 12782, 12788, 12789, 12795, 12797, 12799, 12801, 12802, 12813, 12828, 12829, 12830, 12837, 12843, 12845, 12846, 12852, 12853, 12856, 12861, 12862, 12874, 12875, 12876, 12878, 12879, 12880, 12898, 12904, 12908, 12909, 12910, 12916, 12923, 12925, 12927, 12929, 12933, 12934, 12935, 12939, 12941, 12943],
    "rp_alexandra_posed_025": [12351, 12352, 12354, 12357, 12358, 12359, 12360, 12361, 12362, 12363, 12364, 12365, 12366, 12367, 12368, 12369, 12370, 12371, 12372, 12373, 12374, 12375, 12376, 12377, 12378, 12379, 12380, 12381, 12382, 12383, 12384, 12385, 12386, 12387, 12388, 12389, 12390, 12391, 12392, 12393, 12394, 12395, 12396, 12397, 12398, 12399, 12400, 12401, 12402, 12403, 12404, 12405, 12406, 12407, 12408, 12409, 12410, 12411, 12412, 12413, 12414, 12415, 12416, 12417, 12418, 12419, 12420, 12421, 12422, 12423, 12424, 12425, 12426, 12427, 12428, 12429, 12430, 12431, 12432, 12434, 12435, 12436, 12437, 12438, 12439, 12440, 12441, 12442, 12535, 12553, 12565, 12581, 12590, 12592, 12593, 12594, 12651, 12652, 12653, 12654, 12655, 12661, 12662, 12663, 12664, 12668, 12669, 12670, 12684, 12685, 12688, 12707, 12711, 12712, 12713, 12718, 12719, 12720, 12722, 12727, 12740, 12741, 12744, 12745, 12748, 12749, 12752, 12755, 12756, 12757, 12758, 12759, 12765, 12766, 12769, 12770, 12775, 12776, 12780, 12781, 12807, 12814, 12821, 12827, 12832, 12833, 12834, 12841, 12856, 12858, 12861, 12868, 12871, 12872, 12891, 12902, 12903, 12904, 12913, 12914, 12923, 12925, 12936, 12937, 12941, 12942, 12943, 12957, 12961, 12971, 12974, 12976, 12979, 12989, 13014, 13016, 13028, 13043, 13079, 13082, 13088],
    "rp_cindy_posed_020": [2875, 2876, 2877, 2878, 2879, 2880, 2881, 2882, 2883, 2884, 2885, 2886, 2887, 2888, 2889, 2890, 2891, 2892, 2893, 2894, 2895, 2896, 2897, 2898, 2899, 2900, 2901, 2902, 2903, 2904, 2905, 2906, 2907, 2908, 2909, 2910, 2911, 2912, 2913, 2914, 2915, 2916, 2917, 2918, 2919, 2920, 2921, 2922, 2923, 2924, 2925, 2926, 2927, 2928, 2929, 2930, 2931, 2932, 2933, 2934, 2935, 2936, 2937, 2938, 2939, 2940, 2941, 2942, 2943, 2944, 2945, 2946, 2947, 2948, 2949, 2950, 2951, 2952, 2953, 2954, 2955, 2956, 2957, 2958, 2959, 2960, 2961, 2962, 2963, 2964, 2965, 2966, 2967, 2968, 2969, 2970, 2971, 2972, 2973, 2974, 2975, 3060, 3066, 3067, 3068, 3074, 3075, 3076, 3080, 3081, 3082, 3111, 3119, 3120, 3121, 3125, 3126, 3129, 3133, 3134, 3138, 3140, 3141, 3142, 3148, 3149, 3151, 3152, 3153, 3164, 3165, 3174, 3176, 3180, 3181, 3184, 3185, 3187, 3191, 3192, 3193, 3197, 3198, 3199, 3200, 3203, 3204, 3207, 3212, 3213, 3214, 3237, 3240, 3244, 3245, 3246, 3252, 3264, 3270, 3275, 3276, 3280, 3281, 3285, 3287, 3288, 3289, 3290, 3293, 3295, 3299, 3300, 3301, 3302, 3305, 3306, 3309, 3310, 3315, 3316, 3319, 3320, 3323, 3327, 3328, 3330, 3334, 3337, 3338, 3341, 3345, 3346, 3347, 3350, 3351, 3353, 3354, 3357, 3358, 3362, 3368, 3370, 3371, 3372, 3376],
    "rp_claudia_posed_020": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 226, 234, 270, 274, 307, 314, 328, 341, 381, 383, 386, 388, 390, 397, 398, 405, 410, 411, 412, 413, 417, 418, 419, 421, 445, 447, 448, 449, 450, 451, 453, 454, 455, 457, 459, 461, 463, 464, 466, 467, 471, 478, 479, 480, 481, 487, 491, 492, 493, 494, 501, 502, 503, 504, 505, 506, 531, 568, 573, 574, 575, 586, 588, 589, 590, 592, 596, 608, 619],
    "rp_aneko_posed_011": [8264, 8265, 8266, 8267, 8268, 8269, 8270, 8271, 8272, 8273, 8274, 8275, 8276, 8277, 8278, 8279, 8280, 8281, 8282, 8283, 8284, 8285, 8286, 8287, 8288, 8289, 8290, 8291, 8292, 8293, 8294, 8295, 8296, 8297, 8298, 8299, 8300, 8301, 8302, 8303, 8304, 8305, 8306, 8307, 8308, 8309, 8310, 8311, 8312, 8313, 8314, 8315, 8316, 8317, 8318, 8319, 8320, 8321, 8322, 8323, 8324, 8325, 8326, 8327, 8328, 8329, 8330, 8331, 8332, 8333, 8334, 8335, 8336, 8337, 8338, 8339, 8340, 8341, 8342, 8343, 8344, 8345, 8346, 8468, 8483, 8485, 8495, 8497, 8501, 8504, 8507, 8540, 8541, 8542, 8545, 8549, 8550, 8555, 8562, 8563, 8564, 8566, 8567, 8569, 8572, 8579, 8587, 8589, 8590, 8591, 8592, 8599, 8600, 8601, 8602, 8609, 8610, 8614, 8615, 8616, 8622, 8636, 8650, 8658, 8661, 8662, 8666, 8667, 8683, 8684, 8693, 8694, 8695, 8696, 8712, 8717, 8718, 8719, 8722, 8723, 8724, 8728, 8729, 8733, 8734, 8737, 8741, 8750, 8753, 8755, 8760, 8762, 8764, 8765, 8784, 8795, 8802, 8807, 8811, 8816, 8819, 8821, 8826, 8829, 8830, 8832, 8833, 8835, 8838, 8840, 8861]
    }

# for name in ["rp_aaron_posed_009", "rp_aaron_posed_013", "rp_ethan_posed_015", "rp_henry_posed_001"]:
# for name in ['rp_alexandra_posed_025', 'rp_cindy_posed_020', 'rp_claudia_posed_020']:
for name in ['rp_aneko_posed_011']:

    garment_obj_path = os.path.join('/mnt/vlg-nfs/genli/datasets/bedlam/clothing_meshes/', name, 'pant.obj')
    smpl_file = os.path.join(DEFAULTS.aux_data, 'smpl', 'SMPLX_FEMALE.npz')
    garments_dict_path = '/mnt/vlg-nfs/genli/datasets/bedlam/garments_dict.pkl' 

    # Name of the garment we are adding
    garment_name = name + '_pant'


    add_garment_to_garments_dict(os.path.join('/mnt/vlg-nfs/genli/datasets/bedlam/clothing_meshes/', name, 'top.obj'), garments_dict_path, name + '_top', smpl_file=smpl_file, n_samples_lbs=0, verbose=True)

    add_garment_to_garments_dict(garment_obj_path, garments_dict_path, garment_name, smpl_file=smpl_file, n_samples_lbs=0, verbose=True)
    # pinned_indices = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 118, 128, 188, 191, 192, 193, 194, 211, 216, 228, 229, 233, 238, 239, 251, 340, 356, 374, 388]
    pinned_indices = pinned[name]

    add_pinned_verts(garments_dict_path, garment_name, pinned_indices)
