# Functions

Functions in V are declared with the `fn` keyword:

```v
fn add(x int, y int) int {
	return x + y
}
```

A function is called using a function name and a list of arguments:

```v
add(2, 3)
```

## Parameters

Function parameters are written in the Go style, first comes the name, then the type:

```v
fn greet(name string, age int) {
	println('Hello, ${name}! You are ${age} years old.')
}
```

In V, function parameters cannot have default values.
Just like in Go and C, functions cannot be overloaded.
This simplifies the code and improves its maintainability and readability.

## Return values

As you may have noticed, the return type is specified after the parameter list.
If the function does not return a value, then the return type is omitted:

```v
fn greet(name string) {
	println('Hello, ${name}!')
}
```

V supports multiple return values:

```v play
fn foo() (int, int) {
    return 2, 3
}
    
a, b := foo()
println(a) // 2
println(b) // 3
```

When calling such a function, you must assign each return value to a variable.
The number of variables must match the number of return values.

If you want to ignore one or more return values, you can use `_`:

```v
a, _ := foo()
```

## Hoisting

Functions can be used before their declaration:
`add` and `sub` are declared after `main`, but can still be called from `main`.

This is true for all declarations in V and eliminates the need for header files
or thinking about the order of files and declarations.

## Returning multiple values

```v play
fn foo() (int, int) {
	return 2, 3
}

a, b := foo()
println(a) // 2
println(b) // 3
c, _ := foo() // ignore values using `_`
```

## Variable number of arguments

You can mark the last parameter of a function with `...`
to indicate that the function can take a variable number of arguments:

```v
fn sum(a ...int) int {
	mut total := 0
	for x in a {
		total += x
	}
	return total
}
```

In such a case, you can call the function with any number of arguments:

```v
println(sum()) // 0
println(sum(1)) // 1
println(sum(2, 3)) // 5
```

Using `...a` array unpacking, you can pass an array as a function argument:

```v
a := [2, 3, 4]
println(sum(...a)) // 9
b := [5, 6, 7]
println(sum(...b)) // 18
```

Inside the function itself, such an argument will be represented as an array:

```v play
fn sum(a ...int) int {
	println(a)
	return 0
}

sum(2, 3, 4) // [2, 3, 4]
```

## Immutable function args by default

In V function arguments are immutable by default, and mutable args have to be
marked on call.

```v
fn mutate(x []int) {
	x << 2
	// error: `x` is immutable, declare it with `mut` to make it mutable
}
```

This is to prevent accidental modification of arguments, which can lead to bugs.

## Mutable arguments

It is possible to modify function arguments by declaring them with the keyword `mut`:

```v
fn mutate(mut x []int) {
	x << 2
}

mut nums := [1, 2, 3]
mutate(mut nums)
println(nums) // [1, 2, 3, 2]
```

Note, that you have to add `mut` before `nums` when calling this function. This makes
it clear that the function being called will modify the value.

It is preferable to return values instead of modifying arguments,
e.g. `user = register(user)` instead of `register(mut user)`.

Modifying arguments should only be done in performance-critical parts of your application
to reduce allocations and copying.

For this reason V doesn't allow the modification of arguments with primitive types (e.g. integers).
Only more complex types such as arrays and maps may be modified.

## Parameter evaluation order

The evaluation order of the parameters of function calls is *NOT* guaranteed.
Take for example the following program:

```v
fn f(a1 int, a2 int, a3 int) {
	dump(a1 + a2 + a3)
}

fn main() {
	f(dump(100), dump(200), dump(300))
}
```

V currently does not guarantee, that it will print 100, 200, 300 in that order.
The only guarantee is that 600 (from the body of `f`), will be printed after all of them.
That *may* change in V 1.0.

## Generic functions

Functions can have generic parameters, which are specified using square brackets after the function name:

```v
fn each[T](a []T, cb fn (T)) { /*...*/ }
```

See [Generics](generics.md) for more information.

## Inline functions

Functions can be declared as inline using the `inline` attribute:

```v
[inline]
fn add(x int, y int) int {
    return x + y
}
```

This will cause the function to be inlined at the call site.
This can improve performance, but also increase the size of the binary.

To prevent the inlining of a function, use the `noinline` attribute:

```v
[noinline]
fn add(x int, y int) int {
    return x + y
}
```

