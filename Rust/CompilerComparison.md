# How to make your rust applications you made on your machine able to work on other machines. 
- For advanced use
- 1. Add target triplets
```bash
rustup target add x86_64-apple-darwin # macOS (amd64)
rustup target add aarch64-apple-darwin # macOS (arm64)
rustup target add aarch64-unknown-linux-gnu # Linux (aarch64)
rustup target add armv8-unknown-linux-gnu # Linux (armv8)
rustup target add x86_64-pc-windows-msvc # Windows (amd64)
```
- 2. Compile binaries
```
cargo build --target x86_64-apple-darwin # Compile for macOS (amd64)
cargo build --target aarch64-apple-darwin # Compile for macOS (arm64)
cargo build --target aarch64-unknown-linux-gnu # Compile for Linux (aarch64)
cargo build --target armv8-unknown-linux-gnu # Compile for Linux (armv8)
cargo build --target x86_64-pc-windows-msvc # Compile for Windows (amd64)
```
- 3. Use cross-complilation toolchain
```bash
rustup toolchain install stable-x86_64-apple-darwin # Install the stable toolchain for macOS (amd64)
rustup toolchain install stable-aarch64-apple-darwin # Install the stable toolchain for macOS (arm64)
rustup toolchain install stable-aarch64-unknown-linux-gnu # Install the stable toolchain for Linux (aarch64)
rustup toolchain install stable-armv8-unknown-linux-gnu # Install the stable toolchain for Linux (armv8)
rustup toolchain install stable-x86_64-pc-windows-msvc # Install the stable toolchain for Windows (amd64)
```

- 4. Cargo options
```bash
cargo build --target <target> --release to build the binary in release mode.
cargo build --target <target> --features <features> to build the binary with specific features.
cargo build --target <target> --manifest-path <manifest-path> to build the binary with a specific manifest path.
cargo build --target <target> --workspace to build the binary with workspace.
cargo build --target <target> --jobs <jobs> to build the binary with multiple jobs.
cargo build --target <target> --verbose to build the binary with verbose output.
cargo build --target <target> --quiet to build the binary with quiet output.
cargo build --target <target> --color <color> to build the binary with color output.
cargo build --target <target> --message-format <message-format> to build the binary with message format output.
cargo build --target <target> --build-plan <build-plan> to build the binary with build plan output.
cargo build --target <target> --unit-graph <unit-graph> to build the binary with unit graph output.
cargo build --target <target> --future-incompat-report <future-incompat-report> to build the binary with future incompat report output.
cargo build --target <target> -- timings <timings> to build the binary with timings output.
cargo build --target <target> --profile <profile> to build the binary with profile output.
cargo build --target <target> --test to build the binary with test.
cargo build --target <target> --bench to build the binary with bench.
cargo build --target <target> --example to build the binary with example.
cargo build --target <target> --lib to build the binary with lib.
cargo build --target <target> --bin to build the binary with bin.
cargo build --target <target> --bins to build the binary with bins.
cargo build --target <target> --tests to build the binary with tests.
cargo build --target <target> --benches to build the binary with benches.
cargo build --target <target> --examples to build the binary with examples.
cargo build --target <target> --libs to build the binary with libs.
cargo build --target <target> --bins --tests --benches --examples --libs to build the binary with bins, tests, benches, examples and libs.
cargo build --help to see all the available options.
cargo config -- configure the build process.
cargo clean -- clean the build artifacts.
cargo doc --generate documentation.
cargo test --run tests.
cargo bench --run benchmarks.
cargo run -- run the binary.
```
| Language | Rust | C++ | Java |
|----------|------|-----|------|
| Source Code | Source Code | Source Code | Source Code |
|----------|------|-----|------|
|          |          |          |          |
|          |          |          |          |
|          | v        | v        | v        |
|----------|------|-----|------|
| Lexical Analysis | Lexical Analysis | Lexical Analysis | Lexical Analysis |
|----------|------|-----|------|
|          |          |          |          |
|          |          |          |          |
|          | v        | v        | v        |
|----------|------|-----|------|
| Syntax Analysis | Syntax Analysis | Syntax Analysis | Syntax Analysis |
|----------|------|-----|------|
|          |          |          |          |
|          |          |          |          |
|          | v        | v        | v        |
|----------|------|-----|------|
| Semantic Analysis | Semantic Analysis | Bytecode Generation | Bytecode Generation |
|----------|------|-----|------|
|          |          |          |          |
|          |          |          |          |
|          | v        | v        | v        |
|----------|------|-----|------|
| Optimization | Optimization | Just-In-Time | Just-In-Time |
|----------|------|-----|------|
|          |          |          |          |
|          |          |          |          |
|          | v        | v        | v        |
|----------|------|-----|------|
| Code Generation | Code Generation | Machine Code | Machine Code |
|----------|------|-----|------|
