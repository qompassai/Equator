# Why To Build From Source

The primary reason to build from source is in order to participate in the development process of Zig itself. Building from source means that you can make changes to Zig itself and then test out those changes.

If your goal is to install a specific version of Zig, you can find pre-built tarballs on [the download page](https://ziglang.org/download/). You could also try [installing Zig from a package manager](https://github.com/ziglang/zig/wiki/Install-Zig-from-a-Package-Manager). Finally, there is [zig-bootstrap](https://github.com/ziglang/zig-bootstrap) to cross-compile an installation of Zig from source for any target. When using zig-bootstrap, be sure to check out the git tag corresponding to the version you want to build, as master branch is not kept in any coherent state.

When building from source, pay attention to which commits failed and succeeded CI checks. Check the [commit history](https://github.com/ziglang/zig/commits/master) and notice which commits succeeded (:heavy_check_mark:) or failed (:x:). You will want to check out the latest master branch commit that succeeded in order to avoid bugs in the most recent commits.

If you run into trouble, first refer to [[Troubleshooting Build Issues]], and then ask politely for help in one of the [[Community]] spaces.

The following steps are for Unix-like operating systems. For Windows, refer to [[Building Zig on Windows]].

It is recommended to follow Option A after doing a `git pull`, modifying the cmake line with `-DCMAKE_BUILD_TYPE=Release` and then following Option B while working on a feature branch, using Option A as your prior build of Zig.

# Option A: Use Your System Installed Build Tools

## Dependencies

 * [cmake](https://cmake.org/files/) >= 3.5
 * [gcc](https://gcc.gnu.org/releases.html) >= 7.0.0 or [clang](https://releases.llvm.org/download.html) >= 6.0.0
 * [LLVM, Clang, LLD development libraries](https://releases.llvm.org/download.html) == 18.x, compiled with the same gcc or clang version above
   - Use the system package manager, or [build from source](https://github.com/ziglang/zig/wiki/How-to-build-LLVM,-libclang,-and-liblld-from-source#posix).

## Instructions

```sh
mkdir build
cd build
cmake ..
make install
```

Please be aware of the handy cmake variable `CMAKE_PREFIX_PATH`. CMake will look for LLVM and other dependencies in this location first.

This produces `stage3/bin/zig` which is the Zig compiler built by itself.

### For macOS + Homebrew
```sh
mkdir build
cd build
cmake .. -DZIG_STATIC_LLVM=ON -DCMAKE_PREFIX_PATH="$(brew --prefix llvm@18);$(brew --prefix zstd)"
make install
```

### For FreeBSD

```sh
sudo pkg install -qyr FreeBSD devel/llvm18 devel/cmake archivers/zstd textproc/libxml2 archivers/lzma
mkdir build
cd build
cmake .. -DZIG_STATIC_LLVM=ON -DCMAKE_PREFIX_PATH="/usr/local/llvm18;/usr/local"
make install
```

# Option B: Use a Pre-Built Zig Binary

## Dependencies

 * A recent prior build of Zig. The exact version required depends on how recently breaking changes occurred. If the language or std lib changed too much since this version, then this strategy will fail with compilation errors, and you must use Option A above.
 * LLVM, Clang, and LLD libraries built using Zig.

The easiest way to obtain both of these artifacts is to use [zig-bootstrap](https://github.com/ziglang/zig-bootstrap), which creates the directory `out/zig-$target-$cpu` and `out/$target-$cpu`, to be used as `$ZIG_PREFIX` and `$LLVM_PREFIX`, respectively, in the following command:

## Instructions

```sh
"$ZIG_PREFIX/bin/zig" build \
  -p stage3 \
  --search-prefix "$LLVM_PREFIX" \
  --zig-lib-dir lib \
  -Dstatic-llvm
```

Where `$LLVM_PREFIX` is the path that contains, for example, `include/llvm/Pass.h` and `lib/libLLVMCore.a`.

This produces `stage3/bin/zig`. See `zig build -h` to learn about the options that can be passed such as `-Drelease`.
