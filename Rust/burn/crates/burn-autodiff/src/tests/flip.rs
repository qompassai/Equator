#[burn_tensor_testgen::testgen(ad_flip)]
mod tests {
    use super::*;
    use burn_tensor::TensorData;

    #[test]
    fn should_diff_flip() {
        let data_1 = TensorData::from([[[1.0, 7.0], [2.0, 3.0]]]); // 1x2x2
        let data_2 = TensorData::from([[[3.0, 2.0, 7.0], [3.0, 3.2, 1.0]]]); // 1x2x3

        let device = Default::default();
        let tensor_1 = TestAutodiffTensor::<3>::from_data(data_1, &device).require_grad();
        let tensor_2 = TestAutodiffTensor::from_data(data_2, &device).require_grad();

        let tensor_3 = tensor_2.clone().flip([1, 2]);
        let tensor_4 = tensor_1.clone().matmul(tensor_3);
        let grads = tensor_4.backward();

        let grad_1 = tensor_1.grad(&grads).unwrap();
        let grad_2 = tensor_2.grad(&grads).unwrap();

        grad_1
            .to_data()
            .assert_eq(&TensorData::from([[[7.2, 12.0], [7.2, 12.0]]]), false); // 1x2x2
        grad_2.to_data().assert_eq(
            &TensorData::from([[[10.0, 10.0, 10.0], [3.0, 3.0, 3.0]]]),
            false,
        ); // 1x2x3
    }
}
