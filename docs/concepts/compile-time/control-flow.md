# Compile-time statements

## `$if` expression

`$if` expression is a special compile-time `if` expression that can be used to
detect an OS, compiler, platform, or compilation options.
It can also be used
to check the types of fields or methods when iterating them, see
[Compile-time Reflection](./reflection.md).
It can also specify different code depending on the type in generic functions,
see
[Generics](../generics.md#compile-time-conditions).

It supports multiple conditions in one branch:

```v failcompile
$if ios || android {
	println('Running on a mobile device!')
}
$if linux && x64 {
	println('64-bit Linux.')
}
```

Can be used as an expression:

```v
os := $if windows { 'Windows' } $else { 'Unix' }
println('Using ${os}')
```

Can have `$else-$if` and `$else` branches:

```v failcompile
$if tinyc {
	println('tinyc')
} $else $if clang {
	println('clang')
} $else $if gcc {
	println('gcc')
} $else {
	println('different compiler')
}
```

Can be used to check compilation options:

```v failcompile
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
```

Custom compiler options passed via `-d` can be checked with `$if option ? {}`:

```v failcompile
// v -d option ...
$if option ? {
	println('custom option')
}
```

Below are all the main supported options:

| OS                              | Compilers         | Platforms        | Other                                  |
|---------------------------------|-------------------|------------------|----------------------------------------|
| `windows`, `linux`, `macos`,    | `gcc`, `tinyc`,   | `amd64`, `arm64` | `debug`, `prod`, `test`                |
| `mac`, `darwin`, `ios`,         | `clang`, `mingw`, | `x64`, `x32`,    | `js`, `glibc`, `prealloc`              |
| `android`, `mach`, `dragonfly`, | `msvc`,           | `little_endian`, | `no_bounds_checking`, `freestanding`,  |
| `gnu`, `hpux`, `haiku`, `qnx`   | `cplusplus`       | `big_endian`     | `no_segfault_handler`, `no_backtrace`, |
| `solaris`, `termux`             |                   |                  | `no_main`                              |

## `$for` statement

`$for` allows you to iterate over special arrays, currently arrays for fields of
structures, methods of types, attributes of types and other.

```v
struct User {
	name string
	age  int
}

fn main() {
	$for field in User.fields {
		println(field.name)
	}
}

// name
// age
```

> **Note**
> Currently, `break` and `continue` cannot be used inside `$for`.

See the [Compile-time Reflection](./reflection.md) article for more details.
