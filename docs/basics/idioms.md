# Idioms

## Filter a list

```v
odd_numbers := [1, 2, 3, 4].filter(it % 2 == 1)
```

## Check if array contains element

```v
10 in [1, 2, 3, 4]
```

## Check if a map does not contain a key

```v
int_to_hex_string := {
	1: '0x1'
	2: '0x2'
}

10 !in int_to_hex_string
```

## String interpolation

```v
println("Hello, ${name}")
```

## Sym types handling

```v
type StringOrIntOrBool = string | int | bool

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

```v
for index, element in arr {}
// or
for element in arr {}
```

## Error handling

```v
fn get() !int { ... }

val := get() or {
	println('Error: ${err}')
	exit(1)
}

println(val)
```

## If unwrapping

```v
fn get() !int { ... }

if val := get() {
	println(val)
} else {
	println('Error: ${err}')
	exit(1)
}
```

## If expression

```v
val := if a == 1 {
	100
} else if a == 2 {
	200
} else {
	300
}
```

## Swap two variables

```v
a, b = b, a
```

## Generic function

```v
fn sum[T](a T, b T) T {
	return a + b
}
```

## Embed file

```v
embedded_file := $embed_file('index.html')
println(embedded_file.to_string())
```

## Compile-time reflection

```v
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

```v
fn main() {
	mut f := os.open('log.txt') or { panic(err) }
	defer {
		f.close()
	}

	f.writeln('All ok')
}
```

## Run function in separate thread

```v
spawn foo()
```
