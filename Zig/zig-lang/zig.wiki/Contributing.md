# Contributing

## Start a Project Using Zig

One of the best ways you can contribute to Zig is to start using it for a
personal project. Here are some great examples:

 * [River](https://github.com/ifreund/river/) - a dynamic tiling wayland compositor 
 * [ncdu](https://dev.yorhel.nl/ncdu) - disk usage analyzer with an ncurses interface

More examples can be found on the
[Community Projects Wiki](https://github.com/ziglang/zig/wiki/Community-Projects).

Without fail, these projects lead to discovering bugs and helping flesh out use
cases, which lead to further design iterations of Zig. Importantly, each issue
found this way comes with real world motivations, making it straightforward to
explain the reasoning behind proposals and feature requests.

Ideally, such a project will help you to learn new skills and add something
to your personal portfolio at the same time.

## Spread the Word

Another way to contribute is to write about Zig, speak about Zig at a
conference, or do either of those things for your project which uses Zig. Here
are some examples:

 * [Iterative Replacement of C with Zig](http://tiehuis.github.io/blog/zig1.html)
 * [The Right Tool for the Right Job: Redis Modules & Zig](https://www.youtube.com/watch?v=eCHM8-_poZY)
 * [Writing a small ray tracer in Rust and Zig](https://nelari.us/post/raytracer_with_rust_and_zig/)

Programming languages live and die based on the pulse of their ecosystems. The
more people involved, the more we can build upon each other's abstractions and
build great things.

## Finding a Contributor Friendly Issue

The issue label
[Contributor Friendly](https://github.com/ziglang/zig/issues?q=is%3Aissue+is%3Aopen+label%3A%22contributor+friendly%22)
exists to help you find issues that are **limited in scope and/or
knowledge of Zig internals.**

Please note that issues labeled
[Proposal](https://github.com/ziglang/zig/issues?q=is%3Aissue+is%3Aopen+label%3Aproposal)
but do not also have the
[Accepted](https://github.com/ziglang/zig/issues?q=is%3Aissue+is%3Aopen+label%3Aaccepted)
label are still under consideration, and efforts to implement such a proposal
have a high risk of being wasted. If you are interested in a proposal which is
still under consideration, please express your interest in the issue tracker,
providing extra insights and considerations that others have not yet expressed.
The most highly regarded argument in such a discussion is a real world use case.

## Editing Source Code

First, [build zig from source](https://github.com/ziglang/zig/wiki/Building-Zig-From-Source).

For a smooth workflow, it is recommended to use CMake with the following settings:

 * `-DCMAKE_BUILD_TYPE=Release` - to recompile zig faster.
 * `-GNinja` - Ninja is faster and simpler to use than Make.
 * `-DZIG_NO_LIB=ON` - Prevents the build system from copying the lib/
   directory to the installation prefix, causing zig use lib/ directly from the
   source tree instead. Effectively, this makes it so that changes to lib/ do
   not require re-running the install command to become active.

After configuration, there are two scenarios:

 1. Pulling upstream changes and rebuilding.
    - In this case use `git pull && ninja install`. Expected wait: about 10 minutes.
 2. Building from source after making local changes.
    - In this case use `stage3/bin/zig build -p stage4 -Denable-llvm -Dno-lib`. Expected wait: about 1 minute.

This leaves you with two builds of Zig:

 * `stage3/bin/zig` - an optimized master branch build. Useful for
   miscellaneous activities such as `zig fmt`, as well as for building the
   compiler itself after changing the source code.
 * `stage4/bin/zig` - a debug build that includes your local changes; useful
   for testing and eliminating bugs before submitting a patch.

## Testing

```
stage4/bin/zig build test -Denable-llvm
```

This command runs the whole test suite, which does a lot of extra testing that
you likely won't always need, and can take upwards of 1 hour. This is what the
CI server runs when you make a pull request.

To save time, you can add the `--help` option to the `zig build` command and
see what options are available. One of the most helpful ones is
`-Dskip-release`. Adding this option to the command above, along with
`-Dskip-non-native`, will take the time down from around 2 hours to about 30
minutes, and this is a good enough amount of testing before making a pull
request.

Another example is choosing a different set of things to test. For example,
`test-std` instead of `test` will only run the standard library tests, and
not the other ones. Combining this suggestion with the previous one, you could
do this:

```
stage4/bin/zig build test-std -Dskip-release
```

This will run only the standard library tests in debug mode for all targets.
It will cross-compile the tests for non-native targets but not run them.

When making changes to the compiler source code, the most helpful test step to
run is `test-behavior`. When editing documentation it is `docs`. You can find
this information and more in the `zig build --help` menu.

### Directly Testing the Standard Library with `zig test`

This command will run the standard library tests under a small number of
configurations and is estimated to complete in 3 minutes:

```
zig build test-std -Dskip-release -Dskip-non-native
```

However, one may also use `zig test` directly. From inside the `ziglang/zig` repo root:

```
zig test lib/std/std.zig --zig-lib-dir lib
```

You can add `--test-filter "some test name"` to run a specific test or a subset of tests.
(Running exactly 1 test is not reliably possible, because the test filter does not
exclude anonymous test blocks, but that shouldn't interfere with whatever
you're trying to test in practice.)

Note that `--test-filter` filters on fully qualified names, so e.g. it's possible to run only the `std.json` tests with:

```
zig test lib/std/std.zig --zig-lib-dir lib --test-filter "json."
```

### Testing Non-Native Architectures with QEMU

The Linux CI server additionally has qemu installed and sets `-fqemu`.
This provides test coverage for, e.g. aarch64 even on x86_64 machines. It's 
recommended for Linux users to install qemu and enable this testing option
when editing the standard library or anything related to a non-native
architecture.

Note that QEMU packages provided by some system package managers (such as Debian) may be a few releases old, or may be missing newer targets such as aarch64 and RISC-V. If you're interested in obtaining static binaries of the latest QEMU version, this repo may be of interest: [ziglang/qemu-static](https://github.com/ziglang/qemu-static)

#### Testing Non-Native glibc Targets

Testing foreign architectures with dynamically linked glibc is one step trickier.
This requires enabling `--glibc-runtimes /path/to/glibc/multi/install/glibcs`.
This path is obtained by building glibc for multiple architectures. This
process for me took an entire day to complete and takes up 65 GiB on my hard
drive. The CI server does not provide this test coverage. Instructions for
producing this path can be found
[on the wiki](https://github.com/ziglang/zig/wiki/Updating-libc#glibc).
Just the part with `build-many-glibcs.py`.

It is understood that most contributors will not have these tests enabled.

### Testing Windows from a Linux Machine with Wine

When developing on Linux, another option is available to you: `-fwine`.
This will enable running behavior tests and std lib tests with Wine. It's
recommended for Linux users to install Wine and enable this testing option 
when editing the standard library or anything Windows-related.

### Testing WebAssembly using wasmtime

If you have [wasmtime](https://wasmtime.dev/) installed, take advantage of the
`-fwasmtime` flag which will enable running WASI behavior tests and std
lib tests. It's recommended for all users to install wasmtime and enable this
testing option when editing the standard library and especially anything
WebAssembly-related.

## Improving Translate-C

Please read the [Editing Source Code](#editing-source-code) section as a
prerequisite to this one.

`translate-c` is a feature provided by Zig that converts C source code into
Zig source code. It powers the `zig translate-c` command as well as
[@cImport](https://ziglang.org/documentation/master/#cImport), allowing Zig
code to not only take advantage of function prototypes defined in .h files,
but also `static inline` functions written in C, and even some macros.

This feature works by using libclang API to parse and semantically analyze
C/C++ files, and then based on the provided AST and type information,
generating Zig AST, and finally using the mechanisms of `zig fmt` to render
the Zig AST to a file.

The relevant tests for this feature are:

 * `test/cases/run_translated_c/` - each file in this directory is C code with a `main` function. 
   The C code is translated into Zig code, compiled, and run, and tests that the expected output 
   is the same, and that the program exits cleanly. This kind of test coverage is preferred, when
   possible, because it makes sure that the resulting Zig code is actually viable. Note that
   all functions in this file will be run individually, and the test harness expects a return
   value of 0 for the test to pass.

 * `test/stage1/behavior/translate_c_macros.zig` - each test case consists of a Zig test
   which checks that the relevant macros in `test/stage1/behavior/translate_c_macros.h`.
   have the correct values. Macros have to be tested separately since they are expanded by
   Clang in `run_translated_c` tests.

 * `test/cases/translate_c/` - this directory each test case is C code, with a list of 
   expected strings which must be found in the resulting Zig code. This kind of test is more 
   precise in what it measures, but does not provide test coverage of whether the resulting Zig 
   code is valid.

Legacy translate-c tests:

 * `test/run_translated_c.zig` - this file contains tests that accomplish the same goal as the
    tests in `test/cases/run_translated_c/`, but they use the old test harness. Please do NOT
    add new cases to this file.

 * `test/translate_c.zig` - this file contains tests that accomplish the same goal as the
    tests in `test/cases/translate_c/`, but they use the old test harness. Please do NOT
    add new cases to this file.



This feature is self-hosted, even though Zig is not fully self-hosted yet. In the Zig source
repo, we maintain a C API on top of Clang's C++ API:

 * `src/zig_clang.h` - the C API that we maintain on top of Clang's C++ API. This
   file does not include any Clang's C++ headers. Instead, C types and C enums are defined
   here.

 * `src/zig_clang.cpp` - a lightweight wrapper that fulfills the C API on top of the
   C++ API. It takes advantage of `static_assert` to make sure we get compile errors when
   Clang's C++ API changes. This one file necessarily does include Clang's C++ headers, which
   makes it the slowest-to-compile source file in all of Zig's codebase.

 * `src/clang.zig` - the Zig equivalent of `src/zig_clang.h`. This is a manually
   maintained list of types and functions that are ABI-compatible with the Clang C API we
   maintain. In theory this could be generated by running translate-c on `src/zig_clang.h`,
   but that would introduce a dependency cycle, since we are using this file to implement
   translate-c.

Finally, the actual source code for the translate-c feature is
`src/translate_c.zig`. This code uses the Clang C API exposed by
`src/clang.zig`, and produces Zig AST.

The steps for contributing to translate-c look like this:

 1. Identify a test case you want to improve. Add it as a run-translated-c test
    case (usually preferable), or as a translate-c test case. 
    - see `test/cases/README.MD` for a reference for creating a test case file

 2. Edit `src/translate_c.zig` to improve the behavior.

 3. Run your test: `./zig build test-cases -Dtest-filter="my_specific_and_unique_test_file_name"`

 4. Run the relevant tests: `./zig build test-cases test-run-translated-c test-translate-c`

## Autodoc

Autodoc is an interactive, searchable, single-page web application for browsing
Zig codebases.

An autodoc deployment looks like this:

```
index.html
main.js
main.wasm
sources.tar
```

* `main.js` and `index.html` are static files which live in a Zig installation
  at `lib/docs/`.
* `main.wasm` is compiled from the Zig files inside `lib/docs/wasm/`.
* `sources.tar` is all the zig source files of the project.

These artifacts are produced by the compiler when `-femit-docs` is passed.

### Making Changes

The command `zig std` spawns an HTTP server that provides all the assets
mentioned above specifically for the standard library.

The server creates the requested files on the fly, including rebuilding
`main.wasm` if any of its source files changed, and constructing `sources.tar`,
meaning that any source changes to the documented files, or to the autodoc
system itself are immediately reflected when viewing docs.

This means you can test changes to Zig standard library documentation, as well
as autodocs functionality, by pressing refresh in the browser.

Prefixing the URL with `/debug` results in a debug build of `main.wasm`.

### Debugging the Zig Code

While Firefox and Safari support are obviously required, I recommend Chromium
for development for one reason in particular:

[C/C++ DevTools Support (DWARF)](https://chromewebstore.google.com/detail/cc++-devtools-support-dwa/pdcpmagijalfljmkmjngeonclgbbannb)

This makes debugging Zig WebAssembly code a breeze.

### The Sources Tarball

The system expects the top level of `sources.tar` to be the set of modules
documented. So for the Zig standard library you would do this:
`tar cf std.tar std/`. Don't compress it; the idea is to rely on HTTP
compression.

Any files that are not `.zig` source files will be ignored by `main.wasm`,
however, those files will take up wasted space in the tar file. For the
standard library, use the set of files that zig installs to when running `zig
build`, which is the same as the set of files that are provided on
ziglang.org/download.

If the system doesn't find a file named "foo/root.zig" or "foo/foo.zig", it
will use the first file in the tar as the module root.

You don't typically need to create `sources.tar` yourself, since it is lazily
provided by the `zig std` HTTP server as well as produced by `-femit-docs`.
