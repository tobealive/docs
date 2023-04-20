# V and C

## Including C code

You can include C code directly in your V module.
For example, let's say that your C code is located in a folder named **'c'** inside your module
folder.
Then:

- Put a **v.mod** file inside the top-level folder of your module (if you
  created your module with `v new` you already have **v.mod** file).
  For example:

```vmod ignore
Module {
	name: 'mymodule',
	description: 'My nice module wraps a simple C library.',
	version: '0.0.1'
	dependencies: []
}
```

- Add these lines to the top of your module:

```v oksyntax
#flag -I @VMODROOT/c
#flag @VMODROOT/c/implementation.o
#include "header.h"
```

> **Note**
> `@VMODROOT` will be replaced by V with the *nearest parent folder,
> where there is a **v.mod** file*.
> Any **.v** file beside or below the folder where the **v.mod** file is,
> can use `#flag @VMODROOT/abc` to refer to this folder.
> The `@VMODROOT` folder is also *prepended* to the module lookup path, so
> you can *import* other modules under your `@VMODROOT`, by just naming them.

The instructions above will make V look for a compiled **.o** file in
your module **folder/c/implementation.o**.
If V finds it, the **.o** file will get linked to the main executable, that used the module.
If it does not find it, V assumes that there is a `@VMODROOT/c/implementation.c` file,
and tries to compile it to a **.o** file, then will use that.

