# Environment specific files

V provides the ability to create files that will only be used in a specific
environment.
For example, only on Windows, or only on Linux.

If a file has an environment-specific suffix, it will only be compiled for that
environment.

- `.js.v` – will be used only by the JS backend. These files can contain `JS.*`
  declarations.
- `.c.v` – will be used only by the C backend. These files can contain `C.*`
  declarations.
- `.native.v` – will be used only by V's native backend.
- `_nix.c.v` – will be used only on Unix systems (non-Windows).
- `_${os}.c.v` – will be used only on the specific `os` system.
  For example, `_windows.c.v` will be used only when compiling on Windows, or
  with `-os windows`.
- `_default.c.v` – will be used only if there is NOT a more specific platform
  file.
  For example, if you have both `file_linux.c.v` and `file_default.c.v`,
  and you are compiling for linux, then only `file_linux.c.v` will be used,
  and `file_default.c.v` will be ignored.

Here is a more complete example:

**main.v:**

```v ignore
module main

fn main() {
  println(message)
}
```

**main_default.c.v:**

```v ignore
module main

const (
  message = 'Hello, World!'
)
```

**main_linux.c.v:**

```v ignore
module main

const (
  message = 'Hello, Linux!'
)
```

**main_windows.c.v:**

```v ignore
module main

const (
  message = 'Hello, Windows!'
)
```

With the example above:

- when you compile for Windows, you will get 'Hello, Windows!'
- when you compile for Linux, you will get 'Hello, Linux!'
- when you compile for any other platform, you will get the
  non-specific 'Hello, World!' message.

**_d_customflag.v** – will be used *only* if you pass `-d customflag` to V.
That corresponds to `$if customflag ? {}`, but for a whole file, not just a
single block. `customflag` should be a `snake_case` identifier, it can not
contain arbitrary characters (only lower case latin letters + numbers + `_`).

> **Note**
> A combinatorial `_d_customflag_linux.c.v` postfix will not work.
> If you do need a custom flag file, that has platform dependent code, use the
> postfix **_d_customflag.v**, and then use platform dependent compile time
> conditional blocks inside it, i.e. `$if linux {}` etc.

**_notd_customflag.v** – similar to **_d_customflag.v**, but will be used
*only* if you do NOT pass `-d customflag` to V.

See also [Cross Compilation](../../advanced-concepts/cross-compilation.md).
