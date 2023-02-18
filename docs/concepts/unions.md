# Unions

Unions are a special data type that, like a structure, describes stored fields,
but unlike a structure, it can store only one of the fields at a time.

The size of a union is equal to the size of the largest field.

To understand what a union is, consider an example:

```v play
union IntOrString {
mut:
	i int
	s string
}

fn main() {
	mut val := IntOrString{}
	val.i = 10
	println(val.i) // 10
	val.s = 'hello'
	println(val.s) // hello
}
```

Unions are specified using the `union` keyword. Fields are set in the same way as in structures.

In this example, we have created a `val` variable of type `IntOrString`.
At the beginning, `val` does not contain any data, so we should explicitly state what we want to store in it.

Since the size of the union is equal to the size of the largest field, in this case, the size of `val` is equal to the
size of `string`, i.e. 16.

In memory, it will look like this:

```text
          IntOrString union
+---------------+  +---------------+
| | | | | | | | |  | | | | | | | | |
+---------------+  +---------------+
      8 bytes           8 bytes
```

After creation, we assign `val.i = 10`. So `val` now stores an integer.

In memory, it would look like this (`x` marks the bytes that store some value):

```text
          IntOrString union
+---------------+  +---------------+
|x|x|x|x| | | | |  | | | | | | | | |
^^^^^^^^^
   10
+---------------+  +---------------+
      8 bytes           8 bytes
```

Now, when we access `val.i`, the compiler accesses memory and interprets its value as an integer.
Thus, we get the value `10`.

Now we assign `val.s = 'hello'`. Now, `x` stores a string, not an integer.
Previously stored data is overwritten with new.

In memory, it will look like this:

```text
          IntOrString union
+---------------+  +---------------+
|x|x|x|x|x|x|x|x|  |x|x|x|x|x|x|x|x|
^^^^^^^^^^^^^^^^^  ^^^^^^^^ ^^^^^^^^
 pointer to data     len    additio-
                            nal info
+---------------+  +---------------+
      8 bytes           8 bytes
```

The first 8 bytes store a pointer to the character array, the first 4 bytes of the
second 8 bytes store the length of the string, and the remaining 4 bytes store additional
information.

Now try replacing `println(val.s)` with `println(val.i)` in the example above and run the example.

You will get `6829482` or some other number in the output.

This happened because the compiler accessed the first 4 bytes of the first 8 bytes and
interpreted them as an integer.

```text
          IntOrString union
+---------------+  +---------------+
|x|x|x|x|x|x|x|x|  |x|x|x|x|x|x|x|x|
^^^^^^^^^^^^^^^^^  ^^^^^^^^ ^^^^^^^^
 pointer to data     len    additio-
                            nal info
^^^^^^^^
  try access to this memory                            
+---------------+  +---------------+
      8 bytes           8 bytes
```

And since a pointer to an array of characters is stored there, the compiler interprets it
as an integer and returns the result.

## Embedding

Just like structs, unions support embedding.

```v play
struct Rgba32_Component {
	r byte
	g byte
	b byte
	a byte
}

union Rgba32 {
	Rgba32_Component
	value u32
}

clr1 := Rgba32{
	value: 0x008811FF
}

clr2 := Rgba32{
	Rgba32_Component: Rgba32_Component{
		a: 128
	}
}

sz := sizeof(Rgba32)
unsafe {
	println('Size: ${sz}B,clr1.b: ${clr1.b},clr2.b: ${clr2.b}')
	// Size: 4B, clr1.b: 136, clr2.b: 0
}
```

Union member access must be performed in an `unsafe` block.

> **Note**
> Embedded struct arguments are not necessarily stored in the order listed.
