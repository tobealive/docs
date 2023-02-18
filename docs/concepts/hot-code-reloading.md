# Hot code reloading

V has built-in partial support for reloading code at runtime.
Such programs change their behavior when the code changes without recompilation.

```v live
module main

import time

[live]
fn print_message() {
	println('Hello! Modify this message while the program is running.')
}

fn main() {
	for {
		print_message()
		time.sleep(500 * time.millisecond)
	}
}
```

Build this example with `v -live message.v`.
You can also run this example with `v -live run message.v`.

Make sure that in command you use a path to a V's file, **not** a path to
a folder (like `v -live run .`) – in that case you need to modify content of
a folder (add new file, for example), because changes in *message.v* will have no effect.

Functions that you want to be reloaded must have `[live]`
[attribute](./attributes.md)
before their definition.

Right now it's not possible to modify types while the program is running.

More examples, including a graphical application:
[Hot Reload Examples](https://github.com/vlang/v/tree/master/examples/hot_reload).
