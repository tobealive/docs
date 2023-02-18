# Jumps

## Goto

V allows unconditionally jumping to a label with `goto`. 
The label name must be contained within the same function as the `goto` statement. 
A program may `goto` a label outside or deeper than the current scope. `goto` allows 
jumping past variable initialization or jumping back to code that accesses memory 
that has already been freed, so it requires `unsafe`.

```v play
fn main() {
	x := true
	y := true
	if x {
		if y {
		    unsafe {
				goto my_label
			}
			println('never reached')
        }
	}
	my_label:
	println('hello')
}
```

`goto` should be avoided, particularly when `for` can be used instead.
[Labelled break/continue](loops.md#labelled-break--continue) can be used to break out of
a nested loop, and those do not risk violating memory-safety.
