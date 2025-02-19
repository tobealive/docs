# Memory-unsafe code

Sometimes for efficiency, you may want to write low-level code that can potentially
corrupt memory or be vulnerable to security exploits.
V supports writing such code, but not by default.

V requires that any potentially memory-unsafe operations are marked intentionally.
Marking them also indicates to anyone reading the code that there could be
memory-safety violations if there was a mistake.

Examples of potentially memory-unsafe operations are:

- Pointer arithmetic
- Pointer indexing
- Conversion to a pointer from an incompatible type
- Calling certain C functions, e.g. `free`, `strlen` and `strncmp`.

To mark potentially memory-unsafe operations, enclose them in an `unsafe` block:

```v play
// allocate 2 uninitialized bytes & return a reference to them
mut p := unsafe { malloc(3) }
p[0] = `h` // warning: pointer indexing is only allowed in `unsafe` blocks

unsafe {
	p[0] = `h` // ok
	p[1] = `e`
	p[2] = `l`
}
p++
// warning: pointer arithmetic is only allowed in `unsafe` blocks

unsafe {
	p++ // ok
}
println((*p).ascii_str()) // l
```

Best practice is to avoid putting memory-safe expressions inside an `unsafe` block,
so that the reason for using `unsafe` is as clear as possible.
Generally any code you think is memory-safe should not be inside an `unsafe` block,
so the compiler can verify it.

If you suspect your program does violate memory-safety, you have a head start on
finding the cause: look at the `unsafe` blocks (and how they interact with
surrounding code).
