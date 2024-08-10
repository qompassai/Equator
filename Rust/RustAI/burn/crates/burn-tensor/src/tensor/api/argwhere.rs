use crate::{backend::Backend, ops::IntTensor, Device, ElementConversion, Shape, TensorData};
use alloc::vec::Vec;

/// Compute the indices of the elements that are non-zero, grouped by element.
///
/// # Arguments
///
/// * `data` - The input tensor data.
///
/// # Returns
///
/// A vector of tensors, one for each dimension of the given tensor, containing the indices of
/// the non-zero elements in that dimension.
///
/// # Remarks
///
/// This is a fallback solution that used only when the backend doesn't have the corresponding implementation.
/// Ideally, it is supposed to be implemented by the backend and the backend implementation will be resolved
/// by static dispatch. It is not designed for direct usage by users, and not recommended to import
/// or use this function directly.
pub fn argwhere_data<B: Backend, const D: usize>(
    data: TensorData,
    device: &Device<B>,
) -> IntTensor<B, 2> {
    let dims = &data.shape;
    let count_nonzero = data.iter::<bool>().filter(|&v| v).count();

    /// Converts a flat index into a vector of indices for the specified tensor shape
    fn unravel_index<B: Backend>(index: usize, shape: &[usize]) -> Vec<B::IntElem> {
        shape
            .iter()
            .rev()
            .scan(index, |i, size| {
                let dim_idx = *i % size;
                *i /= size;
                Some((dim_idx as i64).elem())
            })
            .collect::<Vec<_>>()
            .into_iter()
            .rev()
            .collect()
    }

    let indices = data
        .iter::<bool>()
        .enumerate()
        .filter_map(|(index, v)| if v { Some(index) } else { None })
        .map(|index| unravel_index::<B>(index, dims))
        .collect::<Vec<_>>()
        .concat();

    B::int_from_data(
        TensorData::new(indices, Shape::new([count_nonzero, D])),
        device,
    )
}
