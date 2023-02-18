# Strings

```v nofmt
name := 'Bob'
assert name.len == 3       // will print 3
assert name[0] == u8(66) // indexing gives a byte, u8(66) == `B`
assert name[1..3] == 'ob'  // slicing gives a string 'ob'

// escape codes
windows_newline := '\r\n'      // escape special characters like in C
assert windows_newline.len == 2

// arbitrary bytes can be directly specified using `\x##` notation where `#` is
// a hex digit aardvark_str := '\x61ardvark' assert aardvark_str == 'aardvark'
assert '\xc0'[0] == u8(0xc0)

// or using octal escape `\###` notation where `#` is an octal digit
aardvark_str2 := '\141ardvark'
assert aardvark_str2 == 'aardvark'

// Unicode can be specified directly as `\u####` where # is a hex digit
// and will be converted internally to its UTF-8 representation
star_str := '\u2605' // ★
assert star_str == '★'
assert star_str == '\xe2\x98\x85' // UTF-8 can be specified this way too.
```

In V, a string is a read-only array of bytes. All Unicode characters are encoded using UTF-8:

```v
s := 'hello 🌎' // emoji takes 4 bytes
assert s.len == 10

arr := s.bytes() // convert `string` to `[]u8`
assert arr.len == 10

s2 := arr.bytestr() // convert `[]byte` to `string`
assert s2 == s
```

String values are immutable. You cannot mutate elements:

```v failcompile
mut s := 'hello 🌎'
s[0] = `H`
//   ^ error: cannot assign to s[i] since V strings are immutable
// (note, that variables may be mutable but string values are always immutable, like in Go and Java)
```

Note that indexing a string will produce a `byte`, not a `rune` nor another `string`. Indexes
correspond to _bytes_ in the string, not Unicode code points.
If you want to convert the `byte` to a `string`, use the `.ascii_str()` method on the `byte`:

```v
country := 'Netherlands'
println(country[0]) // 78
println(country[0].ascii_str()) // N
```

Both single and double quotes can be used to denote strings.
For consistency, `vfmt` converts double quotes to single quotes unless the string contains a single quote character.

For raw strings, prepend `r`. Escape handling is not done for raw strings:

```v
s := r'hello\nworld' // the `\n` will be preserved as two characters
println(s) // "hello\nworld"
```

Strings can be easily converted to integers:

```v
s := '42'
n := s.int() // 42

// all int literals are supported
assert '0xc3'.int() == 195
assert '0o10'.int() == 8
assert '0b1111_0000_1010'.int() == 3850
assert '-0b1111_0000_1010'.int() == -3850
```

For more advanced `string` processing and conversions, refer to the
[vlib/strconv](https://modules.vlang.io/strconv.html) module.

## String interpolation

Basic interpolation syntax is pretty simple – use `${` before a variable name and `}` after. The
variable will be converted to a string and embedded into the literal:

```v
name := 'Bob'
println('Hello, ${name}!') // Hello, Bob!
```

It also works with fields: `'age = ${user.age}'`. You may also use more complex expressions:
`'can register = ${user.age > 13}'`.

Format specifiers similar to those in C's `printf()` are also supported. `f`, `g`, `x`, `o`, `b`,
etc. are optional and specify the output format. The compiler takes care of the storage size, so
there is no `hd` or `llu`.

To use a format specifier, follow this pattern:

`${varname:[flags][width][.precision][type]}`

### Flags

Zero or more of the following:

- `-` – left-align output within the field. The default is to right-align.
- `0` – use `0` as the padding character instead of the default `space` character.

> **Note**
> V does not currently support the use of `'` or `#` as format flags, and V supports but
> doesn't need `+` to right-align since that's the default.

### Width

Integer value describing the minimum width of total field to output.

### Precision

Integer value preceded by a `.` will guarantee that many digits after the decimal
point, if the input variable is a float.

Ignored if variable is an integer.

### Type

- `f` and `F` specify the input is a float and should be rendered as such.
- `e` and `E` specify the input is a float and should be rendered as an exponent (partially broken).
- `g` and `G` specify the input is a float--the renderer will use floating point notation for small values and exponent
  notation for large values.
- `d` specifies the input is an integer and should be rendered in base-10 digits.
- `x` and `X` require an integer and will render it as hexadecimal digits.
- `o` requires an integer and will render it as octal digits.
- `b` requires an integer and will render it as binary digits.
- `s` requires a string (almost never used).

> **Note**
> When a numeric type can render alphabetic characters, such as hex strings or special values
> like `infinity`, the lowercase version of the type forces lowercase alphabetics and the
> uppercase version forces uppercase alphabetics.

In most cases, it's best to leave the format type empty. Floats will be rendered by
default as `g`, integers will be rendered by default as `d`, and `s` is almost always redundant.
There are only three cases where specifying a type is recommended:

- format strings are parsed at compile time, so specifying a type can help detect errors then
- format strings default to using lowercase letters for hex digits and the `e` in exponents.
  Use an uppercase type to force the use of uppercase hex digits and an uppercase `E` in exponents.
- format strings are the most convenient way to get hex, binary or octal strings from an integer.

See
[Format Placeholder Specification](https://en.wikipedia.org/wiki/Printf_format_string#Format_placeholder_specification)
for more information.

```v
x := 123.4567
println('[${x:.2}]') // round to two decimal places => [123.46]
println('[${x:10}]') // right-align with spaces on the left => [   123.457]
println('[${int(x):-10}]') // left-align with spaces on the right => [123       ]
println('[${int(x):010}]') // pad with zeros on the left => [0000000123]
println('[${int(x):b}]') // output as binary => [1111011]
println('[${int(x):o}]') // output as octal => [173]
println('[${int(x):X}]') // output as uppercase hex => [7B]

println('[${10.0000:.2}]') // remove insignificant 0s at the end => [10]
println('[${10.0000:.2f}]') // do show the 0s at the end, even though they do not change the number => [10.00]
```

## String operators

```v
name := 'Bob'
bobby := name + 'by' // + is used to concatenate strings
println(bobby) // "Bobby"
mut s := 'hello '
s += 'world' // `+=` is used to append to a string
println(s) // "hello world"
```

All operators in V must have values of the same type on both sides.
You cannot concatenate an integer to a string:

```v failcompile
age := 10
println('age = ' + age)
//      ^^^^^^^^^^^^^^ error: infix expr: cannot use `int` (right expression) as `string`
```

We have to either convert `age` to a `string`:

```v
age := 11
println('age = ' + age.str())
```

or use string interpolation (preferred):

```v
age := 12
println('age = ${age}')
```

See all methods of
[string](https://modules.vlang.io/index.html#string)
and related modules
[strings](https://modules.vlang.io/strings.html),
[strconv](https://modules.vlang.io/strconv.html).
