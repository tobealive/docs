# Numbers

## Literals

### Integer literals

V supports the following kinds of integer literals:

- `123` - decimal numbers
- `0x7B` - hexadecimal numbers
- `0b01111011` - binary numbers
- `0o173` - octal numbers

Literals can use `_` as a delimiter:

```v
million := 1_000_000 // same as 1000000
three := 0b0_11 // same as 0b11
```

> **Note**
> You cannot use more than one delimiter in a row.

### Floating point literals

V supports the following kinds of floating point literals:

- `1.0` - standard notation
- `1.` - notation with zero decimal part
- `.1` - entry with zero integer part
- `1e10` - notation with exponent
    - `1e+10` - positive exponent (by default
    - `1e-10` - negative exponent

As with integer literals, floating point numbers can use `_` as a delimiter:

```v
float_num := 3_122.55 // same as 3122.55
```

### Types of literals

By default, if you don't specify a type explicitly, then literals will be of type `int` or `f64`
depending on whether it is an integer or a float.

```v play
a := 123
println(typeof(a)) // int

b := 3.14
println(typeof(b)) // f64
```

If you want to use a different type, then you can use a casting:

```v play
a := i64(123)
println(typeof(a)) // i64

b := f32(3.14)
println(typeof(b)) // f32
```
