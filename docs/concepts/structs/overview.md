# Structs

A structure is a data type that allows you to combine several other data types into one with unique names for each.

Suppose you want to store information about a person.
You need to store the name and age.

You can define a `Person` struct with two fields: `name` and `age`:

```v
struct Person {
	name string
	age  int
}
```

In V, structures are specified using the `struct` keyword.
Each field must have a unique name and type.

To instantiate a struct, use a struct literal:

```v failcompile
p := Person{
	name: 'Bob'
	age: 20
}
```

Fields can be initialized in any order or omitted when they are created.

There is also a short syntax for instantiating structures:

```v failcompile
p := Person{'Bob', 20}
```

To refer to a structure field, use a dot:

```v failcompile
p := Person{
	name: 'Bob'
	age: 20
}

println(p.name) // Bob
```

## Fields

### Access/mutability modifiers

As already described above, structures can have fields.
By default, all fields are immutable and private.
Privacy means that access to them will be only within the current [module](../modules/overview.md).

Fields access modifiers can be changed with `pub` and `mut` keywords.
In total, there are 5 possible options:

```v
struct Foo {
	a int // private immutable (default)
mut:
	b int // private mutable
	c int // (you can list multiple fields with the same access modifier)
pub:
	d int // public immutable (readonly)
pub mut:
	e int // public, but mutable only in parent module
__global:
	// (not recommended to use, that's why the 'global' keyword starts with __)
	f int // public and mutable both inside and outside parent module
}
```

### Default field values

All struct fields are
[zeroed](../types/zero-values.md)
by default during the creation of the struct.
Array and map fields are allocated.

```v nofmt
struct Foo {
	num int            // 0 by default
	str string         // '' by default
	arr []int          // `[]int{}` by default
	mp  map[string]int // `map[string]int{}` by default
}
```

To set a default value for a field, use `=` after the field type:

```v
struct Foo {
	num int = 42
}
```

### Required fields

As already described earlier, when creating an instance of a structure, fields can be omitted.
To mark some fields as required, use `[required]` [attribute](../attributes.md):

```v
struct Foo {
	n int [required]
}
```

## Methods

Structs can also have methods. To set them, a special syntax is used:

```v
struct Person {
	name string
	age  int
}

fn (p Person) say_hi() {
	println('Hi, my name is ${p.name}')
}
```

Before the function name, a new parameter is added called `receiver`.
It defines the type of the structure that the method belongs to, as well as the name of the variable,
through which you can access an instance of the structure on which the method is called.

By convention, the receiver name should not be `self` or `this`.
It is better to use a short, preferably one-letter, name.

Just like accessing the fields of a structure, a dot is used:

```v play
struct Person {
	name string
	age  int
}

fn (p Person) say_hi() {
	println('Hi, my name is ${p.name}')
}

p := Person{
	name: 'Bob'
	age:  20
}
p.say_hi() // Hi, my name is Bob
```

> **Note**
> Methods must be declared in the same module as the struct.

### Reference receiver

In the example above, we declared the receiver as `p Person`.
This means that the method will be called on a copy of the structure.
To call a method on the original structure, you need to use `&` before the receiver type:

```v play
struct Person {
	name string
	age  int
}

fn (p &Person) say_hi() {
	println('Hi, my name is ${p.name}')
}

p := Person{
	name: 'Bob'
	age:  20
}
p.say_hi() // Hi, my name is Bob
```

In this case, an instance of the structure will be passed to the method by reference.

This can be useful for large structures where copying them can be an expensive operation.
Note that although a struct is passed by reference, you cannot change the fields of a struct
within a method, even if they are marked `mut`.

### Mutable receivers

By default, struct fields cannot be changed in methods, even if the field itself is marked as `mut`.
The following code will not compile:

```v play
struct Person {
	mut:
	name string
	age  int
}

fn (p Person) birthday() {
	p.age++
	//^^^^^ error: `p` is immutable, declare it with `mut` to make it mutable
}
```

To change the fields of a structure in a method, you need to add `mut` before the name of the receiver:

```v
struct Person {
mut:
	name string
	age  int
}

fn (mut p Person) birthday() {
	p.age++
}
```

In this case, we can freely change the mutable fields of the structure inside the method.
Such methods can only be called on mutable struct instances:

```v failcompile
mut mut_person := Person{
	name: 'Bob'
	age: 20
}

immut_person := Person{
	name: 'Bob'
	age: 20
}

mut_person.birthday() // ok
immut_person.birthday()
//^^^^^^^^^^ `immut_person` is immutable, declare it with `mut` to make it mutable
```

