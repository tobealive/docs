# Profiling

V has initial support for profiling your programs.

The next command will run your program and generate a **profile.txt** file,
which you can then analyze:

```bash
v -profile profile.txt run file.v
```

The generated **profile.txt** file will have lines with 4 columns:

1. How many times a function was called
2. How much time in total a function took (in ms)
3. How much time, on average, a call to a function took (in nanoseconds)
4. The name of the V function

You can sort on column 3 (average time per function) using:

```shell
sort -n -k3 profile.txt | tail
```

You can also use stopwatches to measure just portions of your code explicitly:

```v play
import time

fn main() {
	sw := time.new_stopwatch()
	println('Hello world')
	println('Greeting the world took: ${sw.elapsed().nanoseconds()}ns')
}
```
