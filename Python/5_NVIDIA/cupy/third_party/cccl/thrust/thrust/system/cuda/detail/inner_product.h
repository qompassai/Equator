/******************************************************************************
 * Copyright (c) 2016, NVIDIA CORPORATION.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the NVIDIA CORPORATION nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL NVIDIA CORPORATION BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 ******************************************************************************/
#pragma once

#include <thrust/detail/config.h>

#if defined(_CCCL_IMPLICIT_SYSTEM_HEADER_GCC)
#  pragma GCC system_header
#elif defined(_CCCL_IMPLICIT_SYSTEM_HEADER_CLANG)
#  pragma clang system_header
#elif defined(_CCCL_IMPLICIT_SYSTEM_HEADER_MSVC)
#  pragma system_header
#endif // no system header

#if THRUST_DEVICE_COMPILER == THRUST_DEVICE_COMPILER_NVCC
#  include <thrust/detail/minmax.h>
#  include <thrust/distance.h>
#  include <thrust/system/cuda/detail/reduce.h>

#  include <iterator>

THRUST_NAMESPACE_BEGIN

namespace cuda_cub
{

template <class Derived, class InputIt1, class InputIt2, class T, class ReduceOp, class ProductOp>
T _CCCL_HOST_DEVICE inner_product(
  execution_policy<Derived>& policy,
  InputIt1 first1,
  InputIt1 last1,
  InputIt2 first2,
  T init,
  ReduceOp reduce_op,
  ProductOp product_op)
{
  using size_type        = typename iterator_traits<InputIt1>::difference_type;
  size_type num_items    = static_cast<size_type>(thrust::distance(first1, last1));
  using binop_iterator_t = transform_pair_of_input_iterators_t<T, InputIt1, InputIt2, ProductOp>;

  return cuda_cub::reduce_n(policy, binop_iterator_t(first1, first2, product_op), num_items, init, reduce_op);
}

template <class Derived, class InputIt1, class InputIt2, class T>
T _CCCL_HOST_DEVICE
inner_product(execution_policy<Derived>& policy, InputIt1 first1, InputIt1 last1, InputIt2 first2, T init)
{
  return cuda_cub::inner_product(policy, first1, last1, first2, init, plus<T>(), multiplies<T>());
}

} // namespace cuda_cub

THRUST_NAMESPACE_END
#endif