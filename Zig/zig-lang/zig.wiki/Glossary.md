The below terms may be helpful if you're new to Zig, compilers, or low-level programming.

### AIR

Analyzed Intermediate Representation. This data is produced by Sema and consumed by codegen. Unlike ZIR where there is one instance for an entire source file, each function gets its own AIR. Also, unlike ZIR, each AIR instruction has an associated type.

See `src/Air.zig`.

### Comptime

Compile-time, as opposed to runtime. [Introduction to comptime in zig](https://ziglang.org/documentation/master/#comptime)

### Container

An array list, hash map, or non-intrusive linked list.

### Namespace

Structs, enums, unions, and opaques declare namespaces. Each Zig source file is a struct and
therefore also a namespace.

Namespaces contain order-independent declarations.

When deciding upon a name for a namespace, keep in mind the **fully qualified namespace**.

For example:

 * Bad namespaces:
   - `hash.HashMap`
   - `crypto.sha.Sha3`
 * Good namespaces:
   - `hash.Map`
   - `crypto.Sha3`

### ELF

"Executable and Linkable Format, formerly named Extensible Linking Format, is a common standard file format for executable files, object code, shared libraries, and core dumps." -[Executable and Linkable Format on Wikipedia](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)

ELF is the format used by object files and executables on most operating systems. Exceptions are macOS which uses Macho, and Windows, which uses PE for executables and COFF for object files.

### IR

Intermediate representation. Typically represented as instructions that reference each other. Zig has several kinds of IR:

 * ZIR
 * AIR
 * MIR (stage2 only)

There is also LLVM IR.

### LLVM

[LLVM Website](https://llvm.org/)

LLVM is a set of compiler and toolchain technologies. Zig uses LLVM as one of many Backends. Zig's LLVM backend inputs AIR and outputs LLVM IR. LLVM inputs LLVM IR, performs optimizations, and then outputs object files.

See `src/codegen/llvm.zig`. 

### LLVM IR

LLVM Intermediate Representation. This is the format that LLVM inputs. It then performs optimizations and then outputs an object file.

### Semantic Analysis

Semantic analysis of ZIR instructions. Transforms untyped ZIR instructions into semantically-analyzed AIR instructions.
Does type checking, comptime control flow, and safety-check generation. This is the the heart of the Zig compiler.

See `src/Sema.zig`.

### MIR

Machine Intermediate Representation, lowered to from AIR. Each instruction set architecture will have its own MIR dialect as it is designed to closely match available instructions. Designed for stage2+, since LLVM and C backends don't need MIR. Partially implemented. See [the design issue](https://github.com/ziglang/zig/issues/9514).

### ZIR

Zig Intermediate Representation. `src/Astgen.zig` converts AST nodes to these
untyped IR instructions. Next, `src/Sema.zig` processes these into AIR.
The minimum amount of information needed to represent a list of ZIR instructions.
Once this structure is completed, it can be used to generate AIR, followed by
machine code, without any memory access into the AST tree token list, node list,
or source bytes. Exceptions include:
 * Compile errors, which may need to reach into these data structures to
   create a useful report.
 * In the future, possibly inline assembly, which needs to get parsed and
   handled by the codegen backend, and errors reported there. However for now,
   inline assembly is not an exception.

Each Zig source file has a corresponding ZIR representation. You can use `zig ast-check -t example.zig` to see a textual representation of the ZIR for any Zig source file.

See `src/Zir.zig`.

### stage1

[These files](https://github.com/ziglang/zig/tree/master/stage1). There used to be a C++ implementation of Zig that was referred to as "stage1" but it was replaced by these files. They are used to [build Zig from a WebAssembly kernel](https://ziglang.org/news/goodbye-cpp/).

### stage2

[These files](https://github.com/ziglang/zig/tree/master/src). This is an implementation of Zig written in Zig.

### stage3

stage2 compiled with itself produces stage3. Compiling again with stage3 produces stage3 (input and output are the same).
