Recently, proposal [#5909](https://github.com/ziglang/zig/issues/5909) was implemented into the Zig compiler (see [the PR](https://github.com/ziglang/zig/pull/16163)). This change
improves readability and safety, but requires a little explanation to understand how to use properly.

## Result Locations and Types

If you've been using Zig a while, you might be familiar with Result Location Semantics (RLS). The
idea here is that when you write an expression like `ptr.* = .{ .x = 1, .y = 2 }`, the literal on the
right-hand side isn't actually constructed in memory; instead, this is translated as if it were
`ptr.*.x = 1; ptr.*.y = 2;`. This feature is an active area of experimentation in the compiler, and
exists both as an optimization and as a way to construct values which must exist at a fixed memory
address (see also [this related issue](https://github.com/ziglang/zig/issues/2765)).

A highly related concept in Zig is the idea of an expression's "result type". Loosely speaking, the
idea is that we can know from an expression's surrounding context what type the expression has, and
this can change how we evaluate the expression itself. Here are some examples of result types:
* In `const x: T = e`, the result type of `e` is `T`
* In `@as(T, e)`, the result type of `e` is `T`
* In `return e`, the result type of `e` is the function's return type
* In `f(e)`, the result type of `e` is the function's first parameter type
* In `x >> y`, the result type of `y` is the log-2 int type of `x`
* In `S{ .f = e }`, the result type of `e` is the field type of `f`

There are many more expressions which have result locations and types - this is not yet properly
documented, but when it is, the documentation will live
[here](https://ziglang.org/documentation/master/#Result-Location-Semantics). In the meantime, any
questions on RLS or result types can be directed towards one of the many Zig [community spaces](Community).

## Cast Builtins

Let's look at the actual change here. Here is a list of all affected builtins:
* pointer casts: `@addrSpaceCast`, `@alignCast`, `@ptrCast`
* similar-type casts: `@errSetCast`, `@floatCast`, `@intCast`
* xFromY casts: `@intFromFloat`, `@enumFromInt`, `@floatFromInt`, `@ptrFromInt`
* other: `@truncate`, `@bitCast`

Importantly, note that `@as` is unaffected.

All of these builtins used to take two parameters; now, they only take one (the value to cast). The
type to cast *to* is inferred based on the **expression's result type**.

If used in an expression with no result type, you'll get an error like this:
```
$ zig test foo.zig
foo.zig:2:15: error: @enumFromInt must have a known result type
    const x = @enumFromInt(123);
              ^~~~~~~~~~~~~~~~~
foo.zig:2:15: note: use @as to provide explicit result type
```

The error note here provides a hint on an easy way to provide a result type: the `@as` builtin. This
builtin performs a _coercion_ to a known type, but also sets the result type of its second operand.
So we could write this:
```zig
const x = @as(MyEnum, @enumFromInt(123));
```

This works, but it's definitely not very nice to read. That's because normally, this isn't the best
thing to do; result types can normally come from other, more useful, contexts. In this case, we'd prefer to use a
type annotation on `x`:
```zig
const x: MyEnum = @enumFromInt(123);
```

Much better! This is no longer or messier than the old syntax, and it's a bit clearer what the type
of `x` is.

In many cases, you won't need to annotate types at all; this was one of the key motivators for this
change. For instance, consider the following snippet (using the old syntax):
```zig
const S = struct { x: u32 };
var y: u64 = something();
const s: S = .{ .x = @intCast(u32, y) };
```

The problem here is that this logic is not resilient to refactoring: if the type of the field `x` is
changed, we could easily forget to update the `@intCast` with it, and potentially cause an overflow
when we don't need to. So, what does this line look like under the new semantics?
```zig
const s: S = .{ .x = @intCast(y) };
```

This is much better! The downcast is still explicit, like we want it to be, but we haven't
needed to duplicate the result type. This makes the code a bit cleaner, and more resilient to
refactoring.

The intention is that **most expressions should work like this**: either requiring a simple type
annotation on a `const` or `var`, or requiring no type at all (instead inferring it from the result
location).

### Pointer Casts

One slightly hairy part of this is pointer casts. In particular, `@alignCast` and `@addrSpaceCast`
are a bit special: under the old syntax, we don't pass them the full type, but instead *just* the
new alignment or address space. Moreover, these are often chained, as in
`@ptrCast(*T, @alignCast(@alignOf(T), ptr))`. How do we make this work without making it much more
verbose?

The solution here is that pointer casts work a little bit differently. Any nesting of `@ptrCast`,
`@alignCast`, `@addrSpaceCast`, `@constCast`, and `@volatileCast` is treated by the compiler as a
**single operation**, with one overall result type. That means, for instance, that you can apply the
following change:
```diff
  const ptr: *anyopaque = something();
- const self = @ptrCast(*Self, @alignCast(@alignOf(Self), ptr));
+ const self: *Self = @ptrCast(@alignCast(ptr));
```

Here, the `*Self` result type is passed to the `@ptrCast(@alignCast(ptr))` expression, which then
casts to that type. It may help to change how you think about these builtins: rather than thinking
of them as *doing* a cast, think of them as *allowing* a cast, e.g. `@constCast(@alignCast(ptr))`
means "it is allowed to change the alignment and const-ness of `ptr`".

Note that any nesting order is permitted for these builtins; it has no effect on functionality or
generated code.

## `zig fmt`

Since these are quite fundamental changes which will affect a large amount of Zig code,
`zig fmt` has been made to automatically update code in the old style to the new style where
possible. This migration is done very naively, always using `@as`. For instance, it will perform
this change:
```zig
- const y = @intCast(u8, x);
+ const y = @as(u8, @intCast(x));
```

This change isn't very pretty - and definitely isn't how you'd write the code yourself - but it will
work the same as before. If you have a small codebase with relatively few usages of these builtins,
you may instead wish to spend time manually cleaning up all use sites.

Most builtins support this automatic fixup without problems, but there are a few exceptions.

### `@alignCast` and `@addrSpaceCast`

The builtins `@alignCast` and `@addrSpaceCast` cannot be automatically updated, as their old usage
does not pass the full result type as a parameter, instead only passing the new alignment or address
space. `zig fmt` will not attempt to change uses of these builtins; they are left for you to fix.

### `@ptrCast` alignment

`@ptrCast` has one noteworthy quirk. Previously, `@ptrCast(*T, ptr)` had an interesting feature
where it did not always result in type `*T`. Instead, if `ptr` had a higher alignment than `*T`,
that higher alignment was implicitly preserved.

This feature does not make sense under a result-type based system. A small amount of code relies
(intentionally or not) on this behavior; such code will exhibit new compile errors after `zig fmt`
relating to misaligned pointers, and will need to be manually fixed to maintain the desired alignment.

### `@truncate`

The old usage of `@truncate` has a small quirk. When truncating a vector, you did not provide the
*vector* type as a parameter; instead, you provided the scalar type. For instance:
```zig
const x: @Vector(2, u32) = .{ 1, 2 };
const y: @Vector(2, u8) = @truncate(u8, x);
```

This quirk in usage makes it impossible to automatically update uses of `@truncate` on vectors.
`zig fmt` is unable to detect this case, and will simply apply an incorrect fix, turning the
above into `@as(u8, @truncate(x))`. This is guaranteed to always cause a compile error, so such
cases can be manually caught and corrected. (It was chosen to keep this fixup because it is by
far more common to use `@truncate` on scalars, for which the fix works correctly.)