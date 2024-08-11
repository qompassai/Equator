## Where is the stdlib code located?
You can find it under [`/lib/std/`](https://github.com/ziglang/zig/tree/master/lib/std).

## How is the stdlib structured?
When you import "std" in a Zig source file, you are importing [`/lib/std/std.zig`](https://github.com/ziglang/zig/tree/master/lib/std/std.zig).

```zig
const std = @import("std");
```

In that file you can see where each exposed symbol comes from:

```zig
// Excerpt from std.zig
...
pub const ArrayHashMap = array_hash_map.ArrayHashMap;
pub const ArrayHashMapUnmanaged = array_hash_map.ArrayHashMapUnmanaged;
pub const ArrayList = @import("array_list.zig").ArrayList;
pub const ArrayListAligned = @import("array_list.zig").ArrayListAligned;
pub const ArrayListAlignedUnmanaged = @import("array_list.zig").ArrayListAlignedUnmanaged;
pub const ArrayListUnmanaged = @import("array_list.zig").ArrayListUnmanaged;
...
```


Some parts of the stdlib are simple and are implemented in a single file, like `std.ascii`, which is entirely implemented in `/lib/std/ascii.zig`.

Other parts of the standard library are beefier and have their own dedicated subdirectory, like `std.math`. These "submodules" always have a regular structure: 
- A subdirectory that contains most of the implementation
- A file inside `/lib/std/` that exposes the public parts implemented in the relative subdirectory

In the case of `std.math`, for example, `/lib/std/math/ceil.zig` contains the implementation of ceil that `/lib/std/math.zig` then re-exports like this:

```zig
pub const ceil = @import("math/ceil.zig").ceil; 
```

The directory tree of the `std.ascii` and `std.math` files described above looks like this:

```
.
`-- lib/
    `-- std/
        |-- ascii.zig
        |-- math/
        |   `-- ceil.zig
        `-- math.zig
```

With this knowledge it should be easy for you to track down the implementation code of every symbol defined in the standard library.


## Tricks
- Search for `pub fn` and `pub const` to quickly skim over the public API of an implementation.
- The same file that contains the implementation of something will often also contain tests for it. Tests can be useful to learn about how to use an API. You can search for `test` to find them quickly.


## Is there any other material on the topic?
- [Reading Zig's Standard Library (video)](https://www.youtube.com/watch?v=NQgju_2mX-8)