This allows you to have C code that is contained in a V module, so that its distribution is easier.
You can see a complete minimal example for using C code in a V wrapper module here:
[project_with_c_code](https://github.com/vlang/v/tree/master/vlib/v/tests/project_with_c_code).
Another example, demonstrating passing structs from C to V and back again:
[interoperate between C to V to C](https://github.com/vlang/v/tree/master/vlib/v/tests/project_with_c_code_2).

## Passing C compilation flags

Add `#flag` directives to the top of your V files to provide C compilation flags like:

- `-I` for adding C include file search paths
- `-l` for adding C library names that you want to get linked
- `-L` for adding C library files search paths
- `-D` for setting compile time variables

You can use different flags for different targets.
Currently the `linux`, `darwin` , `freebsd`, and `windows` flags are supported.

> **Note**
> Each flag must go on its own line (for now)

```v skip
#flag linux -lsdl2
#flag linux -Ivig
#flag linux -DCIMGUI_DEFINE_ENUMS_AND_STRUCTS=1
#flag linux -DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1
#flag linux -DIMGUI_IMPL_API=
```

In the console build command, you can use:

- `-cc` to change the default C backend compiler.
- `-cflags` to pass custom flags to the backend C compiler (passed before other C options).
- `-ldflags` to pass custom flags to the backend C linker (passed after every other C option).

For example:

```bash
v -cc gcc-9 -cflags -fsanitize=thread .
```

You can define a `VFLAGS` environment variable in your terminal to store your `-cc`
and `-cflags` settings, rather than including them in the build command each time.

## #pkgconfig

Add `#pkgconfig` directive is used to tell the compiler which modules should be used for compiling
and linking using the pkg-config files provided by the respective dependencies.

As long as backticks can't be used in `#flag` and spawning processes is not desirable for security
and portability reasons, V uses its own pkgconfig library that is compatible with the standard
freedesktop one.

If no flags are passed it will add `--cflags` and `--libs` to pkgconfig (not to V).
In other words, both lines below do the same:

```v oksyntax
#pkgconfig r_core
#pkgconfig --cflags --libs r_core
```

The `.pc` files are looked up into a hardcoded list of default pkg-config paths, the user can add
extra paths by using the `PKG_CONFIG_PATH` environment variable. Multiple modules can be passed.

To check the existence of a pkg-config use `$pkgconfig('pkg')` as a compile time "if" condition to
check if a pkg-config exists.
If it exists, the branch will be created.
Use `$else` or `$else $if`to handle other cases.

```v ignore
$if $pkgconfig('mysqlclient') {
	#pkgconfig mysqlclient
} $else $if $pkgconfig('mariadb') {
	#pkgconfig mariadb
}
```

## C types

Ordinary zero terminated C strings can be converted to V strings with

```v failcompile
unsafe { &char(cstring).vstring() }
```

or if you know their length already with:

```v failcompile
unsafe { &char(cstring).vstring_with_len(len) }
```

> **Note**
> The `.vstring()` and `.vstring_with_len()` methods do NOT create a copy of the `cstring`,
> so you should NOT free it after calling the method `.vstring()`.
> If you need to make a copy of the C string (some libc APIs like `getenv` pretty much require that,
> since they return pointers to internal libc memory), you can use `cstring_to_vstring(cstring)`.

On Windows, C APIs often return so called `wide` strings (utf16 encoding).
These can be converted to V strings with

```v failcompile
string_from_wide(&u16(cwidestring))
```

V has these types for easier interoperability with C:

- `voidptr` for C's `void*`
- `&byte` for C's `byte*`
- `&char` for C's `char*`
- `&&char` for C's `char**`

To cast a `voidptr` to a V reference, use:

```v failcompile
user := unsafe { &User(user_void_ptr) }
```

`voidptr` can also be dereferences into a V struct through casting:

```v failcompile
user := unsafe { User(user_void_ptr) }
```

See
[Example of a module that calls C code from V](https://github.com/vlang/v/blob/master/vlib/v/tests/project_with_c_code/mod1/wrapper.v)
for a complete example.

## C Declarations

C identifiers are accessed with the `C` prefix similarly to how module-specific identifiers are
accessed.
Functions must be redeclared in V before they can be used.
Any C types may be used behind the `C` prefix, but types must be redeclared in V in
order to access type members.

To redeclare complex types, such as in the following C code:

```c
struct SomeCStruct {
	uint8_t implTraits;
	uint16_t memPoolData;
	union {
		struct {
			void* data;
			size_t size;
		};

		DataView view;
	};
};
```

Members of sub-data-structures may be directly declared in the containing struct as below:

```v
struct C.SomeCStruct {
	implTraits  byte
	memPoolData u16
	// These members are part of sub data structures that can't
	// currently be represented in V.
	// Declaring them directly like this is sufficient for access.
	// union {
	// struct {
	data voidptr
	size usize
	// }
	view C.DataView
	// }
}
```

The existence of the data members is made known to V, and they may be used without
re-creating the original structure exactly.

Alternatively, you may [embed](../concepts/structs/embedding.md) the sub-data-structures to maintain
a parallel code structure.

## Export to shared library

By default, all V functions have the following naming scheme in C: `[module name]__[fn_name]`.

For example, `fn foo() {}` in module `bar` will result in `bar__foo()`.

To use a custom export name, use the `[export]` attribute:

```v
[export: 'my_custom_c_name']
fn foo() {
}
```

## Translating C to V

V can translate your C code to human-readable V code, and generate V wrappers
on top of C libraries.

[C2V](https://github.com/vlang/c2v)
currently uses Clang's AST to generate V, so to translate a C file to V,
you need to have Clang installed on your machine.

Let's create a simple program **test.c** first:

```c
#include "stdio.h"

int main() {
	for (int i = 0; i < 10; i++) {
		printf("hello world\n");
	}
	return 0;
}
```

Run `v translate test.c`, and V will generate **test.v**:

```v
fn main() {
	for i := 0; i < 10; i++ {
		println('hello world')
	}
}
```

To generate a wrapper on top of a C library use `translate wrapper` command:

```bash
v translate wrapper c_code/libsodium/src/libsodium
```

This will generate a directory `libsodium` with a V module.

See [libsodium wrapper](https://github.com/vlang/libsodium) generated with C2V.

## When should you translate C code and when should you simply call C code from V?

If you have well-written, well-tested C code, then of course you can always simply call this C code
from V.

Translating it to V gives you several advantages:

- If you plan to develop that code base, you now have everything in one language,
  which is much safer and easier to develop in than C.
- Cross-compilation becomes a lot easier. You don't have to worry about it at all.
- No more build flags and include files either.

## Calling V from C

Since V can compile to C, calling V code from C is very easy, once you know how.

Use `v -o file.c your_file.v` to generate a C file, corresponding to the V code.

See
[Call V from C Example](https://github.com/vlang/v/tree/master/examples/call_v_from_c)
for a complete example.
