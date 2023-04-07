# References

References in V are similar to those in C++ and Go.
You can read more about references in
[wiki article](https://en.wikipedia.org/wiki/Reference_(computer_science)).
Here we will describe some features of working with references in V.

References in V are specified by using the `&` symbol in front of the type:

```v
struct Foo {
	inner &Foo
}

fn foo(foo &Foo) {
	// ...
}
```

## Take address

To create a reference, you need to take the address, e.g. of a variable.
In V, this is done with the `&` operator:

```v
struct Foo {
	abc int
}

foo := Foo{}
foo_ptr := &foo
```

Now `foo_ptr` is a reference to `foo`.
Note that you cannot change fields through this reference as it is immutable.

You can take a mutable reference from a mutable variable with which to change fields:

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

Taking the address from an immutable variable and assigning it to a mutable reference is *
*prohibited**:

```v play
struct Foo {
	abc int
}

foo := Foo{}
foo_ptr := &foo
mut foo_ptr2 := foo_ptr
//              ^^^^^^^ error: `foo_ptr` is immutable,
//                      cannot have a mutable reference to an immutable object
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
To display the address of the reference, you should use string interpolation:

```v play
struct Foo {
	abc int
}

foo := Foo{}
foo_ptr := &foo

println('${foo_ptr:p}')
// 2ae32cf2dfe0
```

Or use `ptr_str()`:

```v play
struct Foo {
    abc int
}

foo := Foo{}
foo_ptr := &foo

println(ptr_str(foo_ptr))
// 2ae32cf2dfe0
```
