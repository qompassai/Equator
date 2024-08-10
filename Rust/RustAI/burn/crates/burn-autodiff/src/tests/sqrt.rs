#[burn_tensor_testgen::testgen(ad_sqrt)]
mod tests {
    use super::*;
    use burn_tensor::TensorData;

    #[test]
    fn should_diff_sqrt() {
        let data_1 = TensorData::from([[0.0, 1.0], [3.0, 4.0]]);
        let data_2 = TensorData::from([[6.0, 7.0], [9.0, 10.0]]);

        let device = Default::default();
        let tensor_1 = TestAutodiffTensor::<2>::from_data(data_1, &device).require_grad();
        let tensor_2 = TestAutodiffTensor::from_data(data_2, &device).require_grad();

        let tensor_3 = tensor_1.clone().matmul(tensor_2.clone().sqrt());
        let tensor_4 = tensor_3.matmul(tensor_2.clone());
        let grads = tensor_4.backward();

        let grad_1 = tensor_1.grad(&grads).unwrap();
        let grad_2 = tensor_2.grad(&grads).unwrap();

        let expected = TensorData::from([[82.1126, 99.0832], [82.1126, 99.0832]]);
        grad_1.to_data().assert_approx_eq(&expected, 3);

        let expected = TensorData::from([[30.3093, 33.1204], [34.5819, 38.7694]]);
        grad_2.to_data().assert_approx_eq(&expected, 3);
    }
}
