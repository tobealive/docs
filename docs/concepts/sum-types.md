# Sum types

The sum type is a special data type that can hold a value of one of several
types while maintaining type safety.

Suppose you need to describe the width of an element in CSS.
It can be specified either as a number of pixels or as a string expression.
Of course the CSS specification is more complex, but we'll simplify it for the sake of the example.

To specify the sum type, use the `type` keyword:

```v
type Width = int | string
```

The `|` lists the types that the sum type will consist of.

Now let's try to use it:

```v play
type Width = int | string

fn main() {
    int_width := Width(10)
    println(int_width)
    string_width = Width('calc(100% - 100px)')
    println(string_width)
}
```

To create a new instance of the sum type, use type casting:

```v oksyntax
int_width := Width(10)
```

In this case, the expression that is cast to the sum type must be one of the
types listed through `|` when declaring the sum type.
Otherwise, there will be a compilation error.

## Recursive sum types

The sum type can be recursive, i.e. refer to itself, but only if it is defined
as an array or map element type:

```v
type JsonValue = []JsonValue | bool | f64 | int | map[string]JsonValue | string
```

## Accessing fields from structures in the sum type

If the sum type contains structures, then through the sum type you can access their fields
provided that a field with the same name exists in all structures that are part of the sum type.

```v
struct Star {
	name string
}

struct Planet {
	name string
}

type Object = Planet | Star

fn main() {
	star := Object(Star{'Sun'})
	println(star.name) // Sun
}
```

## Calling methods from structures in sum type

Unlike fields, even if all structures in a sum type have a method with the same name,
they cannot be accessed through the sum type!

## Get the type of the stored value

Sometimes you need to find out what type is stored in an instance of the sum type.
To do this, for any sum type, the `type_name()` method is defined, which returns
the name of the type that is currently stored.

```v play
struct Moon {}

struct Mars {}

struct Venus {}

type World = Mars | Moon | Venus

world := World(Moon{})
println(world.type_name()) // Moon
println(world)
```

## Working with sum type

To conveniently handle the type of the sum, the `match` expression can be
used to check the type of the stored value.

```v
type Width = int | string

fn absolute_width(width Width) int {
	return match width {
		int {
			width
		}
		string {
			0
		}
	}
}
```

At the same time, `match` must be exhaustive, that is, handle all possible
variants of the sum type or have an `else` branch:

```v
type Width = f64 | int | string

fn absolute_width(width Width) int {
	return match width {
		int { width }
		else { 0 }
	}
}
```

With sum types you could build recursive structures:

```v play
struct Empty {}

struct Node {
	value f64
	left  Tree
	right Tree
}

type Tree = Empty | Node

fn sum(tree Tree) f64 {
	return match tree {
		Empty { 0 }
		Node { tree.value + sum(tree.left) + sum(tree.right) }
	}
}

fn main() {
	left := Node{0.2, Empty{}, Empty{}}
	right := Node{0.3, Empty{}, Node{0.4, Empty{}, Empty{}}}
	tree := Node{0.5, left, right}
	println(sum(tree)) // 0.2 + 0.3 + 0.4 + 0.5 = 1.4
}
```

## `is` and `as` operators

The `is` operator checks if the value stored in the sum type is of the specified type:

```v play
type Width = int | string

fn main() {
    width := Width(10)
    println(width is int) // true
    println(width is string) // false
}
```

The `as` operator casts the value stored in the sum type to the specified type:

```v play
type Width = int | string

fn main() {
    width := Width(10)
    int_width := width as int
    println(int_width.hex2()) // 0xa
}
```

If the value stored in the sum type is not of the specified type, then the program will panic.
Because of this, the `as` operator should be used with caution.
Smart casts can be used as a replacement.

## Smart casts

The V compiler can automatically type cast inside `if` and `match` blocks:

```v play
type Width = int | string

fn main() {
    width := Width(10)
    if width is int {
        println(width.hex2()) // 0xa
    }
}
```

In this example, `width` is of type `int` within the body of the `if` block.
The compiler understands that inside the `if` block, the `width` variable is of type `int`,
since the condition of the `if` block checks that `width is int`.

If `width` is a mutable identifier, it would be unsafe if the compiler smart casts it without a warning.
That's why you have to declare a `mut` before the `is` expression:

```v play
type Width = int | string

fn main() {
    mut width := Width(10)
    if mut width is int {
        println(width.hex2()) // 0xa
    }
Ъ
```

Otherwise `width` would keep its original type.

This works for both, simple variables and complex expressions like `user.name`:

```v play
type Width = int | string

struct Component {
    width Width
}

fn main() {
    component := Component{
        width: Width(10)
    }
    match component.width {
        int {
            // smartcasted to int
            println(component.width.hex2()) // 0xa
        }
        string {
            // smartcasted to string
            println(component.width.len)
        }
    }
}
```
