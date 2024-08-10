#[burn_tensor_testgen::testgen(powf_scalar)]
mod tests {
    use super::*;
    use burn_tensor::{Tensor, TensorData};

    #[test]
    fn should_support_powf_ops() {
        let data = TensorData::from([[0.0, 1.0, 2.0], [3.0, 4.0, 5.0]]);
        let tensor = Tensor::<TestBackend, 2>::from_data(data, &Default::default());

        let output = tensor.powf_scalar(0.71);
        let expected = TensorData::from([[0.0, 1.0, 1.6358], [2.182, 2.6759, 3.1352]]);

        output.into_data().assert_approx_eq(&expected, 3);
    }

    #[test]
    fn should_support_neg_power() {
        let data = TensorData::from([[1.0, 1.0, 2.0], [3.0, 4.0, 5.0]]);
        let tensor = Tensor::<TestBackend, 2>::from_data(data, &Default::default());

        let output = tensor.powf_scalar(-0.33);
        let expected =
            TensorData::from([[1.0, 1.0, 0.79553646], [0.695905, 0.6328783, 0.58794934]]);

        output.into_data().assert_approx_eq(&expected, 3);
    }

    #[test]
    fn should_support_neg_values_with_even_power() {
        let data = TensorData::from([[0.0, -1.0, -2.0], [-3.0, -4.0, -5.0]]);
        let tensor = Tensor::<TestBackend, 2>::from_data(data, &Default::default());

        let output = tensor.powf_scalar(4.0);
        let expected = TensorData::from([[0.0, 1.0, 16.0], [81.0, 256.0, 625.0]]);

        output.into_data().assert_approx_eq(&expected, 3);
    }

    #[test]
    fn should_support_neg_values_with_odd_power() {
        let data = TensorData::from([[0.0, -1.0, -2.0], [-3.0, -4.0, -5.0]]);
        let tensor = Tensor::<TestBackend, 2>::from_data(data, &Default::default());

        let output = tensor.powf_scalar(3.0);
        let expected = TensorData::from([[0.0, -1.0, -8.0], [-27.0, -64.0, -125.0]]);

        output.into_data().assert_approx_eq(&expected, 3);
    }
}
