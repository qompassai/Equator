# Python 3.14 (With GIL) for ARM64

This is a custom build of Python 3.14.0a0 with the following specifications:

- Compiled on Ubuntu 24.04
- Global Interpreter Lock (GIL) enabled
- Optimizations enabled
- Compiled on NVIDIA AGX Orin Developer Kit
- Target architecture: ARM64

## Installation

Extract the tarball and run the binary:

```
tar -xzvf p3.14wGIL_arm64.tar.gz
./p3.14wGIL_arm64
```

## Notes

This is an alpha version of Python 3.14. Use with caution in production environments.
