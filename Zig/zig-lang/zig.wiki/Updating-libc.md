Here's how to update the libc files that Zig bundles.
 
## glibc

Warning: Last time I went through this guide, I experienced a bug in glibc/scripts/build-many-glibcs.py that made it incorrectly mark compilers which had successfully finished building as "UNRESOLVED", which ruined everything. I worked around the issue by doing this process on Debian instead of on NixOS.

Make sure these dependencies are installed. If the scripts below fail, I'm not aware of a way to make them resume; each command deletes everything and starts over.

 * python3
 * subversion
 * gawk
 * autoconf
 * automake
 * libtool
 * flex
 * bison
 * build-essential
 * texinfo

Next, git clone glibc.

```
git clone git://sourceware.org/git/glibc.git
cd glibc
git checkout glibc-2.39 # the tag of the version to update to
```

Assuming the path of that is `~/glibc`, make a new directory and go to it. Then run the Python commands, each of which uses all CPU cores and takes a long time. If any of them fail, look at the logs to find out why, correct it, and then start the command again. Unfortunately each command will delete its own previous progress and start over.

```sh
mkdir multi
cd multi
python3 ~/glibc/scripts/build-many-glibcs.py . checkout
cd src/glibc
git checkout glibc-2.39 # the tag of the version to update to
cd -
python3 ~/glibc/scripts/build-many-glibcs.py . host-libraries # took 51s with 32 CPU cores
python3 ~/glibc/scripts/build-many-glibcs.py . compilers # took 2h11m with 64 CPU cores
python3 ~/glibc/scripts/build-many-glibcs.py . glibcs # took 2h with 64 CPU cores
```

Next, make sure that the list of architectures in `tools/process_headers.zig` is complete in that it lists all of the glibc targets and maps them to Zig targets. Any additional targets you add, add to the `available_libcs` global constant in `lib/std/zig/target.zig`.

Next, from the "build" directory of zig git source, use `tools/process_headers.zig`:

```sh
zig run ../tools/process_headers.zig -- --search-path ~/glibc/multi/install/glibcs --out hdrs --abi glibc
```

Inspect the `hdrs` directory that the tool just created. If it looks good, then:

```sh
rm -rf $(find ../lib/libc/include/ -name "*linux-gnu*")
rm -rf ../lib/libc/include/generic-glibc
mv hdrs/* ../lib/libc/include/
```

Inspect `git status` and make sure the changes look good. Make a commit with only the updated glibc headers in it.

