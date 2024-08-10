use crate::{
    backend::Backend,
    ops::{ConvOptions, ConvTransposeOptions, InterpolateOptions, UnfoldOptions},
    Int, Tensor, TensorPrimitive,
};

/// Applies the [embedding module](crate::ops::ModuleOps::embedding).
pub fn embedding<B>(weights: Tensor<B, 2>, indices: Tensor<B, 2, Int>) -> Tensor<B, 3>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::embedding(
        weights.primitive.tensor(),
        indices.primitive,
    )))
}

/// Applies a [1D convolution](crate::ops::ModuleOps::conv2d).
pub fn conv1d<B>(
    x: Tensor<B, 3>,
    weight: Tensor<B, 3>,
    bias: Option<Tensor<B, 1>>,
    options: ConvOptions<1>,
) -> Tensor<B, 3>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::conv1d(
        x.primitive.tensor(),
        weight.primitive.tensor(),
        bias.map(|b| b.primitive.tensor()),
        options,
    )))
}

/// Applies a [2D convolution](crate::ops::ModuleOps::conv2d).
pub fn conv2d<B>(
    x: Tensor<B, 4>,
    weight: Tensor<B, 4>,
    bias: Option<Tensor<B, 1>>,
    options: ConvOptions<2>,
) -> Tensor<B, 4>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::conv2d(
        x.primitive.tensor(),
        weight.primitive.tensor(),
        bias.map(|b| b.primitive.tensor()),
        options,
    )))
}

/// Applies a [3D convolution](crate::ops::ModuleOps::conv3d).
pub fn conv3d<B>(
    x: Tensor<B, 5>,
    weight: Tensor<B, 5>,
    bias: Option<Tensor<B, 1>>,
    options: ConvOptions<3>,
) -> Tensor<B, 5>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::conv3d(
        x.primitive.tensor(),
        weight.primitive.tensor(),
        bias.map(|b| b.primitive.tensor()),
        options,
    )))
}

/// Applies a [1D transposed convolution](crate::ops::ModuleOps::conv_transpose1d).
pub fn conv_transpose1d<B>(
    x: Tensor<B, 3>,
    weight: Tensor<B, 3>,
    bias: Option<Tensor<B, 1>>,
    options: ConvTransposeOptions<1>,
) -> Tensor<B, 3>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::conv_transpose1d(
        x.primitive.tensor(),
        weight.primitive.tensor(),
        bias.map(|b| b.primitive.tensor()),
        options,
    )))
}

/// Applies a [2D transposed convolution](crate::ops::ModuleOps::conv_transpose2d).
pub fn conv_transpose2d<B>(
    x: Tensor<B, 4>,
    weight: Tensor<B, 4>,
    bias: Option<Tensor<B, 1>>,
    options: ConvTransposeOptions<2>,
) -> Tensor<B, 4>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::conv_transpose2d(
        x.primitive.tensor(),
        weight.primitive.tensor(),
        bias.map(|b| b.primitive.tensor()),
        options,
    )))
}

/// Applies a 3D transposed convolution](crate::ops::ModuleOps::conv_transpose3d).
pub fn conv_transpose3d<B>(
    x: Tensor<B, 5>,
    weight: Tensor<B, 5>,
    bias: Option<Tensor<B, 1>>,
    options: ConvTransposeOptions<3>,
) -> Tensor<B, 5>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::conv_transpose3d(
        x.primitive.tensor(),
        weight.primitive.tensor(),
        bias.map(|b| b.primitive.tensor()),
        options,
    )))
}

/// Applies a [4D to 3D unfold](crate::ops::ModuleOps::unfold4d).
pub fn unfold4d<B>(x: Tensor<B, 4>, kernel_size: [usize; 2], options: UnfoldOptions) -> Tensor<B, 3>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::unfold4d(
        x.primitive.tensor(),
        kernel_size,
        options,
    )))
}

