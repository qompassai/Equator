use backend_comparison::persistence::save;
use burn::tensor::{backend::Backend, Distribution, Shape, Tensor, TensorData};
use burn_common::{
    benchmark::{run_benchmark, Benchmark},
    sync_type::SyncType,
};
use derive_new::new;

#[derive(new)]
struct ToDataBenchmark<B: Backend, const D: usize> {
    shape: Shape<D>,
    device: B::Device,
}

impl<B: Backend, const D: usize> Benchmark for ToDataBenchmark<B, D> {
    type Args = Tensor<B, D>;

    fn name(&self) -> String {
        "to_data".into()
    }

    fn shapes(&self) -> Vec<Vec<usize>> {
        vec![self.shape.dims.into()]
    }

    fn execute(&self, args: Self::Args) {
        let _data = args.to_data();
    }

    fn prepare(&self) -> Self::Args {
        Tensor::random(self.shape.clone(), Distribution::Default, &self.device)
    }

    fn sync(&self) {
        B::sync(&self.device, SyncType::Wait)
    }
}

#[derive(new)]
struct FromDataBenchmark<B: Backend, const D: usize> {
    shape: Shape<D>,
    device: B::Device,
}

impl<B: Backend, const D: usize> Benchmark for FromDataBenchmark<B, D> {
    type Args = (TensorData, B::Device);

    fn name(&self) -> String {
        "from_data".into()
    }

    fn shapes(&self) -> Vec<Vec<usize>> {
        vec![self.shape.dims.into()]
    }

    fn execute(&self, (data, device): Self::Args) {
        let _data = Tensor::<B, D>::from_data(data.clone(), &device);
    }

    fn prepare(&self) -> Self::Args {
        (
            TensorData::random::<B::FloatElem, _, _>(
                self.shape.clone(),
                Distribution::Default,
                &mut rand::thread_rng(),
            ),
            self.device.clone(),
        )
    }

    fn sync(&self) {
        B::sync(&self.device, SyncType::Wait)
    }
}

#[allow(dead_code)]
fn bench<B: Backend>(
    device: &B::Device,
    feature_name: &str,
    url: Option<&str>,
    token: Option<&str>,
) {
    const D: usize = 3;
    let shape: Shape<D> = [32, 512, 1024].into();

    let to_benchmark = ToDataBenchmark::<B, D>::new(shape.clone(), device.clone());
    let from_benchmark = FromDataBenchmark::<B, D>::new(shape, device.clone());

    save::<B>(
        vec![run_benchmark(to_benchmark), run_benchmark(from_benchmark)],
        device,
        feature_name,
        url,
        token,
    )
    .unwrap();
}

fn main() {
    backend_comparison::bench_on_backend!();
}
