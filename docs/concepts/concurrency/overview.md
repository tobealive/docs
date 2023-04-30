# Concurrency

The concurrency model in V was heavily inspired by Go.
An important difference at the moment is the fact that there are no coroutines in V, so any
functions run in a separate system thread, which reduces flexibility.

> **Tip**
> Coroutines are planned, but they are not implemented at the moment.

## Spawning Concurrent Tasks

To run a function on a separate thread, use the `spawn` keyword:

```v skip
import math

fn do_smth(a f64, b f64) { // ordinary function without return value
	c := math.sqrt(a * a + b * b)
	println(c)
}

fn main() {
	// do_smth will be run in a separate thread
	spawn do_smth(3, 4)
}
```

You can also use
[anonymous functions](../functions/anonymous-and-higher-order-functions.md):

```v skip
import math

fn main() {
	spawn fn (a f64, b f64) {
		c := math.sqrt(a * a + b * b)
		println(c)
	}(3, 4)
}
```

V also has the `go` keyword, it is reserved for coroutines, currently it works the same as `spawn`
and will be automatically changed to `spawn` when formatted with `vfmt`.

### Waiting for a function to finish

To wait for the completion of a function running in a separate thread, the result of
the `spawn` expression can be assigned to a variable that will act as *handle*.
This handle can be used to wait for the function to complete by calling the `wait()` method:

```v play
import math

fn do_smth(a f64, b f64) {
	c := math.sqrt(a * a + b * b)
	println(c)
}

fn main() {
	h := spawn do_smth(3, 4)

	// do_smth() runs in parallel thread
	h.wait()
	// do_smth() has definitely finished
}
```

Using this approach, you can also get the return value from a function running on a separate thread.

> **Note**
> This will not require changing the signature of the function itself.

```v
import math

fn get_hypot(a f64, b f64) f64 { // ordinary function returning a value
	return math.sqrt(a * a + b * b)
}

fn main() {
	handle := spawn get_hypot(54.06, 2.08) // spawn thread and get handle to it
	h1 := get_hypot(2.32, 16.74) //           do some other calculation here
	h2 := handle.wait() //                    get result from spawned thread
	println('Results: ${h1}, ${h2}') //       Results: 16.9, 54.1
}
```

### Threads array

If there is a large number of tasks, it might be easier to manage them using an array of threads:

```v play
import time

fn task(id int, duration int) {
	println('task ${id} begin')
	time.sleep(duration * time.millisecond)
	println('task ${id} end')
}

fn main() {
	mut threads := []thread{}
	threads << spawn task(1, 500)
	threads << spawn task(2, 900)
	threads << spawn task(3, 100)
	threads.wait()
	println('done')
}

// task 1 begin
// task 2 begin
// task 3 begin
// task 3 end
// task 1 end
// task 2 end
// done
```

Additionally, for threads that return the same type, calling `wait()`
on the thread array will return all computed values.

```v play
fn expensive_computing(i int) int {
	return i * i
}

fn main() {
	mut threads := []thread int{}
	for i in 1 .. 5 {
		threads << spawn expensive_computing(i)
	}
	// Join all tasks
	r := threads.wait()
	println('All jobs finished: ${r}') // All jobs finished: [1, 4, 9, 16]
}
```

## Spawning Threads in `main()`

Consider the following code:

```v play
fn watcher() {
	for {
		println('started')
		break
	}
}

fn main() {
	spawn watcher()
}
```

Here we are running the `watcher()` function in a separate thread, however the problem is
that `main()` will finish before `watcher()` has started, so the program will exit even
though `watcher()` has not finished yet.

To avoid this, use the `wait()` described in the
[previous section](#waiting-for-a-function-to-finish):

```v play
fn watcher() {
	for {
		println('started')
		break
	}
}

fn main() {
	h := spawn watcher()
	h.wait()
}
```

## Change Stack Size

To change the stack size of a thread, use the `spawn_stack` attribute:

```v
// 64KB  stack size
[spawn_stack: 65536]
fn watcher() {
	println('hello')
}
```

## Thread Communication

V uses channels to communicate between threads, they will be discussed in the
[next article](./channels.md).
