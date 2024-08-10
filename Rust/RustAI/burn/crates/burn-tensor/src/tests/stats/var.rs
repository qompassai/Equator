#[burn_tensor_testgen::testgen(var)]
mod tests {
    use super::*;
    use burn_tensor::backend::Backend;
    use burn_tensor::{Tensor, TensorData};

    type FloatElem = <TestBackend as Backend>::FloatElem;
    type IntElem = <TestBackend as Backend>::IntElem;

    #[test]
    fn test_var() {
        let tensor = TestTensor::<2>::from_data(
            [[0.5, 1.8, 0.2, -2.0], [3.0, -4.0, 5.0, 0.0]],
            &Default::default(),
        );

        let output = tensor.var(1);
        let expected = TensorData::from([[2.4892], [15.3333]]).convert::<FloatElem>();

        output.into_data().assert_approx_eq(&expected, 3);
    }

    #[test]
    fn test_var_mean() {
        let tensor = TestTensor::<2>::from_data(
            [[0.5, 1.8, 0.2, -2.0], [3.0, -4.0, 5.0, 0.0]],
            &Default::default(),
        );

        let (var, mean) = tensor.var_mean(1);

        let var_expected = TensorData::from([[2.4892], [15.3333]]).convert::<FloatElem>();
        let mean_expected = TensorData::from([[0.125], [1.]]).convert::<FloatElem>();

        var.into_data().assert_approx_eq(&var_expected, 3);
        mean.into_data().assert_approx_eq(&mean_expected, 3);
    }

    #[test]
    fn test_var_bias() {
        let tensor = TestTensor::<2>::from_data(
            [[0.5, 1.8, 0.2, -2.0], [3.0, -4.0, 5.0, 0.0]],
            &Default::default(),
        );

        let output = tensor.var_bias(1);
        let expected = TensorData::from([[1.86688], [11.5]]).convert::<FloatElem>();

        output.into_data().assert_approx_eq(&expected, 3);
    }

    #[test]
    fn test_var_mean_bias() {
        let tensor = TestTensor::<2>::from_data(
            [[0.5, 1.8, 0.2, -2.0], [3.0, -4.0, 5.0, 0.0]],
            &Default::default(),
        );

        let (var, mean) = tensor.var_mean_bias(1);

        let var_expected = TensorData::from([[1.86688], [11.5]]).convert::<FloatElem>();
        let mean_expected = TensorData::from([[0.125], [1.]]).convert::<FloatElem>();

        var.into_data().assert_approx_eq(&var_expected, 3);
        mean.into_data().assert_approx_eq(&mean_expected, 3);
    }
}
