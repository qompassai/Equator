/*
 *  Copyright 2008-2013 NVIDIA Corporation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#pragma once

#include <thrust/detail/config.h>

#if defined(_CCCL_IMPLICIT_SYSTEM_HEADER_GCC)
#  pragma GCC system_header
#elif defined(_CCCL_IMPLICIT_SYSTEM_HEADER_CLANG)
#  pragma clang system_header
#elif defined(_CCCL_IMPLICIT_SYSTEM_HEADER_MSVC)
#  pragma system_header
#endif // no system header
#include <thrust/detail/pointer.h>
#include <thrust/pair.h>
#include <thrust/system/detail/generic/tag.h>

THRUST_NAMESPACE_BEGIN
namespace system
{
namespace detail
{
namespace generic
{

template <typename T, typename DerivedPolicy>
_CCCL_HOST_DEVICE
thrust::pair<thrust::pointer<T, DerivedPolicy>, typename thrust::pointer<T, DerivedPolicy>::difference_type>
get_temporary_buffer(thrust::execution_policy<DerivedPolicy>& exec,
                     typename thrust::pointer<T, DerivedPolicy>::difference_type n);

_CCCL_EXEC_CHECK_DISABLE
template <typename DerivedPolicy, typename Pointer>
_CCCL_HOST_DEVICE void
return_temporary_buffer(thrust::execution_policy<DerivedPolicy>& exec, Pointer p, std::ptrdiff_t n);

_CCCL_EXEC_CHECK_DISABLE
template <typename DerivedPolicy, typename Pointer>
_CCCL_HOST_DEVICE void return_temporary_buffer(thrust::execution_policy<DerivedPolicy>& exec, Pointer p);

} // namespace generic
} // namespace detail
} // namespace system
THRUST_NAMESPACE_END

#include <thrust/system/detail/generic/temporary_buffer.inl>