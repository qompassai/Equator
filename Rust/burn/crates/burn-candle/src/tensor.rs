use std::marker::PhantomData;

use burn_tensor::{
    quantization::{QTensorPrimitive, QuantizationScheme, QuantizationStrategy},
    Element, Shape, TensorData,
};

use crate::{element::CandleElement, CandleDevice};

/// A tensor that uses the candle backend.
#[derive(Debug, Clone)]
pub struct CandleTensor<E: CandleElement, const D: usize> {
    pub(crate) tensor: candle_core::Tensor,
    phantom: PhantomData<E>,
}

impl<E: CandleElement, const D: usize> CandleTensor<E, D> {
    /// Create a new tensor.
    pub fn new(tensor: candle_core::Tensor) -> Self {
        Self {
            tensor,
            phantom: PhantomData,
        }
    }

    /// Creates a new tensor from data and a device.
    ///
    /// # Arguments
    ///
    /// * `data` - The tensor's data.
    /// * `device` - The device on which the tensor will be allocated.
    ///
    /// # Returns
    ///
    /// A new tensor.
    pub fn from_data(data: TensorData, device: CandleDevice) -> Self {
        let candle_shape: candle_core::Shape = data.shape.clone().into();
        let tensor = candle_core::Tensor::from_slice(
            data.convert::<E>().as_slice::<E>().unwrap(),
            candle_shape,
            &device.into(),
        );
        Self::new(tensor.unwrap())
    }

    pub(crate) fn shape(&self) -> Shape<D> {
        let x: [usize; D] = self.tensor.dims().try_into().unwrap();
        Shape::from(x)
    }
}

/// A quantized tensor for the candle backend.
#[derive(Clone, Debug)]
pub struct CandleQTensor<const D: usize> {
    /// The quantized tensor.
    // NOTE: candle  does not implement `WithDType` for i8
    pub qtensor: CandleTensor<u8, D>,
    /// The quantization scheme.
    pub scheme: QuantizationScheme,
}

impl<const D: usize> QTensorPrimitive for CandleQTensor<D> {
    fn scheme(&self) -> &QuantizationScheme {
        &self.scheme
    }

    fn strategy(&self) -> QuantizationStrategy {
        todo!()
    }
}
