# Enums

Enums are a data type that defines a set of named integer constants.

In V, enums are declared using the `enum` keyword:

```v play
enum Color {
	red
	green
	blue
}

mut color := Color.red
println(color) // red
```

By default, V uses `int` to store enum values.
To use any other numeric type (e.g. `u8`), you can specify it after the enum name with the `as` keyword:

```v
enum Color as u8 {
	red
	green
	blue
}
```

To get the ordinal of an enum field, use a cast:

```v play
enum Color {
	red
	green
	blue
}

color := Color.red
println(int(color)) // 0
```

Sequence numbers start at 0 and increase by 1 for each next enum field.

For each field, you can specify your own value:

```v
enum Color {
	red = 0xFF0000
	green = 0x00FF00
	blue = 0x0000FF
}
```

If you do not specify a value for the first option, then it will be 0.
If you do not specify a value for the next option, then it will be equal to the value of the previous option plus 1.

```v
enum Color {
	any // value is 0
	red = 10
	green // value is 11
	blue // value is 12
}
```

The compiler can infer which enum the value belongs to:

```v play
enum Color {
	red
	green
	blue
}

mut color := Color.red
color = .green
// V knows that `color` is a `Color`. No need to use `color = Color.green` here.

println(color) // green
```

Enum fields can re-use reserved keywords escaped with an @:

```v play
enum Color {
	@none
	red
	green
	blue
}

color := Color.@none
println(color)
```

For convenient work with enums, you can use the `match` expression.
Enum match must be exhaustive or have an `else` branch.
This ensures that if a new enum field is added, it's handled everywhere in the code.

```v play
enum Color {
	red
	green
	blue
}

color := Color.red
match color {
	.red { println('the color was red') }
	.green { println('the color was green') }
	.blue { println('the color was blue') }
}
```

Enums can have methods, just like structs.

```v play
enum Cycle {
	one
	two
	three
}

fn (c Cycle) next() Cycle {
	match c {
		.one {
			return .two
		}
		.two {
			return .three
		}
		.three {
			return .one
		}
	}
}

mut c := Cycle.one
for _ in 0 .. 10 {
	println(c)
	c = c.next()
}
```

Output:

```
one
two
three
one
two
three
one
two
three
one
```

## Bitfield enums

[//]: # (TODO: add a link to the attributes page
Enums can be used as bitfields. To do this, add the `bitfield` [attribute](#attributes) to the definition:

```v
[flag]
enum BitField {
	read
	write
	other
}
```

The maximum number of fields in such an enum depends on the type you use to store the field values.
For example, if you use `u8`, then the maximum number of fields will be 8. The default is `int` so
the maximum number of fields will be 32.

In such an enumeration, the fields will have the following values:

```v
println(BitField.read)  // 1 or 0b0001
println(BitField.write) // 2 or 0b0010
println(BitField.other) // 4 or 0b0100
```

You may notice that the values of the enum fields are doubled.
In binary, this means that each subsequent enumeration field will have a 1 in binary representation
shifted one bit to the left.

Such an enumeration can be used to store multiple values packed into a single number stored in a
single variable.

```v play
[flag]
enum BitField {
    read
    write
    other
}

fn main() {
    mut flags := BitField.read
    flags.set(.write)
    println(flags) // BitField{.read | .write}
    println(int(flags)) // 3 or 0b0011
}
```

Such enums provide convenient methods for setting/removing bits:

- `has()` – checks if a bit is set
- `set()` – sets a bit
- `clear()` – clears a bit
- `toggle()` – toggles a bit
- `all()` – checks if all bits are set

```v play
[flag]
enum BitField {
	read
	write
	other
}

fn main() {
	mut flags := BitField.read
	flags.set(.write)
	println(flags.has(.read)) // true
	println(flags.has(.write)) // true
	println(flags.has(.other)) // false
	flags.clear(.write)
	println(flags.has(.write)) // false
	flags.toggle(.other)
	println(flags.has(.other)) // true
	println(flags.all(.write | .other)) // false
	println(flags.all(.read | .other | .write)) // false
}
```
