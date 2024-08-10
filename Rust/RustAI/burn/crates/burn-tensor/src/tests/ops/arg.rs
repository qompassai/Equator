#[burn_tensor_testgen::testgen(arg)]
mod tests {
    use super::*;
    use burn_tensor::{Tensor, TensorData};

    #[test]
    fn test_argmax_2d_dim0() {
        let tensor = TestTensor::<2>::from([[10.0, 11.0, 2.0], [3.0, 4.0, 5.0]]);

        let output = tensor.argmax(0);

        output
            .into_data()
            .assert_eq(&TensorData::from([[0, 0, 1]]), false);
    }

    #[test]
    fn test_argmin_2d_dim0() {
        let tensor = TestTensor::<2>::from([[10.0, 11.0, 2.0], [30.0, 4.0, 5.0]]);

        let output = tensor.argmin(0);

        output
            .into_data()
            .assert_eq(&TensorData::from([[0, 1, 0]]), false);
    }

    #[test]
    fn test_argmax_2d_dim0_int() {
        let tensor = TestTensorInt::<2>::from([[10, 11, 2], [3, 4, 5]]);

        let output = tensor.argmax(0);

        output
            .into_data()
            .assert_eq(&TensorData::from([[0, 0, 1]]), false);
    }

    #[test]
    fn test_argmin_2d_dim0_int() {
        let tensor = TestTensorInt::<2>::from([[10, 11, 2], [30, 4, 5]]);

        let output = tensor.argmin(0);

        output
            .into_data()
            .assert_eq(&TensorData::from([[0, 1, 0]]), false);
    }

    #[test]
    fn test_argmax_2d_dim1() {
        let tensor = TestTensor::<2>::from([[10.0, 11.0, 2.0], [3.0, 4.0, 5.0]]);

        let output = tensor.argmax(1);

        output
            .into_data()
            .assert_eq(&TensorData::from([[1], [2]]), false);
    }

    #[test]
    fn test_argmin_2d_dim1() {
        let tensor = TestTensor::<2>::from([[10.0, 11.0, 2.0], [30.0, 4.0, 5.0]]);

        let output = tensor.argmin(1);

        output
            .into_data()
            .assert_eq(&TensorData::from([[2], [1]]), false);
    }
}
