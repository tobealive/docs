# Shared Objects

In the previous article, we looked at using mutexes to synchronize access to shared data.
V provides syntactic sugar for this using `shared` variables and `lock` and `rlock` blocks.

Under the hood, `shared` variables are structs with an additional hidden mutex that is used to
synchronize data access.

> **Note**
> Shared variables must be structs, arrays, or maps!

Such variables can be passed as arguments to other functions and threads, in which case they need to
be passed as `shared` arguments:

```v play
struct DataModel {
mut:
	data int
}

fn worker(shared model DataModel) {
	//    ^^^^^^ mark the argument as shared
	rlock model {
		// ^^ use rlock, because we only read the data
		println(model.data)
	}
}

fn main() {
	shared model := DataModel{
		data: 10
	}
	h := spawn worker(shared model)
	//                ^^^^^^ pass variable as shared
	h.wait()
}
```

Receivers can also be marked as `shared`:

```v play
struct DataModel {
mut:
	data int
}

fn (shared model DataModel) worker() {
	// ^^^ mark the receiver as shared
	lock model {
		// ^ use lock, because we read and write the data
		model.data = 100
		println(model.data)
	}
}

fn main() {
	shared model := DataModel{
		data: 10
	}
	h := spawn model.worker()
	h.wait()
}
```

## Accessing shared variables data

To access the data of `shared` variables, blocks `lock` for reading/writing and `rlock` for reading
are used.
Outside them, access to data is prohibited.

```v ignore
lock data {
    // read/modify/write data
}

rlock data {
    // read data
}
```
