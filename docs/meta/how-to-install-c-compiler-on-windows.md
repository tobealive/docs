# How to install C compiler on Windows

### MinGW

You can get an up-to-date build of MinGW [here](https://winlibs.com/) **(recommended)**,
or [here](https://github.com/mstorsjo/llvm-mingw/releases).
The main benefit with these compiler toolchains is that the release archives are self-contained.
There is _no_ installation necessary.
Just ~1GB of disk space.

1. Download a .zip file from the links above.
2. Unpack the downloaded archive into a folder, for example in `C:\mingw\`.
3. Add the `bin` subfolder (`C:\mingw\bin\`) to your PATH.

If you want to uninstall this compiler, you can simply delete the folder where you unpacked the
zip (eg. `C:\mingw\`).

### Visual Studio

Visual Studio takes up a lot more space (typically
[20GB-50GB](https://learn.microsoft.com/en-us/visualstudio/releases/2022/system-requirements#hardware)),
but may be useful if you're planning on doing C interop with the Windows SDK / WinAPI.

[Download](https://visualstudio.microsoft.com/vs/) and install the latest Visual Studio.
The community edition will suffice.
In the installer select `Visual Studio core editor`, `Desktop development with C++`,
and `Windows 11 SDK`.
Change your selection accordingly if you have Windows 10.

It is also recommended to use either the Visual Studio Development Command Prompt (20XX) or Visual
Studio Development PowerShell (20XX) which adds `cl.exe` and other relevant MSVC tools to PATH.
See the
[reference](https://learn.microsoft.com/en-us/visualstudio/ide/reference/command-prompt-powershell)
for more information.

When you build V from source, use `make.bat -msvc` to specify that you want to build V using Visual
Studio, otherwise it defaults to TCC (which is good for fast compilation).
For your own projects, use `v -cc msvc ...`, optionally with `-prod` to make optimised executables
with MSVC.
