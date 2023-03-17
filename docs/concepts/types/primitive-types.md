# Primitive types

## Overview

V supports a wide range of primitive types.
Below is a list of all supported primitive types:

```v ignore
bool

string

i8    i16  int  i64      i128 (soon)
u8    u16  u32  u64      u128 (soon)

rune // represents a Unicode code point

f32 f64

isize, usize // platform-dependent,
             // the size is how many bytes it takes
             // to reference any location in memory

voidptr // this one is mostly used for C interoperability

any // similar to C's void* and Go's interface{}
```

> **Note**
> Unlike C and Go, `int` is always a 32-bit integer.

## Promotions

There is an exception to the rule that all operators in V must have values of the
same type on both sides.
A small primitive type on one side can be automatically promoted if it fits completely
into the data range of the type on the other side.

These are the allowed possibilities:

```v ignore
   i8 – i16 – int – i64
                  ↘     ↘
                    f32 – f64
                  ↗     ↗
   u8 – u16 – u32 – u64 ⬎
      ↘     ↘     ↘      ptr
   i8 – i16 – int – i64 ⬏
```

An `int` value for example can be automatically promoted to `f64`
or `i64` but not to `u32` (`u32` would mean loss of the sign for
negative values).
Promotion from `int` to `f32`, however, is currently done automatically
(but can lead to precision loss for large values).

Literals like `123` or `4.56` are treated in a special way. They do
not lead to type promotions, however they default to `int` and `f64`
respectively, when their type has to be decided:

```v nofmt
u := u16(12)
v := 13 + u    // v is of type `u16` – no promotion
x := f32(45.6)
y := x + 3.14  // x is of type `f32` – no promotion
a := 75        // a is of type `int` – default for int literal
b := 14.7      // b is of type `f64` – default for float literal
c := u + a     // c is of type `int` – automatic promotion of `u`'s value
d := b + x     // d is of type `f64` – automatic promotion of `x`'s value
```