Note that in this case the receiver becomes implicitly referential, i.e.
its type becomes `&Person` instead of `Person`.
This means that the structure instance will not be copied when the method
is called, but a pointer to it will be passed.

> **Note**
> The `mut p &Person` entry is currently prohibited.

## Allocate structs on the heap

Structs are allocated on the stack.
To allocate a struct on the heap and get a [reference](../types/references.md) to it, use the `&` prefix:

```v
struct Point {
	x int
	y int
}

p := &Point{10, 10}
// References have the same syntax for accessing fields
println(p.x)
```

See also [Stack and Heap](../memory-management.md#stack-and-heap)

### Always heap allocated structs

For some structures, you may want them to always be allocated on the heap.
You can use [attribute](../attributes.md) `[heap]` for this:

```v
[heap]
struct Point {
	x int
	y int
}

p := Point{10, 10}
println(p.x)
```

## Struct update syntax

V provides a convenient syntax for changing the fields of a structure.

```v
struct User {
	name          string
	age           int
	is_registered bool
}

fn register(u User) User {
	return User{
		...u
		is_registered: true
	}
}

mut user := User{
	name: 'Bob'
	age: 20
}
user = register(user)
println(user)
// User{
//    name: 'Bob'
//    age: 20
//    is_registered: true
// }
```

The passed structure will be copied, and only those fields specified in the update
syntax after the `...u` will be changed in the copy.

## Trailing struct literal arguments

V doesn't have default function arguments or named arguments, for that trailing struct
literal syntax can be used instead:

```v
[params]
struct ButtonConfig {
	text        string
	is_disabled bool
	width       int = 70
	height      int = 20
}

struct Button {
	text   string
	width  int
	height int
}

fn new_button(c ButtonConfig) &Button {
	return &Button{
		width: c.width
		height: c.height
		text: c.text
	}
}

button := new_button(text: 'Click me', width: 100)
// the height is unset, so it's the default value
assert button.height == 20
```

As you can see, both the struct name and braces can be omitted, instead of:

```v oksyntax nofmt
new_button(ButtonConfig{text:'Click me', width:100})
```

This only works for functions that take a struct for the last argument.

`[params]` [attribute](../attributes) is used to tell V, that the trailing struct parameter
can be omitted *entirely*, so that you can write `button := new_button()`.
Without it, you have to specify *at least* one of the field names, even if it
has its default value, otherwise the compiler will produce this error message,
when you call the function with no parameters:
`error: expected 1 arguments, but got 0`.

## `[noinit]` structs

V supports `[noinit]` structs, which are structs that cannot be initialised outside the module
they are defined in. They are either meant to be used internally or they can be used externally
through *factory functions*.

For an example, consider the following source in a directory `sample`:

```v oksyntax
[noinit]
pub struct Information {
pub:
	data string
}

pub fn new_information(data string) !Information {
	if data.len == 0 || data.len > 100 {
		return error('data must be between 1 and 100 characters')
	}
	return Information{
		data: data
	}
}
```

Note that `new_information` is a *factory* function.
Now when we want to use this struct outside the module:

```v okfmt
import sample

fn main() {
	// This doesn't work when the [noinit] attribute is present:
	// info := sample.Information{
	// 	data: 'Sample information.'
	// }

	// Use this instead:
	info := sample.new_information('Sample information.')!

	println(info)
}
```

## Structs with reference fields

Structs with references to require explicitly setting the initial value to a
reference value unless the struct already defines its own initial value.

Zero-value references, or nil pointers, will **NOT** be supported in the future,
for now data structures such as Linked Lists or Binary Trees that rely on reference
fields that can use the value `0`, understanding that it is unsafe, and that it can
cause a panic.

```v
struct Node {
	a &Node
	b &Node = unsafe { nil } // Auto-initialized to nil, use with caution!
}

// Reference fields must be initialized unless an initial value is declared.
foo := Node{
	a: unsafe { nil }
}
bar := Node{
	a: &foo
}
baz := Node{
	a: unsafe { nil }
	b: unsafe { nil }
}
qux := Node{
	a: &foo
	b: &bar
}
println(baz)
println(qux)
```

## Anonymous structs

V supports anonymous structs: structs that don't have to be declared separately
with a struct name.

```v play
struct Book {
	author struct {
		name string
		age  int
	}

	title string
}

book := Book{
	author: struct {
	    name: 'Samantha Black'
	    age: 24
	}
}
println(book.author.name) // Samantha Black
println(book.author.age) // 24
```
