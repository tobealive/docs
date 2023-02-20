# Zero values

Zero values are used when no value is provided.
For example, when a struct field is not initialized, it will have a Zero value.

The following table shows Zero values for each type:

| Type                          | Zero value          |
|-------------------------------|---------------------|
| `bool`                        | `false`             |
| `string`                      | `''` (empty string) |
| `int` and other integer types | `0`                 |
| `float` and other float types | `0.0`               |
| `rune`                        | `0`                 |
| `voidptr`                     | `0`                 |
| `array`                       | `[]`                |
| `map`                         | `{}`                |
| `struct`                      | `StructName{}`      |
| `enum`                        | First enum value    |
