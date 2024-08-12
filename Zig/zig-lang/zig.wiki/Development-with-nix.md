## nix-zig-build
A Nix Flake for building and testing Zig.

https://github.com/erikarvstedt/nix-zig-build

## Traditional approach

Here is a sample `shell.nix` for building/developing zig.
```nix
with import <nixpkgs> {};

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    gdb
    libxml2
    ninja
    qemu
    wasmtime
    zlib
  ] ++ (with llvmPackages_17; [
    clang
    clang-unwrapped
    lld
    llvm
  ]);

  hardeningDisable = [ "all" ];
}
```
The `hardeningDisable` part is crucial, otherwise you will get compile errors.

## Flake

Alternatively, you can use this sample `flake.nix`:

```nix
{
  description = "A flake for Zig development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, ... }: inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cmake
            gdb
            libxml2
            ninja
            qemu
            wasmtime
            zlib
          ] ++ (with llvmPackages_17; [
            clang
            clang-unwrapped
            lld
            llvm
          ]);

          hardeningDisable = [ "all" ];
        };
        # For compatibility with older versions of the `nix` binary
        devShell = self.devShells.${system}.default;

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "zig";
          # TODO: Fix the output of `zig version`.
          version = "0.10.0-dev";
          src = self;

          nativeBuildInputs = with pkgs; [
            cmake
          ] ++ (with llvmPackages_14; [
            libclang
            lld
            llvm
          ]);

          preBuild = ''
            export HOME=$TMPDIR;
          '';

          cmakeFlags = [
            # https://github.com/ziglang/zig/issues/12069
            "-DZIG_STATIC_ZLIB=on"
          ];
        };
      }
  );
}
```

## Notes for macOS users

If using macOS, you will need to [build llvm yourself](https://github.com/ziglang/zig/wiki/How-to-build-LLVM,-libclang,-and-liblld-from-source) and use the system's clang to build zig. This is possible using the sample `shell.nix` below.

```nix
with import <nixpkgs> { };

pkgs.mkShellNoCC {
  nativeBuildInputs = with pkgs; [ cmake gdb ninja qemu wasmtime ];

  hardeningDisable = [ "all" ];
}
```