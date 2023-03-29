# Known attributes

> **Note**
> This list is not complete yet.
> If you know of an attribute that is not listed here, please
> [open an issue](https://github.com/vlang-foundation/docs/issues/new)
> or
> [create a pull request](https://github.com/vlang-foundation/docs/edit/master/docs/concepts/attributes/known-attributes.md).

## `[deprecated]`

The `[deprecated]` attribute indicates that the definition is deprecated and should not be used in
new code.
If a definition is marked with the `[deprecated]` attribute, the compiler will issue a warning when
it is used.

```v
[deprecated]
fn legacy_function() {
}

legacy_function() // warning: function `legacy_function` has been deprecated
```

The `[deprecated]` attribute has an optional parameter that allows you to specify a message to be
displayed when using the deprecated definition:

```v
[deprecated: 'use new_function() instead']
fn legacy_function() {}

legacy_function() // warning: function `legacy_function`
                  // has been deprecated: use new_function() instead
```

## `[deprecated_after]`

The `[deprecated_after]` attribute allows you to specify a date after which the definition will be
marked as deprecated:

```v
[deprecated: 'use new_function() instead']
[deprecated_after: '2023-05-27']
fn legacy_function() {}
```

## `[unsafe]`

The `[unsafe]` attribute specifies that the function should be called in an `unssafe` block.
Code in the body of such function will still be checked, unless you also wrap it in `unsafe {}`
blocks.
This is useful, when you want to have an `[unsafe]` function that has checks before/after a certain
unsafe operation, that will still benefit from V's safety features.

```v play
[unsafe]
fn risky_business() {
    // code that will be checked, perhaps checking pre conditions
    unsafe {
        // code that *will not be* checked, like pointer arithmetic,
        // accessing union fields, calling other `[unsafe]` fns, etc...
        // Usually, it is a good idea to try minimizing code wrapped
        // in `unsafe {}` as much as possible.
    }
    // code that will be checked, perhaps checking post conditions
}

fn main() {
    unsafe {
        risky_business()
    }
}
```

## `[inline]`, `[noinline]`

The `[inline]` attribute specifies that function calls should be inlined at the call site.
The `[noinline]` attribute, on the other hand, indicates that function calls should not be inlined.

You can learn more about inline functions at
[Wiki page](https://en.wikipedia.org/wiki/Inline_function).

You usually do not need to add them manually, because C compilers are smart enough to figure out
which functions need inline.

## `[noreturn]`

The `[noreturn]` attribute specifies that the function does not return to its callers.
Such functions can be used at the end of `or` blocks, just like `exit(1)` or `panic('message')`.
Such functions cannot have a return type, and must end with either a `for {}` block or a call to
another function with the `[noreturn]` attribute.

```v
[noreturn]
fn forever() {
	for {}
}
```

## `[heap]`

The `[heap]` attribute specifies that the structure should always be allocated on the heap.
See [Structs](../structs/overview.md#always-heap-allocated-structs) for more details.

## `[if debug]`, `[if my_flag ?]`

The `[if debug]` attribute specifies that the definition will only be compiled
if the `-g` flag has been passed.
The `[if my_flag ?]` attribute specifies that the definition will only be compiled
if the `-d my_flag` flag was passed.

```v
[if debug]
fn foo() {
}

fn bar() {
	foo() // will not be called if `-g` is not passed
}
```

## `[keep_args_alive]`

The `[keep_args_alive]` attribute specifies that the memory pointed to by the function arguments
will not be
freed by the garbage collector (if used) until the function returns.
This is useful when a function calls a C function that stores a pointer to the arguments.

```v
[keep_args_alive]
fn C.my_external_function(voidptr, int, voidptr) int
```

## `[manualfree]`

The `[manualfree]` attribute specifies that the function will not automatically free memory
allocated within it.
You will have to deallocate the memory inside the function yourself.

```v
[manualfree]
fn custom_allocations() {
}
```

## `[typedef]`

The `[typedef]` attribute indicates that the structure is defined with `typedef struct` in C.
This is useful when you want to use a structure defined in C in V.

```v
[typedef]
struct C.Foo {
}
```

## `[callconv: "stdcall"]`

The `[callconv: "..."]` attribute indicates that the function should be called with a specific
calling convention.
For example: `stdcall`, `fastcall` and `cdecl`.
This list also applies to alias types.

```v
[callconv: 'stdcall']
fn C.DefWindowProc(hwnd int, msg int, lparam int, wparam int)

[callconv: 'fastcall']
type FastFn = fn (int) bool
```

## `[console]` (Windows only)

Without this attribute, all graphical apps will have the following behavior on Windows:

- If run from a console or terminal, keep the terminal open so all (e)println statements can be
  viewed.
- If run from e.g. Explorer, by double-click an app is opened, but no terminal is opened, and no
  `(e)println` output can be seen.

Use it to force-open a terminal to view output in, even if the app is started from Explorer.

> **Note**
> Valid for `main()` declaration only!
