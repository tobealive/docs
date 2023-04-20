# Idioms

## Filter a list

```v
odd_numbers := [1, 2, 3, 4].filter(it % 2 == 1)
```

## Check if array contains element

```v failcompile
10 in [1, 2, 3, 4]
```

## Check if a map does not contain a key

```v failcompile
int_to_hex_string := {
	1: '0x1'
	2: '0x2'
}

10 !in int_to_hex_string
```

## String interpolation

```v failcompile
println('Hello, ${name}')
```

## Sum types handling

```v
type StringOrIntOrBool = bool | int | string

fn process(val StringOrIntOrBool) {
	match val {
		string { println('string') }
		int { println('int') }
		else { println('other') }
	}
}
```

## Iterate over a range

```v
for i in 0 .. 10 {}
```

## Iterate over an array

```v failcompile
for index, element in arr {}
// or
for element in arr {}
```

## Error handling

```v nofmt failcompile
fn get() !int { ... }

val := get() or {
	println('Error: ${err}')
	exit(1)
}

println(val)
```

## If unwrapping

```v nofmt failcompile
fn get() !int { ... }

if val := get() {
	println(val)
} else {
	println('Error: ${err}')
	exit(1)
}
```

## If expression

```v failcompile
val := if a == 1 {
	100
} else if a == 2 {
	200
} else {
	300
}
```

## Swap two variables

```v failcompile
a, b = b, a
```

## Get CLI parameters

```v
import os

println(os.args)
```

## Generic function

```v
fn sum[T](a T, b T) T {
	return a + b
}
```

## Embed file

```v failcompile
embedded_file := $embed_file('index.html')
println(embedded_file.to_string())
```

## Runtime reflection

```v okfmt
module main

import v.reflection

fn main() {
	a := 100
	typ := reflection.type_of(a)
	println(typ.name) // int
}
```

## Compile-time reflection

```v okfmt
struct User {
	name string
	age  int
}

fn main() {
	$for field in User.fields {
		$if field.name == 'name' {
			println('found name field')
		}
	}
}
```

## Defer execution

```v nofmt failcompile
fn main() {
	mut f := os.open('log.txt') or { panic(err) }
	defer {
		f.close()
	}

	f.writeln('All ok')
}
```

## Run function in separate thread

```v failcompile
spawn foo()
```
