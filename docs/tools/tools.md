# Tools

V has built-in tools to simplify development.

## `v fmt`

You don't need to worry about formatting your code or setting style guidelines.
`v fmt` takes care of that:

```shell
v fmt file.v
```

It's recommended to set up your editor, so that `v fmt -w` runs on every save.
A vfmt run is usually pretty cheap (takes <30ms).

Always run `v fmt -w file.v` before pushing your code.

### Disabling formatting

To disable formatting for a block of code, wrap it with `// vfmt off` and `// vfmt on` comments:

```v
// Affected by fmt
a := [1, 2, 3]

// vfmt off
// This code will not be formatted
b := [
		1,
		2,
		3,
	 ]
// vfmt on

// Affected by fmt
c := [1, 2, 3]
```

## `v shader`

You can use GPU shaders with V graphical apps. You write your shaders in an
[annotated GLSL dialect](https://github.com/vlang/v/blob/1d8ece7/examples/sokol/02_cubes_glsl/cube_glsl.glsl)
and use `v shader` to compile them for all supported target platforms.

```shell
v shader /path/to/project/dir/or/file.v
```

Currently, you need to
[include a header and declare a glue function](https://github.com/vlang/v/blob/c14c324/examples/sokol/02_cubes_glsl/cube_glsl.v#L43-L46)
before using the shader in your code.

## Profiling

V has initial support for profiling your programs: `v -profile profile.txt run file.v`
That will produce a **profile.txt** file, which you can then analyze.

The generated **profile.txt** file will have lines with 4 columns:

1. how many times a function was called
2. how much time in total a function took (in ms)
3. how much time on average, a call to a function took (in ns)
4. the name of the V function

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
