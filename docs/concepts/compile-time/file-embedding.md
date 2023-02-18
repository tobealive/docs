# File Embedding

V can embed arbitrary files into the executable with the `$embed_file(<path>)` compile time function.
Paths can be absolute or relative to the source file.

```v ignore
import os

fn main() {
	embedded_file := $embed_file('v.png')
	os.write_file('exported.png', embedded_file.to_string())!
}
```

When you build your code in a **non-**[**production mode**](../production-builds.md),
the file will not be embedded.
Instead, it will be loaded *the first time* your program calls `embedded_file.data()` at runtime, making
it easier to change in external editor programs, without needing to recompile your executable.

In [production mode](../production-builds.md),
the file *will be embedded inside* your executable, increasing your binary size, but making it more
self-contained and thus easier to distribute.
In this case, `embedded_file.data()` will cause *no IO*, and it will always return the same data.

`$embed_file` supports compression of the embedded file in production mode.
Currently only one compression type is supported: `zlib`

```v ignore
import os

fn main() {
	embedded_file := $embed_file('v.png', .zlib) // compressed using zlib
	os.write_file('exported.png', embedded_file.to_string())!
}
```

`$embed_file` returns
[EmbedFileData](https://modules.vlang.io/v.embed_file.html#EmbedFileData)
which could be used to obtain the file contents as `string` or `[]u8`.