Next, use [glibc-abi-tool](https://github.com/ziglang/glibc-abi-tool/) to update the `lib/libc/glibc/abilists` file. The instructions for how to do that are in the README.

Finally, update the rest of the files in `lib/libc/glibc/` besides `abilists`, to match the new glibc version, using the tool:

```
./zig run ../tools/update_glibc.zig -- ~/src/glibc ..
```

You definitely need to inspect the *full* diff and look for patches that Zig has on top of these files and put them back in place.

If any new features were added to features.h they probably need to be gated by the glibc version with an `#ifdef`.

If you keep your glibc build artifacts, you can use it with `zig build test -fqemu --glibc-runtimes /foo/glibc/multi/install/glibcs`.

## musl

```sh
git clone git://git.musl-libc.org/musl
git checkout v1.2.5 # the tag of the version to update to
rm -rf obj/ && make DESTDIR=build-all/aarch64     install-headers ARCH=aarch64     prefix=/usr/local/musl
rm -rf obj/ && make DESTDIR=build-all/arm         install-headers ARCH=arm         prefix=/usr/local/musl
rm -rf obj/ && make DESTDIR=build-all/i386        install-headers ARCH=i386        prefix=/usr/local/musl
rm -rf obj/ && make DESTDIR=build-all/loongarch64 install-headers ARCH=loongarch64 prefix=/usr/local/musl
rm -rf obj/ && make DESTDIR=build-all/mips        install-headers ARCH=mips        prefix=/usr/local/musl
rm -rf obj/ && make DESTDIR=build-all/mips64      install-headers ARCH=mips64      prefix=/usr/local/musl
rm -rf obj/ && make DESTDIR=build-all/powerpc     install-headers ARCH=powerpc     prefix=/usr/local/musl
rm -rf obj/ && make DESTDIR=build-all/powerpc64   install-headers ARCH=powerpc64   prefix=/usr/local/musl
rm -rf obj/ && make DESTDIR=build-all/riscv32     install-headers ARCH=riscv32     prefix=/usr/local/musl
rm -rf obj/ && make DESTDIR=build-all/riscv64     install-headers ARCH=riscv64     prefix=/usr/local/musl
rm -rf obj/ && make DESTDIR=build-all/s390x       install-headers ARCH=s390x       prefix=/usr/local/musl
rm -rf obj/ && make DESTDIR=build-all/x86_64      install-headers ARCH=x86_64      prefix=/usr/local/musl
rm -rf obj/ && make DESTDIR=build-all/m68k        install-headers ARCH=m68k        prefix=/usr/local/musl
```

Make sure the list of architectures in `tools/process_headers.zig` is complete
in that it lists all of the musl targets which have corresponding Zig targets.
Any additional targets you add, add to the `available_libcs` variable in
`src/target.zig`.

Next, use `tools/process_headers.zig`, with these parameters:
 * `--abi musl`
 * `--search-path` parameter will be the path to the `build-all` directory.
 * `--out` to a temporary directory if you want to inspect the output first, or `lib/libc/include` if you are confident in the output.

To update musl source code:

```sh
cd lib/libc/musl
rm -rf arch crt compat src include
cp -r ~/src/musl/arch ./
cp -r ~/src/musl/crt ./
cp -r ~/src/musl/compat ./
cp -r ~/src/musl/src ./
cp -r ~/src/musl/include ./
cp ~/src/musl/COPYRIGHT .
```

Remove the non-supported architectures:

```sh
rm -rf arch/microblaze
rm -rf arch/mipsn32
rm -rf arch/or1k
rm -rf arch/sh
rm -rf arch/x32
```

Next, look at a `git status` and `git diff` and make sure everything looks OK.
There are some chores to do below:

Update the contents of `libc/musl/src/internal/version.h` to the correct musl
version number. This file will have been deleted by the above process and you
will need to create it now (look at the `git diff` to see the contents).

Take note of the `.mak` files. These will show up in the "Untracked files"
section, and should be deleted:

```sh
rm arch/arm/arch.mak
rm arch/i386/arch.mak
rm arch/mips/arch.mak
rm arch/powerpc/arch.mak
rm arch/m68k/arch.mak
```

If there are any new ones not covered in this list, support needs to be added
in `src/musl.zig`, where there is special handling for these. Look for
`time32_compat_arch_list`.

Update `src_files` in `src/musl.zig` to be a complete list, e.g. with
`find musl/src -type f -name "*.c" -o -iname "*.s"`. Similarly, update
`compat_time32_files`, e.g. with `find musl/compat/time32 -type f -name "*.c"
-o -iname "*.s"`. Lexically sort the resulting lists in `src/musl.zig` to keep
the diff clean.

If musl added any new architectures, add them to `musl_arch_names` in
`src/musl.zig`. These can be found by `ls arch/` in the musl source directory.

### Updating the libc.S file

`lib/libc/musl/libc.S` contains stubs for all the dynamic symbols of musl's `libc.so`. It is generated from `tools/gen_stubs.zig`.

First, cross-compile musl for all the supported architectures.

Unfortunately, Zig's compiler_rt symbols will end up inside libc.so. Usually
this is harmless since these symbols are weak and overridden by libc, however
in this use case we are running a tool which inspects the symbols of libc.so to
find out what *musl* has inside of it. So,
[temporarily hack up Zig's compiler_rt](https://gist.github.com/andrewrk/4702aa82a14a865bafe0b9d61c961e7e)
to omit as many of the symbols as possible, especially the ones that have the
same name as libc symbols, such as `memset`.

```
echo -e '#!/bin/sh\nzig cc -target aarch64-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/aarch64"   --target=aarch64   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install

# fatal error: error in backend: Do not know how to soften this operator's operand!
# zig: error: clang frontend command failed with exit code 139 (use -v to see invocation)
echo -e '#!/bin/sh\nzig cc -target arm-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/arm"   --target=arm   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install

# I had to temporarily patch zig's compiler_rt to get this one to work.
echo -e '#!/bin/sh\nzig cc -target x86-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/i386"   --target=i386   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install

echo -e '#!/bin/sh\nzig cc -target mips-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/mips"   --target=mips   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install

echo -e '#!/bin/sh\nzig cc -target mips64-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/mips64" --target=mips64   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install

echo -e '#!/bin/sh\nzig cc -target powerpc-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/powerpc"   --target=powerpc   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install

echo -e '#!/bin/sh\nzig cc -target powerpc64-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/powerpc64"   --target=powerpc64   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install

echo -e '#!/bin/sh\nzig cc -target riscv64-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/riscv64"   --target=riscv64   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install

# error: unknown target CPU 'generic'
# note: valid target CPU values are: arch8, z10, arch9, z196, arch10, zEC12, arch11, z13, arch12, z14, arch13, z15, arch14
echo -e '#!/bin/sh\nzig cc -target s390x-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/s390x"   --target=s390x   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install

echo -e '#!/bin/sh\nzig cc -target x86_64-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/x86_64"   --target=x86_64   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install

# checking whether C compiler works... no; compiler output follows:
# /home/andy/local/bin/zcc: line 2: 2622967 Segmentation fault      (core dumped) zig cc -target m68k-linux-musl $@
echo -e '#!/bin/sh\nzig cc -target m68k-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/m68k"   --target=m68k   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install

# I had to temporarily patch zig's compiler_rt to get this one to work.
echo -e '#!/bin/sh\nzig cc -target riscv32-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/riscv32"   --target=riscv32   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install

# I had to temporarily patch zig's compiler_rt to get this one to work.
echo -e '#!/bin/sh\nzig cc -target loongarch64-linux-musl $@' > ~/local/bin/zcc && \
  make distclean && \
  PATH="$HOME/local/bin:$PATH" CC=zcc ./configure --prefix="$(pwd)/build-all/loongarch64"   --target=loongarch64   --disable-static && \
  PATH="$HOME/local/bin:$PATH" CC=zcc make -j$(nproc) install
```

Some of these didn't work last time I tried them, as you can see with the
comments that contain error messages. These are bugs that should be fixed in
zig or in clang. However, fixing those bugs is a separate issue that won't
block the musl upgrade process. If any of them start working, then add the
newly working architecture to the `arches` global variable in
`tools/gen_stubs.zig`.

Anyway you should now have `libc.so` built for multiple architectures:

```
andy@ark ~/src/musl ((v1.2.4))> find -name "libc.so"
./build-all/riscv64/lib/libc.so
./build-all/mips/lib/libc.so
./build-all/mips64/lib/libc.so
./build-all/aarch64/lib/libc.so
./build-all/i386/lib/libc.so
./build-all/x86_64/lib/libc.so
./build-all/powerpc/lib/libc.so
./build-all/powerpc64/lib/libc.so
```

From the root of the zig source repository:

```sh
zig run tools/gen_stubs.zig -- ~/src/musl/build-all >lib/libc/musl/libc.S
```

Pay attention to the stderr output of this command. It may reveal an issue has occurred that will require you to massage the data by editing gen_stubs.zig.

Check the `git diff` to make sure everything seems OK. In particular, look for wrongly included compiler-rt symbols that should be added to the blacklist in `tools/gen_stubs.zig`.

To verify that the stub `libc.so` matches the "real" musl `libc.so` first build a zig hello world that dynamically links musl:

```sh
zig build-exe -lc -dynamic -target x86_64-linux-musl hello.zig --verbose-link
```

Copy the path to the stub `libc.so` in the global cache from the link command logged and then run the following commands (with the proper paths):

```sh
objdump --dynamic-syms /home/ifreund/.cache/zig/o/94cd8ea1da001f912f2f7d259446424d/libc.so | sed -E -e 's/[0-9a-f]{16}//g' | sort > stubs.txt
objdump --dynamic-syms /path/to/musl/lib/libc.so | sed -E -e 's/[0-9a-f]{16}//g' | sort > musl.txt                                                
diff musl.txt stubs.txt
```

If all is well, the only output of the diff command should be the line containing the filename. For example:

```bash session
1702c1702
< ../musl/lib/libc.so:     file format elf64-x86-64
---
> /home/ifreund/.cache/zig/o//libc.so:     file format elf64-x86-64
```

## Linux

Install `rsync` and `build-essential`.

Clone the linux stable tree (note that it is different from the [torvalds tree](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git)):

```
git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
```

... and checkout the latest stable patch release. Stable kernel version is prominently displayed in the front-page of [kernel.org](https://kernel.org). Run the following commands:

```
make SHELL=/bin/sh ARCH=alpha      INSTALL_HDR_PATH=dest/alpha      headers_install
make SHELL=/bin/sh ARCH=arc        INSTALL_HDR_PATH=dest/arc        headers_install
make SHELL=/bin/sh ARCH=arm        INSTALL_HDR_PATH=dest/arm        headers_install
make SHELL=/bin/sh ARCH=arm64      INSTALL_HDR_PATH=dest/arm64      headers_install
make SHELL=/bin/sh ARCH=csky       INSTALL_HDR_PATH=dest/csky       headers_install
make SHELL=/bin/sh ARCH=hexagon    INSTALL_HDR_PATH=dest/hexagon    headers_install
make SHELL=/bin/sh ARCH=ia64       INSTALL_HDR_PATH=dest/ia64       headers_install
make SHELL=/bin/sh ARCH=loongarch  INSTALL_HDR_PATH=dest/loongarch  headers_install
make SHELL=/bin/sh ARCH=m68k       INSTALL_HDR_PATH=dest/m68k       headers_install
make SHELL=/bin/sh ARCH=microblaze INSTALL_HDR_PATH=dest/microblaze headers_install
make SHELL=/bin/sh ARCH=mips       INSTALL_HDR_PATH=dest/mips       headers_install
make SHELL=/bin/sh ARCH=nios2      INSTALL_HDR_PATH=dest/nios2      headers_install
make SHELL=/bin/sh ARCH=openrisc   INSTALL_HDR_PATH=dest/openrisc   headers_install
make SHELL=/bin/sh ARCH=parisc     INSTALL_HDR_PATH=dest/parisc     headers_install
make SHELL=/bin/sh ARCH=powerpc    INSTALL_HDR_PATH=dest/powerpc    headers_install
make SHELL=/bin/sh ARCH=riscv      INSTALL_HDR_PATH=dest/riscv      headers_install
make SHELL=/bin/sh ARCH=s390       INSTALL_HDR_PATH=dest/s390       headers_install
make SHELL=/bin/sh ARCH=sh         INSTALL_HDR_PATH=dest/sh         headers_install
make SHELL=/bin/sh ARCH=sparc      INSTALL_HDR_PATH=dest/sparc      headers_install
make SHELL=/bin/sh ARCH=x86        INSTALL_HDR_PATH=dest/x86        headers_install
make SHELL=/bin/sh ARCH=xtensa     INSTALL_HDR_PATH=dest/xtensa     headers_install
```

Eyeball the `linux_targets` variable inside `tools/update-linux-headers.zig`.

```
rm -rf lib/libc/include/*-linux-any
zig run tools/update-linux-headers.zig -- --search-path ~/Downloads/linux/dest --out lib/libc/include
```

## freebsd

TODO

## openbsd

TODO

## netbsd

TODO

## macOS

Follow the directions on the README of [ziglang/fetch-them-macos-headers](https://github.com/ziglang/fetch-them-macos-headers).

The "fetch" command has to be run natively on 6 different macOS computers:

 * x86_64-macos-11.x.x (Big Sur)
 * x86_64-macos-12.x.x (Monterey)
 * x86_64-macos-13.x.x (Ventura)
 * aarch64-macos-11.x.x (Big Sur)
 * aarch64-macos-12.x.x (Monterey)
 * aarch64-macos-13.x.x (Ventura)

Be sure to run all system updates (other than upgrading to the next major OS version) before running the "fetch" command.

After each fetch command, commit the changes to the repository. Finally, after all fetches have been completed, run the "generate" command, using the destination path of the Zig source repository.

## mingw-w64 (Windows)

The process-headers tool is not needed for these headers because mingw-w64
headers are already multi-architecture.

```
git clone git://git.code.sf.net/p/mingw-w64/mingw-w64
```

Check out the latest master branch commit.

```
ZIGSRC=$HOME/Downloads/zig
rm -rf $ZIGSRC/lib/libc/include/any-windows-any /tmp/prefix
cd mingw-w64-headers
./configure --prefix=/tmp/prefix --with-default-msvcrt=ucrt
make install
mv /tmp/prefix/include $ZIGSRC/lib/libc/include/any-windows-any
```

Next, navigate back to your Zig checkout and update the CRT files:

```
zig build update-mingw -Dmingw-src=$HOME/Downloads/mingw-w64
```

## wasi-libc

Fetch the `wasi-libc` repository:

```sh
git clone https://github.com/WebAssembly/wasi-libc
```

The `src/wasi_libc.zig` contains the code to build it from Zig. It should mirror the `wasi-libc` `Makefile`. The order of include directories is especially important.

So, start by inspecting the `Makefile`'s history and update `wasi_libc.zig` accordingly.
Also check for breaking changes in `libc-bottom-half/crt`.

Then, copy the content of `wasi-libc`'s `libc-bottom-half/headers/public/wasi` into `lib/zig/libc/include/wasm-wasi-musl/wasi`.

Next, sync the content of the following directories into `lib/libc/wasi`:

* `emmalloc`
* `libc-bottom-half`
* `libc-top-half`
  
The `libc-bottom-half/headers/public` subdirectory should ignored, as its content was already copied to `lib/zig/libc/include/wasm-wasi-musl/wasi`.

Finally, run the usual test suite and watch for regressions.

By the way, `wasi-libc` can be compiled with `zig cc` (make sure that Zig's `wasm-wasi-musl/wasi` directory is up to date beforehand):

```sh
env AR="zig ar" CC="zig cc -target wasm32-freestanding" make
```
