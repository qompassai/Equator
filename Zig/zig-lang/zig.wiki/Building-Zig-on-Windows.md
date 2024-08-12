**Note**: If you want the latest build of Zig on Windows, you can get it from [the download page](https://ziglang.org/download/).

***

## Option 1: Use the Windows Zig Compiler Dev Kit

This one has the benefit that LLVM, LLD, and Clang are built in Release mode, while your Zig build has the option to be a Debug build. It also works completely independently from MSVC so you don't need it to be installed.

Determine the URL by [looking at the CI script](https://github.com/ziglang/zig/blob/master/ci/x86_64-windows-debug.ps1#L1-L4). It will look something like this (replace `$VERSION` with the one you see by following the above link):

```
https://ziglang.org/deps/zig+llvm+lld+clang-x86_64-windows-gnu-$VERSION.zip
```

This zip file contains:

 * An older Zig installation.
 * LLVM, LLD, and Clang libraries (.lib and .h files), version 16.0.1, built in Release mode.
 * zlib (.lib and .h files), v1.2.13, built in Release mode
 * zstd (.lib and .h files), v1.5.2, built in Release mode

### Option 1a: CMake + [Ninja](https://ninja-build.org/)

Unzip the dev kit and then in cmd.exe in your Zig source checkout:

```bat
mkdir build
cd build
set DEVKIT=$DEVKIT
```

Replace `$DEVKIT` with the path to the folder that you unzipped after downloading it from the link above. Make sure to use forward slashes (`/`) for all path separators (otherwise CMake will try to interpret backslashes as escapes and fail).

Then run:

```bat
cmake .. -GNinja -DCMAKE_PREFIX_PATH="%DEVKIT%" -DCMAKE_C_COMPILER="%DEVKIT%/bin/zig.exe;cc" -DCMAKE_CXX_COMPILER="%DEVKIT%/bin/zig.exe;c++" -DCMAKE_AR="%DEVKIT%/bin/zig.exe" -DZIG_AR_WORKAROUND=ON -DZIG_STATIC=ON -DZIG_USE_LLVM_CONFIG=OFF
```

 * Append `-DCMAKE_BUILD_TYPE=Release` for a Release build.
 * Append `-DZIG_NO_LIB=ON` to avoid having multiple copies of the lib/ folder.

Finally, run:

```bat
ninja install
```

You now have the `zig.exe` binary at `stage3\bin\zig.exe` and you can run the tests:

```bat
stage3\bin\zig.exe build test
```

This can take a long time. For tips & tricks on using the test suite, see [Contributing](https://github.com/ziglang/zig/blob/master/.github/CONTRIBUTING.md#editing-source-code).

### Option 1b: Zig build

Unzip the dev kit and then in cmd.exe in your Zig source checkout:

```bat
$DEVKIT\bin\zig.exe build -p stage3 --search-prefix $DEVKIT --zig-lib-dir lib -Dstatic-llvm -Duse-zig-libcxx -Dtarget=x86_64-windows-gnu
```

Replace `$DEVKIT` with the path to the folder that you unzipped after downloading it from the link above.

Append `-Doptimize=ReleaseSafe` for a Release build.

**If you get an error building at this step**, it is most likely that the Zig installation inside the dev kit is too old, and the dev kit needs to be updated. In this case one more step is required:

 1. [Download the latest master branch zip file](https://ziglang.org/download/#release-master).
 2. Unzip, and try the above command again, replacing the path to zig.exe with the path to the zig.exe you just extracted, and also replace the lib\zig folder with the new contents.

You now have the `zig.exe` binary at `stage3\bin\zig.exe` and you can run the tests:

```bat
stage3\bin\zig.exe build test
```

This can take a long time. For tips & tricks on using the test suite, see [Contributing](https://github.com/ziglang/zig/blob/master/.github/CONTRIBUTING.md#editing-source-code).

## Option 2: Using CMake and Microsoft Visual Studio

This one has the benefit that changes to the language or build system won't break your dev kit. This option can be used to upgrade a dev kit.

First, [build LLVM, LLD, and Clang from source using CMake and Microsoft Visual Studio](https://github.com/ziglang/zig/wiki/How-to-build-LLVM,-libclang,-and-liblld-from-source#windows). Or, skip this step using a pre-built binary tarball, which unfortunately is not provided here.

Install [Build Tools for Visual Studio 2019](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2019). Be sure to select "Desktop development with C++" when prompted.
 * You must additionally check the optional component labeled **C++ ATL for v142 build tools**.

Install [CMake](http://cmake.org).

Use [git](https://git-scm.com/) to clone the zig repository to a path with no spaces, e.g. `C:\Users\Andy\zig`.

Using the start menu, run **x64 Native Tools Command Prompt for VS 2019** and execute these commands, replacing `C:\Users\Andy` with the correct value.

```bat
mkdir C:\Users\Andy\zig\build-release
cd C:\Users\Andy\zig\build-release
"c:\Program Files\CMake\bin\cmake.exe" .. -Thost=x64 -G "Visual Studio 16 2019" -A x64 -DCMAKE_PREFIX_PATH=C:\Users\Andy\llvm+clang+lld-13.0.1-x86_64-windows-msvc-release-mt -DCMAKE_BUILD_TYPE=Release
msbuild -p:Configuration=Release INSTALL.vcxproj
```

You now have the `zig.exe` binary at `bin\zig.exe` and you can run the tests:

```bat
bin\zig.exe build test
```

This can take a long time. For tips & tricks on using the test suite, see [Contributing](https://github.com/ziglang/zig/blob/master/.github/CONTRIBUTING.md#editing-source-code).

Note: In case you get the error "llvm-config not found" (or similar), make sure that you have **no** trailing slash (`/` or `\`) at the end of the `-DCMAKE_PREFIX_PATH` value. 
