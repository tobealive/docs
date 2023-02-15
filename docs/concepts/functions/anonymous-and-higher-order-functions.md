# Anonymous & higher order functions

As well as regular functions, V supports anonymous and higher-order functions.

Anonymous functions can be declared inside other functions:

```v play
fn main() {
    double_fn := fn (n int) int {
        return n + n
    }
    println(double_fn(5)) // 10
}
```

Such functions do not have a name and can be passed to other functions as arguments:

```v play
fn run(value int, op fn (int) int) int {
    return op(value)
}
    
fn main() {
    println(run(5, fn (n int) int {
        return n + n
    })) // 10
}
```

In the example above, the `run()` function takes another function as its second argument,
its type describes the function type.

Such a type is described as `fn (<param_types>) <return_type>`, for example:

```v
fn (int) int
fn (string, int) string
fn (string, int)
```

If the function returns nothing, then the return type is omitted.

In the example:

```v play
fn main() {
    double_fn := fn (n int) int {
        return n + n
    }
    println(double_fn(5)) // 10
}
```

The variable `double_fn` is of type `fn (int) int`.
Function types are first class types, which means they can be used
as types on a par with, for example, `int` or `string`.

For example, you can have an array of functions:

```v play
fn sqr(n int) int {
    return n * n
}

fn cube(n int) int {
    return n * n * n
}

fn main() {
    fns := [sqr, cube]
    println(fns[0](10)) // 100
    println(fns[1](10)) // 1000
}
```

Or a function map:

```v play
fn sqr(n int) int {
    return n * n
}

fn cube(n int) int {
    return n * n * n
}

fn main() {
    fns_map := {
        'sqr':  sqr
        'cube': cube
    }
    println(fns_map['sqr'](10)) // 100
    println(fns_map['cube'](10)) // 1000
}
```

Anonymous functions can be called right after they are declared:

```v play
fn main() {
    fn (n int) {
        println(n + n) // 10
    }(5)
}
```

Thanks to [type aliases](../type-aliases.md), you can give names to functional types:

```v play
type Filter = fn (string) string

fn filter(s string, f Filter) string {
    return f(s)
}

fn main() {
    println(filter('Hello world', fn (s string) string {
        return s.to_upper()
    })) // HELLO WORLD
}
```

V has duck-typing, so functions don't need to declare compatibility with
a function type – they just have to be compatible:

```v
fn uppercase(s string) string {
	return s.to_upper()
}
```

Such a function can now be used wherever a `Filter` is expected:

```v play
type Filter = fn (string) string

fn filter(s string, f Filter) string {
	return f(s)
}

fn uppercase(s string) string {
	return s.to_upper()
}

fn main() {
	println(filter('Hello world', uppercase)) // HELLO WORLD
}
```

Compatible functions can also be explicitly cast to a function type:

```v oksyntax
my_filter := Filter(uppercase)
```

The cast here is purely informational – duck-typing means that the
resulting type is the same without an explicit cast:

```v oksyntax
my_filter := uppercase
```
