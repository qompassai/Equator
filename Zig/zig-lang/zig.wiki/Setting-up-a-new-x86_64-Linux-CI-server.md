## Initial Setup

Order the server from Hetzner.

Choose a subdomain and add an A record in AWS Route 53 to point to it.

```
ssh root@zanic.ziglang.org
installimage
```

Choose latest stable Debian which is currently "bookworm".

In the settings editor, change the hostname (e.g. `zanic.ziglang.org`).

Reboot.

```
ssh root@zanic.ziglang.org

apt update
apt upgrade
apt install cmake ninja-build tidy git build-essential binaryen

adduser ci
passwd -d ci
su ci
cd

mkdir deps
cd deps
wget https://ziglang.org/deps/qemu-linux-x86_64-6.1.0.1.tar.xz
tar xf qemu-linux-x86_64-6.1.0.1.tar.xz
wget https://github.com/bytecodealliance/wasmtime/releases/download/v2.0.2/wasmtime-v2.0.2-x86_64-linux.tar.xz
tar xf wasmtime-v2.0.2-x86_64-linux.tar.xz
wget https://ziglang.org/deps/zig+llvm+lld+clang-x86_64-linux-musl-0.11.0-dev.1869+df4cfc2ec.tar.xz
tar xf zig+llvm+lld+clang-x86_64-linux-musl-0.11.0-dev.1869+df4cfc2ec.tar.xz
rm *.tar.xz
```

Then add as many runners as the hardware can handle.

## Add a GitHub Actions Runner

[New self-hosted runner](https://github.com/ziglang/zig/settings/actions/runners/new)

```
ssh root@zanic.ziglang.org
su ci
cd
# follow the snippet of code from the GitHub instructions
```

 * Name of runner: make up something unique
 * Add label: `x86_64`

Instead of their last `./run.sh` step, do this, as root:

```
./svc.sh install ci
./svc.sh start ci
```
