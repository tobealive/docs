# Printing custom types

You can define custom output for your types.
To do this, it is enough to define a `str()` method that returns a string.

```v play
struct Color {
	r int
	g int
	b int
}

pub fn (c Color) str() string {
	return '{${c.r}, ${c.g}, ${c.b}}'
}

red := Color{
	r: 255
	g: 0
	b: 0
}
println(red) // {255, 0, 0}
```

The `str()` method is implicitly defined for all types, the code above overrides it for the `Color`
structure.

You can override it for any type, even arrays, maps, or sum types:

```v play
struct Color {
	r int
	g int
	b int
}

pub fn (c Color) str() string {
	return '{${c.r}, ${c.g}, ${c.b}}'
}

pub fn (colors []Color) str() string {
	return colors.map(it.str()).join('; ')
}

colors := [Color{
	r: 255
	g: 0
	b: 0
}, Color{
	r: 0
	g: 255
	b: 0
}]
println(colors) // {255, 0, 0}; {0, 255, 0}
```
