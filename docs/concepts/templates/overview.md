# Templates

V allows easily using text templates, expanded at compile time to V functions,
that efficiently produce text output.
This is especially useful for templated HTML views, but the mechanism is general enough
to be used for other kinds of text output also.

V uses the special
[compile-time](../compile-time/overview.md)
function `$tmpl()` for this, which generates template code at compile time, which is then executed
when the function using the template is called.

Consider a simple example:

```v ignore
fn build() string {
	name := 'Peter'
	age := 25
	numbers := [1, 2, 3]
	return $tmpl('template.txt')
}

fn main() {
	println(build())
}
```

**template.txt:**

```text
name: @{name}

age: @{age}

numbers: @{numbers}

@for number in numbers
  @{number}
@end
```

Output:

```text
name: Peter

age: 25

numbers: [1, 2, 3]

1
2
3
```

As you can see, we did not explicitly pass the `name`, `age`, and `numbers` variables to
the `$tmpl()` function.
However, they are still available within the template, because templates have access to the
variables of the outer function in which they are used.

For more information about template directives, see [template directives](directives.md).
