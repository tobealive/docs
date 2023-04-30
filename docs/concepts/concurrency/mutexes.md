# Mutexes

Channels work great for communication between threads.
But what if we just want to synchronize access to a shared resource?

This concept is called mutual exclusion, and the conventional name for the data structure that
provides it is mutex.

Mutex allows you to restrict access to a shared resource from other threads.
When one thread acquires a mutex, if another thread tries to acquire the same mutex, the thread will
be blocked until the mutex is released.
Thus, only one thread at a time can access the shared resource.

The V standard library provides two types of mutexes: `sync.Mutex` and `sync.RwMutex`.

Use the `@lock()` method to acquire the mutex and `unlock()` to release it.

> **Note**
> `lock` is a keyword in V, so the method is named `@lock` instead of `lock`.

To automatically release the mutex, it is convenient to use `defer`, in which case the mutex will be
released automatically when the function exits:

```v ignore
m.@lock()
defer {
    m.unlock()
}
```

Let us look at an example of using a mutex:

```v play
import sync
import time

struct SafeCounter {
mut:
	mt sync.Mutex
pub mut:
	value map[string]int
}

fn (mut c SafeCounter) inc(key string) {
	c.mt.@lock() // acquire the mutex
	defer {
		c.mt.unlock() // automatically release the mutex
	}
	c.value[key]++ // this code is executed only by one thread at a time
}

fn (mut c SafeCounter) value(key string) int {
	c.mt.@lock() // acquire the mutex
	defer {
		c.mt.unlock() // automatically release the mutex
	}
	return c.value[key] // this code is executed only by one thread at a time
}

fn main() {
	mut counter := &SafeCounter{
		mt: sync.new_mutex() // create a new mutex
	}

	for i := 0; i < 5; i++ {
		spawn fn [mut counter] () {
			for j := 0; j < 100; j++ {
				counter.inc('key')
			}
		}()
	}

	time.sleep(1 * time.second)
	println(counter.value('key'))
}
```

In this example, the `inc()` method of the `SafeCounter` structure is called from different threads
at the same time.
But thanks to the mutex, only one thread can acquire the mutex and execute the code inside
the `inc()` method.
Other threads will be blocked until the mutex is released.

## `sync.RwMutex`

`sync.RwMutex` provides more flexible synchronization by allowing you to acquire a mutex for reading
or writing.
Thus, if the mutex is acquired for writing, other threads will not be able to acquire the mutex
for writing, but they will be able to acquire the mutex for reading.
And vice versa, if the mutex is acquired for reading, other threads will be able to acquire the
mutex only for writing.

> **Note**
> The developer himself controls that when the mutex is captured for reading, the code does not
> write to the shared resource!

To lock a mutex for reading use the `@rlock()` method, and to lock a mutex for writing use
the `@lock()`method.
