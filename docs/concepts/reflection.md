# Reflection

V has two kinds of reflection, one at run time and one at compile time.
Run-time reflection works while the program is running.
Compile-time reflection works while the program is being compiled.

In this article, we will look at run-time reflection; compile-time reflection is described in the
[Compile-time reflection](./compile-time/reflection.md)
article.

Unlike compile-time reflection, run-time reflection allows you to get type/method information at run
time.

The
[`v.reflection`](https://modules.vosca.dev/standard_library/v/reflection.html)
module is responsible for working with run-time reflection.

Consider a basic example of working with reflection:

```v play
module main

import v.reflection

fn main() {
	a := 100
	typ := reflection.type_of(a)
	println(typ.name) // int
}
```

The `reflection.type_of()` function returns an object of type `reflection.Type` that describes the
type of the value passed to it.

## Iterate over methods of a type

The `reflection.Type` structure contains a `sym` field of type `reflection.TypeSymbol` which
contains additional information about the type.

The `methods` field contains all methods of the type:

```v play
module main

import v.reflection

fn main() {
	a := 100
	typ := reflection.type_of(a)

	for method in typ.sym.methods {
		println(method.name)
	}
}

// str_l
// str
// hex
// hex2
// hex_full
```

The `methods` field is of type
[`[]reflection.Function`](https://modules.vosca.dev/standard_library/v/reflection.html#Function)
which contains information about the method.

## Check if a return type is Option or Result

When we iterate over methods or functions, we can get a function return type from
the `return_typ` field of the `reflection.Function` struct.

The `return_typ` field is of type `reflection.VType`.
This type has a `has_flags()` method that allows you to get the type flags.

For example, we can check if the return type is `Option` or `Result`:

```v play
module main

import v.reflection

fn main() {
	a := 100
	typ := reflection.type_of(a)

	for method in typ.sym.methods {
		if method.return_typ.has_flag(.option) {
			println('method ${method.name} returns an Option')
		}

		if method.return_typ.has_flag(.result) {
			println('method ${method.name} returns a Result')
		}
	}
}
```

## Check if a type is a map or array

The `kind` field of the `reflection.TypeSymbol` structure contains a kind of
type `reflection.VKind`.
So for example, to check if the type is `map` or `array`, we can do the following:

```v play
module main

import v.reflection

fn main() {
	a := map[string]int{}
	typ := reflection.type_of(a)

	if typ.sym.kind == .map {
		println('a is a map')
	}

	if typ.sym.kind == .array {
		println('a is an array')
	}
}
```

See all type options in
[`reflection.VKind`](https://modules.vosca.dev/standard_library/v/reflection.html#VKind).

## Get all functions/structs/etc.

To get a list of all functions/structs/enumerations/etc., functions of the `reflection.get_*()`
family are used.

For example, to get a list of all functions, we can do the following:

```v play
module main

import v.reflection

fn main() {
	for func in reflection.get_funcs() {
		println(func.name)
	}
}
```

> **Note**
> `reflection.get_funcs()` returns all functions that are defined including builtin functions.

This is a brief introduction to run-time reflection.
See the
[`v.reflection`](https://modules.vosca.dev/standard_library/v/reflection.html)
module documentation for more information.
