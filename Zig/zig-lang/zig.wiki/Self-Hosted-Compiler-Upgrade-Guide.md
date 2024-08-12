This guide is to help you modify your project so that it builds & runs correctly again after the merge of [#12368](https://github.com/ziglang/zig/pull/12368).

## Is it time to upgrade?

One option you have is to simply wait for 0.10.0, or even 0.10.1, before attempting an upgrade. This gives you the smoothest experience, letting other, more brave souls, help with quality assurance before you get your hands dirty. There's no shame in this, do what works for you.

If anything goes wrong in the upgrade, you can always start using `-fstage1` to get the old compiler, or put the equivalent in your build.zig file, so that your users can continue using `zig build` as usual.

```zig
exe.use_stage1 = true;
```

The new compiler, sometimes called "stage2" or "stage3", is in many ways better than the old compiler (also called "stage1"), however it is not yet strictly better.

All 0.10.x releases will have the `-fstage1` option; the upgrade only will become mandatory starting with 0.11.0.
For some users, sticking with stage1 for the duration of the 0.10.x release will be the best move; for others, upgrading to self-hosted earlier will be right for them. This guide should help you decide which category you fall into.

In between now and 0.10.0, the Zig team will do our best to address real world bugs and get as many third party projects supported by the new compiler as possible. Some projects may not get there; these should continue to use `-fstage1` until Zig project fixes enough bugs. There will also be a 0.10.1.

### Improvements Over Stage1

 * Many bugs are fixed, which could never be fixed in stage1 due to fundamental design flaws.
 * Performance is noticeably improved. For Zig, we observe 1.5x speed in building itself.
 * Memory usage is improved by a factor of about 3x. For Zig, building itself went from using 9.1 GiB to 2.7 GiB.
 * The LLVM code generated is better. LLVM has an easier time optimizing. You likely will have small improvements in perf of your project.
 * Many compile errors are more helpful.
 * The core design is fundamentally different so that
   [game-changing performance enhancements become possible](https://www.youtube.com/watch?v=AqDdWEiSwMM)

### Falling Short of Stage1

Although we fully intend to make self-hosted a strict improvement, that is not the case yet.

 * There are some fresh bugs.
 * async/await is not done yet ([#6025](https://github.com/ziglang/zig/issues/6025)). Users of async/await cannot upgrade until a few more months when this feature is complete.
 * Some compile errors are still missing.
 * Some compile errors are less helpful.

## How to Upgrade

Assuming that you have decided the time is nigh, here are some tips.

Although most of the language is the same between stage1 and self-hosted, there are some incompatibilities. There are two strategies to deal with this:

 1. Have a different branch for when using Zig self-hosted. Once you decide to commit to the upgrade, merge that branch into your main branch.
 2. Make the codebase support both stage1 and self-hosted at the same time using conditional compilation based on `@import("builtin").zig_backend`.

## Function Pointers

In stage1, the type `fn () void` is a function pointer and acts like a pointer. However, the language spec, which is not written yet, will have this type be a "function body" type. It must be compile-time known, and in order to get a function pointer, `*const fn () void` must be used.

Self-hosted implements this correctly, which means your project will likely break everywhere that you use a function pointer.

Here is the problem most people will run into:

```zig
test "function pointer" {
    const s = foo();
    s.fnPtr();
}

const S = struct {
    fnPtr: fn () void,
};

fn bar() void {}
fn baz() void {}

var runtime: bool = true;

fn foo() S {
    if (runtime) {
        return .{
            .fnPtr = bar,
        };
    } else {
        return .{
            .fnPtr = baz,
        };
    }
}
```

With self-hosted, this produces:

```
test.zig:16:9: error: cannot load runtime value in comptime block
    if (runtime) {
        ^~~~~~~
test.zig:2:18: note: called from here
    const s = foo();
              ~~~^~
```

This happens because:
 * `fn () void` is a **function body** type, not a function pointer type.
 * Function body types are comptime-only, while function pointers may be runtime-known.
 * The struct `S` is a comptime-only type due to its comptime-only field.
 * The function `foo` is a comptime-only function due to its comptime-only return type.
 * Therefore, `foo()` is called at comptime, however it tries to read a global variable, which is runtime-known.

The solution is to make the function into a function pointer:

```diff
-    fnPtr: fn () void,
+    fnPtr: *const fn () void,
```

Ideally, the compile error for this will be enhanced to make the solution more obvious, however, that enhancement will come later.

## `{}` vs `.{}`

This one is pretty simple:

```zig
test {
    var x: void = .{};
    _ = x;
}
```

```
test.zig:2:20: error: expected type 'void', found '@TypeOf(.{})'
    var x: void = .{};
                  ~^~
```

`.{}` is a struct literal; `{}` is a void value. It has always been a bug that stage1 accepts this code. Just change `.{}` to `{}`.

```diff
-    var x: void = .{};
+    var x: void = {};
```

## Address-of Temporaries Now Produces Const Pointers

stage1 allowed this code:

```zig
const std = @import("std");

test {
    const arena = std.heap.ArenaAllocator.init(std.heap.page_allocator).allocator();

    const ptr = try arena.create(i32);
    ptr.* = 1234;
}
```

```
test.zig:4:72: error: expected type '*heap.arena_allocator.ArenaAllocator', found '*const heap.arena_allocator.ArenaAllocator'
    const arena = std.heap.ArenaAllocator.init(std.heap.page_allocator).allocator();
                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
test.zig:4:72: note: cast discards const qualifier
```

The lang spec will not allow this. Address of temporaries produces constant pointers for safety reasons. To fix this code, extract the temporary into an explicit `var`. This makes the mutable temporary more obvious, which is safer.

```diff
-    const arena = std.heap.ArenaAllocator.init(std.heap.page_allocator).allocator();
+    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
+    const arena = arena_state.allocator();
```

## Pointers to Zero-Bit Types are No Longer Themselves Zero-Bit Types

This assertion does not pass with stage1 but it does with self-hosted:

```zig
const std = @import("std");
const assert = std.debug.assert;

comptime {
    assert(@sizeOf(*u0) == @sizeOf(*u8));
}
```

However, pointers to comptime-only types are still zero bit types, such as `*comptime_int`.

## Escaped Pointer to Parameter

```zig
const std = @import("std");
const expect = std.testing.expect;

test "escaped pointer to parameter" {
    var s: S = .{ .field = 1234 };
    const value = s.foo();
    try expect(value == &s.field);
}

const S = struct {
    field: i32,

    fn foo(s: S) *const i32 {
        return &s.field; // XXX: escaped pointer to parameter
    }
};
```

This test passes with stage1 despite having a critical bug: a temporary is created by taking the address of the the [pass-by-value parameter](https://ziglang.org/documentation/master/#Pass-by-value-Parameters) which is then returned from the function.

Stage1 is naive, always passing structs by pointer in code such as this. Meanwhile, the self-hosted compiler efficiently takes advantage of smaller arguments such as this, passing them truly by value, revealing the bug.

Hopefully in the future Zig will have [runtime safety for this](https://github.com/ziglang/zig/issues/3180), however, currently this will manifest as a use-after-free. So if you find a pointer to bogus data, double check that the pointer was not created this way.

Once the problem has been identified, the fix is simple:

```diff
-    fn foo(s: S) *const i32 {
+    fn foo(s: *const S) *const i32 {
```
## Runtime Slice Concatenation & Multiplication

Slice concatenation in stage 2 now works on [any two slices with comptime-known length](https://github.com/ziglang/zig/issues/11773). This [stops the arguments from being implicitly comptime](https://github.com/ziglang/zig/issues/11773#issuecomment-1144110692), which means that function calls within a slice-concatenation expression now need to be explicitly called at comptime.

This can prevent the following example from compiling in stage 2 where it previously did in stage 1:

```zig
const std = @import("std");

test {
    const a = foo() ++ "bb";
    try std.testing.expect(a.len == 5);
}

fn foo() []const u8 {
    return "aaa";
}
```

This fix here is simple:

```diff
-    const a = foo() ++ "bb";
+    const a = comptime foo() ++ "bb";
```

## Using `builtin.zig_backend`

There is a new declaration available in `@import("builtin").zig_backend`. Contents reproduced here:

```zig
/// This enum is set by the compiler and communicates which compiler backend is
/// used to produce machine code.
/// Think carefully before deciding to observe this value. Nearly all code should
/// be agnostic to the backend that implements the language. The use case
/// to use this value is to **work around problems with compiler implementations.**
///
/// Avoid failing the compilation if the compiler backend does not match a
/// whitelist of backends; rather one should detect that a known problem would
/// occur in a blacklist of backends.
///
/// The enum is nonexhaustive so that alternate Zig language implementations may
/// choose a number as their tag (please use a random number generator rather
/// than a "cute" number) and codebases can interact with these values even if
/// this upstream enum does not have a name for the number. Of course, upstream
/// is happy to accept pull requests to add Zig implementations to this enum.
///
/// This data structure is part of the Zig language specification.
pub const CompilerBackend = enum(u64) {
    /// It is allowed for a compiler implementation to not reveal its identity,
    /// in which case this value is appropriate. Be cool and make sure your
    /// code supports `other` Zig compilers!
    other = 0,
    /// The original Zig compiler created in 2015 by Andrew Kelley.
    /// Implemented in C++. Uses LLVM.
    stage1 = 1,
    /// The reference implementation self-hosted compiler of Zig, using the
    /// LLVM backend.
    stage2_llvm = 2,
    /// The reference implementation self-hosted compiler of Zig, using the
    /// backend that generates C source code.
    /// Note that one can observe whether the compilation will output C code
    /// directly with `object_format` value rather than the `compiler_backend` value.
    stage2_c = 3,
    /// The reference implementation self-hosted compiler of Zig, using the
    /// WebAssembly backend.
    stage2_wasm = 4,
    /// The reference implementation self-hosted compiler of Zig, using the
    /// arm backend.
    stage2_arm = 5,
    /// The reference implementation self-hosted compiler of Zig, using the
    /// x86_64 backend.
    stage2_x86_64 = 6,
    /// The reference implementation self-hosted compiler of Zig, using the
    /// aarch64 backend.
    stage2_aarch64 = 7,
    /// The reference implementation self-hosted compiler of Zig, using the
    /// x86 backend.
    stage2_x86 = 8,
    /// The reference implementation self-hosted compiler of Zig, using the
    /// riscv64 backend.
    stage2_riscv64 = 9,
    /// The reference implementation self-hosted compiler of Zig, using the
    /// sparc64 backend.
    stage2_sparc64 = 10,

    _,
};
```

Please read the doc comments carefully before using this value. In summary, you can work around compiler issues by doing something like this:

```zig
const FnPtr = switch (builtin.zig_backend) {
    .stage1 => fn()void,
    else => *const fn()void,
};
```