/// Applies a [1D max pooling](crate::ops::ModuleOps::max_pool1d).
pub fn max_pool1d<B>(
    x: Tensor<B, 3>,
    kernel_size: usize,
    stride: usize,
    padding: usize,
    dilation: usize,
) -> Tensor<B, 3>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::max_pool1d(
        x.primitive.tensor(),
        kernel_size,
        stride,
        padding,
        dilation,
    )))
}

/// Applies a [2D max pooling](crate::ops::ModuleOps::max_pool2d).
pub fn max_pool2d<B>(
    x: Tensor<B, 4>,
    kernel_size: [usize; 2],
    stride: [usize; 2],
    padding: [usize; 2],
    dilation: [usize; 2],
) -> Tensor<B, 4>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::max_pool2d(
        x.primitive.tensor(),
        kernel_size,
        stride,
        padding,
        dilation,
    )))
}

/// Applies a [2D avg pooling](crate::ops::ModuleOps::avg_pool2d).
pub fn avg_pool2d<B>(
    x: Tensor<B, 4>,
    kernel_size: [usize; 2],
    stride: [usize; 2],
    padding: [usize; 2],
    count_include_pad: bool,
) -> Tensor<B, 4>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::avg_pool2d(
        x.primitive.tensor(),
        kernel_size,
        stride,
        padding,
        count_include_pad,
    )))
}

/// Applies a [1D avg pooling](crate::ops::ModuleOps::avg_pool1d).
pub fn avg_pool1d<B>(
    x: Tensor<B, 3>,
    kernel_size: usize,
    stride: usize,
    padding: usize,
    count_include_pad: bool,
) -> Tensor<B, 3>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::avg_pool1d(
        x.primitive.tensor(),
        kernel_size,
        stride,
        padding,
        count_include_pad,
    )))
}

/// Applies a [1D max pooling](crate::ops::ModuleOps::max_pool1d).
pub fn max_pool1d_with_indices<B>(
    x: Tensor<B, 3>,
    kernel_size: usize,
    stride: usize,
    padding: usize,
    dilation: usize,
) -> (Tensor<B, 3>, Tensor<B, 3, Int>)
where
    B: Backend,
{
    let output =
        B::max_pool1d_with_indices(x.primitive.tensor(), kernel_size, stride, padding, dilation);

    (
        Tensor::new(TensorPrimitive::Float(output.output)),
        Tensor::new(output.indices),
    )
}

/// Applies a [2D max pooling with indices](crate::ops::ModuleOps::max_pool2d_with_indices).
pub fn max_pool2d_with_indices<B>(
    x: Tensor<B, 4>,
    kernel_size: [usize; 2],
    stride: [usize; 2],
    padding: [usize; 2],
    dilation: [usize; 2],
) -> (Tensor<B, 4>, Tensor<B, 4, Int>)
where
    B: Backend,
{
    let output =
        B::max_pool2d_with_indices(x.primitive.tensor(), kernel_size, stride, padding, dilation);

    (
        Tensor::new(TensorPrimitive::Float(output.output)),
        Tensor::new(output.indices),
    )
}

/// Applies a [2D adaptive avg pooling](crate::ops::ModuleOps::adaptive_avg_pool2d).
pub fn adaptive_avg_pool2d<B>(x: Tensor<B, 4>, output_size: [usize; 2]) -> Tensor<B, 4>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::adaptive_avg_pool2d(
        x.primitive.tensor(),
        output_size,
    )))
}

/// Applies a [1D adaptive avg pooling](crate::ops::ModuleOps::adaptive_avg_pool1d).
pub fn adaptive_avg_pool1d<B>(x: Tensor<B, 3>, output_size: usize) -> Tensor<B, 3>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::adaptive_avg_pool1d(
        x.primitive.tensor(),
        output_size,
    )))
}

/// Applies a [2D interpolation](crate::ops::ModuleOps::interpolate).
pub fn interpolate<B>(
    x: Tensor<B, 4>,
    output_size: [usize; 2],
    options: InterpolateOptions,
) -> Tensor<B, 4>
where
    B: Backend,
{
    Tensor::new(TensorPrimitive::Float(B::interpolate(
        x.primitive.tensor(),
        output_size,
        options,
    )))
}
