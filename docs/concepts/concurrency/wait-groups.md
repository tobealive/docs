# WaitGroups

`WaitGroup` are used to wait for multiple threads to complete.

The `sync.new_waitgroup()` function is used to create a `WaitGroup` instance.

Let us look at an example of using `WaitGroup`:

```v play
import time
import sync

fn worker(id int) {
	println('Worker ${id} starting')
	time.sleep(time.second)
	println('Worker ${id} done')
}

fn main() {
	mut wg := sync.new_waitgroup()

	for i in 0 .. 5 {
		wg.add(1)

		spawn fn [mut wg, i] () {
			defer {
				wg.done()
			}
			worker(i)
		}()
	}

	wg.wait()
}
```

Here we start 5 threads, each of which makes some kind of payload in the form of a call to
the `worker()` function.

We call `wg.wait()` to wait for all threads to finish.
This call will block the current thread until all threads have completed.
This will happen when `wg.done()` is called for every call to `wg.add(1)`.

In the example above, we call `wg.add(1)` 5 times in a loop, which means we are waiting for 5
threads to complete.

When the `worker()` function ends, we call `wg.done()` to tell `WaitGroup` that the thread has
ended.

> **Note**
> If we call `wg.done()` more times than `wg.add(1)`, then the program will panic.

> **Note**
> If we call `wg.done()` fewer times than `wg.add(1)`, then the program will hang forever.
