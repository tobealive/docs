# Conditional compilation

## Compile time pseudo variables

V also gives your code access to a set of pseudo string variables,
that are substituted at compile time:

- `@FN` – replaced with the name of the current V function
- `@METHOD` – replaced with ReceiverType.MethodName
- `@MOD` – replaced with the name of the current V module
- `@STRUCT` – replaced with the name of the current V struct
- `@FILE` – replaced with the absolute path of the V source file
- `@LINE` – replaced with the V line number where it appears (as a string).
- `@FILE_LINE` – like `@FILE:@LINE`, but the file part is a relative path
- `@COLUMN` – replaced with the column where it appears (as a string).
- `@VEXE` – replaced with the path to the V compiler
- `@VEXEROOT`  – will be substituted with the *folder*,
  where the V executable is (as a string).
- `@VHASH`  – replaced with the shortened commit hash of the V compiler (as a string).
- `@VMOD_FILE` – replaced with the contents of the nearest v.mod file (as a string).
- `@VMODROOT` – will be substituted with the *folder*,
  where the nearest v.mod file is (as a string).

That allows you to do the following example, useful while debugging/logging/tracing your code:

```v
eprintln('file: ' + @FILE + ' | line: ' + @LINE + ' | fn: ' + @MOD + '.' + @FN)
```

Another example, is if you want to embed the version/name from v.mod *inside* your executable:

```v ignore
import v.vmod
vm := vmod.decode( @VMOD_FILE ) or { panic(err) }
eprintln('${vm.name} ${vm.version}\n ${vm.description}')
```

## Compile-time reflection

Having built-in JSON support is nice, but V also allows you to create efficient
serializers for any data format. V has compile-time `if` and `for` constructs:

```v
struct User {
	name string
	age  int
}

fn main() {
	$for field in User.fields {
		$if field.typ is string {
			println('${field.name} is of type string')
		}
	}
}

// Output:
// name is of type string
```

See [**examples/compiletime/reflection.v**](/examples/compiletime/reflection.v)
for a more complete example.

## Compile time code

`$` is used as a prefix for compile-time operations.

### `$if` condition

```v
fn main() {
	// Support for multiple conditions in one branch
	$if ios || android {
		println('Running on a mobile device!')
	}
	$if linux && x64 {
		println('64-bit Linux.')
	}
	// Usage as expression
	os := $if windows { 'Windows' } $else { 'UNIX' }
	println('Using ${os}')
	// $else-$if branches
	$if tinyc {
		println('tinyc')
	} $else $if clang {
		println('clang')
	} $else $if gcc {
		println('gcc')
	} $else {
		println('different compiler')
	}
	$if test {
		println('testing')
	}
	// v -cg ...
	$if debug {
		println('debugging')
	}
	// v -prod ...
	$if prod {
		println('production build')
	}
	// v -d option ...
	$if option ? {
		println('custom option')
	}
}
```

If you want an `if` to be evaluated at compile time it must be prefixed with a `$` sign.
Right now it can be used to detect an OS, compiler, platform or compilation options.
`$if debug` is a special option like `$if windows` or `$if x32`, it's enabled if the program
is compiled with `v -g` or `v -cg`.
If you're using a custom ifdef, then you do need `$if option ? {}` and compile with`v -d option`.
Full list of builtin options:

| OS                             | Compilers        | Platforms        | Other                                            |
|--------------------------------|------------------|------------------|--------------------------------------------------|
| `windows`, `linux`, `macos`    | `gcc`, `tinyc`   | `amd64`, `arm64` | `debug`, `prod`, `test`                          |
| `mac`, `darwin`, `ios`,        | `clang`, `mingw` | `x64`, `x32`     | `js`, `glibc`, `prealloc`                        |
| `android`, `mach`, `dragonfly` | `msvc`           | `little_endian`  | `no_bounds_checking`, `freestanding`             |
| `gnu`, `hpux`, `haiku`, `qnx`  | `cplusplus`      | `big_endian`     | `no_segfault_handler`, `no_backtrace`, `no_main` |
| `solaris`, `termux`            |                  |                  |                                                  |

### `$embed_file`

```v ignore
import os
fn main() {
	embedded_file := $embed_file('v.png')
	os.write_file('exported.png', embedded_file.to_string())!
}
```

V can embed arbitrary files into the executable with the `$embed_file(<path>)`
compile time call. Paths can be absolute or relative to the source file.

