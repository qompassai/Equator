#[burn_tensor_testgen::testgen(powf)]
mod tests {
    use super::*;
    use burn_tensor::{Tensor, TensorData};

    #[test]
    fn should_support_powf_ops() {
        let data = TensorData::from([[1.0, 1.0, 2.0], [3.0, 4.0, 5.0]]);
        let tensor = Tensor::<TestBackend, 2>::from_data(data, &Default::default());
        let pow = TensorData::from([[1.0, 1.0, 2.0], [3.0, 4.0, 2.0]]);
        let tensor_pow = Tensor::<TestBackend, 2>::from_data(pow, &Default::default());

        let output = tensor.powf(tensor_pow);
        let expected = TensorData::from([[1.0, 1.0, 4.0], [27.0, 256.0, 25.0]]);

        output.into_data().assert_approx_eq(&expected, 3);
    }

    #[test]
    fn should_support_neg_power() {
        let data = TensorData::from([[1.0, 1.0, 2.0], [3.0, 4.0, 5.0]]);
        let tensor = Tensor::<TestBackend, 2>::from_data(data, &Default::default());
        let pow = TensorData::from([[-0.95, -0.67, -0.45], [-0.24, -0.5, -0.6]]);
        let tensor_pow = Tensor::<TestBackend, 2>::from_data(pow, &Default::default());

        let output = tensor.powf(tensor_pow);
        let expected = TensorData::from([[1., 1., 0.73204285], [0.76822936, 0.5, 0.38073079]]);

        output.into_data().assert_approx_eq(&expected, 3);
    }

    #[test]
    fn should_support_neg_values_with_even_power() {
        let data = TensorData::from([[1.0, -1.0, -2.0], [-3.0, -4.0, -5.0]]);
        let tensor = Tensor::<TestBackend, 2>::from_data(data, &Default::default());
        let pow = TensorData::from([[2.0, 2.0, 4.0], [4.0, 4.0, 2.0]]);
        let tensor_pow = Tensor::<TestBackend, 2>::from_data(pow, &Default::default());

        let output = tensor.powf(tensor_pow);
        let expected = TensorData::from([[1.0, 1.0, 16.0], [81.0, 256.0, 25.0]]);

        output.into_data().assert_approx_eq(&expected, 3);
    }

    #[test]
    fn should_support_neg_values_with_odd_power() {
        let data = TensorData::from([[1.0, -1.0, -2.0], [-3.0, -4.0, -5.0]]);
        let tensor = Tensor::<TestBackend, 2>::from_data(data, &Default::default());
        let pow = TensorData::from([[3.0, 3.0, 3.0], [3.0, 3.0, 3.0]]);
        let tensor_pow = Tensor::<TestBackend, 2>::from_data(pow, &Default::default());

        let output = tensor.powf(tensor_pow);
        let expected = TensorData::from([[1.0, -1.0, -8.0], [-27.0, -64.0, -125.0]]);

        output.into_data().assert_approx_eq(&expected, 3);
    }
}
