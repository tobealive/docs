# Builtin functions

## `(e)print(ln)`: Printing to the console

`println` is a simple yet powerful builtin function, that can print anything:
strings, numbers, arrays, maps, structs.

`print` is the same as `println`, but doesn't add a newline character at the end.

`eprintln` is the same as `println`, but prints to the standard error output.

`eprint` is the same as `eprintln`, but doesn't add a newline character at the end.

```v play
struct User {
	name string
	age  int
}

println(1) // 1
println('hi') // hi
println([1, 2, 3]) // [1, 2, 3]
println(User{ name: 'Bob', age: 20 })
// User{
//   name: 'Bob'
//   age: 20
// }
```

See also [Printing Custom Types](printing-custom-types.md).

## `sizeof`: Getting the size of a type

`sizeof` returns the size of a type in bytes.

This builtin function can be used in two ways:

- `sizeof[type]()` – returns the size of the type in bytes
- `sizeof(expr)` – returns the size of the type of the expression in bytes

```v play
struct User {
	name string
	age  int
}

user := User{}
println(sizeof(user)) // 24
println(sizeof[User]()) // 24
println(sizeof[int]()) // 4
println(sizeof(1)) // 8
```

## `typeof`: Getting the type of expression

`typeof` returns the type of expression in `TypeInfo` struct.

```v play
struct User {
	name string
	age  int
}

user := User{}
println(typeof(user)) // User
println(typeof(user).idx) // 94
println(typeof(user).name) // User
```

`TypeInfo` struct definition:

```v
struct TypeInfo {
	idx  int    // index of the type in the type table
	name string // name of the type
}
```

## `isreftype`: Checking if a type is a reference type

`isreftype` returns `true` if the type is a reference type, `false` otherwise.

```v play nofmt
println(isreftype[int]())            // false
println(isreftype[string]())         // true
println(isreftype[[]int]())          // true
println(isreftype[map[string]int]()) // true
println(isreftype('hello'))          // true
println(isreftype(10))               // true
```

## `__offsetof`: Getting the offset of a struct field

`__offsetof` returns the offset of a struct field in bytes.

```v play
struct Foo {
	a int
	b string
}

println(__offsetof(Foo, b)) // 8
```

## `dump`: Dumping expressions at runtime

You can dump/trace the value of any V expression using `dump(expr)`.
This function takes an expression and returns it, so you can use it anywhere in the expression.
`dump(expr)` keeps track of the original location, the expression itself, and the value of the
expression.

```v play
fn factorial(n u32) u32 {
	if dump(n <= 1) {
		return dump(1)
	}
	return dump(n * factorial(n - 1))
}

fn main() {
	println(factorial(5))
}
```

Output:

```text
[factorial.v:2] n <= 1: false
[factorial.v:2] n <= 1: false
[factorial.v:2] n <= 1: false
[factorial.v:2] n <= 1: false
[factorial.v:2] n <= 1: true
[factorial.v:3] 1: 1
[factorial.v:5] n * factorial(n - 1): 2
[factorial.v:5] n * factorial(n - 1): 6
[factorial.v:5] n * factorial(n - 1): 24
[factorial.v:5] n * factorial(n - 1): 120
120
```
