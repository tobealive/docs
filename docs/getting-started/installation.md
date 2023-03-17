# Installation

## Installing V from source (preferred way)

To install from source, we need `git` and `make`.

### Linux, macOS, Windows, *BSD, Solaris, WSL, etc

To get started, simply try to execute the following in your terminal/shell:

```bash
git clone https://github.com/vlang/v
cd v
make
## On Windows run make.bat in a cmd shell, or ./make.bat in PowerShell
```

And that is it! Find your V executable at `./v`.

Let us check if it works:

```bash
./v run examples/hello_world.v
# or on Windows:
v run examples/hello_world.v
```

This command should print `Hello, World!` to the console.

[//]: # TODO: Не должны ли мы иметь отдельную статью Troubleshooting?

If it doesn't, please see
[Installation Issues](https://github.com/vlang/v/discussions/categories/installation-issues)
for help.

### C compiler

V uses C compiler to compile V programs and itself.

The [Tiny C Compiler (tcc)](https://repo.or.cz/w/tinycc.git) is downloaded for you by `make` if
there is a compatible version for your system, and installed under the V `thirdparty` directory.
This compiler is very fast, but does almost no optimizations. It is best for development builds.

If V cannot find a compatible version of tcc, it will try to use the system C compiler.
If you do not have a C compiler installed, follow these instructions:

- [Installing a C compiler on Linux and macOS](https://github.com/vlang/v/wiki/Installing-a-C-compiler-on-Linux-and-macOS)
- [Installing a C compiler on Windows](https://github.com/vlang/v/wiki/Installing-a-C-compiler-on-Windows)

### Symlinking

To have convenient access to the compiler by its name from anywhere, the compiler provides
the handy `symlink` command, which creates a symbolic link `/usr/local/bin/v` to the executable V on
Unix.
On Windows, it adds the path to the V executable to the PATH environment variable.

#### Unix

```bash
sudo ./v symlink
```

#### Windows

On Windows, start a new shell with administrative privileges, for example, by pressing the
<kbd>Windows Key</kbd>, then type `cmd.exe`, right-click on its menu entry, and choose `Run as
administrator`.
In the new administrative shell, cd to the path where you have compiled V, then type:

```bat
v symlink
# on PowerShell:
./v symlink
```

That will make V available everywhere, by adding it to your PATH. Please restart your
shell/editor after that, so that it can pick up the new PATH variable.

> **Note**
> There is no need to run `v symlink` more than once – V will still be available, even after
> `v up`, restarts, and so on. You only need to run it again if you decide to move the V repo
> folder somewhere else.

## Updating V

V is constantly evolving, so to use the latest up-to-date version, you need to update V.

To update V, simply run:

```bash
v up
```

## Void Linux

```bash
## xbps-install -Su base-devel
## xbps-install libatomic-devel
git clone https://github.com/vlang/v
cd v
make
```

## Docker

```bash
git clone https://github.com/vlang/v
cd v
docker build -t vlang .
docker run --rm -it vlang:latest
```

## Docker with Alpine/musl

```bash
git clone https://github.com/vlang/v
cd v
docker build -t vlang --file=Dockerfile.alpine .
docker run --rm -it vlang:latest
```

## Termux/Android

On Termux, V needs some packages preinstalled – a working C compiler, also `libexecinfo`,
`libgc` and `libgc-static`. After installing them, you can use the same script, like on
Linux/macos:

```bash
pkg install clang libexecinfo libgc libgc-static make git
git clone https://github.com/vlang/v
cd v
make
```

## V net.http, net.websocket, `v install`

`net.http`, `net.websocket` module, and the `v install` command may all use SSL.

V comes with a version of `mbedtls`, which should work on all systems. If you find a need to
use OpenSSL instead, you will need to make sure that it is installed on your system, then
use the `-d use_openssl` switch when you compile.

To install OpenSSL on non-Windows systems:

```bash
macOS:
brew install openssl

Debian/Ubuntu:
sudo apt install libssl-dev

Arch/Manjaro:
openssl is installed by default

Fedora:
sudo dnf install openssl-devel
```

On Windows, OpenSSL is simply hard to get working correctly. The instructions
[here](https://tecadmin.net/install-openssl-on-windows/) may (or may not) help.

## V sync

V's `sync` module and channel implementation uses libatomic.
It is most likely already installed on your system, but if not,
you can install it by doing the following:

```bash
macOS: already installed

Debian/Ubuntu:
sudo apt install libatomic1

Fedora/CentOS/RH:
sudo dnf install libatomic-static
```

> **Note**
> If you run into any trouble, or you have a different operating
> system or Linux distribution that doesn't install or work immediately, please see
> [Installation Issues](https://github.com/vlang/v/discussions/categories/installation-issues)
> and search for your OS and problem.
> If you cannot find your problem,
> please add it to an existing discussion if one exists for your OS,
> or create a new one if a main discussion does not yet exist for your OS.

And that is it! We are ready to start code in V!

In the next article, we will learn how to write our first "Hello, World" program in V.
