# Writing Documentation

The way it works is very similar to Go.
It's straightforward: there's no need to write documentation separately for your code,
`vdoc` will generate it from doc-comments in the source code.

Documentation for each function/type/const must be placed right before the declaration:

```v okfmt
// clearall clears all bits in the array
fn clearall() {
}
```

The comment must start with the name of the definition.

Sometimes one line isn't enough to explain what a function does, in that case comments should
span to the documented function using single line comments:

```v okfmt
// copy_all recursively copies all elements of the array by their value,
// if `dupes` is false all duplicate values are eliminated in the process.
fn copy_all(dupes bool) {
	// ...
}
```

By convention, it is preferred that comments are written in *present tense*.

## Module Documentation

Documentation for modules is written in a separate file **README.md** in the root of the module
folder.

The file must start with a header:

```md
## Description:
```

which must be followed by a description of the module.

## Documentation Generation

To generate documentation use `vdoc`, for example `v doc net.http`.

## Newlines in Documentation Comments

Comments spanning multiple lines are merged together using spaces, unless

- the line is empty
- the line ends with a `.` (end of sentence)
- the line is purely of at least 3 of `-`, `=`, `_`, `*`, `~` (horizontal rule)
- the line starts with at least one `#` followed by a space (header)
- the line starts and ends with a `|` (table)
- the line starts with `-` (list)
