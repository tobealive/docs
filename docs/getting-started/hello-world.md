# Hello World

```v play
fn main() {
	println('Hello, world!')
}
```

Save this snippet into a file named **hello.v** and run `v run hello.v`.
And that's it, you just wrote and executed your first V program!

> **Tip**
> You can also run the example in the browser using the **Run** button in the top
> right corner of any code snippet.

You can compile a program without execution with `v hello.v`.
It will produce an executable named `hello`.
You can then run it with `./hello`.

See `v help` for all supported commands.

From the example above, you can see that functions are declared with the `fn` keyword.
The return type is specified after the function name.
In this case `main` doesn't return anything, so there is no return type.

As in many other languages (such as C, Go, and Rust), `main` is the entry point of your program.

[`println`](../concepts/builtin-functions.md#eprintln-printing-to-the-console)
is one of the few
[built-in functions](../concepts/builtin-functions.md).
It prints the value passed to it to standard output.

`fn main()` declaration can be skipped in one file programs.
This is useful when writing small programs, "scripts", or just learning the language.
For brevity, `fn main()` will be skipped in this tutorial.

This means that a "hello world" program in V is as simple as:

```v
println('hello world')
```

> **Note**
> If you do not use explicitly `fn main() {}`, you need to make sure, that all your
> declarations, come before any variable assignment statements, or top level function calls,
> since V will consider everything after the first assignment/function call as part of your
> implicit main function.
