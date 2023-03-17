# Basic syntax

## Entry point

In V, the entry point of a program is the `main` function.
It is the first function that is called when the program starts.

```v play
fn main() {
	println('Hello, World!')
}
```

It can be omitted if the program is a single file.

```v
println('Hello, World!')
```

## Printing to the console

To print to the console, use the `print` or `println` functions.

`print` prints the value passed to it to standard output.

```v play
print('Hello,')
print(' World!')
```

`println` prints the value passed to it to standard output and adds a newline
character at the end.

```v play
println('Hello, World!')
println("I'm V!")
```

Try to run these examples to see the difference.

See [Builtin functions](../concepts/builtin-functions.md) for more information.

## Functions

A function with two string arguments and a string return type.

```v
fn concatenate(a string, b string) string {
	return a + b
}
```

If function doesn't return anything, you can omit the return type.

```v
fn say_hello() {
	println('Hello, World!')
}
```

Function calls looks like this:

```v ignore
concatenate('Hello, ', 'World!')
```

See [Functions](../concepts/functions/overview.md) for more information.

## Variables

Variables in V declared with `:=` operator.

```v
name := 'V'
age := 4
```

You can also declare multiple variables in one line.

```v
name, age := 'V', 4
```

By default all variables are immutable. To make a variable mutable, use `mut`
keyword.

```v
mut name := 'V'
name = 'V Language'
```

See [Variables](../concepts/variables) for more information.

## Constants

Constants in V declared with `const` keyword. It can be declared only in the top
level scope.

```v play
const name = 'V'

fn main() {
	println(name)
}
```

You can define several constants with next syntax:

```v play
const (
	name = 'V'
	age = 4
)

fn main() {
	println(name)
	println(age)
}
```

See [Constants](../concepts/constants) for more information.

## Structs

V is not an object-oriented language, it doesn't have classes.
But it has structs:

```v play
struct Person {
	name string
	age  int
}

fn main() {
	p := Person{
		name: 'Bob'
		age: 42
	}
	println(p)
}
```

By default, all fields in a struct are immutable, private, and can be accessed
only from the same module.
To make a field mutable, use `mut` keyword.

```v play
struct Person {
	name string
mut:
	age int
}

fn main() {
	mut p := Person{
		name: 'Bob'
		age: 42
	}
	p.age++
	println(p)
}
```

To make field public, use `pub` keyword.

```v play
struct Person {
	name string
pub:
	age int
}

fn main() {
	mut p := Person{
		name: 'Bob'
		age: 42
	}
	println(.age)
}
```

Structs can have methods:

```v play
struct Person {
	name string
	age  int
}

fn (p Person) say_hello() {
	println('Hello, ${p.name}!')
}

fn main() {
	p := Person{
		name: 'Bob'
		age: 42
	}
	p.say_hello()
}
```

See [Structs](../concepts/structs) for more information.

## Interfaces

V has interfaces, which are similar to interfaces in other languages. V uses
[duck typing](https://en.wikipedia.org/wiki/Duck_typing).
This means that there is no `implements` keyword.

```v play
interface Greeter {
	greet()
}

struct Person {
	name string
}

fn (p Person) greet() {
	println('Hello, ${p.name}!')
}

fn greet(g Greeter) {
	g.greet()
}
```

See [Interfaces](../concepts/interfaces) for more information.

## String templates

```v play
name := 'V'
println('Hello, ${name}!')

age := 4
println('V is ${age} years old!')
```

See [String templates](../concepts/types/strings.md#string-interpolation) for
more information.

## Conditional expressions

```v play
age := 4
if age < 18 {
	println('You are a child!')
} else if age < 60 {
	println('You are an adult!')
} else {
	println('You are a senior!')
}
```

`if` can be used as an expression.

```v play
age := 4
status := if age < 18 {
	'You are a child!'
} else if age < 60 {
	'You are an adult!'
} else {
	'You are a senior!'
}
println(status)
```

See [Conditional expressions](../concepts/control-flow/conditions.md) for more
information.

## For loop

V has only `for` loops in different forms.

```v play
for i := 0; i < 10; i++ {
	println(i)
}
```

or

```v play
for i in 0..10 {
	println(i)
}
```

or

```v play
items := ['a', 'b', 'c']
for index, item in items {
	println('${index}: ${item}')
}
```

See [For loop](../concepts/control-flow/loops.md) for more information.

## Match expression

```v play
age := 4
match age {
	age < 18 {
		println('You are a child!')
	}
	age < 60 {
		println('You are an adult!')
	}
	else {
		println('You are a senior!')
	}
}
```

Or for sum types:

```v play
type Status = string | int

fn get_status() Status {
	return 'OK'
}

status := get_status()
match status {
	string {
		println('Status is a string: ${status}')
	}
	int {
		println('Status is an integer: ${status}')
	}
	else {
		println('Unknown status type')
	}
}
```

See [Match expression](../concepts/control-flow/conditions.md#match-expression)
for more information.
For more information about sum types see [Sum types](../concepts/sum-types).

## Error handling

```v play
fn get_age() !int {
	return error('Age is not set')
}

fn main() {
	age := get_age() or {
		println('Age is not set')
		return
	}
	println(age)
}
```

See [Error handling](../concepts/error-handling) for more information.

## Import modules

```v play
import os

fn main() {
	println(os.args)
}
```

See [Modules](../concepts/modules/overview) for more information.

## Comments

```v
// This is a single line comment.
/*
This is a multiline comment.
   /* It can be nested. */
*/
```
