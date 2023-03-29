# Performance tuning

## Overview

The generated C code is usually fast enough when you compile in
[production mode](../concepts/production-builds.md).
There are some situations, though, where you may want to give additional hints to the compiler,
so that it can further optimize some blocks of code.

> **Note**
> These are *rarely* needed, and should not be used unless you
> *[profile](profiling.md) your code*, and then see that there are significant benefits for them.
> To cite GCC's documentation: "programmers are notoriously bad at predicting
> how their programs actually perform".

### `[inline]`

The `[inline]`
[attribute](../concepts/attributes/known-attributes.md#inline-noinline)
can be added to a function to force the compiler to inline it.
C compiler will try to inline them, which in some cases, may be beneficial for performance,
but may impact the size of your executable.

### `[direct_array_access]`

In functions tagged with `[direct_array_access]` the compiler will translate array operations
directly into C array operations – omitting bound checking.
This may save a lot of time on a function that iterates over an array but at the
cost of making the function unsafe – unless the user will check the boundaries.

### `_likely_` and `_unlikely_`

`if _likely_(bool expression) { ... }` this hints the C compiler that the passed
boolean expression is very likely to be true, so it can generate assembly
code, with less chance of branch misprediction.
In the other backends, that does nothing.

`if _unlikely_(bool expression) { ... }` similar to `_likely_(x)`, but it hints that
the boolean expression is highly improbable.
In the other backends, that does nothing.

## Memory usage optimization

V offers these attributes related to memory usage that can be applied to a structure type:
`[packed]` and `[minify]`.
These attributes affect memory layout of a structure, potentially leading to reduced
cache/memory usage and improved performance.

### `[packed]`

The `[packed]` attribute can be added to a structure to create an unaligned memory layout,
which decreases the overall memory footprint of the structure.

> **Note**
> Using the `[packed]` attribute may negatively impact performance
> or even be prohibited on certain CPU architectures.
> Only use this attribute if minimizing memory usage is crucial for your program
> and you're willing to sacrifice performance.

### `[minify]`

The `[minify]` attribute can be added to a struct, allowing the compiler to reorder the fields
in a way that minimizes internal gaps while maintaining alignment.

> **Note**
> Using the `[minify]` attribute may cause issues with binary serialization or reflection.
> Be mindful of these potential side effects when using this attribute.
