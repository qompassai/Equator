`zig cc`, as [Andrew once
mentioned](https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html),
is a drop-in replacement for gcc/clang. However, it is not a 100% drop-in
replacement: there are differences. If one digs deeper, they will be found,
hopefully not stumbled upon.

This page is intended to answer the question: "gcc/clang does X, zig cc does Y.
Is it a bug in zig or clang or both or neither?".

# The differences

A "difference" is a situation when, all other things being equal, the behavior
of the program differs depending on the chosen compiler. If clang and gcc
behave X and `zig cc` behaves Y, this is a sign of a different behavior that
should be either fixed (a bug) or added to this wiki (an intentional design
choice).

## UBSAN and "SIGILL: Illegal Instruction"

`zig cc` differs from "mainstream" compilers by [enabling UBSAN by
default](https://github.com/ziglang/zig/issues/4830#issuecomment-605491606).
Which means your program may compile successfully and crash with:

```
SIGILL: illegal instruction
```

This flag encourages program authors to fix the undefined behavior. There are
[many ways](https://github.com/ziglang/zig/issues/5163) to find the undefined
behavior.

## ELF: Use of `--gc-sections` by default

`zig cc` passes `--gc-sections` to the ld.lld linker by default, which causes
problems for CGo <= 1.18. This is [fixed for Go
1.19+](https://go-review.googlesource.com/c/go/+/407814). Until Go 1.19 is
released, it is recommended to add `--no-gc-sections` to the linker when
using `zig cc` to compile CGo programs.

## ELF: strip xor debug symbols

`zig cc` does not strip debug symbols by default and does not support the `-g`
option: debug symbols are always included in the binaries, unless the linker is
instructed to strip them.

Therefore, if one compares a simple C program (the program text is below)
compiled with gcc, clang-13 and `zig cc`, the program compiled with `zig cc`
will have debug symbols, whereas clang-13/gcc will not:

```
$ for cc in gcc clang-13 "zig cc"; do \
    $cc main.c -o main."$cc"; file main."$cc" | sed 's/:.* for/: for/'; done
main.gcc: for GNU/Linux 3.2.0, not stripped
main.clang-13: for GNU/Linux 3.2.0, not stripped
main.zig cc: for GNU/Linux 2.0.0, with debug_info, not stripped
```

More context and reasoning
[here](https://github.com/ziglang/zig/issues/11194#issuecomment-1071922540).

## Default use of link-time-optimization (LTO)

`zig cc` enables LTO by default, which can significantly affect the duration of the linking step. That can be avoided by passing `-fno-lto` to the CFLAGS at the expense of a lesser-optimized artifact.

# How to see the differences between clang and zig cc?

To compile/link ELF binaries, `zig cc` uses two underlying sub-commands under
the hood:

1. `zig clang`, a statically-compiled Clang.
2. `zig ld.lld`, a statically-compiled ELF linker from LLVM.

Our goal is to determine the exact flags that are passed to `zig clang`, `zig
ld.lld`, and to compare them to their LLVM counterparts.

Take this program as an example:

```c
#include <stdio.h>
#include <features.h>

int main() {
    #ifdef __GLIBC__
    printf("glibc_%d.%d\n", __GLIBC__, __GLIBC_MINOR__);
    #else
    printf("non-glibc\n");
    #endif
    return 0;
}
```

First, compile and link with `clang` (specifically, the clang version that zig
is linked to, which can be determined by running `zig clang --version`), and
note the linker flags:

```
clang-13 -v main.c -o main |& tee clang-13.log
```

Same with `zig cc`:

```
ZIG_VERBOSE_CC=1 ZIG_VERBOSE_LINK=1 zig cc main.c -o main |& tee zig-cc.log
```

And peruse the log files. Please file issues and update the wiki if you spot
more differences than documented above.
