#[burn_tensor_testgen::testgen(sqrt)]
mod tests {
    use super::*;
    use burn_tensor::{Tensor, TensorData};
    use core::f32::consts::SQRT_2;

    #[test]
    fn should_support_sqrt_ops() {
        let data = TensorData::from([[0.0, 1.0, 2.0], [3.0, 4.0, 5.0]]);
        let tensor = Tensor::<TestBackend, 2>::from_data(data, &Default::default());

        let output = tensor.sqrt();
        let expected = TensorData::from([[0.0, 1.0, SQRT_2], [1.73205, 2.0, 2.2360]]);

        output.into_data().assert_approx_eq(&expected, 3);
    }
}
