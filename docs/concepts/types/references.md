# References

References in V are similar to those in C++ and Go.
You can read more about references in
[wiki article](https://en.wikipedia.org/wiki/Reference_(computer_science)).
Here we will describe some features of working with references in V.

References in V are specified by using the `&` symbol in front of the type:

```v
struct Foo {
	inner &Foo
	//    ^^^^ reference to Foo
}

fn foo(foo &Foo) {
	//     ^^^^ reference to Foo
}
```

## Take address

To create a reference, you need to take the address, e.g. of a variable or a field.
In V, this is done with the `&` operator:

```v
struct Foo {
	abc int
}

foo := Foo{}
foo_ptr := &foo
//         ^^^^ take address of foo variable
```

Now `foo_ptr` is a reference to `foo`.

> **Note**
> Due to strict mutability rules, you cannot change the fields of the structure through such a
> reference, since the reference is immutable and is made for an immutable variable.

You can take a mutable reference from a mutable variable with which you can change fields:

```v play
struct Foo {
mut:
	abc int
}

mut foo := Foo{}
mut foo_ptr := &foo

foo_ptr.abc = 123
println(foo.abc) // 123
```

Taking the address from an **immutable** variable and assigning it to a **mutable** reference is
**prohibited**:

```v play
struct Foo {
	abc int
}

foo := Foo{}
foo_ptr := &foo
mut foo_ptr2 := foo_ptr
//              ^^^^^^^ error: `foo_ptr` is immutable,
//                      cannot have a mutable reference to an immutable object
println(foo_ptr2)
```

## Dereferencing a reference

To get a value by reference, you can dereference the reference.
This is done with the `*` operator:

```v play
struct Foo {
	abc int
}

foo := Foo{}
foo_ptr := &foo

println(*foo_ptr)
// Foo{
//   abc: 0
// }
```

> **Note**
> Dereferencing a
> [null reference](#null-reference)
> will result in a fatal runtime error!

## Print reference

In the output, the reference will have a `&` at the beginning:

```v play
struct Foo {
	abc int
}

foo := Foo{}
foo_ptr := &foo

println(foo_ptr)
// &Foo{
//   abc: 0
// }
```

Unlike other languages, a value is displayed that is stored by reference.
To display the address of the reference, you should use
[string interpolation](./strings.md#string-interpolation)
with `p` format specifier:

```v play
struct Foo {
	abc int
}

foo := Foo{}
foo_ptr := &foo

println('${foo_ptr:p}')
// 2ae32cf2dfe0
```

Or use `ptr_str()` function:

```v play
struct Foo {
	abc int
}

foo := Foo{}
foo_ptr := &foo

println(ptr_str(foo_ptr))
// 2ae32cf2dfe0
```

## Null reference

Null references are references that do not point to any object.
Dereferencing such references will result in a fatal runtime error.

Due to easy integration with C code, null references can be implicitly created in C code and then
passed to V code.
In such a case, the V code must be prepared for the fact that the reference may be null.

V has a `nil` keyword that represents a null reference, but it can only be used in
[unsafe](../../advanced-concepts/memory-unsafe-code.md)
code:

```v play
struct Foo {
	parent &Foo = unsafe { nil }
}

fn main() {
	foo := Foo{}
	println(foo.parent)
}
```

To check for a null reference, you can use either the `isnil` function or compare against `nil`:

```v play
struct Foo {
	parent &Foo = unsafe { nil }
}

fn main() {
	foo := Foo{}

	if isnil(foo.parent) {
		println('foo.parent is nil')
	}

	if foo.parent == unsafe { nil } {
		println('foo.parent is nil')
	}
}
```

If you need to return a value or `nil` from a function, or you want to represent a field that may
not be initialized, it is better to use
[Option type](../error-handling/overview.md#option-types),
which is much safer:

```v play
struct Parent {
	name string
}

struct Foo {
	parent ?Parent
}

fn get_foo_or_none() ?Foo {
	if true {
		return Foo{}
	}
	return none
}

fn main() {
	foo := Foo{}
	println(foo.parent) // Option(none)

	foo2 := get_foo_or_none() or {
		return
	}
	println(foo2)
	// Foo{
	//   parent: Option(none)
	// }
}
```
