# Symbol visibility

```v
pub fn public_function() {
}

fn private_function() {
}
```

Functions are private (not exported) by default.
To allow other [modules](#module-imports) to use them, prepend `pub`. The same applies
to [structs](#structs), [constants](#constants) and [types](#type-declarations).

> **Note**
> `pub` can only be used from a named module.
> For information about creating a module, see [Modules](#modules).
