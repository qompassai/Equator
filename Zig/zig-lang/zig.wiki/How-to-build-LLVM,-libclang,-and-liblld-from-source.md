## Windows

### Alternate Options to Building from Source

 * [pre-built binaries](https://github.com/ziglang/zig/wiki/Building-Zig-on-Windows#option-2-using-cmake-and-microsoft-visual-studio)
 * [cross-compile using the bootstrap repository](https://github.com/ziglang/zig-bootstrap)

### Setup

Install [CMake](https://cmake.org/), version 3.20.0 or newer.

[Download llvm, clang, and lld](http://releases.llvm.org/download.html#18.0.0) The downloads from llvm lead to the github release pages, where the source's will be listed as : `llvm-18.X.X.src.tar.xz`, `clang-18.X.X.src.tar.xz`, `lld-18.X.X.src.tar.xz`. Unzip each to their own directory. Ensure no directories have spaces in them. For example:

 * `C:\Users\Andy\llvm-18.0.0.src`
 * `C:\Users\Andy\clang-18.0.0.src`
 * `C:\Users\Andy\lld-18.0.0.src`

Install [Build Tools for Visual Studio 2019](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2019). Be sure to select "C++ build tools" when prompted.
 * You **must** additionally check the optional component labeled **C++ ATL for v142 build tools**. As this won't be supplied by a default installation of Visual Studio.
 * Full list of supported MSVC versions:
   - 2017 (version 15.8) (unverified)
   - 2019 (version 16.7)

Install [Python 3.9.4](https://www.python.org). Tick the box to add python to your PATH environment variable.

### LLVM

Using the start menu, run **x64 Native Tools Command Prompt for VS 2019** and execute these commands, replacing `C:\Users\Andy` with the correct value. Here is listed a brief explanation of each of the CMake parameters we pass when configuring the build 

- `-Thost=x64` : Sets the windows toolset to use 64 bit mode.
- `-A x64` : Make the build target 64 bit .
- `-G "Visual Studio 16 2019"` : Specifies to generate a 2019 Visual Studio project, the best supported version.
- `-DCMAKE_INSTALL_PREFIX=""` : Path that llvm components will being installed into by the install project.
- `-DCMAKE_PREFIX_PATH=""` : Path that CMake will look into first when trying to locate dependencies, should be the same place as the install prefix. This will ensure that clang and lld will use your newly built llvm libraries.
- `-DLLVM_ENABLE_ZLIB=OFF` : Don't build llvm with ZLib support as it's not required and will disrupt the target dependencies for components linking against llvm. This only has to be passed when building llvm, as this option will be saved into the config headers.
- `-DCMAKE_BUILD_TYPE=Release` : Build llvm and components in release mode.
- `-DCMAKE_BUILD_TYPE=Debug` : Build llvm and components in debug mode.
- `-DLLVM_USE_CRT_RELEASE=MT` : Which C runtime should llvm use during release builds.
- `-DLLVM_USE_CRT_DEBUG=MTd` : Make llvm use the debug version of the runtime in debug builds.

#### Release Mode

```bat
mkdir C:\Users\Andy\llvm-18.0.0.src\build-release
cd C:\Users\Andy\llvm-18.0.0.src\build-release
"c:\Program Files\CMake\bin\cmake.exe" .. -Thost=x64 -G "Visual Studio 16 2019" -A x64 -DCMAKE_INSTALL_PREFIX=C:\Users\Andy\llvm+clang+lld-18.0.0-x86_64-windows-msvc-release-mt -DCMAKE_PREFIX_PATH=C:\Users\Andy\llvm+clang+lld-18.0.0-x86_64-windows-msvc-release-mt -
DLLVM_ENABLE_ZLIB=OFF -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_LIBXML2=OFF -DLLVM_USE_CRT_RELEASE=MT
msbuild /m -p:Configuration=Release INSTALL.vcxproj
```

#### Debug Mode

```bat
mkdir C:\Users\Andy\llvm-18.0.0.src\build-debug
cd C:\Users\Andy\llvm-18.0.0.src\build-debug
"c:\Program Files\CMake\bin\cmake.exe" .. -Thost=x64 -G "Visual Studio 16 2019" -A x64 -DCMAKE_INSTALL_PREFIX=C:\Users\andy\llvm+clang+lld-18.0.0-x86_64-windows-msvc-debug -
DLLVM_ENABLE_ZLIB=OFF -DCMAKE_PREFIX_PATH=C:\Users\andy\llvm+clang+lld-18.0.0-x86_64-windows-msvc-debug -DCMAKE_BUILD_TYPE=Debug -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="AVR" -DLLVM_ENABLE_LIBXML2=OFF -DLLVM_USE_CRT_DEBUG=MTd
msbuild /m INSTALL.vcxproj
```

### LLD

Using the start menu, run **x64 Native Tools Command Prompt for VS 2019** and execute these commands, replacing `C:\Users\Andy` with the correct value.

#### Release Mode

```bat
mkdir C:\Users\Andy\lld-18.0.0.src\build-release
cd C:\Users\Andy\lld-18.0.0.src\build-release
"c:\Program Files\CMake\bin\cmake.exe" .. -Thost=x64 -G "Visual Studio 16 2019" -A x64 -DCMAKE_INSTALL_PREFIX=C:\Users\Andy\llvm+clang+lld-14.0.6-x86_64-windows-msvc-release-mt -DCMAKE_PREFIX_PATH=C:\Users\Andy\llvm+clang+lld-18.0.0-x86_64-windows-msvc-release-mt -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT
msbuild /m -p:Configuration=Release INSTALL.vcxproj
```

#### Debug Mode

```bat
mkdir C:\Users\Andy\lld-18.0.0.src\build-debug
cd C:\Users\Andy\lld-18.0.0.src\build-debug
"c:\Program Files\CMake\bin\cmake.exe" .. -Thost=x64 -G "Visual Studio 16 2019" -A x64 -DCMAKE_INSTALL_PREFIX=C:\Users\andy\llvm+clang+lld-18.0.0-x86_64-windows-msvc-debug -DCMAKE_PREFIX_PATH=C:\Users\andy\llvm+clang+lld-18.0.0-x86_64-windows-msvc-debug -DCMAKE_BUILD_TYPE=Debug -DLLVM_USE_CRT_DEBUG=MTd
msbuild /m INSTALL.vcxproj
```

### Clang

Using the start menu, run **x64 Native Tools Command Prompt for VS 2019** and execute these commands, replacing `C:\Users\Andy` with the correct value.

#### Release Mode

```bat
mkdir C:\Users\Andy\clang-18.0.0.src\build-release
cd C:\Users\Andy\clang-18.0.0.src\build-release
"c:\Program Files\CMake\bin\cmake.exe" .. -Thost=x64 -G "Visual Studio 16 2019" -A x64 -DCMAKE_INSTALL_PREFIX=C:\Users\Andy\llvm+clang+lld-18.0.0-x86_64-windows-msvc-release-mt -DCMAKE_PREFIX_PATH=C:\Users\Andy\llvm+clang+lld-18.0.0-x86_64-windows-msvc-release-mt -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT
msbuild /m -p:Configuration=Release INSTALL.vcxproj
```

#### Debug Mode

```bat
mkdir C:\Users\Andy\clang-18.0.0.src\build-debug
cd C:\Users\Andy\clang-18.0.0.src\build-debug
"c:\Program Files\CMake\bin\cmake.exe" .. -Thost=x64 -G "Visual Studio 16 2019" -A x64 -DCMAKE_INSTALL_PREFIX=C:\Users\andy\llvm+clang+lld-18.0.0-x86_64-windows-msvc-debug -DCMAKE_PREFIX_PATH=C:\Users\andy\llvm+clang+lld-18.0.0-x86_64-windows-msvc-debug -DCMAKE_BUILD_TYPE=Debug -DLLVM_USE_CRT_DEBUG=MTd
msbuild /m INSTALL.vcxproj
```

## Posix

This guide will get you both a Debug build of LLVM, and/or a Release build of LLVM.
It intentionally does not require privileged access, using a prefix inside your home
directory instead of a global installation.

### Release

This is the generally recommended approach.

```
cd ~/Downloads
git clone --depth 1 --branch release/18.x https://github.com/llvm/llvm-project llvm-project-18
cd llvm-project-18
git checkout release/18.x

mkdir build-release
cd build-release
cmake ../llvm \
  -DCMAKE_INSTALL_PREFIX=$HOME/local/llvm18-release \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS="lld;clang" \
  -DLLVM_ENABLE_LIBXML2=OFF \
  -DLLVM_ENABLE_TERMINFO=OFF \
  -DLLVM_ENABLE_LIBEDIT=OFF \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_PARALLEL_LINK_JOBS=1 \
  -G Ninja
ninja install
```

### Debug

This is occasionally needed when debugging Zig's LLVM backend. Here we build the three
projects separately so that LLVM can be in Debug mode while the others are in Release
mode.

```
cd ~/Downloads
git clone --depth 1 --branch release/18.x https://github.com/llvm/llvm-project llvm-project-18
cd llvm-project-18
git checkout release/18.x

# LLVM
mkdir llvm/build-debug
cd llvm/build-debug
cmake .. \
  -DCMAKE_INSTALL_PREFIX=$HOME/local/llvm18-debug \
  -DCMAKE_PREFIX_PATH=$HOME/local/llvm18-debug \
  -DCMAKE_BUILD_TYPE=Debug \
  -DLLVM_ENABLE_LIBXML2=OFF \
  -DLLVM_ENABLE_TERMINFO=OFF \
  -DLLVM_ENABLE_LIBEDIT=OFF \
  -DLLVM_PARALLEL_LINK_JOBS=1 \
  -G Ninja
ninja install
cd ../..

# LLD
mkdir lld/build-debug
cd lld/build-debug
cmake .. \
  -DCMAKE_INSTALL_PREFIX=$HOME/local/llvm18-debug \
  -DCMAKE_PREFIX_PATH=$HOME/local/llvm18-debug \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_PARALLEL_LINK_JOBS=1 \
  -DCMAKE_CXX_STANDARD=17 \
  -G Ninja
ninja install
cd ../..

# Clang
mkdir clang/build-debug
cd clang/build-debug
cmake .. \
  -DCMAKE_INSTALL_PREFIX=$HOME/local/llvm18-debug \
  -DCMAKE_PREFIX_PATH=$HOME/local/llvm18-debug \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_PARALLEL_LINK_JOBS=1 \
  -DLLVM_INCLUDE_TESTS=OFF \
  -G Ninja
ninja install
cd ../..
```

Then add to your Zig CMake line that you got from the README.md:
`-DCMAKE_PREFIX_PATH=$HOME/local/llvm18-debug` or `-DCMAKE_PREFIX_PATH=$HOME/local/llvm18-release`
depending on whether you want Debug or Release LLVM.
