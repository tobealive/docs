# Constants

In V, in addition to variables, you can also create constants.
Such constants can only be declared outside functions in the global scope.

Constants are declared with `const`:

```v
const pi = 3.14
```

Multiple constants can be declared in one block:

```v skip
const (
	pi = 3.14
	e  = 2.71828
)
```

The type of constant is automatically inferred from its value.
Constant names must be in `snake_case`.
Constant values can never be changed.

V constants are more flexible than in most languages.
You can assign more complex values:

```v play
struct Color {
	r int
	g int
	b int
}

fn rgb(r int, g int, b int) Color {
	return Color{
		r: r
		g: g
		b: b
	}
}

const (
	numbers = [1, 2, 3]
	red = Color{
		r: 255
		g: 0
		b: 0
	}
	// evaluate function call at program start-up
	blue = rgb(0, 0, 255)
)

println(numbers)
println(red)
println(blue)
```

Function calls in constants will be evaluated during program startup.

## Constants inside modules

Like
[other declarations](../concepts/modules/overview.md#symbol-visibility),
constants can be declared public using the `pub` keyword:

```v oksyntax
module mymodule

pub const golden_ratio = 1.61803

fn calc() {
	println(mymodule.golden_ratio)
}
```

The `pub` keyword is only allowed before the `const` keyword and cannot be used inside
a `const ( ... )` block.

## Required module prefix

Outside from `main` module all constants need to be prefixed with the module name.

In order to distinguish constants from local variables, the full path to constants must be
specified.

For example, to access the `pi` constant, full `math.pi` name must be used both outside the `math`
module, and inside it.
That restriction is relaxed only for the `main` module (the one containing your `fn main()`),
where you can use the unqualified name of constants defined there, i.e. `numbers`, rather
than `main.numbers`.

[vfmt](../tools/builtin-tools.md#v-fmt) takes care of this rule, so you can type `println(pi)`
inside the `math` module, and vfmt will automatically update it to `println(math.pi)`.
