# FAQ

## Why create V when there are already so many languages? Why not use Go, Rust, C++, Python, etc?

See [detailed comparison](https://vlang.io/compare) of V and other languages.

## What language is V written in?

V.
The compiler can compile itself.
The original version was written in Go.

## Does V use LLVM?

No.
V uses C as its main backend and will compile directly to machine code by the time of the 1.0
release.

See
[benefits of using C](https://github.com/vlang/v/discussions/7849)
as a language backend.

## What about optimization?

For now, V emits C and uses GCC/Clang for optimized
[production builds](../concepts/production-builds.md).
This way you get access to sophisticated optimization.

## Is there garbage collection?

Yes, by default V uses a GC.
You can disable it and manage memory manually with `-gc none` or use an experimental autofree
via `-autofree`.

See [memory management](../concepts/memory-management.md) article for more details.

## Is there a package manager?

Yes!
V is a very modular language and encourages the creation of modules that are easy to reuse.

The page for modules right now is [vpm.vlang.io](https://vpm.vlang.io/).
Submitting your V module takes a couple of seconds.
Installing modules is as easy as `v install sqlite`

See [package management](../concepts/package-management.md) article to learn more about V's
package management.

## What about concurrency?

To run `foo()` concurrently, just call it with `spawn`, like `spawn foo()`.
Right now it launches the function in a new system thread.

Coroutines and the scheduler will be implemented in the future, and writing a concurrency
code in V is going to be the same as in Go — with a `go` keyword, like `go foo()`.

See [concurrency](../concepts/concurrency.md) article for more details.

## Does V run on bare metal?

There is a `-freestanding` option that excludes libc and vlib, but it is a work in progress and is
not the focus of development right now.

## Will I be able to use a custom allocator?

Yes, but not for now.
This hasn't been implemented yet.

## Is V going to change a lot?

No, V will always stay a small and simple language.

See [note](https://github.com/vlang/v/blob/master/README.md#stability-guarantee-and-future-changes)
about a stability guarantee and future changes.

## What operating systems are supported?

Windows, macOS, Linux, FreeBSD, OpenBSD, NetBSD, DragonflyBSD, Solaris, Android (Termux).

## Who's behind V?

600+ open source [contributors](https://github.com/vlang/v/graphs/contributors).

## Can I use C libs in V?

Yes.
V works with libraries written in C without overhead.
You can find out more in the article [V and C](../advanced-concepts/v-and-c.md).

We also have [C2V](https://github.com/vlang/c2v) tool to translate C code to V.
Please note that this is currently in alpha.

## What about editor support?

See [editor plugins](../tools/editor_plugins/overview.md) page.

## Why "V"?

Initially, the language had the same name as the product it was created for Volt.
The extension was ".v", Alex didn't want to mess up git history, so he decided to name it V.

> **Note**
> The ".v" extension clashes with (at least) two other known file formats: "Verilog" and "Coq"
> languages.
> This is actually unfortunate, but so is life sometimes... V language will not change its
> extension.

It is a simple name that reflects the simplicity of the language, and it's easy to pronounce for
everyone in the world.

Please note that the name of the language is "V", not "Vlang" or "V-Lang" etc.
The name is not very searchable (like Go), so use #vlang on Twitter, vlang on Google, etc.

## Any plans to implement macros?

No, macros can be really useful, but they complicate the code significantly.
Every company, team, and developer can extend the language, and it is no longer possible to jump
into a new codebase and immediately understand what's going on.

V will have sophisticated code generation.

## Under which license is V published?

MIT.
