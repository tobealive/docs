# Maps

## Overview

Like many other modern languages, V has built-in support for
maps (sometimes called hashes or dicts in other languages).
Map is an [associative data type](https://en.wikipedia.org/wiki/Associative_array)
that stores key-value pairs.

Currently, maps can have keys of type `string`, `rune`, integers, floats, enums or `voidptr`.

Maps are ordered by insertion, like dictionaries in Python.
The order is a guaranteed language feature.
This may change in the future.

See all methods of
[`map`](https://modules.vosca.dev/standard_library/builtin.html#map) struct
and
[`maps`](https://modules.vosca.dev/standard_library/maps.html) module.

## Map Initialization

There are two syntaxes for creating a map.

The first one is used to create an empty map:

```v failcompile
// map with keys of type `string` and values of type `int`
m := map[string]int{}
// map with keys of type `string` and values of type `Foo`
m2 := map[string]Foo{}
```

The square brackets indicate the type of the key, followed by the type of the value.

The second syntax is used to create a map with initial values:

```v
m := {
	'one': 1
	'two': 2
}
```

V automatically infers the type of the key and value, in the example above the map will be of
type `map[string]int`.

## Add elements to a map

To add an element to the map, use the expression `map[key] = value`:

```v play
mut m := map[string]int{}
m['one'] = 1
m['two'] = 2
println(m) // {'one': 1, 'two': 2}
```

If the map already contains an element with that key, then the value will be overwritten.

> **Note**
> To add a new element, the `m` variable must be declared with the `mut` modifier.

## Delete elements from a map

To delete an element from a map, use the `map.delete()` method:

```v play
mut m := {
    'one': 1
    'two': 2
}
m.delete('one')
println(m) // {'two': 2}
```

> **Note**
> To delete an element, the `m` variable must be declared with the `mut` modifier.

## Get element from a map by key

To get an element from a map, use the `map[key]` expression:

```v play
m := {
    'one': 1
    'two': 2
}
println(m['one']) // 1
```

If the key is not found, it will return
[Zero-value](./zero-values.md)
for a value type:

```v play
m := {
    'one': 1
    'two': 2
}
println(m['bad_key']) // 0
```

To return a different value if the key is not found, or to add custom handling for this case,
use the `or` block:

```v play
m := {
    'one': 1
    'two': 2
}
println(m['bad_key'] or { 100 }) // 100
```

`or` block, as in the case of
[handling Result/Option types](../error-handling/overview.md#or-blocks),
can contain several statements:

```v play
m := {
    'one': 1
    'two': 2
}
println(m['bad_key'] or {
    println('key not found')
    100
})
// key not found
// 100
```

You can also check that a key is present in the map, and get its value if found, in a single
expression using `if` unwrapping:

```v play
m := {
    'abc': 'def'
}
if v := m['abc'] {
    println('the map value for that key is: ${v}')
}
```

## Check if a key exists in a map

To check if a key exists in a map, use the `key in map` expression:

```v play
m := {
    'one': 1
    'two': 2
}
println('one' in m) // true
println('three' in m) // false
```

`!in` can be used to check for the absence of a key in a map:

```v play
m := {
    'one': 1
    'two': 2
}
println('one' !in m) // false
println('three' !in m) // true
```

## Get all keys from a map

To get all the keys from the map, use the `map.keys()` method:

```v play
m := {
    'one': 1
    'two': 2
}
println(m.keys()) // ['one', 'two']
```

## Get all values from a map

To get all values from a map, use the `map.values()` method:

```v play
m := {
    'one': 1
    'two': 2
}
println(m.values()) // [1, 2]
```

## Check if a value exists in a map

To check if a value is in a map, you can use a combination of `map.keys()` and the `in` operator:

```v play
m := {
    'one': 1
    'two': 2
}
println(1 in m.values()) // true
println(3 in m.values()) // false
```

> **Note**
> Unlike the operation of checking the presence of a key in the map, this operation
> requires a complete enumeration of all map values and has O(n) complexity.

## Assigning one map to another

In V, you can't just assign the value of a map variable to another variable:

```v nofmt failcompile play
m := {
	'one': 1
	'two': 2
}
m2 := m // error: cannot copy map:
        // call `move` or `clone` method (or use a reference)
println(m2)
```

There are three ways to solve this problem:

### Save a reference to the map in a variable

```v play
mut m := {
    'one': 1
    'two': 2
}
mut m2 := &m
println(m2) // &{'one': 1, 'two': 2}

m2['three'] = 3
println(m2) // &{'one': 1, 'two': 2, 'three': 3}
println(m) // {'one': 1, 'two': 2, 'three': 3}
```

See [References](./references.md) article for more information about how to use references.

> **Note**
> In this case the `m2` variable will refer to the same map as `m`, so changes in one map will be
> visible in the other.

### Use the `clone()` method

```v play
m := {
    'one': 1
    'two': 2
}
m2 := m.clone()
println(m2) // {'one': 1, 'two': 2}
println(m) // {'one': 1, 'two': 2}
```

This method creates a copy of the map, so changes in one map will not be visible in another.

### Use the `move()` method

```v play
mut m := {
    'one': 1
    'two': 2
}
m2 := m.move()
println(m2) // {'one': 1, 'two': 2}
println(m) // {}
```

This method moves the map's internal data to a new map, thus not copying all the data, but moving
internal data pointers.
This is much more efficient than cloning the map, but after calling `move()` the `m` variable will
be an empty map.

> **Note**
> Only mutable maps can be moved.
