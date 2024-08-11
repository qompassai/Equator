The meetings happen weekly, every Thursday at 19.00 UTC, on [this Discord server](https://discord.gg/gxsFFjE)

Edit this wiki to get your agenda item for next week added.  
When there are no items in the agenda for a given week, the meeting is skipped.

## 2023-10-26
@Jan200101
- rpath: the path forward
  - Where is it sane to point rpaths to?
  - Should Zig set rpaths to libraries it links so?
    - This has security implicitations because other libraries could be loaded from the given path
  - preventing native library paths from polluting the rpath
    - native refers to what is in the system dynamic linker search path without having to change the environment
  - distribution compatibility
    - Fedora [forbids](https://docs.fedoraproject.org/en-US/packaging-guidelines/#_beware_of_rpath) rpaths to system paths
    - Debian allows but [discourages](https://wiki.debian.org/RpathIssue) rpaths to standard library paths
    - NixOS [relies on rpaths](https://nixos.wiki/wiki/Packaging/Binaries) to function

@mlugg
* let's recap the plan for comptime memory
  * i'm currently working on changing the pointer representation and rewriting comptime pointer accesses
    * this should completely eliminate false positive "depends on xyz having a well-defined layout" errors
    * you can do all manner of crazy pointer reinterpretations and it should always work
    * it also has some fun logic to prevent `undefined` values from turning into `0xAA`; you can currently trigger that with a simple bitcast
    * i think i have most of the logic written. todos:
      * port comptime pointer access logic from my previous attempt at this a few months ago (it nearly worked)
      * codegen new pointer repr on all backends
      * deal with bit-pointers; these are weird for fun reasons:
        * in theory, when loading a `*align(a:b:h) T`, we load a single `u<h>` and reinterpret at an offset of `b` bits
        * but this is tricky because we can't actually reinterpret pointers as integers
        * so i need special logic within the pointer access code for accessing a value at a certain bit offset
          * i need to make sure this doesn't damage performance of non-bit-pointer lookups
          * i should do some perf testing in general. maybe benchmark some non-trivial computation (e.g. hashing) at comptime
  * we've mostly eliminated the use of `Decl` for anonymous decls
    * aside: "anonymous decl" is a name we may want to consider changing, maybe to "anonymous constant"
    * my latest working model of dependencies defines a "decl" essentially just as a "named value", so "anonymous decl" would mean "unnamed named value" which doesn't really make sense
  * the next big step on the path to incremental is eliminating the last use of `Decl` for anon decls, which is comptime pointer accesses
    * we currently use the legacy `Value` representation for this; we should split something like it out into a `MutableValue` type
    * this will also allow us to finally kill off `TypedValue`
  * comptime-mutable memory will become local state to the analysis of a single decl. proposed rules:
    * references to comptime-mutable memory cannot become runtime-known, e.g. via a runtime store of the pointer value or as an arg to a runtime function call
    * references to comptime-mutable memory cannot exit the scope of the analysis which owns the memory, e.g. via a comptime argument to a non-inline generic call
    * comptime-mutable memory becomes immutable when control exits the scope it was declared in
      * non-const pointers to the memory can still exist, but trying to mutate through them is a compile error
      * this rule isn't strictly necessary, it's up to us whether we want to have it or not. i have no strong opinion currently
* async! i've been working on it (separate impl rather than the existing `stage2-async` branch)
  * semantic analysis work is basically done, and i think i understand how to do the layout of frames and how to codegen
  * the trickiest bit is actually determining whether a given function is async. this must happen after semantic analysis to allow analysis to ever be significantly threaded - otherwise, we would need to immediately analyze a runtime function when it's called to determine if it's async
  * this decouples codegen and semantic analysis - we can't necessarily codegen something immediately after analyzing it, we first need to determine whether it's async (and all of its suspension points)
  * so we should look into putting codegen on its own thread as a part of this
  * to do that, `InternPool` must be made thread-safe
    * interested to hear if andrew has thoughts on how to do this
    * obvious solution: `RwLock` on the pool or something like that? but the critical section must be as small as possible, as there will definitely be contention (quite a lot of compiler time is spent in InternPool)
      * `get` in theory is itself a potential write operation, but i suspect the majority of gets will be already interned. if so, we don't want to acquire a write lock for the entire `get`, but if we only acquire it in the not-yet-interned path then we need to check *again* whether it exists in case it was written in the meantime, which is sad
  * we should probably thread codegen in a separate pr before implementing async to make this changeset not the biggest thing in the world

## 2023-09-28
@mlugg
- Tuple memory layout: what's the deal?
  - #15479 is a bit tricky:
    - We could lower to setting each field individually, but this would be a bit slower for big tuples
    - Otherwise, this requires us to restrict memory layout compared to regular structs: homogeneous tuples must contain somewhere within them a standard, ordered, unpadded array.
      - This could potentially also allow runtime indexing of such tuples if we wanted
  - Field reordering still sounds useful when field types differ, and no real downsides that I can see
  - In-memory coercions? Is `struct { u32, u32 }` IMC to `struct { c_uint, u32 }`?
    - This allows pointer coercions like `*const struct { u32, u32 }` -> `*const struct { c_uint, u32 }`
    - This would further constrain tuple layout in the spec
- Oh dear god why does `++` work on many-pointers
  - See `test/behavior/basic.zig:manyptrConcat`
  - In the compiler, this uses the entire "memory island" of the pointee decl
    - In non-trivial cases it just crashes with `unreachable` :D
  - We agree this behavior makes no sense, right?
    - [The commit introducing this behavior](https://github.com/ziglang/zig/commit/032c722d2019a475362c0ae01241a80417bdd8a2) claims that "many-pointers at comptime have a known size like slices", which is not true
      - `Value.sliceLen` only works because its implementation is... sort of crazy (considers if the memory island corresponds to an array)
    - In fact, this is a nonsensical claim: the construction of a many-pointer in Zig cannot indicate the programmer's intent as to its "length"!

## 2023-08-17
@moosichu
- interested/have started 3 projects (ubsan-rt, time-trace & zig ar), curious as to which people think should be a prioritised. 
- ubsan-rt (and other sanitizers)
  - Goal is to solve #5163, project @ https://github.com/moosichu/zigsan
  - Current intent is to make the user experience/errors returned as helpful as possible:
    - See https://github.com/moosichu/zigsan/blob/c80d8dbf53606469e45b1a08a694046aa1f6bc2d/src/rt/ubsan_rt.zig#L32
    - Motivation is that ubsan being enabled by default is currently one of the most jarring things for newcomes to zig as a C/C++ compiler!
    - Would be good to have confirmation that this is the right approach.
    - Current assumption is that experience should aim to be consistent with zig, and not the experience llvm's ubsan rt implementation provides, is this correct?
    -  What would be considered a good state for this to be mergable upstream in terms of bugs/issues? Getting complete coverage is hard without it being used in anger. One weird bug I've come across is weird issues around f80 formatting - are those OK to ship with short term provided the basic experience is improved over the current status-quo (of just trapping?).
    - Additionally, do we need to respect all the flags clang supports with regards to PC suppression & suppressing certain errors?
  - Also currently thinking that considering we enable ubsan by default for clang, aro will want undefined behaviour sanitization as well. Will it conform to the ubsan abi or just do it's own thing?
  - Longer term - is asan integration desirable? Is this something zig allocators might even want to use?
- `-ftime-trace`
  - Need help with artifact generation - managing to generate json files in the temp folder/zig-cache but not entirely sure how that works! (TODO: provide more info on specifically what is wanted/I don't understand).
  - How does comptime eval actuall work/where does it happen in the compiler? (So this can be profiled).
  - Need a consistent way to generate artifacts from building natively with zig & C/C++.
  - Ultimate goal (I think) is to provide an experience where you type `zig build -ftime-trace` and you get good stats on the bottlenecks for your build across all artifacts (zig/C/C++) including the ability to trace comptime bits yourself. But this project is potentially quite large, so was wondering if there were any intermediate goals/ways this could be staged that would be beneficial to the compiler project. (Initial goal for me would be to just output the clang time-trace artifacts into zig-out first, but would this be mergeable as-is upstream?)
    - Does anyone know which problems they would try to tackle first in a more managable way?
- zig ar
  - TODO: Formulate some questions around this.

## 2023-08-10
@mlugg
* Consistent InternPool indices for builtin types
  * Attempted to implement this, but trickier than it seems
  * We don't want userland code to discover e.g. `std.builtin.Type` and give it another index
  * So we want to resolve them before main analysis
  * But we can't go through namespaces until we've analyzed `std.zig`, which may end up referencing those types!
  * Idea: in `Module.semaDecl`, detect the decl being `std.builtin.Xyz` and tell Sema to create the type at a specific IP index
    * Should be safe provided every such decl is a simple `const Foo = [struct,enum,etc] { ... };`
    * Can add an assertion to validate that
* Alignment requirements for comptime memory
  * Blocker for FBA working properly at comptime
  * If our FBA buffer has alignment 1 and we want to allocate something with alignment 2, how can we do that?
    * Runtime: `@intFromPtr` used and integer value offset to fit alignment
    * This can't work at comptime, since it's impossible to implement `@intFromPtr` in a transparent/reasonable way
  * Comptime pointer access currently does not enforce pointer alignment correctness at all
    * We could leave it at this, and just special-case allocators at comptime to pretend the alignment is 1
    * (or do that in the Allocator interface)
  * However, we generally try to make anything that's UB at runtime a compile error at comptime, even if it could theoretically be handled at comptime
  * So we want a way to align pointers at comptime, but this currently isn't logically possible beyond the base value's alignment, because comptime values do not have a specific address
  * Possible solution: introduce a new builtin for aligning a pointer to a boundary, and give `comptime var`s a "pseudo-address"
    * This pseudo-address would not be exposed in the language, nor have any effect on runtime code
    * It could just be equal to the alignment (e.g. a value with alignment 4 is at pseudo-address 0x4)
    * Then we have a concrete place in memory the value could be
    * New `@alignPtrToBoundary` builtin (TODO better name) uses this pseudo-address to make the FBA consistent with how it would behave if the buffer had a real address
    * This builtin would work at runtime, so FBA would not have to special-case this logic at comptime
    * May also have minor positive perf implications at runtime due to better aliasing analysis?
    * Internally using concrete addresses like this means theoretically alignment checks are perfect: if you do something weird which does give the correct alignment but would be hard to figure out otherwise, it will be at a correctly aligned pseudo-address and Just Work (tm)
    * Related to pointer mutation work: do we allow this alignment stuff to rely on the layout of undefined-layout structures? e.g. if I have a `struct { x: u32, y: u32 }` with the struct at an alignment of 8, if I take a pointer to `x`, is it allowed (assuming the struct is laid out in that order) for the pointer value to have an alignment of 8? After all, code could check this using `@offsetOf`

## 2023-03-16
@mlugg
- allowing non-CompileStep binary artifacts to be represented in package manager
    - e.g. some dependency library which is really slow to build. some people might prefer to download a prebuilt .a
    - (real use cases in mach)
    - really, 'Dependency.artifact' doesn't need to give back a full CompileStep, but just somewhere to get the final binary from
    - should it just return a 'FileSource'?
- allocator (FBA) at comptime: @returnAddress (#14931)
    - i think this is allowed to return 0 if unsupported?
    - if so, can we just do the same at comptime?
- bug with passing comptime-mutable pointers to runtime code (#10920)
    - we need to demote comptime-mutable pointers to immutable when they become comptime-unknown
    - (i.e. assigned to a global or passed as a non-comptime param to non-inline function)
    - unfortunately, this needs to happen recursively, which sorta sucks
    - do we track this information on relevant 'Value's (pointer-ey things, aggregates) or do we just bite the bullet and check recursively?

## 2023-02-23
@mlugg
- depending on the main module (useful for testing stuff with dep loops)
  - changing cli syntax some more for funsies
  - specify main *module* rather than file
  - probably keep backward-compatibility, just check if the name ends in '.zig' or something and if so make an implicit 'main' module
  - std.Build changes: CompileStep should probably just store a *Module
    - might want to change/add some helpers to make using the new structure convenient
    - possibly standardise on declaring module deps *after* creation to make creating dep loops neater?
    - while on that, maybe 'addModule' et al deserve some bikeshedding name-wise
- while making module changes, any thoughts on #12201?
- better test filtering
  - per-file filtering (currently testing individual files in std is regressed, this would be a good solution)
  - should we start exposing --test-filter to test runners? currently e.g. the compiler tests have their own '-Dtest-filter' which is a bit confusing
    - tiny brainstorm there which is a potential proposal but i'd want to discuss first: maybe you should be able to annotate tests somehow and take arguments to them, so e.g. for the compiler tests we could actually use a test block for each one annotated with the type of test it is and taking corresponding args. pulls the responsibility for stuff like threading more into the root test runner which feels good
- we now have an inferred qualified name for modules (e.g. 'root.foo.bar'). should we use these for more error output? probably handy now that package hierarchies may be more common
- we should probably decide and document constraints on module names. no colons, maybe disallow '.zig' suffix because it's confusing - anything else?

@hryx

Depending on an upstream Zig module which uses `@cImport` but does not create a static/shared lib
- Use case: local project "foo" is a Lua extension written in Zig and depends on a Lua API bindings package
    - foo wants the API defined in "lua.zig", but does not want to link against liblua.so
    - foo itself does not use `@cImport`
    - foo creates a dynamic lib with unresolved symbols
    - Host Lua (REPL or embedded) loads `libfoo.so` with `dlopen()`, resolves symbols
- Problem: there is no way to declare include paths in the upstream module definition
    - Build fails: dependency calls `@cImport` but can't find lua.h
    - foo is now responsible for calling `foo_lib.addIncludePath("...")`
    - Cached dependency is at ~/.cache/zig/p/package-hash/...
- Demo: https://github.com/hryx/test-lua-extension
    - There are 3 branches: one with no package management, one that defines the Lua wrapper, and one user ("foo" above)


## 2023-02-16
@mlugg: Sharing a dependency across multiple modules
- (note: using new terminology here. a "module" is what's created by std.Build.addModule)
- if modules `foo` and `bar` both depend on a module `common`, we want stuff within `common` to be able to be shared between them, i.e. we only want `common` to be analyzed once
- this currently works, by accident (my recent work on multi-module files should have broken it but i guess that itself is somehow broken)
- the problem is, we have no way of knowing `foo` and `bar` define `common` in the same way (i.e. give it the same deps)
- this is currently an AstGen race condition based on which one it gets to first I believe?
- we might need to change the build-exe `--pkg-begin` interface to a more "flat" structure to make this work intuitively

@r00ster91: Discuss the new experimental 6502 codegen backend
* Introduce the backend and talk about what it can do so far
* Talk about some of its problems or unique features. For example there's one problem no other backend is dealing with.
* Maybe talk about writing a 6502 emulator to test the backend and run behavior tests.
           This would greatly increase (currently pretty much non-existent) test coverage of the codegen.
           I believe the 6502 is simple enough that it would be justified to write an emulator for it. I imagine it would live in src/arch/6502/Emulator.zig or src/arch/6502/Emu.zig.
           Also, we only have to implement the instructions that we're actually codegenerating. Should be fun.
           Discuss how this would be integrated exactly. Because it would work on any platform, would this emulator be run by default on zig build test etc.?

## 2023-01-12
1. @luukdegram: Discuss https://github.com/ziglang/zig/issues/5494
    * Do we always want to emit custom sections? (Rust does this).
    * Do we want to emit custom sections based on the name? i.e. must start with `.custom_section.`?
    * There are restrictions (from LLVM) to emit this: Data must always be MDString.
        * This means it only works on global constants.
        * If I understand this correctly, data cannot contain declrefs. i.e. pointers to other decls.

After some discussion a counter-proposal was introduced:
The addition of a new builtin: `@wasmCustomSection("key", "value")`. This new builtin allows users to emit custom data into the `custom` section existent in WebAssembly modules. This has the benefits of `linksection` remaining to work as status quo which works similarly to other formats such as ELF and MachO. It also means we don't have to provide conditional checks on the `linksection` syntax in the event someone wants to emit a custom section for WebAssembly.


## 2022-12-29

1. @matu3ba: I'd like to present my work so far and ask a bunch of design questions regarding a portable interface for non-standard streams or if that is too clunky/not flexible enough.
I'd also like to discuss how to handle posix spawn, which mandates declarative step definition, but child_process offers no api to it and how this could work together with the Windows approach of process spawning (imperative like fork).
This insofar aligns with stage2, as it is a prequisite for a clean fix to std.log.debug and std.log.info do not show up in zig build test output as mentioned in https://zig.news/slimsag/my-hopes-and-dreams-for-zig-test-2pkh and I got so far no input/feedback on the design or general attitude of my PR(s) from core members.
Relevant PR (both breaking and creating new zig1 fails) https://github.com/ziglang/zig/pull/12754 and https://github.com/matu3ba/zig/tree/childproc_stdin for the sketch of necessary changes to use stdin without pipe mode.

## 2022-11-10

1. @gwenzek
    - I've adapted a large test suite for C ABI and figured out how to test it across different arch
    - discuss how to best use the test suite
    - get pointers on how to fix it

## 2022-10-20

1. @mlugg
    - inconsistent and hard to repro bug with package imports
       - I have a vague theory as to what's going on but need a hand from experienced folk to figure out if I'm right and figure out a fix
       - only repros with one specific project; I've failed at finding any reduction. I suspect the inconsistency of the issue is the problem here
       - happens without clearing cache in the meantime
       - expected behavior: no errors, actual behavior: Sema error
       - further insights might be gained from in-depth debug logging
2. @andrewrk
   - status on the 0.10.0 release (proceeding according to schedule)
       - 38 issues left open, some of these may be postponed
   - outlining a plan for moving towards a global intern pool for types and values
       - Values are represented as `u32` indices, this makes the compilation state easily serialized
       - this will affect many lines of code, therefore, Andrew has a transition plan
       - At the moment, the index into the indexed values is a `u32`, this may be changed to `u64` in the future
       - Another idea: perform Liveness Analysis on ZIR so we can reuse slots in the intern pool
       - The intern pool would also need to be garbage collected
       - we do want to eventually multi-thread Sema, but the intern pool may present a challenge for this, worst-case scenario: locking

## 2022-09-15

1. @joachimschmidt557
    - Layout of optional types
        - is it defined according to the language spec?
            - no
        - if not, should we strive toward same layout in LLVM and self-hosted?
            - yup, as the code in `type.zig` assumes the payload-first layout

## 2022-09-08

1. @Vexu
    - `referenced here` note. Reference [#10648](https://github.com/ziglang/zig/pull/10648) [#10648](https://github.com/ziglang/zig/pull/10648) [#12141](https://github.com/ziglang/zig/issues/12141) [#7668](https://github.com/ziglang/zig/issues/7668)
        - Andrew: `referenced here` notes in stage1 were very noisy, which led to people ignoring the error notes
        - maybe introduce a command-line flag to turn on these error notes?
        - But if they aren't there by default, might as well not include them
        - Maybe this version of referenced here notes: https://github.com/ziglang/zig/pull/11533
        - Vexu's idea: provide a limited error note trace for the first error together with instructions on how to get a full trace (using a command-line flag)
            - We'll go forward with this
    - Reinterpreting invalid data at comptime? Reference [#12468](https://github.com/ziglang/zig/issues/12468) [#11734](https://github.com/ziglang/zig/pull/11734)
        - SpexGuy had some opinions on this, but he was not present at the meeting
    - https://github.com/ziglang/zig/pull/12764 result locations
        - Proposal: remove type awareness from AstGen, move to Sema
        - Andrew's take: hold off on AstGen because some language design changes regarding aliasing, async, and result locations may come in the future
2. @kubkon
    - demo of the incremental COFF linker
    - issue with libstd and `File` abstraction I bumped into while working on the COFF linker and getting all tests passing on Windows: [#12783](https://github.com/ziglang/zig/issues/12783)
        - Andrew's opinion: When using `pwrite`s, we can expect that we only use `pwrite`s, so it is reasonable to make the behavior that `pwrite`s invalidate seek position
        - Luuk's opinion: People expect the same behavior across all platforms
        - Maybe also add some safety feature to `File` so that normal `write`s/other other operations will panic after `pwrite`s were performed
3. @andrewrk
   - LLVM 15 upgrade status report
       - Updated `NativeTargetInfo.zig`
       - CI will test `llvm-15` branch, when everything works, it's time to merge

## 2022-08-25

1. @joachimschmidt557
    - ~CodeGen: merging the instruction mappings of both branches in a conditional branch~ (postponed)

## 2022-08-18

1. @joachimschmidt557
    - Yet another rewrite of the register allocation mechanism in Codegen
        - Justification
            - More generic than `binOpRegister` and `binOpImmediate`
            - Handles register classes
            - Promotes use of `Air.Inst.Index` instead of `MCValue`
            - Handles edge case of flipped RHS and LHS
        - Also: get rid of `binOp`
            - huge function, split each switch prong into a new fn
            - eliminate redundancies and footguns (e.g. checking whether an operand fits into an immediate)
2. @kristoff-it
    - Quick update on the state of Autodoc
        - source listings are implemented
        - at the moment, source listings are basically only the source files with syntax highlighting and anchors for line numbers
        - Future work: clicking import paths leading to other files, clicking other stuff leading to their respective declaration
        - Loris thinks replacing multiple-file approach in the future might be possible
        - Proposition: go even further, ship Autodoc as a WASM module and generate documentation and syntax highlighting on-the-fly just-in-time
            - would maybe make examples in the language reference editable and runnable
            - There is an inherent tradeoff between bandwidth and compute power here – having the compiler as a WASM module means less data tranferred (only raw source without syntax highlighting and other metadata) but having more power draw on the client
            - We'll have to investigate further where we want to land eventually

## 2022-08-04

1. @vincenzopalazzo
   - std-lib: JSON parsing panic when the string contains trash at the end, [issue related](https://github.com/vincenzopalazzo/cln4zig/issues/2)
        - Suggestion: use https://ziglang.org/documentation/master/std/#root;io.Reader.readUntilDelimiterArrayList API of `std.io.Reader`
2. @matu3ba
    - questions on AST traversal and rendering strategy for zig-reduce (see https://gist.github.com/matu3ba/a6a76dd8309b37a002cd09de79512e99)
        - `render` function of "normal" AST is written with `zig fmt` in mind
        - Suggestion: using translate-c's AST API which is a bit more flexible and more suitable for this use case
    - strategy to reduce generated C code (see https://github.com/ziglang/zig/issues/11651, https://github.com/ziglang/zig/issues/11849)
        - An AIR optimization is necessary where we prevent emitting many debug line numbers (which may arise from comptime code etc.)

## 2022-07-28

1. @joachimschmidt557
    - self-hosted codegen: revamp `branch_stack` mapping of AIR indices -> `MCValue`
        - problem that made Joachim aware of this issue is unrelated (runtime safety checks for divisions are emitted in Sema even when the RHS of the division is a constant)
        - example AIR snippet:
```
  %4 = constant(u32, 32)
   ...
  %6 = cmp_neq(%4, %5!)
   ...
  %15 = div_trunc(%0!, %4!)
```
In `%6`, `%4` is moved into a register. This move is made "permanent", i.e. in the instruction mapping, the MCValue corresponding to `%4` is no longer an immediate, but instead a register. This alone is actually a good thing: For more complex constants such as `0x1234abcd`, moving them into a register is something we want to avoid as much as possible, so we communicate to later instructions that this value is "cached" in a register.

However, a problem arises in `%15`. Codegen doesn't know that `%4` is actually a constant value and cannot generate a more efficient right shift. The solution is to add more tracking information.

Also related: "copy-on-write" behavior for register and stack allocations: For `register_c_flag` MCValues, we currently need to allocate a new register (which is kinda wasteful) when we want to access the register or the c flag individually (as part of `struct_field_val`). Proposed solution: introduce more sophisticated tracking mechanisms to `RegisterManager` (and future `StackManager`) which support multiple AIR instructions "sharing" an MCValue and performing "copy-on-write" if necessary.

Also also related: Why do the native codegen backends have this branch stack? It's because they don't have the luxury of infinite registers like LLVM and WASM. Therefore, they need to keep track of branches and consolidate the MCValues of different branches.

2. @mattnite
    - some experiments on C/C++ build.zig packages
        - Goal: make transition from CMake to `build.zig` as smooth as possible
        - Proposed "design pattern" in `build.zig`:
            - `<library> = <library_name>.create(b, target, mode, <build options>` where build options can be e.g. for curl whether to enable FTP
            - `<library>.addDependency(.private, <other library>`
        - Preventing arbitrary code execution (possible options)
            - use zig comptime to configure a library
            - force libraries to only use the standard library build steps and use a custom "sandboxed" build runner
            - compile the configure code to WASM/BPF and execute that in a sandbox, make it print the dependencies and all other information on standard out
        - Integration with the system package manager
            - introduce a config that makes the build script use the system package instead of the vendored package
3. @nektro
    - debugging help for [#11867](https://github.com/ziglang/zig/pull/11867)
        - Andrew will review the PR
    - showcase of llvm15 upgrade progress
        - ThreadSanitizer runtime is manually cherry-picked from LLVM codebase, so this can be temporarily regressed in the LLVM 15 upgrade
        - `systemz` vs `s390x` naming: make it consistent, it seems like `s390x` is the preferred name
            - making this consistent can be done on `master` branch instead of `llvm15` branch
        - `llvm15` branch created, @nektro will open a PR
4. @superauguste / aurame
    - questions/clarifications about plans for stage2 language server
        - Protocol used will be different from language server protocol
        - Protocol will be subscription-based instead of query-based
5. @matu3ba (screensharing did not work)

## 2022-06-09

1. @kubkon
    - demo of some micro-optimisations immediately achievable in self-hosted backends
    - incremental writing of symtab in ELF leads to inelegant warnings in gdb, lldb, objdump, etc.
        - Likely the cause by a call of `allocateDeclIndexes` followed by the usage of `freeUnusedDecls`. Since we've been wanting to get rid of `allocateDeclIndexes` for a while now, we will follow through with that change and it will likely fix this issue as well.
    - ordering of static libs on linker line - should we link `libcompiler_rt.a` before `libc.a`, or after? Depending on the ordering,
      we will get different results. Related [#11832](https://github.com/ziglang/zig/pull/11832).
        - Problems were occurring due to symbol aliases, the alias was exported as strong, rather than the linkage as specified. - Decided to remove all symbol aliases within compiler-rt, as well as look into fixing this issue.
        - Discussed the improvement of link-time by changing compiler-rt from a singular object file, into object files per file and store those as part of the archive file. This has a few benefits: 
            - We can parallelize the compilation of those files; (This will likely offset the extra work that needs to be done to handle those files separately rather than in a singular compilation unit).
            - Symbol resolution is lazy for archive files, meaning we only link the object files within an archive if it contains a symbol that is required.
            - This means that rather than having to parse, resolve symbols and link the entire compiler-rt object file, we can simply link with the  compiler-rt functions that are actually used;
            - Deduplication/garbage collection will also be made faster by this, as there is less to clean up, further increasing the linking time. 

## 2022-06-02

1. @Luukdegram
    - Require some help tackling https://github.com/ziglang/zig/pull/11747
        - compiler_rt is working for WASM, except for `memcpy` and `memset`
        - `memcpy` and `memset` should be moved from `c.zig` to compiler_rt
        - However, this currently causes issues, specifically when compiling for MIPS+musl
        - During `LLVM Emit Object`, OOM occurs
2. @andrewrk
    - Discussing some additional linker API for Sema to query what kinds of relocations are supported by the target, for the purposes of  comptime math performed on the result of `@ptrToInt(&global_variable_or_function)`.
        - Test case: https://github.com/ziglang/zig/blob/e498fb155051f548071da1a13098b8793f527275/test/behavior/align.zig#L503
        - Top-level `const x = @ptrToInt(&foo) + 10` could be lowered to a relocation of foo with addend 10
        - requires addend support in linker format (WASM doesn't support this)
        - ELF also supports negative addends
        - Support for this can be added incrementally; if the linker backend does not support these operations, emit a compile error
3. @kristoff
    - Next steps to expose autodoc from Zig master.
        - new Autodoc is close to publishable
        - command-line flag for new Autodoc could be possible, but not necessary (old Autodoc has a bad reputation anyways)
        - new Autodoc has a larger JSON payload size (28 MB vs 13 MB on stdlib)
        - However, compressed (gzip) sizes are very similar (1-2 MB)
        - Source code in Autodoc: as strings inside JSON payload or HTML files?
        - Extra network requests for source code viewing is an acceptable tradeoff, so HTML files sounds like a good idea


## 2022-05-26

1. @Vexu
   - `@ptrToInt` on pointers to comptime variables
       - https://github.com/ziglang/zig/blob/b08d32ceb5aac5b1ba73c84449c6afee630710bb/test/behavior/align.zig#L508
       - Previous design: Storing the result of `@ptrToInt` on a comptime var to a runtime value will cause the comptime var to lose it's mutability and be a global constant henceforth
       - Proposal: Make that a compile error instead
2. @kubkon - ~If Jakub can make it~(I made it!!!) we'll talk about adding linker test cases to the test-cases harness.
   - initial proposal (rejected): Linker tests usually need multiple files, so for each test we include one folder with all the source files and a `manifest` file which describes the build process and the expected output/some other test (e.g. fuzzy grep).
   - Consensus: No binary blobs in source tree
   - `zig cc` is used by Go and Rust, we want regression tests for that, but we'll do that in a different repo
   - Alternative to initial proposal: Use the standalone tests API
   - New build step for linker tests, these tests will however reuse the standalone test API
   - Also: we will start to enable LLVM in the CI tests
3. @kristoff-it 
   - ultra quick demo of autodoc progress
       - Autodoc is searching for more contributors
       - some things are better in new autodoc, however, many features from stage1 autodoc are still missing

## 2022-05-19

1. @andrewrk
   - let's come up with a strategy for more efficient overflow arithmetic lowering for safety checks, and coordinate between different backend maintainers to make sure it is reasonable for the different backends.
       - The approach by stage2 results in slightly less optimal LLVM IR
       - The generated assembly is identical however
       - Turns out this is not a problem
2. @kubkon
   - AVX PoC for native self-hosted x64 backend - [#11681](https://github.com/ziglang/zig/pull/11681)
       - floating point support with AVX/SSE works on Linux and macOS now
   - handling of extended register sets in regalloc - general purpose + floating-point/SIMD
   - demo of new register locking mechanism - vital for anyone wanting to contribute to native backends that require register use!
       - previous mechanism (freeze/unfreeze) was error-prone (a register could be locked a second time further down in the call stack and unlocked when returning to the caller function, which assumed it was locked)
       - New lock/unlock mechanism prevents this bug by only locking once
   - [#10318](https://github.com/ziglang/zig/issues/10318) - proposed resolution by changing macOS ABI from GNU to none in [fix-10318](https://github.com/ziglang/zig/tree/fix-10318)
       - The default ABI for macOS will change to `none`
       - Compile error when using `gnu` abi for macOS (similar to the error which is shown when using `musl` ABI on `macos`)

## 2022-04-28

1. @kubkon
    - demo of the new test harness for compile error tests and run-and-compare (incremental updates) tests
        - spec by @mitchellh in [#11288](https://github.com/ziglang/zig/issues/11288)
        - initial draft partial implementation by @topolarity in [#11284](https://github.com/ziglang/zig/pull/11284), [#11417](https://github.com/ziglang/zig/pull/11417) and [#11421](https://github.com/ziglang/zig/pull/11421)
        - some cleaning + more complete manifest parser + migration of run-and-compare tests in [#11530](https://github.com/ziglang/zig/pull/11530)

## 2022-04-21

1. @joachimschmidt557
    - debug info for local variables: keep AIR instructions alive for debug info purposes
        - Joachim's "premise": no `<optimized out>` in debug builds
        - This would require us to preserve AIR instructions which have debug info attached to them
        - Temporary AIR instructions which do not have debug info attached do not have this restriction
        - We run into a predicament:
            - On the one hand, no `<optimized out>` in debug builds makes sense
            - On the other hand, extracting a temporary into a constant variable should not have negative effects on the performance
        - Also might be worth considering: Overwriting variables with undefined once they go out of scope
        - @kubkon wants to investigate capabilities of DWARF, how it might mitigate this issue
        - Possible solution:
            - Make the frontend handle this
            - Add a new AIR instruction (e.g. `dbg_var_end`) for when a variable `x` goes out of scope
            - This has the effect that the AIR instruction connected to `x` dies exactly at that `dbg_var_end` instruction
            - Investigate the implications of this in a separate branch
2. @andrewrk
    - outline the plan for shipping the self-hosted compiler
        - 0.10.0 has two non-negotiable prerequisites:
            - [ship self-hosted](https://github.com/ziglang/zig/issues/89)
            - LLVM 14
        - Next steps
            1. fix translate-c segfault
            2. runtime safety tests (will unlock working on 3 with stage3)
            3. compile error tests

## 2022-03-17

1. @joachimschmidt557
    - remove `MCValue.embedded_in_code`
        - consensus: yes, do it
        - switch jump tables will be lowered using a different mechanism than `MCValue.embedded_in_code`
    - register allocation for floating point registers
        - Multiple `RegisterManager`s or one unified?
        - We also need to keep vector registers in mind
        - Try multiple `RegisterManager`s approach for now
2. @kubkon
    - demo of hot-code reloading on macOS
        - AArch64 backend still needs some work for stdlib `nanosleep`
        - ~~Requires sudo for now~~ Managed to bake in entitlements as explained in the follow-up blog post: https://www.jakubkonka.com/2022/03/22/hcs-zig-part-two.html
            - needs to open Mach IPC port
            - LLDB compiled from source can do this without sudo using entitlements
            - we will do this too
        - Requires manual pkill of child process for now
        - Also works with ASLR enabled (we kind of act like a dynamic linker)
        - Blog post on Jakub's homepage: http://www.jakubkonka.com/2022/03/16/hcs-zig.html
3. @Snektron
    - Showcase some spir-v progress
        - stage2 can compile a SPIR-V shader which can then be executed on the GPU by a Zig program which was also compiled with stage2
        - improvements to SPIR-V inline assembly will be taken into account when overhauling inline assembly
4. @andrewrk
    - quick progress update and asking people with open PRs to please rebase because of the recent CI failure

## 2022-03-10

1. @andrewrk
   - let's figure out how we want Sema to emit debug information for local variables that works well for the LLVM backend as well as the native backends and wasm backend.
       - Mapping of variable names to locations (stack, register)
       - Add 2 more AIR instructions: "debug pointer" and "debug value" (corresponding to the LLVM debug instructions)
       - We should also emit spills (register -> stack offset and vice versa) in DWARF
       - There was still uncertainty whether 2 instructions were necessary or 1 is enough
       - Andrew will implement this for LLVM (and possibly reduce it to 1 extra instruction)
2. @kristoff-it
    - Showcase current state of Autodoc, briefly explain implementation layout & main techniques adopted, invite others to contribute. [Video trailer](https://clips.twitch.tv/NastySmallDonkeyM4xHeh-MRPWeTcGhj0ezOlV).
        - [Slides](https://docs.google.com/presentation/d/1I7ofH3Q1dZdYjAymDNUJK8DzZeO7gpt1eAFDZpcEIRA/edit?usp=sharing)
        - Autodoc can render `std.ascii` already
        - Correct terminology: Autodoc = system that generates docs, Autodocs = the generated docs
        - High-Level Design
            - Single-Page Application, search embedded in page
            - Optimise for memory usage
        - Additional features (not present in stage1 autodoc)
            - toggle for internal mode (shows private decls)
            - Sources section (syntax-highlighted Zig code)
            - Guides section (hand-written docs)
        - Autodoc uses ZIR
            - for complex expressions which cannot be trivially evaluated, Autodoc uses `ComptimeExpr`
            - Possibility: Wait for Sema to complete and use more info from there; map Sema information to `ComptimeExpr`s
            - `ArrayList`: When both `ArrayList(u8)` and `ArrayList([]const u8)` are used, show these example instatiations
        - Vision for Guides
            - searchable
            - maybe generated from folder with Markdown files?
            - figure out vision later

## 2022-03-03

1. @joachimschmidt557
    - runtime safety checks in Sema without generating too much extra machine code
        - related issues: https://github.com/ziglang/zig/issues/10248 https://github.com/ziglang/zig/issues/84
        - way forward for arithmetic operations: Sema will generate an `add_with_overflow` instruction for add operations when runtime safety is on, else will emit `add` (for subtractions, multiplications similar)
        - as `@addWithOverflow` and co. return a tuple, this enables the codegen backends to specialise on this: For e.g. ARM, `@addWithOverflow` can return an MCValue consisting of a register and the condition flags (including overflow flag). The overflow check can then be lowered to check the condition flags.
        - We will introduce optimizations to lowering of `cond_br` in codegen. If one branch ends with unreachable, we can remove the need for one branch instruction as control flow will never leave that branch again. Checking whether a branch ends in unreachable is trivial: we just check the last instruction in the branch.
        - Why Sema generates the panic: This enables us to skip emitting the panic handler if it is never called.
        - Related: For `try`, Sema can generate conditional branches with some sort of hint that the branch for the error case can jump to the end of the function (or similar) and have the non-error path (which should be the hot path) in the machine code as "uninterrupted" as possible.
2. Type Coercion in AstGen vs in Sema
```zig
const a = true;
const b = if (a) 1 else 2;
```
At the moment, this generates a coercion to bool in AstGen which should be moved to Sema.

3. https://github.com/ziglang/zig/issues/11046
    - one of the last things preventing `std.debug.dumpStackTrace`
    - @andrewrk wants to tackle this

## 2022-02-10

1. @joachimschmidt557
    - codegen: third rewrite of lowering mechanics for binary operations: showcase and feedback
2. @kubkon
    - codegen+linker: lowering of slices: showcase
    - codegen: truncation, signed, non-power-of-two: showcase and feedback
    - codegen: PIE mechanics: showcase and feedback
    - linker: refactoring of `LinkBlock` abstraction
3. @topolarity
    - sema: Does "Value.read/writeToMemory" need to respect the ABI size of exotic (non-power-of-two) types? Is memory required to be sign-extended to the full buffer size? (Context: Trying to fix an observed bug in `@bitCast` for exotic integers, where the sign bit is ignored)
4. @andrewrk
    - Pitch my SegmentedList idea
5. @agni
    - :^)

## 2022-01-27

1. @g_w1
    - For https://github.com/ziglang/zig/issues/7923 , what should the parser type of the ident be?
      We don't want to allow `test u32 {` or `test @as(...)` for example, but do we want `test @This() {`? What should the parser do vs astgen vs sema?

## 2022-01-20

1. @andrewrk
   - Should we move the concept of byval/byref from the backend to the frontend? In other words, the frontend would ask the backend if a given type was byval or byref, and avoid using the byval instructions, such as elem_val, for types that are byref. This would make Sema emit allocations rather than codegen backends having to find out (possibly too late) that they needed more allocations for byval stuff.
2. @Luukdegram
    - Moving and enable/disable behavior tests.

## 2022-01-13
1. @andrewrk
    - Getting help from @Luukdegram on the wasm backend to troubleshoot #10582
2. @joachimschmidt557
    - Register allocation stuff again (yay)
        - API change
        - scratch register for Emit pass
3. @kubkon
    - proposal: storing pointers in linear memory: dealing with moved atoms/decls in the linker via relocation mechanism rather than in codegen


## 2021-12-23
1. @gwenzek
    - Heterogeneous programming support #10397
2. @Luukdegram
    - Address spaces in Wasm. Solving #4866

## 2021-12-15

1. @mattnite
    - BTF: getting useful BTF info when compiling for BPF, see if there are other ideas for llvm intrinsics.

## 2021-11-25

1. @joachimschmidt557
    - Register allocation: maybe just use the stack for now and focus on getting more tests passing and then design a generic and efficient register allocator (credits for that idea: Loris and Meghan)
2. @Luukdegram
    - ABI implementations: Ensuring correctness between backends (llvm vs ours).
    - (Info for the curious reader: https://github.com/WebAssembly/tool-conventions/blob/main/BasicCABI.md)

## 2021-11-18

 1. @kubkon
    - callee preserved registers on x86_64 - do we reserve `rax` for params and return values only, or is a block free to use after pushing it on the stack?
    - related issue - https://github.com/ziglang/zig/pull/10140
    - for register allocator - do we track register liveness?
 2. @jmc
    - signal boost for the new wiki pages [Contributing to Stage 2](https://github.com/ziglang/zig/wiki/Contributing-to-Stage-2) and [C backend signup sheet](https://github.com/ziglang/zig/wiki/C-Backend-Behavioral-Tests-signup-sheet)

## 2021-11-11

Meeting will be skipped due to [Handmade Seattle](https://www.handmade-seattle.com/).

## 2021-11-04

1. @Luukdegram
    - Proposal and reasoning for emitting MIR in the wasm backend.
        - Supporting document: https://docs.google.com/document/d/1JEUe5ivuMHmIY8ehkVHihWIq9bFsvsB0IuVbrLp4Mak/edit?usp=sharing
2. @kubkon
    - progress on MIR transition of x86_64 backend
3. @joachimschmidt557
    - MIR branch lowering algorithm for AArch64
4. @andrewrk
    - showing off ziglang.org/perf and looking for contributions to add benchmarks to gotta-go-fast

## 2021-10-28

1. @joachimschmidt557
    - Progress on MIR transition of AArch64 backend
    - MIR branch lowering
2. @The-King-of-Toasters
    - Discussion on how to work in the event loop code.
        - End goal: add support for Solaris event ports.
        - Easy win: merge the openbsd for initOsData with the rest of the KQueue OSs.
        - Possibly shadow @kprotty to get my head around the codebase.
    - Adding seccomp definitions to `os.linux`
        - Requires filling in definitions for "classic" BPF that many OSs use, split out into own namespace?
        - Seccomp programs load members from the `seccomp_data` structure (see `<linux/seccomp.h>`) using offsets.
          A common idiom for seccomp programs in C is `offsetof(seccomp_data, arg[n])`, where arg is an array of u64s.
          I have a workaround for this, but it would be nice to have this added for parity with C (would be interested in doing this).
3. @andrewrk
   - progress demo & roadmap

## 2021-10-21

1. @joachimschmidt557
    - Register allocation in a separate pass: discussion
2. @paezao
    - Mentoring for https://github.com/ziglang/zig/issues/9185
3. @kubkon
    - Demo and review of MachO's linker state dumping mechanism: https://github.com/ziglang/zig/pull/9985
4. @moosichu
    - Request for clarification on zig ar implementation: https://github.com/moosichu/zar, https://github.com/ziglang/zig/issues/9828
      Steady progress is being made (big thanks to @iddev5), but as features get fleshed out it would be good to have an idea of a final end-goal.
       - What does it need to be considered ready for upstream integration, beyond coverage of the llvm-ar features?
       - Some behavioural differences seem to be desired from llvm-ar (in a cross-compilation setting), so it would be good to know where it struggles so we can address that.
       - Because the goal is to be a drop-in replacement for an existing program. Is that the only goal, or are there others? Should that be a compatibility mode or how the program behaves by default?
       - I also have some ideas for testing, and I want to make sure they make sense (depends on if we can use llvm-ar through zig as well).
       - Also happy to answer any questions/concerns anyone might have.
 

## 2021-10-14

1. @kubkon
   - progress on incremental Mach-O linker
   - progress on zld ELF/x86_64
2. @andrewrk
   - brainstorming on MIR
3. @andyfleming
   - help on appropriate way to run test subset (compile_errors.zig)
     - Issue: https://github.com/ziglang/zig/issues/9203
     - WIP: https://github.com/ziglang/zig/compare/master...andyfleming:fix-9203?expand=1
4. @nektro
   - Q on building with llvm13
   - Q on https://github.com/ziglang/zig/commit/b0f80ef0d5517b5ce8ba60dfae6dd986346f8d4c

## 2021-09-23

1. @joachimschmidt557
    - Thoughts on https://github.com/ziglang/zig/issues/9798

## 2021-09-16

1. @kubkon
   - demo of the MachO linker after merging traditional with incremental codepaths - https://github.com/ziglang/zig/pull/9676
   - what's next for MachO?

## 2021-09-02

1. @g-w1
   - question about ++ and ** at runtime
   - maybe plan9 debuginfo demo
2. @kubkon
   - update from the linker depths - https://github.com/ziglang/zig/pull/9676
   - discussion of current limitations for self-hosted for PIE targets
   - demo of self-hosted linking Zig with compiled C object file
3. @nektro
   - I submitted my first stage2 PR :)
   - Then I submitted 3 more
   - Not super demo-able, just excited. I can overview the bugs they fixed though

## 2021-08-26
1. @andrewrk
   - short "how to start contributing" talk
   - talk about `usingnamespace`
   - stage2 progress report
   - show some stage2 debugging tips
   - here's a contributor friendly item: https://github.com/ziglang/zig/issues/9622
   - brief explanation about Value/Type tag() vs zigTypeTag()

## 2021-07-29
1. @andrewrk
   - Pitch to see if anyone wants to try deleting the "BoundFn" type from the language and compiler (both stage1 and stage2). [#9484](https://github.com/ziglang/zig/issues/9484)
   - Demo of recent progress on getting `zig test` to work for stage2.
   - Discussion: should we kill the "ref" AIR instruction?
2. @joachmschmidt557
   - compare flags issues in self-hosted codegen

## 2021-07-15
1. @andrewrk
   - Pitch to see if anyone wants to take on `zig objcopy` [#9261](https://github.com/ziglang/zig/issues/9261)
2. @jmc
   - https://github.com/ziglang/zig/issues/9257 was closed, but not sure it's "fixed", see discussion there
   - Is https://github.com/ziglang/zig/pull/9183 mergeable?

## 2021-07-08
1. @andrewrk
   - Demo some recent progress
   - Pitch to see if anyone wants to take on a stage1 memory task to help us accelerate stage2 work this release cycle
   - Pitch to see if anyone wants to take on a project to track compilation speed over time
   - Picking back up work on AIR memory layout, specifically with a design goal in mind of improving simplicity of codegen by putting all the constants up front so they can be possibly lowered to memory without jumps
   - Code review & merging of any stage2 open PRs during the meeting
2. @greenfork
   - Questions about linker, [relevant PR](https://github.com/ziglang/zig/pull/9293)
3. @kubkon
   - Demo some recent progress on linker rewrite - merging Zld with incremental MachO!

## 2021-06-24
1. @g-w1
    - Demo plan9 hello world!
2. @andrewrk
    - Brief explanation of how ast-check is now running even when using the stage1 compiler.
3. @greenfork
    - Ideas on tilde error printing, questions [PR](https://github.com/ziglang/zig/pull/9201), [why parent](https://github.com/ziglang/zig/blob/master/src/Module.zig#L1456)
4. @redj
    - https://github.com/ziglang/zig/pull/9029 vs @kubkon's ObjC support.
5. @jmc
    - Opinions on https://github.com/ziglang/zig/issues/9182?

## 2021-06-17
1. @g-w1
    - Demo plan9 linker.
    - Discuss more inline assembly to support hello world/show abi.

## 2021-06-10
1. @Vexu
    - I have some issues and prs that could be discussed to try to shrink the pr queue.
    - Maybe a quick demo of stage2 comptime vars?
2. @andrewrk
    - It's time to rework AIR Memory Layout. Is anybody interested in taking it on? I have a branch to get you started if you want.

## 2021-05-27
### Agenda
1. @Luukdegram
    - wasm proposals, versions, and how to handle them regarding compatibility. (i.e. multi-value returns)
2. @g-w1
    - showcase unused var compile error

## 2021-05-20
1. @Snektron
   - progress on SPIR-V
2. @kubkon
   - progress and Q&A on shipping WASI libc in Zig - [#8837](https://github.com/ziglang/zig/pull/8837)
   - what to do about `zig c++ -target wasm32-wasi`?
3. @andrewrk
   - demo some progress from whole-file-astgen
   - release plan for 0.8.0 - what is left, what to prioritise, etc.

## 2021-05-13
### Agenda
1. @kubkon
   - zld demo: stage1 bootstrapped with `zig-bootstrap` passes tests on macOS
   - Wanna run macOS tests but don't have a Mac? No probs! Zig's got you covered (at least partially): [#8760](https://github.com/ziglang/zig/pull/8760)
2. @andrewrk
   - progress on stage2-whole-file-astgen
   - native libc++
   - pitch the idea of test harness loading code at runtime

## 2021-04-29
### Agenda
1. @ifreund
   - std/build: change default install prefix from local zig-cache to . #8638

## 2021-04-22
### Agenda
1. @andrewrk
   - Demo whole-file-AstGen
   - Outline what a hot code reloading feature would look like

## 2021-04-15
### Agenda

1. @joachimschmidt557:
    - Register manager: Register classes
2. @amro:
    - Stage 1 C ABI struct parameters / return values
3. @andrewrk:
    - llvm12 update
    - demo work-in-progress whole-file-astgen and std.zig integration

## 2021-04-08
### Agenda

1. @andrewrk
    - Go over some contributor friendly stage2 issues, try to inspire some fresh faces to get involved :)
    - Demo recent progress on structs & enums
    - LLVM 12 update
2. @joachimschmidt557:
    - Questions about reusing stack locations (stage2 codegen)

## 2021-04-01
### Agenda
1. @joachimschmidt557:
    - Register allocation: Use function arguments from stack
    - Questions about compiler_rt
1. @g-w1
    - Showcase ast-based doc generator
    - Ask for feedback, specifically about design

## 2021-03-25
### Agenda
1. @andrewrk:
   - brief overview of the compiler pipeline
   - zir-memory-layout branch update
   - a plan for inline while, comptime code, etc in stage2
2. @nektro: plz explain stage1 ZigType + ZigValue

## 2021-03-18
### Agenda
1. @joachimschmidt557:
    - Extract register allocation to separate file
    - Track all registers, not just callee preserved
    - Slightly modify register spilling
2. @andrewrk:
    - Pitching an idea for handling archive files in the cache system/ incremental compilation
    - Status update on zir-memory-layout branch
    - The "start2.zig" plan
3. @kubkon
    - Pitching an idea for handling PIE targets in a uniform manner - see [#8281](https://github.com/ziglang/zig/pull/8281) for changes to GOT handling on macOS
    - Status update on `zld` - see [#8282](https://github.com/ziglang/zig/pull/8282)
4. @dimenus
    - new contributor trying to grok the stage 2 compiler pipeline
    - working on TODOs for inline asm

## 2021-03-11
### Agenda
1. @joachimschmidt557: CPU feature detection on ARM revisited (see https://github.com/ziglang/zig/pull/8206)
2. @andrewrk: progress on ZIR memory layout reworking. LLVM12 status update.

## 2021-03-04
### Agenda
1. @andrewrk:
   - Demo the new target CPU features maintenance strategy
   - LLVM 12 status update
   - Looking for contributors for native CPU feature detection for ARM
   - Some guidance on lazy value system / error sets / strategizing what areas of stage2 to work on so we don't have to redo work later
2. @joachimschmidt557:
   - wrapping arithmetic vs normal arithmetic in TZIR
   - showcase of different ways we could implement CPU feature detection for ARM
3. @kubkon:
   - Yet-another-demo of zld -- zld now passes a vast majority of Zig tests both on aarch64 and x86_64!
   - Enabling logs in stage1 for the linker stage -- as a quick workaround while working out fixes to reloc fixups, I've reverted to using log.warn in place of log.debug to gather some context for the potentially failing test cases; however, a more permanent solution would be to print logs with some runtime command/setting. So the question really is, do we have something similar to how we manage logs in stage2 in stage1?

## 2021-02-25
### Agenda
1. @andrewrk: proposal to improve test harness to support loading test cases at runtime
2. @andrewrk: merge of ast memory layout
3. @kubkon: zld upstreaming & how to handle caching logic as it applies to linking

## 2021-02-18
### Agenda
1. Loris: alternate meeting venues?
2. @andrewrk: progress report on ast memory layout
3. @andrewrk: I have to drop everything and work on llvm12 branch
4. @kubkon: https://github.com/ziglang/zig/pull/8035 -- for context, I need this to be able to integrate `zld` in Zig
5. @kubkon: `zld` progress -- the story thus far...

## 2021-02-04
### Agenda
1. @andrewrk: progress on ast memory layout / asking for help with zig fmt
2. @joachimschmidt557: comptime bitwise operations
3. @Luukdegram: Small wasm demo (importing js functions and calling zig functions from js)
4. @nektro: reconsider length between release cycles

## 2021-01-28
### Agenda

1. ~~@nektro: reconsider length between release cycles~~
2. @andrewrk: experimenting with a different memory layout for AST, with the goal of less memory usage and faster perf. If it is successful, the same strategies can be applied to ZIR and TZIR.

## 2021-01-21

### Agenda

1. @joachimschmidt557: How exitlude jump relocations are implemented in the ARM backend.
2. @andrewrk: (quick announcement) temporarily regressing .zir parsing/emission in order to rework it to better fit into the design
3. @Snektron: Discuss SPIR-V architecture definitions.
4. @max: Demo register allocation system
5. ~~@kubkon: Inside the linker: what is a `TextBlock` and how do we manage the free-lists?~~
6. @kubkon: Pushing stage2 to its limits - demo!
7. @andrewrk: Pitching my grand plan to make astgen emit ZIR that handles result locations optimally and solves cases like [this](https://gist.github.com/FireFox317/21a0109030491b3a81fe579b0052fe40). Goal is clean, maintainable compiler code with no hacks, as well as avoiding dead stores in the common cases, even in debug builds.
8. ~~@kubkon: if time permits, TLS + LLVM + Apple Silicon == no stack traces in stage1. More context [here](http://www.jakubkonka.com/2021/01/21/llvm-tls-apple-silicon.html).~~

## 2021-01-14

### Agenda

1. @Luuk: Refactoring Wasm backend in stage2
2. @joachimschmidt557: [#7187](https://github.com/ziglang/zig/issues/7187)
3. @joachimschmidt557: Questions about `reuseOperand` function in `codegen.zig`
4. @FireFox317: Demo of the LLVM backend in stage2
5. @kubkon: Fancy that! -> [#7781](https://github.com/ziglang/zig/pull/7781)

## 2021-01-07

### Agenda

1. @andrewrk: It's time to start tackling comptime performance in stage2. Here's a motivating test case: https://clbin.com/VdzX5
2. @andrewrk: Windows CI is no longer able to build zig1.obj (using stage1) due to OOM. We need to figure out how to make the CI green.
3. @andrewrk: [#7296](https://github.com/ziglang/zig/issues/7296)
4. @joachimschmidt557: duplication function parameters onto the stack (for debugging purposes etc.)
5. @kubkon: demo of extern fn linking in Mach-O.

## 2020-12-22

### Agenda

1. @andrewrk will demonstrate `tracy` integration -- `tracy` is a performance profiling tool. Here's a link to Andrew's old live coding session about it: [youtube.com](https://youtu.be/c0LRjqgtKS0).
2. @kubkon asked how we will handle `threadlocal` as a keyword. How is it currently handled in stage1 with LLVM?
3. @kubkon asked what is currently missing in stage2 to get the standard basic binary like

```zig
const std = @import("std");

pub fn main() void {
    std.log.info("Hello, world!", .{});
}
```

to successfully compile?

4. @andrewrk will discuss the new thread pool landing in `master`: [ziglang/zig#7462](https://github.com/ziglang/zig/pull/7462).
5. @kubkon made a couple of major changes to how we handle Mach-O in stage2 in the sense that, much like for Elf, we preallocate space for various segments and sections to aid in incremental linking. This allows us to skip rewriting `__LINKEDIT` segment every single time `__text` changes for instance. However, this means we break out from the convention set by other tools such as Apple's `ld` or LLVM's `ld64`. Additionally, this may imply that Apple's `codesign` tool will not validate the Mach-O binary due to certain hard-coded (wrong) assumptions about the structure of the Mach-O. Question here is: should we leave it as-is for Debug builds, and perhaps follow the convention in Release?

#### Meeting notes

1. A command that might be useful for Unix-like OSes:

```
nix-shell  -p cmake -p ninja -p pkg-config -p glfw -p freetype -p capstone -p tbb -p gtk3-x11
```

2. Thread-local is delegated to an appropriate LLVM API function. @kubkon demonstrated the origin of the question being a failing libstd test on `aarch64-macos-gnu` to do with declaring a global variable as thread-local. After some live debugging, we concluded that both `clang` and `zig` generate almost identical LLVM IR for it, and @kubkon later (offline) verified that when we swap LLD for Apple's system linker, the problem disappears. @andrewrk also mentioned that he posted a question on LLVM-dev mailing list inquiring what the chances are of `aarch64` MachO2 backend being ready for LLVM 12 release, and got a disheartening reply stating that "it's ready when it's ready". So yet another point in favour of ditching LLD and putting more effort into our own linker(s).

3. @andrewrk had a stab at answering that one and the answer is that we've got quite a few major hurdles to go over before that's done
   including `comptime`, panic handlers, etc. Specifically for Mach-O however, a good first achievable milestone would be to add support for
   `extern` in stage2 and link with `libSystem` functions instead of hand-writing `print` and `exit` in pure assembly as it is done now.
   
   EDIT: the downstream tracking issue: [ziglang/zig#7527](https://github.com/ziglang/zig/issues/7527)

4. TODO @andrewrk could you write this one up as I AFK when you were discussing it?

5. The entire point boils down to whether we should worry about the generated Mach-O binaries be compatible with Apple's `codesign` tool, and the short answer is no. @andrewrk suggested that we implement the incremental linker in the most optimal and yet correct way (which BTW is not what Apple assumes in their `codesign` or more specifically `codesign_allocate` tool), and see if our users are OK with it, and perhaps, with a bit of luck, have Apple fix their incorrect assumptions in `codesign_allocate.

## 2020-12-17

### Agenda

#### 1. Simplify translate-c implementation by introducing a new pseudo-ast data structures.
See [#6710](https://github.com/ziglang/zig/issues/6710) for more context. This discussion point is championed by @andrewrk.

#### 2. Middle-level IR.
It seems like this could be modeled as a sequence of lowering and optimization passes.  So something like
parse to ast -> comptime and semantic analysis -> runtime semantic IR -> backend agnostic optimizations -> backend -> backend-specific IR -> backend specific optimizations -> assembly.

The individual backends could do multiple passes of lowering followed by optimization, some of which are shared.  So you could make a "register machine"-specific IR and passes, and a "stack machine"-specific IR and passes, and each backend could choose to run the semantic IR through one of those shared lowering + optimization processes before doing really specific backend optimizations.

The problem with the value type you showed is neatly solved by this.  The problem is that you need to combine some low-level state about registers with high-level semantic state, because you're not able to go directly to assembly.  This solves that by introducing a new IR ("register machine IR") which gets produced from the semantic IR.  The code that produces this IR can be shared between any register machine backends, and then they can use the results in different ways to generate machine code.
Backends which aren't register machines, like wasm or the JVM, can do something different with the optimized semantic IR to produce their code.  And since the semantic IR doesn't have any machine specifics in it, there aren't any problems with incompatibility.

This discussion point is championed by @SpexGuy.

#### 3. LLVM-backend for the self-hosted.
Will include a demo. This discussion point is championed by @FireFox317.

### Meeting notes

meeting minutes:
 * 6710 is accepted 
 * @Specs_guy 's middle level IR idea is good and we're gonna try to do it
 * @FireFox317 showed an impressive LLVM backend demo, looking forward to merging that. We discussed how it would integrate into the rest of the compiler design
 * @Vexu brought up 7146. I'm gonna review it, ponder it, and then we're going to do a 1:1 follow up discussion to figure stuff out, specifically regarding how to do incremental compilation


re: @Specs_guy idea,  it might be a nice idea to learn about https://mlir.llvm.org/ as inspiration. we're not going to depend on it because that would be yet another dependency on a c++ llvm project thing, but it's tackling the same problem, so it could have some important ideas for us to consider


## 2020-12-10

### Agenda

* Identify everything that is linking-dependent codegen and linking-independent codegen
    * Linking-dependent: function calls, access to global variables(?)
    * Linking-independent: everything else ?
* Clean distinction between architecture-independent stuff and architecture-specific stuff
    * Encourage deduplication of code
    * Make it very contributer-friendly to add and improve backends
* `MCValue` needs to be completely architecture-dependent
    * Some entries can be considered universal and architecture-independent (embedded_in_code, memory)
    * Entries that are not universal: Register (no registers, general purpose, floating point, etc.) and more
    * `MCValue{ .memory = ... }` is used to populate and reference the GOT via absolute addressing (e.g., `movabsq` on `x86_64`); however, for platforms that require PIE such macOS, we need to fallback to RIP-relative/PC-relative addressing, therefore should `.memory` be re-used for PIEs or should we come up with an additional/alternative to it?
* Consider supporting architechtures without general purpose registers (stack-based, C backend)
* `codegen.zig` should not contain **any** architecture-dependent code, abstract only over stuff that is shared in **all** backends
* What should belong into semantic analysis, what should belong into codegen?
    * Architecture-independent optimizations (arithmetic expressions (strength reduction), `unreachable` optimizations, constant propagation, dead code elimination, loop unrolling, etc.): after sema and before codegen?
    * Generating checks for overflow in debug builds: sema or codegen?
* *(not technically 100% codegen)* What optimizations do we want to include?
    * e.g. ARM: conditional instructions

### Meeting Notes

For the kickoff meeting, the agenda was largely driven by @joachimschmidt57 who came up with this brilliant discussion write-up you can find above. Below you can find a summary of the discussion for each set of bullets from the agenda.

---

> * Identify everything that is linking-dependent codegen and linking-independent codegen
>    * Linking-dependent: function calls, access to global variables(?)
>    * Linking-independent: everything else ?

Linking and codegen are pretty tightly knit together (to better facilitate incremental linking). @joachimschmidt57 suggests we should split the linking-dependent from linking-independent bits in `codegen.zig`. Some examples:
* function calls - are always linking-dependent
* arithmetic calls - should be linking-independent

Consensus here was that (in the long run) we should audit the codegen/linking codebase and identify everything that is linking-dependent. This should help us come up with a plan on how to pull shared bits together and reorganise the codebase in general.

---

> * Clean distinction between architecture-independent stuff and architecture-specific stuff
>    * Encourage deduplication of code
>    * Make it very contributer-friendly to add and improve backends
> * `MCValue` needs to be completely architecture-dependent
>    * Some entries can be considered universal and architecture-independent (embedded_in_code, memory)
>    * Entries that are not universal: Register (no registers, general purpose, floating point, etc.) and more
>    * `MCValue{ .memory = ... }` is used to populate and reference the GOT via absolute addressing (e.g., `movabsq` on `x86_64`); however, for platforms that require PIE such macOS, we need to fallback to RIP-relative/PC-relative addressing, therefore should `.memory` be re-used for PIEs or should we come up with an additional/alternative to it?
> * Consider supporting architechtures without general purpose registers (stack-based, C backend)
> * `codegen.zig` should not contain **any** architecture-dependent code, abstract only over stuff that is shared in **all** backend

@joachimschmidt57 suggested we should move architecture-specific codegen bits (where appropriate) into their own `codegen` modules, for instance, ARM64 codegen-specific functionality would land in `codegen/aarch64.zig`. The general idea here would be for each architecture to have their own version of `MCValue`. One motivation for this is the fact that ARM64, in addition to general-purpose register, also has multiple special-purposed floating-point registers. Furthermore, we should also support register-free architecture and the current version of `MCValue` makes it somewhat clunky since register-free architectures will simply panic/error out on certain `MCValue` fields when switching over them, etc. @andrewrk supports this premise, however, as also pointed out by @ifreund and @luukdegram, we should be careful not to optimise prematurely since we haven't advanced the stage2 enough yet to have explored what `MCValue` would require for each architecture. The timing for this is perfect since @luukdegram only recently refactored Wasm32 to use the common codepath as other architectures: [ziglang/zig#7321](https://github.com/ziglang/zig/pull/7321).

---

> * What should belong into semantic analysis, what should belong into codegen?
>     * Architecture-independent optimizations (arithmetic expressions (strength reduction), `unreachable` optimizations, constant propagation, dead code elimination, loop unrolling, etc.): after sema and before codegen?
>     * Generating checks for overflow in debug builds: sema or codegen?
> * *(not technically 100% codegen)* What optimizations do we want to include?
>    * e.g. ARM: conditional instructions

We should identify which stuff goes in semantic analysis (sema) and which in codegen. For example, generating checks for overflows. @andrewrk said it should go in the sema.

Furthermore, @andrewrk said the plan for this is as follows:
1. first big step, make a simple, maintainable compiler that passes all the tests
2. optimise
3. design direction is for less memory usage in opcodes; ZIR can be architecture-dependent by design if it solves a particular problem for a particular architecture/platform
4. comptime knows the target architecture and immitates it -> sema is very aware of the target

@joachimschmidt57 asked if the optimisations should go after sema but before codegen in the pipeline. @andrewrk said that we don't have any yet they indeed should go between sema and codegen; optimisations take typed IR instructions as the input, and give back optimised typed IR instructions as the output. What optimisations do we want to include? For debug builds, none. No LLVM but Release mode (this would be our self-hosted backend) -> our hand-crafted optimisations. This might be a totally different codegen path. It is important to note that the focus for 1.0 release is to have self-hosted in Debug, and LLVM-backed in Release.

If we figure out some good optimisations, it would be beneficial to insert them between codegen and the LLVM backend; e.g., async functions etc.
