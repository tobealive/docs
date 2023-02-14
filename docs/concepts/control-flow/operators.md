# Operators

## `in` operator

`in` allows to check whether an array or a map contains an element.
To do the opposite, use `!in`.

```v
nums := [1, 2, 3]
println(1 in nums) // true
println(4 !in nums) // true
m := {
	'one': 1
	'two': 2
}
println('one' in m) // true
println('three' !in m) // true
```

It's also useful for writing boolean expressions that are clearer and more compact:

```v
enum Token {
	plus
	minus
	div
	mult
}

struct Parser {
	token Token
}

parser := Parser{}
if parser.token == .plus || parser.token == .minus || parser.token == .div || parser.token == .mult {
	// ...
}
if parser.token in [.plus, .minus, .div, .mult] {
	// ...
}
```

V optimizes such expressions, so both `if` statements above produce the same machine code and no arrays are created.

### `is` and `as` operators

See [Sum types](../sum-types.md#is-and-as-operators).
