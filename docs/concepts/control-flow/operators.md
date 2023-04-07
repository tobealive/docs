# Operators

## `in` operator

`in` allows to check whether an array or a map contains an element.
To do the opposite, use `!in`.

```v play
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
if parser.token == .plus || parser.token == .minus || parser.token == .div {
	// ...
}
if parser.token in [.plus, .minus, .div] {
	// ...
}
```

V optimizes such expressions, so both `if` statements above produce the same machine code and no
arrays are created.

## `is` and `as` operators

See how `is` and `as` operators work for
[Sum types](../sum-types.md#is-and-as-operators), for
[Interfaces](../interfaces.md#casting-an-interface) and for
[Compile-time reflection](../compile-time/reflection.md#type-checking).

## Other operators

See [Operators](../../language-reference/operators.md) for more information about all operators.
