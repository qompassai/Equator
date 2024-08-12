Note: Official builds of master branch and releases are
[available for download](https://ziglang.org/download/).

When using a package manager, it is best to use a tagged release rather than
using an option to install a development version.

See [Repology](https://repology.org/project/zig/versions) for an overview of
which package management systems and operating systems Zig has already been
packaged for, and what the current packaged version is.

[![Packaging status](https://repology.org/badge/vertical-allrepos/zig.svg)](https://repology.org/project/zig/versions)

## Alpine Linux

```
apk add zig
```
## Opensuse Tumbleweed
```
zypper install zig 
```

## Arch Linux

```
pacman -S zig
```

## DragonFlyBSD (ravenports)

```
ravensw install zig-single-standard
```

## Fedora

```
dnf install zig
```

## Fedora Silverblue

```
rpm-ostree install zig
```

## FreeBSD

```
pkg install lang/zig
```

## Gentoo

```sh
# Building from sources
emerge -av dev-lang/zig
# Official ziglang.org static build
emerge -av dev-lang/zig-bin
```

## Homebrew

```
brew install zig
```

## MacPorts

```
port install zig
```

## Mise

```
mise install zig
```


## NixOS

Rather than installing development binaries globally, create a `shell.nix` for your project:

```nix
# shell.nix
let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = [
      pkgs.zig
      # other deps here
    ];
  }
```

Then run `nix-shell` to enter a development shell with zig available.

## Ubuntu (snap)
Stable:
```
snap install zig --classic --beta
```

## Void Linux

```
xbps-install -Su zig
```

## Windows (winget)

```
winget install zig.zig
```

## Windows (choco)

```sh
choco install zig
```

## Windows (scoop)

```
scoop install zig
```

## Termux
```
pkg i zig
```
