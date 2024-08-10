#[burn_tensor_testgen::testgen(div)]
mod tests {
    use super::*;
    use burn_tensor::{Int, Tensor, TensorData};

    #[test]
    fn should_support_div_ops() {
        let data_1 = TensorData::from([[0.0, 1.0, 2.0], [3.0, 4.0, 5.0]]);
        let data_2 = TensorData::from([[1.0, 1.0, 2.0], [3.0, 4.0, 5.0]]);
        let device = Default::default();
        let tensor_1 = Tensor::<TestBackend, 2>::from_data(data_1, &device);
        let tensor_2 = Tensor::<TestBackend, 2>::from_data(data_2, &device);

        let output = tensor_1 / tensor_2;
        let expected = TensorData::from([[0.0, 1.0, 1.0], [1.0, 1.0, 1.0]]);

        output.into_data().assert_approx_eq(&expected, 3);
    }

    #[test]
    fn test_div_broadcast() {
        let data_1 = TensorData::from([[0.0, 1.0, 2.0]]);
        let data_2 = TensorData::from([[1.0, 1.0, 2.0], [3.0, 4.0, 5.0]]);
        let device = Default::default();
        let tensor_1 = Tensor::<TestBackend, 2>::from_data(data_1, &device);
        let tensor_2 = Tensor::<TestBackend, 2>::from_data(data_2, &device);

        let output = tensor_1 / tensor_2;

        output.into_data().assert_eq(
            &TensorData::from([[0.0, 1.0, 1.0], [0.0, 0.25, 0.4]]),
            false,
        );
    }

    #[test]
    fn should_support_div_scalar_ops() {
        let data = TensorData::from([[0.0, 1.0, 2.0], [3.0, 4.0, 5.0]]);
        let scalar = 2.0;
        let device = Default::default();
        let tensor = Tensor::<TestBackend, 2>::from_data(data, &device);

        let output = tensor / scalar;

        output
            .into_data()
            .assert_eq(&TensorData::from([[0.0, 0.5, 1.0], [1.5, 2.0, 2.5]]), false);
    }

    #[test]
    fn should_support_div_ops_int() {
        let data_1 = TensorData::from([[0, 1, 2], [3, 4, 5]]);
        let data_2 = TensorData::from([[1, 1, 2], [1, 1, 2]]);
        let device = Default::default();
        let tensor_1 = Tensor::<TestBackend, 2, Int>::from_data(data_1, &device);
        let tensor_2 = Tensor::<TestBackend, 2, Int>::from_data(data_2, &device);

        let output = tensor_1 / tensor_2;

        output
            .into_data()
            .assert_eq(&TensorData::from([[0, 1, 1], [3, 4, 2]]), false);
    }

    #[test]
    fn test_div_broadcast_int() {
        let data_1 = TensorData::from([[0, 1, 2]]);
        let data_2 = TensorData::from([[1, 1, 2], [3, 4, 5]]);
        let device = Default::default();
        let tensor_1 = Tensor::<TestBackend, 2, Int>::from_data(data_1, &device);
        let tensor_2 = Tensor::<TestBackend, 2, Int>::from_data(data_2, &device);

        let output = tensor_1 / tensor_2;

        output
            .into_data()
            .assert_eq(&TensorData::from([[0, 1, 1], [0, 0, 0]]), false);
    }

    #[test]
    fn should_support_div_scalar_ops_int() {
        let data = TensorData::from([[0, 1, 2], [3, 4, 5]]);
        let scalar = 2;
        let tensor = Tensor::<TestBackend, 2, Int>::from_data(data, &Default::default());

        let output = tensor / scalar;

        output
            .into_data()
            .assert_eq(&TensorData::from([[0, 0, 1], [1, 2, 2]]), false);
    }
}
