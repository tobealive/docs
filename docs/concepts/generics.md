# Generics

Generics are a way of defining functions and data structures that can operate on any data type.
This allows you to create more generic code that can be reused for different data types.

In V at the moment, generics are pretty limited and don't have such important things as type constraints.

Unlike many languages, V uses the `[T]` syntax instead of `<T>` to specify generics.

Generic names use single letters such as `T` or `U`, any other names are currently prohibited.

## Functions

Generic functions are defined using square brackets after the function name containing the parameter types:

```v
fn compare[T](a T, b T) int {
	if a < b {
		return -1
	}
	if a > b {
		return 1
	}
	return 0
}
```

Such a function can be called with any data type that supports the `<` and `>` operators.
When calling a function, the parameter types must optionally be specified in square brackets:

```v
println(compare[int](1, 0))
println(compare[string]("a", "b"))
println(compare(10.0, 20.0))
```

In the first case `compare` will be generated for type `int` and called with `int` and `int` parameters.

If you try to pass `"b"` instead of `0`, you will get a compilation error:

```v
println(compare[int](0, "b"))
// error: cannot use `string` as `int` in argument 2 to `compare`
```

The V compiler is smart enough to be able to determine the types of the parameters if
they are not explicitly specified:

```v
println(compare(1, 0)) // T will be inferred as `int`
println(compare("a", "b")) // T will be inferred as `string`
```

## Structs

Generic structures are defined using square brackets after the name of the structure
containing the parameter types:

```v
struct Optional[T] {
	value      T
	is_defined bool = true
}
```

This structure can be used with any data type; when creating an object, the parameter
types must be specified after the structure name and before the curly brace:

```v
op1 := Option[int]{value: 10}
op2 := Option[string]{value: 'hello'}
```

Unlike functions, when creating a generic structure object, the parameter types must always
be specified explicitly:

```v
op1 := Option[int]{value: 10}
op2 := Option{value: 'hello'} // error: generic struct init must specify type parameter, e.g. Foo[int]
```

### Methods of generic structs

To describe methods of generic structures, the receiver must be of type `Type[<generic parameters>]`:

```v play
struct Optional[T] {
	value      T
	is_defined bool = true
}
   
fn (o Optional[T]) or_else(default T) T {
	if o.is_defined {
		return o.value
	}
	return default
}

fn main() {
	op := Optional[string]{is_defined: false}
	println(op.or_else("default")) // default
}
```

Generic struct methods can use struct parameter types as method parameter types or as return value types.

Such methods can define their own parameter types:

```v play
struct Optional[T] {
	value      T
	is_defined bool = true
}

fn (o Optional[T]) map[U](f fn (T) U) Optional[U] {
	if o.is_defined {
		return Optional[U]{value: f(o.value)}
	}
	return Optional[U]{is_defined: false}
}

fn main() {
	op := Optional[string]{value: '100.5'}
	println(op.map(fn (str string) int {
		return str.int()
	})) // Optional[int]{value: 100'}

	op2 := Optional[string]{is_defined: false}
	println(op2.map(fn (str string) int {
		return str.int()
	})) // Optional[int]{is_defined: false}
}
```

You may notice that when the `map()` method is called, the parameter type `U` is not explicitly specified.
The V compiler itself inferred the type of the `U` parameter from the function passed to it.

## Interfaces

Generic interfaces are defined using square brackets after the interface name containing the parameter types:

```v play
interface Iterator[T] {
	has_next() bool
mut:
	next() T
}
```

This interface can be implemented by any data type that implements the `has_next()` and `next()` methods.

A struct can also be generic:

```v play
interface Iterator[T] {
	has_next() bool
mut:
	next() T
}

struct Array[T] {
mut:
	data []T
	pos  int
}

fn (a Array[T]) has_next() bool {
	return a.pos < a.data.len
}

fn (mut a Array[T]) next() T {
	pos := a.pos
	a.pos++
	return a.data[pos]
}

fn each[T](mut it Iterator[T]) {
	for it.has_next() {
		println(it.next())
	}
}

mut arr := Array[int]{
	data: [1, 2, 3]
}
each(mut arr)
```

Or not:

```v play
interface Iterator[T] {
	has_next() bool
mut:
	next() T
}

struct Array {
mut:
	data []int
	pos  int
}

fn (a Array) has_next() bool {
	return a.pos < a.data.len
}

fn (mut a Array) next() int {
	pos := a.pos
	a.pos++
	return a.data[pos]
}

fn each[T](mut it Iterator[T]) {
	for it.has_next() {
		println(it.next())
	}
}

mut arr := Array{
	data: [1, 2, 3]
}
each[int](mut arr)
```

Note that in this case the compiler will not be able to calculate the type when calling `each()`
and must be specified explicitly.

At the moment, methods declared in the interface cannot have their own parameter types:

```v
interface Iterator[T] {
	map[U](fn (T) U) []U // not allowed
}
```

## Compile-time conditions

Due to the fact that V has [compile-time](./compile-time/control-flow.md) `if`, in the body of generic functions, you can 
separate the code depending on the type passed:

```v play
fn myprintln[T](data T) {
	$if T is $Array {
		println('array: [')
		for i, elem in data {
			myprintln(elem)
			if i < data.len - 1 {
				print(', ')
			}
			println('')
		}
		println(']')
	} $else $if T is $Map {
		println('map: {')
		for key, val in data {
			print('\t(key) ')
			myprintln(key)
			print(' -> (value) ')
			myprintln(val)
		}
		println('}')
	} $else {
		println(data)
	}
}

myprintln([1,2,3])
// array: [
// 1, 
// 2, 
// 3
// ]

myprintln({
	"key1": 100
	"key2": 200
})
// map: {
// 	  (key) key1
//  -> (value) 100
// 	  (key) key2
//  -> (value) 200
// }
```

## Under the hood

In V, generics are implemented using compile-time code generation for each parameter type.
This means that generics do not add any execution time to your program.
