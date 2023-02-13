# Variables

Variables are declared and initialized with `:=`. 
This is the only way to declare variables in V.

```v
name := 'Bob'
age := 20
large_number := i64(9999999999)
```

This means that variables always have an initial value.

The variable's type is inferred from the value on the right hand side.
To choose a different type, use type conversion: the expression `T(v)` 
converts the value `v` to the type `T`.

Unlike most other languages, V only allows defining variables in functions.
By default, V does not allow **global variables**, but you can enable them for low-level code. 
See [Global variables](./global-variables) for more details.

For consistency across different code bases, all variable and function names
must use the `snake_case` style, as opposed to type names, which must use `PascalCase`.

## Mutable variables

By default, all variables are immutable.
To be able to change the value of the variable, declare it with `mut`.

```v play
mut age := 20
println(age)
age = 21
println(age)
```

To change the value of the variable you can use `=`.

Try run the program above after removing `mut` from the first line.

## Initialization vs assignment

Note the (important) difference between `:=` and `=`.
`:=` is used for declaring and initializing, `=` is used for assigning.

```v failcompile
fn main() {
	age = 21
}
```

This code will not compile, because the variable `age` is not declared.
All variables need to be declared in V.

```v
fn main() {
	age := 21
}
```

The values of multiple variables can be changed in one line.
In this way, their values can be swapped without an intermediary variable.

```v
mut a := 0
mut b := 1
println('${a}, ${b}') // 0, 1
a, b = b, a
println('${a}, ${b}') // 1, 0
```

## Variable shadowing

Unlike most languages, variable shadowing is not allowed. Declaring a variable with a name
that is already used in a parent scope will cause a compilation error.

```v play
fn main() {
	a := 10
	if true {
		a := 20 // error: redefinition of `a`
	}
}
```

## Unused variables

By default, in development mode, V will only warn you if you have unused variables.

[//]: # (TODO add a link to the docs about the -prod flag)
In production mode (enabled by passing the `-prod` flag to V – `v -prod foo.v`)
it will not compile at all (like in Go).

```v failcompile nofmt
fn main() {
	a := 10
	// error: unused variable `a`
}
```
