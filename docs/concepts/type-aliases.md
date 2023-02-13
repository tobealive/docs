# Type aliases

In V type aliases is a special case of a [sum type](./sum-types) declaration.

```v
type MyString = string
```

Type aliases are useful for creating a new name for an existing type.
For example, you can use a type alias to make a `string` type more descriptive:

```v
type RawHtml = string
type SafeHtml = string
```

Like other types, alias types can have methods:

```v
type RawHtml = string
type SafeHtml = string

fn (html RawHtml) escape() SafeHtml {
	// ...
}
```

Alias types inherit all methods of the base type:

```v play
type RawHtml = string

fn main() {
	s := RawHtml('<html><html/>   ')
	println(s.trim(' ')) // <html><html/>
}
```

If the base type is a structure, then all fields are also inherited:

```v play
type RawHtml = string

fn main() {
    s := RawHtml('<html><html/>')
    println(s.len) // 13
}
```

Type aliases are also useful for shortening long type names:

```v
type IDs = GenericMap[string, GenericMap[string, int]]
```
