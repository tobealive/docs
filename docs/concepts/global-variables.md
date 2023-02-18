# Global Variables

By default, V does not allow global variables.
However, for low-level code, it can be useful to have global variables.

For this purpose, you can enable global variables with the compiler flag `-enable-globals`.

Global variables declared with `__global ( ... )`:

```v failcompile
__global (
	sem   sync.Semaphore
	float = 20.0
)
```

An initializer for global variables must be explicitly converted to the desired target type.
If no initializer is given a default initialization is done.

Some objects like semaphores and mutexes require an explicit initialization *in place*, i.e.
not with a value returned from a function call but with a method call by reference.

A separate `init()` function can be used for this purpose – it will be called before `main()`:

```v nofmt globals
import sync

__global (
	sem   sync.Semaphore        // needs initialization in `init()`
	mtx   sync.RwMutex          // needs initialization in `init()`
	f1    = f64(34.0625)        // explicily initialized
	shmap shared map[string]f64 // initialized as empty `shared` map
	f2    f64                   // initialized to `0.0`
)

fn init() {
	sem.init(0)
	mtx.init()
}
```

Be aware that in multithreaded applications the access to global variables is subject
to race conditions.
There are several approaches to deal with these:

- use `shared` types for the variable declarations and use `lock` blocks for access.
  This is most appropriate for larger objects like structs, arrays or maps.

- handle primitive data types as [`atomics`](../concepts/atomics.md) using special C-functions.

- use explicit synchronization primitives like mutexes to control access. The compiler
  cannot really help in this case, so you have to know what you are doing.

- don't care – this approach is possible but makes only sense if the exact values
  of global variables do not really matter. An example can be found in the `rand` module
  where global variables are used to generate (non-cryptographic) pseudo random numbers.
  In this case data races lead to random numbers in different threads becoming somewhat
  correlated, which is acceptable considering the performance penalty that using
  synchronization primitives would represent.