When you do not use `-prod`, the file will not be embedded. Instead, it will
be loaded *the first time* your program calls `embedded_file.data()` at runtime, making
it easier to change in external editor programs, without needing to recompile
your executable.

When you compile with `-prod`, the file *will be embedded inside* your
executable, increasing your binary size, but making it more self-contained
and thus easier to distribute. In this case, `embedded_file.data()` will cause *no IO*,
and it will always return the same data.

`$embed_file` supports compression of the embedded file when compiling with `-prod`.
Currently only one compression type is supported: `zlib`

```v ignore
import os
fn main() {
	embedded_file := $embed_file('v.png', .zlib) // compressed using zlib
	os.write_file('exported.png', embedded_file.to_string())!
}
```

`$embed_file` returns
[EmbedFileData](https://modules.vlang.io/v.embed_file.html#EmbedFileData)
which could be used to obtain the file contents as `string` or `[]u8`.

### `$tmpl` for embedding and parsing V template files

V has a simple template language for text and html templates, and they can easily
be embedded via `$tmpl('path/to/template.txt')`:

```v ignore
fn build() string {
	name := 'Peter'
	age := 25
	numbers := [1, 2, 3]
	return $tmpl('1.txt')
}

fn main() {
	println(build())
}
```

1.txt:

```
name: @name

age: @age

numbers: @numbers

@for number in numbers
  @number
@end
```

output:

```
name: Peter

age: 25

numbers: [1, 2, 3]

1
2
3
```

See more [details](https://github.com/vlang/v/blob/master/vlib/v/TEMPLATES.md)

### `$env`

```v
module main

fn main() {
	compile_time_env := $env('ENV_VAR')
	println(compile_time_env)
}
```

V can bring in values at compile time from environment variables.
`$env('ENV_VAR')` can also be used in top-level `#flag` and `#include` statements:
`#flag linux -I $env('JAVA_HOME')/include`.

### `$compile_error` and `$compile_warn`

These two comptime functions are very useful for displaying custom errors/warnings during
compile time.

Both receive as their only argument a string literal that contains the message to display:

```v failcompile nofmt
// x.v
module main

$if linux {
    $compile_error('Linux is not supported')
}

fn main() {
}

$ v run x.v
x.v:4:5: error: Linux is not supported
    2 |
    3 | $if linux {
    4 |     $compile_error('Linux is not supported')
      |     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    5 | }
    6 |
```

## Environment specific files

If a file has an environment-specific suffix, it will only be compiled for that environment.

- `.js.v` – will be used only by the JS backend. These files can contain JS. code.
- `.c.v` – will be used only by the C backend. These files can contain C. code.
- `.native.v` – will be used only by V's native backend.
- `_nix.c.v` – will be used only on Unix systems (non Windows).
- `_${os}.c.v` – will be used only on the specific `os` system.
  For example, `_windows.c.v` will be used only when compiling on Windows, or with `-os windows`.
- `_default.c.v` – will be used only if there is NOT a more specific platform file.
  For example, if you have both `file_linux.c.v` and `file_default.c.v`,
  and you are compiling for linux, then only `file_linux.c.v` will be used,
  and `file_default.c.v` will be ignored.

Here is a more complete example:
main.v:

```v ignore
module main
fn main() { println(message) }
```

main_default.c.v:

```v ignore
module main
const ( message = 'Hello world' )
```

main_linux.c.v:

```v ignore
module main
const ( message = 'Hello linux' )
```

main_windows.c.v:

```v ignore
module main
const ( message = 'Hello windows' )
```

With the example above:

- when you compile for windows, you will get 'Hello windows'
- when you compile for linux, you will get 'Hello linux'
- when you compile for any other platform, you will get the
  non-specific 'Hello world' message.

- **_d_customflag.v** – will be used *only* if you pass `-d customflag` to V.
  That corresponds to `$if customflag ? {}`, but for a whole file, not just a
  single block. `customflag` should be a snake_case identifier, it can not
  contain arbitrary characters (only lower case latin letters + numbers + `_`).
  > **Note**

> A combinatorial `_d_customflag_linux.c.v` postfix will not work.
> If you do need a custom flag file, that has platform dependent code, use the
> postfix **_d_customflag.v**, and then use plaftorm dependent compile time
> conditional blocks inside it, i.e. `$if linux {}` etc.

- **_notd_customflag.v** – similar to _d_customflag.v, but will be used
  *only* if you do NOT pass `-d customflag` to V.

See also [Cross Compilation](#cross-compilation).
