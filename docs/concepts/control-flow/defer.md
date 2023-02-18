# Defer

A `defer` statement defers the execution of a block of statements until the surrounding function returns.

```v
import os

fn read_log() {
	mut ok := false
	mut f := os.open('log.txt') or { panic(err) }
	defer {
		f.close()
	}
	// ...
	if !ok {
		// defer statement will be called here, the file will be closed
		return
	}
	// ...
	// defer statement will be called here, the file will be closed
}
```

If the function returns a value the `defer` block is executed *after* the return expression is evaluated:

```v
import os

enum State {
	normal
	write_log
	return_error
}

fn write_log(s State) !int {
	mut f := os.create('log.txt')!
	defer {
		f.close()
	}
	if s == .write_log {
		// `f.close()` will be called after `f.write()` has been
		// executed, but before `write_log()` finally returns the
		// number of bytes written to `main()`
		return f.writeln('This is a log file')
	} else if s == .return_error {
		// the file will be closed after the `error()` function
		// has returned  – so the error message will still report
		// it as open
		return error('nothing written; file open: ${f.is_opened}')
	}
	// the file will be closed here, too
	return 0
}

fn main() {
	n := write_log(.return_error) or { panic('Error: ${err}') }
	println('${n} bytes written')
}
```

> **Note**
> Unlike Go, in V `defer` will not be called if there is a panic.
