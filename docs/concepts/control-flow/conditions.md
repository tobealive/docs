# Conditions

## If expression

`if` expressions are pretty straightforward and similar to most other languages.
Unlike other C-like languages,
there are no parentheses surrounding the condition and the braces are always required.

```v play
a := 10
b := 20
if a < b {
	println('${a} < ${b}')
} else if a > b {
	println('${a} > ${b}')
} else {
	println('${a} == ${b}')
}

// 10 < 20
```

`if` can be used as an expression, last expression is the value of a block:

```v play
num := 777
s := if num % 2 == 0 { 'even' } else { 'odd' }
println(s) // odd
```

If you're using if as an expression, for example, for returning its value or assigning
it to a variable, the else branch is mandatory.

Therefore, there is no ternary operator (`condition ? then : else`) because ordinary `if` works fine
in this role.

### If unwrapping

To handle Result/Optional types, there is a special `if`:

```v play
struct User {
	id   int
	name string
}

fn get_user(id int) !User {
	if id == 1 {
		return User{
			id: 1
			name: 'John'
		}
	}
	return error('user not found')
}

if user := get_user(0) {
	println(user)
} else {
	// err is implicitly declared here and point
	// to the error returned by `get_user()` if any
	println(err)
}

// user not found
```

See [Error handling](../error-handling/overview.md) for more information.

## Match expression

```v play
os := 'windows'
print('V is running on ')

match os {
	'darwin' { println('macOS') }
	'linux' { println('Linux') }
	'windows' { println('Windows') }
	else { println('unknown: ${os}') }
}
```

A `match` statement is a shorter way to write a sequence of `if-else` statements.
When a matching branch is found, the following statement block will be run.
The `else` branch will be run when no other branches match.

```v play
number := 2
str := match number {
	1 { 'one' }
	2 { 'two' }
	else { 'many' }
}
println(str) // two
```

A `match` statement can also to be used as an `if-else if-else` alternative:

```v play
match true {
	2 > 4 { println('if') }
	3 == 4 { println('else if') }
	2 == 2 { println('else if2') }
	else { println('else') }
}
// else if2
```

or as an [`unless`](https://www.tutorialspoint.com/ruby/ruby_if_else.htm) alternative:

```v play
match false {
	2 > 4 { println('if') }
	3 == 4 { println('else if') }
	2 == 2 { println('else if2') }
	else { println('else') }
}
// if
```

A `match` expression returns the value of the final expression from the matching branch.

```v play
enum Color {
	red
	blue
	green
}

fn is_red_or_blue(c Color) bool {
	return match c {
		.red, .blue { true } // comma can be used to test multiple values
		.green { false }
	}
}

println(is_red_or_blue(.red)) // true
println(is_red_or_blue(.green)) // false
```

A `match` statement can also be used to branch on the variants of an `enum`
by using the shorthand `.variant_here` syntax.
An `else` branch is not allowed when all the branches are exhaustive.

```v play
enum Color {
	red
	blue
	green
}

c := Color.red
match c {
	.red { println('red') }
	.blue { println('blue') }
	.green { println('green') }
}
// red
```

You can also use ranges as `match` patterns.
If the value falls within the range of a branch, that branch will be executed.

```v play
c := `v`
typ := match c {
	`0`...`9` { 'digit' }
	`A`...`Z` { 'uppercase' }
	`a`...`z` { 'lowercase' }
	else { 'other' }
}
println(typ)
// lowercase
```

Note that the ranges use `...` (three dots) rather than `..` (two dots).
This is because the range is *inclusive* of the last element, rather than exclusive
(as `..` ranges are).
Using `..` in a `match` branch will throw an error.

Constants can also be used in the range branch expressions.

```v play
const (
	start = 1
    end = 10
)

val := 2
num := match val {
	start...end {
		1000
	}
	else {
		0
	}
}
println(num)
// 1000
```

> **Note**
> `match` as an expression is not usable in `for` loop and `if` statements.
