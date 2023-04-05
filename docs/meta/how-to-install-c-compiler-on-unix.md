# How to install C compiler on Linux/macOS

## macOS

You can either install XCode from the App Store or run `xcode-select --install` to install XCode
command line tools.

## Debian/Ubuntu

```sh
sudo apt install build-essential
```

## CentOS/RHEL

```sh
sudo yum groupinstall "Development Tools"
```

## Fedora

```sh
sudo dnf install @development-tools
```

## Arch Linux

GCC should be preinstalled
