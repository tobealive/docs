# Compile-time reflection

V provides compile time reflection to get information about data types and structures at compile time.
With its help, you can, for example, make your own efficient serializer for any data format that will
be generated during compilation.

## Fields

Each
[structure](../structs/main.md)
or
[union](../unions.md)
has a `fields` field that contains information about the fields of the structure:

```v play
struct User {
	name string
	age  int
}

fn main() {
	$for field in User.fields {
		println(field.name)
	}
	// name
	// age
}
```

The `fields` field is of type `[]FieldData`.
You can see what fields this type has in
[compiler source code](https://github.com/vlang/v/blob/master/vlib/builtin/builtin.v#L111).
For example, `FieldData` has a `typ` field that contains the type of the field.

## Methods

Each type has a `methods` field, which contains information about the methods of type.
This field is of type `[]FunctionData`.
You can see what fields this type has in
[compiler source](https://github.com/vlang/v/blob/b6ecd634e3174d657c60a061ad74d31705f12f5f/vlib/builtin/builtin.v#L101).

```v play
struct App {}

fn (mut app App) method_one() {}

fn (mut app App) method_two() int {
	return 0
}

fn (mut app App) method_three(s string) string {
	return s
}

fn main() {
	$for method in App.methods {
		$if method.typ is fn (string) string {
			println('${method.name} IS `fn(string) string`')
		} $else {
			println('${method.name} is NOT `fn(string) string`')
		}
		
		$if method.return_type !is int {
			println('${method.name} does NOT return `int`')
		} $else {
			println('${method.name} DOES return `int`')
		}
		
		$if method.args[0].typ !is string {
			println("${method.name}'s first arg is NOT `string`")
		} $else {
			println("${method.name}'s first arg IS `string`")
		}

		$if method.typ is fn () {
			println('${method.name} IS a void method')
		} $else {
			println('${method.name} is NOT a void method')
		}
		println('')
	}
}
```

## Attributes

Each type has an `attributes` field, which contains information about the attributes of the type.
This field is of type `[]StructAttribute`.
You can see what fields this type has in
[compiler source](https://github.com/vlang/v/blob/b6ecd634e3174d657c60a061ad74d31705f12f5f/vlib/builtin/builtin.v#L142).

```v play
[name: "user"]
union User {
	name string
	age  int
}

fn main() {
	$for attr in User.attributes {
		println("'${attr.name}' with value '${attr.arg}'")
	}
	// 'name' with value 'user'
}
```

## Types checking

The types stored in the `typ` field in `FieldData` and `FunctionData` can be compared using the `is` operator:

```v failcompile
$if method.typ is fn (string) string {
	println('${method.name} IS `fn(string) string`')
}

$if field is string {
	println('${field.name} is of type string')
}
```

As with normal `if` expressions, you can use the `in` statement:

```v failcompile
$if field.typ in [string, int] {
	println('${field.name} is of type int or float')
}
```

For convenience of checks, V defines some type constants:

- `$Int` - any integer type
- `$Float` - any floating point type
- `$Array` - any array
- `$Map` - any map
- `$Struct` - any structure
- `$Interface` - any interface
- `$Enum` – any enum
- `$Alias` - any alias type
- `$Sumtype` – any summary type
- `$Funtion` - any function

```v failcompile
$if field.typ is $Int {
	println('${field.name} is of type int')
}

$if field.typ is $Enum {
	println('${field.name} is Enum')
}
```
