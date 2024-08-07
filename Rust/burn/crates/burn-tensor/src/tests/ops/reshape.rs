#[burn_tensor_testgen::testgen(reshape)]
mod tests {
    use super::*;
    use burn_tensor::{Bool, Int, Tensor, TensorData};

    #[test]
    fn should_support_reshape_1d() {
        let data = TensorData::from([0.0, 1.0, 2.0]);
        let tensor = Tensor::<TestBackend, 1>::from_data(data, &Default::default());

        let output = tensor.clone().reshape([1, 3]);
        let expected = TensorData::from([[0.0, 1.0, 2.0]]);

        output.into_data().assert_eq(&expected, false);
    }

    #[test]
    fn should_support_reshape_int() {
        let data = TensorData::from([0, 1, 2]);
        let tensor = Tensor::<TestBackend, 1, Int>::from_data(data, &Default::default());

        let output = tensor.clone().reshape([1, 3]);
        let expected = TensorData::from([[0, 1, 2]]);

        output.into_data().assert_eq(&expected, false);
    }

    #[test]
    fn should_support_reshape_bool() {
        let data = TensorData::from([false, true, false]);
        let tensor = Tensor::<TestBackend, 1, Bool>::from_data(data, &Default::default());

        let output = tensor.clone().reshape([1, 3]);
        let expected = TensorData::from([[false, true, false]]);

        output.into_data().assert_eq(&expected, true);
    }

    #[test]
    fn should_support_reshape_2d() {
        let data = TensorData::from([[0.0, 1.0, 2.0], [3.0, 4.0, 5.0]]);
        let tensor = Tensor::<TestBackend, 2>::from_data(data, &Default::default());

        let output = tensor.clone().reshape([6]);
        let expected = TensorData::from([0.0, 1.0, 2.0, 3.0, 4.0, 5.0]);

        output.into_data().assert_eq(&expected, false);
    }

    #[test]
    fn should_support_dim_infererence() {
        let data = TensorData::from([
            [0.0, 1.0, 2.0],
            [3.0, 4.0, 5.0],
            [6.0, 7.0, 8.0],
            [9.0, 10.0, 11.0],
        ]);
        let tensor = Tensor::<TestBackend, 2>::from_data(data, &Default::default());

        // Infer the dimension via -1
        let reshaped = tensor.clone().reshape([2, -1]);
        assert_eq!(reshaped.shape(), [2, 6].into());

        // Infer the dimension via 0 (keep from the source) and -1 (infer)
        let reshaped = reshaped.reshape([0, 2, -1]);
        assert_eq!(reshaped.shape(), [2, 2, 3].into());

        // This is effectively as if we did a flatten
        let reshaped = tensor.clone().reshape([-1]);
        assert_eq!(reshaped.shape(), [12].into());

        // Keeping the first dimension the same (using 0)
        let reshaped = tensor.clone().reshape([0, 3]);
        assert_eq!(reshaped.shape(), [4, 3].into());
    }

    #[test]
    fn should_not_corrupt_after_slice() {
        let zeros = Tensor::<TestBackend, 1>::zeros([2], &Default::default());
        zeros.clone().slice([1..2]).reshape([1]).exp();

        // May lead to zeroes being equal to [0.0, 1.0]
        zeros.into_data().assert_eq(
            &Tensor::<TestBackend, 1>::zeros([2], &Default::default()).to_data(),
            true,
        );
    }

    #[test]
    #[should_panic]
    fn multiple_neg_ones() {
        let data = TensorData::from([0.0, 1.0, 2.0]);
        let tensor = Tensor::<TestBackend, 1>::from_data(data, &Default::default());
        let data_actual = tensor.reshape([-1, -1]).into_data();
    }

    #[test]
    #[should_panic]
    fn neg_value() {
        let data = TensorData::from([0.0, 1.0, 2.0]);
        let tensor = Tensor::<TestBackend, 1>::from_data(data, &Default::default());
        let data_actual = tensor.reshape([-2, -1]).into_data();
    }
}
