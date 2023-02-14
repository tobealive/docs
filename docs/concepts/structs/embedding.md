# Embedded structs

There is no inheritance in V, but the language provides embedding through which composition can be expressed
as an analogue of inheritance.

```v play
struct Size {
mut:
	width  int
	height int
}

fn (s &Size) area() int {
	return s.width * s.height
}

struct Button {
	Size
	title string
}

mut button := Button{
	title: 'Click me'
	height: 2
}

println(button.area()) // 6
```

Embedded structs must come before all own struct fields.

With embedding, the struct `Button` will automatically have get all the fields and methods from
the struct `Size`, which allows you to do:

```v
mut button := Button{
	title: 'Click me'
	height: 2
}

button.width = 3
println(button.area()) // 6
println(button.Size.area()) // 6
print(button)
// Button{
//   Size: Size{
// 	   width: 3
// 	   height: 2
//   }
//   title: 'Click me'
// }
```

Unlike inheritance, you cannot type cast between structs and embedded structs
(the embedding struct can also have its own fields, and it can also embed multiple structs).

If you need to access embedded structs directly, use an explicit reference like `button.Size`.

Conceptually, embedded structs are similar to [mixin](https://en.wikipedia.org/wiki/Mixin)s
in OOP, *NOT* base classes.

You can also initialize an embedded struct:

```v oksyntax
mut button := Button{
	Size: Size{
		width: 3
		height: 2
	}
}
```

or assign values:

```v oksyntax
button.Size = Size{
	width: 4
	height: 5
}
```

If multiple embedded structs have methods or fields with the same name, or if methods or fields
with the same name are defined in the struct, you can call methods or assign to variables in
the embedded struct like `button.Size.area()`.
When you do not specify the embedded struct name, the method of the outermost struct will be
targeted.
