#[burn_tensor_testgen::testgen(expand)]
mod tests {
    use super::*;
    use burn_tensor::{Shape, Tensor, TensorData};

    #[test]
    fn expand_2d() {
        let tensor = Tensor::<TestBackend, 1>::from_floats([1.0, 2.0, 3.0], &Default::default());
        let output = tensor.expand([3, 3]);

        output.into_data().assert_eq(
            &TensorData::from([[1.0, 2.0, 3.0], [1.0, 2.0, 3.0], [1.0, 2.0, 3.0]]),
            false,
        );

        let tensor =
            Tensor::<TestBackend, 1>::from_floats([4.0, 7.0, 2.0, 3.0], &Default::default());
        let output = tensor.expand([2, 4]);

        output.into_data().assert_eq(
            &TensorData::from([[4.0, 7.0, 2.0, 3.0], [4.0, 7.0, 2.0, 3.0]]),
            false,
        );
    }

    #[test]
    fn expand_3d() {
        let tensor =
            Tensor::<TestBackend, 2>::from_floats([[1.0, 2.0], [3.0, 4.0]], &Default::default());
        let output = tensor.expand([3, 2, 2]);
        let expected = TensorData::from([
            [[1.0, 2.0], [3.0, 4.0]],
            [[1.0, 2.0], [3.0, 4.0]],
            [[1.0, 2.0], [3.0, 4.0]],
        ]);

        output.into_data().assert_eq(&expected, false);
    }

    #[test]
    fn expand_higher_dimensions() {
        let tensor =
            Tensor::<TestBackend, 2>::from_floats([[1.0, 2.0, 3.0, 4.0]], &Default::default());
        let output = tensor.expand([2, 3, 4]);
        let expected = TensorData::from([
            [
                [1.0, 2.0, 3.0, 4.0],
                [1.0, 2.0, 3.0, 4.0],
                [1.0, 2.0, 3.0, 4.0],
            ],
            [
                [1.0, 2.0, 3.0, 4.0],
                [1.0, 2.0, 3.0, 4.0],
                [1.0, 2.0, 3.0, 4.0],
            ],
        ]);

        output.into_data().assert_eq(&expected, false);
    }

    #[test]
    fn broadcast_single() {
        let tensor = Tensor::<TestBackend, 1>::from_floats([1.0], &Default::default());
        let output = tensor.expand([2, 3]);

        output
            .into_data()
            .assert_eq(&TensorData::from([[1.0, 1.0, 1.0], [1.0, 1.0, 1.0]]), false);
    }

    #[test]
    #[should_panic]
    fn should_fail_expand_incompatible_shapes() {
        let tensor = Tensor::<TestBackend, 1>::from_floats([1.0, 2.0, 3.0], &Default::default());
        let _expanded_tensor = tensor.expand([2, 2]);
    }

    #[test]
    fn expand_2d_bool() {
        let tensor = TestTensorBool::<1>::from([false, true, false]);
        let expanded_tensor = tensor.expand([3, 3]);

        let expected_data = TensorData::from([
            [false, true, false],
            [false, true, false],
            [false, true, false],
        ]);

        expanded_tensor.into_data().assert_eq(&expected_data, true);
    }

    #[test]
    fn expand_2d_int() {
        let tensor = TestTensorInt::<1>::from([1, 2, 3]);
        let output = tensor.expand([3, 3]);

        output
            .into_data()
            .assert_eq(&TensorData::from([[1, 2, 3], [1, 2, 3], [1, 2, 3]]), false);
    }

    #[test]
    fn should_all_negative_one() {
        let tensor = TestTensorInt::<1>::from([1, 2, 3]);
        let output = tensor.expand([2, -1]);

        output
            .into_data()
            .assert_eq(&TensorData::from([[1, 2, 3], [1, 2, 3]]), false);
    }

    #[test]
    #[should_panic]
    fn should_panic_negative_one_on_non_existing_dim() {
        let tensor = TestTensorInt::<1>::from([1, 2, 3]);
        let _expanded_tensor = tensor.expand([-1, 3]);
    }
}
