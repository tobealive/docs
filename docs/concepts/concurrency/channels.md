# Channels

Channels in V are very similar to channels in Go.
They are the preferred way to communicate between threads.

Channels are a typed conduit through which you can send and receive values with
the channel (`<-`) operator.

## Creating a channel

To create a channel of the desired type, use `chan T` syntax, where `T` is the type of
values that will be transferred over the channel.

```v
ch := chan int{} // channel of ints
ch2 := chan f64{} // channel of f64s
```

When creating, you can specify the length of the buffer using the `cap` field:

```v
ch := chan int{cap: 100} // channel of ints with buffer length 100
```

This will create a buffered channel, which we will discuss further.

> **Note**
> Although we will be sending values to the channels, there is no need to declare channels as `mut`.

Created channels can be passed to threads as normal variables:

```v
fn f(ch chan int) {
	// ...
}

fn main() {
	ch := chan int{}
	spawn f(ch)
	// ...
}
```

## Sending and receiving

Values can be sent to a channel using the arrow operator `<-`:

```v ignore
ch <- 5
```

Or obtained from a channel:

```v ignore
i := <-ch
```

## Synchronization

By default, when you send a value to a channel, the sending channel **blocks** until another thread
receives the value from the channel.
This allows threads to be synchronized without the use of explicit locks or condition variables.

```v play
fn sum(values []int, res_ch chan int) {
	mut sum := 0

	for val in values {
		sum += val
	}

	res_ch <- sum
}

fn main() {
	s := [1, 2, 3, 4]

	ch := chan int{}
	spawn sum(s[..s.len / 2], ch)
	spawn sum(s[s.len / 2..], ch)

	res1 := <-ch // wait for result
	res2 := <-ch // wait for result
	println(res1 + res2)
}
```

The example code sums the numbers in a slice, distributing the work between two threads.
Once both threads have completed their computation, it calculates the final result.

## Buffered and unbuffered channels

As already described at the beginning, when creating a channel, you can specify the length of the
buffer.
Such channels are called buffered.

Unlike unbuffered channels, when sending a value to a buffered channel, the sender thread is blocked
**only if the buffer is full**.

The receiver will block when trying to read if the buffer is empty:

```v play
fn main() {
	s := [1, 2, 3, 4]

	ch := chan int{cap: 2}
	ch <- 1
	ch <- 2

	println(<-ch)
	println(<-ch)

	println('done')
}
```

Try adding another value to the `ch` pipe to refill the buffer and see what happens.

## Closing a channel

A channel can be closed to indicate that no more values will be sent to it.
Attempting to send a value to a closed channel will cause a panic (except `select`
and `try_push()`).

The receiver can check if the channel is closed using the `or` block:

```v play
fn main() {
	ch := chan int{}
	ch.close()

	m := <-ch or {
		println('channel has been closed')
		-1
	}

	println(m)
}

// channel has been closed
// -1
```

If you try to read a value from a closed channel, you will get the
[Zero-value](../types/zero-values.md)
for the channel type.
In this case, the thread will not be blocked.

> **Note**
> Only the sender should close a channel, never the receiver.

## Read all values from a channel until it's closed

Closing a channel is also useful to stop reading values from a channel using a `for` loop.

In the following example, we read all values from the `ch` channel as long as it has values and
is not closed:

```v play
fn main() {
	ch := chan int{cap: 5}
	for i in 0 .. 5 {
		ch <- i
	}
	ch.close()

	for {
		m := <-ch or { break }
		println(m)
	}

	println('done')
}
```

Note that we use an infinite loop until the channel is closed and the `or` block is executed.

> **Note**
> Channels aren't like files; you don't usually need to close them.
> Closing is only necessary when the receiver must be told there are no more values coming,
> such as to terminate a range loop.

## Channel Select

The `select` expression allows monitoring several channels at the same time without a noticeable
CPU load.
It consists of a list of possible cases and associated branches of statements, like a
[match](../control-flow/conditions.md#match-expression)
expression:

```v play
import time

fn fibonacci(c chan int, quit chan int) {
	mut x, mut y := 0, 1

	for {
		select {
			c <- x {
				x, y = y, x + y
			}
			_ := <-quit {
				println('quit')
				return
			}
		}
	}
}

fn main() {
	ch := chan int{}
	quit := chan int{}

	spawn fn [ch, quit] () {
		for _ in 0 .. 7 {
			println(<-ch)
		}
		quit <- 0
	}()

	fibonacci(ch, quit)
}
```

### Timeout branch

The `select` expression can also have a `timeout` branch, which will be executed if none of the
branches is executed within the specified time.
If no `timeout` branch is specified, then `select` waits for an unlimited amount of time.

```v play
import time

fn main() {
	ch := chan int{}

	select {
		val := <-ch {
			println(val)
		}
		2 * time.second {
			println('timeout')
		}
	}
}

// timeout
```

In the example above, the `timeout` branch will be executed in 2 seconds, because nothing will be
sent to the `ch` channel and the `val := <-ch` branch will not be executed.

### Else branch

The `else` branch will execute immediately if none of the channels in the branches are currently
ready.

```v play
fn main() {
	ch := chan int{}

	select {
		val := <-ch {
			println(val)
		}
		else {
			println('no values in ch for now')
		}
	}
}

// no values in ch for now
```

> **Note**
> `else` cannot be used together with `timeout` within the same `select` expression

### Select as an expression

The `select` can be used as an *expression* of type `bool` that becomes `false` if all channels are
closed:

```v ignore
if select {
    ch <- a {
        // ...
    }
} {
    // channel was open
} else {
    // channel is closed
}
```

## Special Channel Features

For special purposes, there are some builtin fields and methods:

```v play
struct Abc {
	x int
}

a := 2.13
ch := chan f64{}
res := ch.try_push(a) // try to perform `ch <- a`
println(res)

l := ch.len // number of elements in queue
c := ch.cap // maximum queue length
is_closed := ch.closed // bool flag – has `ch` been closed
println(is_closed)
println(l)
println(c)

mut b := Abc{}
ch2 := chan Abc{}
res2 := ch2.try_pop(mut b) // try to perform `b = <-ch2`
println(res2)
```

The `try_push/pop()` methods will return immediately with one of the results
`.success`, `.not_ready` or `.closed` – dependent on whether the object has been transferred or
the reason why not.

Usage of these methods and fields in production is not recommended — algorithms based on them are
often subject to race conditions.

Especially `.len` and `.closed` should not be used to make decisions.
Use `or` branches, error propagation or `select` instead.
