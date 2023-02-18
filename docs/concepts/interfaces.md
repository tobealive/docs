# Interfaces

Interfaces in V define some behavior in the form of methods and fields.
Interfaces can be implemented by any type that has the appropriate methods and fields.
Interfaces are conventions by which types can work together.

Take for example the `Speaker` interface, which defines the `speak()` method:

```v
interface Speaker {
	speak(msg string) string
}
```

When we define a function that takes the `Speaker` interface as an argument, we abstract away
from the actual implementation and only use what the interface defines:

```v failcompile
fn greet(s Speaker) {
	println(s.speak('Hello'))
}
```

Now we can call `greet()` with any type that implements the `Speaker` interface:

```v play
interface Speaker {
	speak(msg string) string
}

struct Dog {}
   
fn (d Dog) speak(msg string) string {
    return '${msg}. Woof, woof!'
}

fn greet(s Speaker) {
    println(s.speak("Hello"))
}
    
fn main() {
    d := Dog{}
    greet(d) // Hello. Woof, woof!
}
```

## Implement an interface

A type implements an interface by implementing its methods and fields.
There is no explicit declaration of intent, no "implements" keyword.

In the example above, we have implemented the `Speaker` interface for the `Dog` type.
To do this, we have defined a `speak()` method for the `Dog` type, which has the same
signature as the `speak()` method in the `Speaker` interface.

To implement an interface that contains fields, a type must have fields with
the same names and types.

```v play
interface IdOwner {
	id int
}

struct User {
	id int
}

fn print_id(o IdOwner) {
	println(o.id)
}

fn main() {
	u := User{
		id: 123
	}
	print_id(u) // 123
}
```

## Mutable section

As with structs, you can define a `mut` section in an interface.
Types that implement an interface must have a `mut` receiver for methods
defined in the `mut` section of the interface.

```v
interface Bar {
mut:
	write(string) string
}

struct MyStruct {}

fn (mut s MyStruct) write(a string) string {
	return a
}

fn main() {
	mut str := MyStruct{}
	write(mut str)
}

fn write(mut s Bar) {
	println(s.write('Bar')) // Bar
}
```

### Casting an interface

Interfaces allow you to abstract away from a specific implementation,
but sometimes you need to access a specific implementation.

For this, smartcasts and the `is` operator are used:

The `is` operator checks if the value that implements the interface is of the specified type:

```v play
interface Speaker {
	speak(msg string) string
}

struct Dog {}
   
fn (d Dog) speak(msg string) string {
    return '${msg}. Woof, woof!'
}
    
struct Cat {}
    
fn (c Cat) speak(msg string) string {
    return '${msg}. Meow, meow!'
}

fn greet(s Speaker) {
    if s is Dog {
        println('a dog speaks: ${s.speak("Hello")}')
    } else if s is Cat {
        println('a cat speaks: ${s.speak("Hello")}')
    } else {
        println('something else')
    }
}

fn main() {
    d := Dog{}
    greet(d) // a dog speaks: Hello. Woof, woof!
}
```

We can also use `match` for type checking:

```v failcompile
fn greet(s Speaker) {
	match s {
		Dog {
			println('a dog speaks: ${s.speak('Hello')}')
		}
		Cat {
			println('a cat speaks: ${s.speak('Hello')}')
		}
		else {
			println('something else')
		}
	}
}
```

### Interface method definitions

Also unlike Go, an interface can have its own methods, similar to how
structs can have their methods.
These 'interface methods' do not have to be implemented, by structs which implement that interface.
They are just a convenient way to write `i.some_function()` instead of `some_function(i)`,
similar to how struct methods can be looked at, as a convenience for writing `s.xyz()` instead of `xyz(s)`.

> **Note**
> This feature is NOT a "default implementation" like in C#.

For example, if a struct `cat` is wrapped in an interface `a`, that has
implemented a method with the same name `speak`, as a method implemented by
the struct, and you do `a.speak()`, *only* the interface method is called:

```v play
interface Adoptable {}

fn (a Adoptable) speak() string {
	return 'adopt me!'
}

struct Cat {}

fn (c Cat) speak() string {
	return 'meow!'
}

struct Dog {}

fn main() {
	cat := Cat{}
	println(cat.speak()) // meow!

	a := Adoptable(cat)
	println(a.speak()) // adopt me! (called Adoptable's `speak()`)
	if a is Cat {
		// Inside this `if` however, V knows that `a` is not just any
		// kind of Adoptable, but actually a Cat, so it will use the
		// Cat `speak`, NOT the Adoptable `speak`:
		println(a.speak()) // meow!
	}

	b := Adoptable(Dog{})
	println(b.speak()) // adopt me! (called Adoptable's `speak`)
}
```

### Embedded interface

Interfaces support embedding, just like structs.
In this case, all methods and fields of the interface will belong to the parent
interface and the type will need to implement methods and fields from all interfaces.

For example, we have two interfaces, `Reader` and `Writer`:

```v
pub interface Reader {
mut:
	read(mut buf []byte) ?int
}

pub interface Writer {
mut:
	write(buf []byte) ?int
}
```

Now, if we want to declare a `ReaderWriter` interface that requires the implementation
of the `read()` and `write()` methods, then instead of copying the methods from `Reader`
and `Writer` to `ReaderWriter`, we simply embed interfaces themselves in `ReaderWriter`:

```v failcompile
pub interface ReaderWriter {
	Reader
	Writer
}
```

Now, if we want to implement `ReaderWriter`, we need to implement the `read()` and `write()`
methods from both built-in interfaces:

```v failcompile
struct MyReaderWriter {}

fn (mut m MyReaderWriter) read(mut buf []byte) ?int {
	// ...
}

fn (mut m MyReaderWriter) write(buf []byte) ?int {
	// ...
}
```
