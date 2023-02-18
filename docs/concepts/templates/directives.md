# Template directives

Unlike many other templating engines, V uses `@` as the directive character.
Each template directive begins with the `@` character.

## Variables

To display the value of a variable in a template, use `@{}`:

```html
<p>
	@{name}
</p>
```

V templates can use variables from the outer function in which they are used:

```v
fn main() {
	name := 'John'
	println($tmpl('template.txt'))
}
```

**template.txt:**

```
name: @{name}
```

You can also access the fields of structures:

```v
struct Person {
	name string
	age  int
}

fn main() {
	person := Person{
		name: 'John'
		age: 25
	}
	println($tmpl('template.txt'))
}
```

**template.txt:**

```
name: @{person.name}
age: @{person.age}
```

## V code in template

You can embed any V code in a template by enclosing it in `@{}`:

```html
<p>
	@{"Hello, " + name}
</p>
```

## Control-flow

All the following directives have bodies that end with `@end`.
Everything between the directive and `@end` is considered to be its body.

Inside the body, newlines at the beginning and at the end are ignored,
to avoid extra spaces in the resulting html.

### `if` statement

The `if` directive, consists of three parts, the `@if` tag, the condition (same syntax like in V)
and the body, where you can write text or html, which will be rendered if the condition is true.
Optionally, the `if` directive can have an `else` branch.
The full syntax of the `if` directive is:

```
@if <condition>

@else

@end
```

For example:

```html
@if is_greeting
<p>
	@{"Hello, " + name}
</p>
@end
```

Result when `is_greeting` is true:

```html
<p>
	Hello, John
</p>
```

Example with `else` branch:

```html
@if is_greeting
<p>
	@{"Hello, " + name}
</p>
@else
<p>
	@{"Goodbye, " + name}
</p>
@end
```

Result when `is_greeting` is `true`:

```html
<p>
	Hello, John
</p>
```

Result when `is_greeting` is `false`:

```html
<p>
	Goodbye, John
</p>
```

In `else` you can use `if` to mimic `else if`, however the inner `if` must end with `@end`:

```
@if <condition>

@else
	@if <condition 2>

	@end
@end
```

## `for` statement

The `for` directive is similar to the [`for`](../control-flow/loops.md) loop in V.
As with `if`, the `for` directive has a body that ends with `@end`.
Within a loop, you can access variables defined for iteration.

```
@for <condition>

@end
```

### `for-in`

With a `for-in` loop, you can iterate over the elements of an array or map.
Inside the loop, you can use the declared variables inside the loop, as in normal loops,
they point to the index and value of an array element or the key and value of a map.

```html
@for index, name in articles
<span>@{index}. @{name}</span>
@end
```

### Other `for` syntax

You can use any `for` loop syntax in V that is supported by V:

```html
@for i := 0; i < 5; i++
<span>@{i}</span>
@end
```

## Include other templates or files

### `include`

The `include` directive is for including other template files (which will be processed as well)
and consists of two parts, the `@include` tag and a following `'<path>'` string.
The path parameter is relative to the `/templates` directory in the corresponding project.

#### Example for the folder structure of a project using templates:

```
<project root>
/templates
    - index.html
    /headers
        - base.html
```

**index.html**

```html

<div>@include 'header/base'</div>
```

> **Note**
> There shouldn't be a file suffix,
> it is automatically appended and only allows `html` files.
