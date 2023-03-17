# Runes

## Overview

Many languages have a type like `char` which represents a character, usually ASCII,
since the size of `char` is defined as 1 byte.

V does not have a `char` type as such (the `u8` type can be used instead),
instead V has a `rune` type.

A `rune` represents a single Unicode character and is an alias for `u32`.
To denote them, use <code>`</code> (backticks):

```v
rocket := `🚀`
```

A `rune` can be converted to a UTF-8 string by using the `.str()` method.

```v play
rocket := `🚀`
println(rocket.str()) // 🚀
```

A `rune` can be converted to UTF-8 bytes by using the `.bytes()` method.

```v play
rocket := `🚀`
println(rocket.bytes()) // [240, 159, 154, 128]
```

Hex, Unicode, and Octal escape sequences also work in a `rune` literal:

```v play
println(`\x61`) // a
println(`\141`) // a
println(`\u0061`) // a

// multibyte literals work too
println(`\u2605`) // ★
println(`\u2605`.bytes()) // [226, 152, 133]
println(`\xe2\x98\x85`.bytes()) // [226, 152, 133]
println(`\342\230\205`.bytes()) // [226, 152, 133]
```

Note that `rune` literals use the same escape syntax as strings,
but they can only hold one Unicode character.
Therefore, if your code does not specify a single Unicode character,
you will receive an error at compile time.

Also remember that strings are indexed as bytes, not runes, so beware:

```v play
rocket_string := '🚀'
println(rocket_string[0] != `🚀`) // true
println('aloha!'[0]) // 97
println('aloha!'[0].ascii_str()) // a
```

A string can be converted to runes by the `.runes()` method.

```v play
hello := 'Hello 👋'
hello_runes := hello.runes()
println(hello_runes) // [`H`, `e`, `l`, `l`, `o`, ` `, `👋`]
println(hello_runes.string()) // Hello 👋
```
