## Dual-Abi Linking

If you get one of these:

```
undefined reference to `_ZNK4llvm17SubtargetFeatures9getStringB5cxx11Ev'
undefined reference to `llvm::SubtargetFeatures::getString() const'
```

This is because of
[C++'s Dual ABI](https://gcc.gnu.org/onlinedocs/libstdc++/manual/using_dual_abi.html).
Most likely LLVM was compiled with one compiler while Zig was compiled with a
different one, for example GCC vs clang.

LLVM, Clang, and Zig must all be compiled with the same C++ compiler.

## Undefined references in `liblldELF.a`

Building with LLVM 17 has `zlib` as a new requirement.

If your system has static `zlib` then `-DZIG_STATIC_ZLIB=ON` needs to be specified to use it (e.g. `cmake .. -DZIG_STATIC_ZLIB=ON`). 

## Arch Linux, Gentoo, Fedora 32+

The Clang packages in these distributions do not contain static libraries, which Zig tries to use by default.
Instead, one should link against the shared lib `libclang-cpp.so`.

For building stage1, set `ZIG_SHARED_LLVM`:

```
cmake .. -DZIG_SHARED_LLVM=ON
```
For building stage2, pass `-Dstatic-llvm=false` to Zig.

Fedora also doesn't ship by default with the static libraries for lib stdc++. 
This will result in link errors for symbols like `std::string`.
You can fix this by installing the following package: `dnf install libstdc++-static`.

## Ubuntu/Debian

The LLVM repositories/packages are listed at https://apt.llvm.org/. The following packages that are not listed must be installed: `liblld-17-dev`, `libclang-17-dev` (as well as at least `libllvm17` from the listed packages).

## macOS

On macOS, you must force static linking of LLVM using `-DZIG_STATIC_LLVM=on`. The full invocation will then look like:

```
cmake .. -DCMAKE_PREFIX_PATH="$(brew --prefix llvm@17);$(brew --prefix zstd)" -DZIG_STATIC_LLVM=on
```

After upgrading LLVM, it's often necessary to remove the CMake cache and build directories:

```
rm CMakeCache.txt
rm -rf CMakeFiles
```

Then try running the cmake command again.