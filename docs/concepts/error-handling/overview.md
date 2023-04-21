# Error handling

Error handling is one of the benefits of V.
It allows you to write safe code where every error is handled.

V uses the special Option and Result types for error handling.

## Option types

Option types allow you to describe a type that may not be initialized,
in other words, store the special value `none`.

The Option type is specified with a question mark `?` in front of the type name: `?Type`.

For example, a function that finds a user by id in the database might look like this:

```v failcompile
fn (r Repo) find_user_by_id(id int) ?User {
	//                              ^ Option type
	for user in r.users {
		if user.id == id {
			return user
		}
	}
	return none
	//     ^^^^ if not found, return `none`
}
```

Note that you do not need to explicitly wrap `user` with an `Option` type, V does this
automatically.

Options are first-class types, which means you can use them as function parameters,
return values, struct fields, and so on.

## Result types

Result types allow you to describe a type that can store a value or an error.
Unlike Option, Result types are not first-class types, which means they can only be used as
the return value of a function.

The Result type is specified with an exclamation mark `!` before the type name: `!Type`.

Let us rewrite the `find_user_by_id` function using the Result type:

```v failcompile
fn (r Repo) find_user_by_id(id int) !User {
	//                              ^ Result type
	for user in r.users {
		if user.id == id {
			return user
		}
	}
	return error('User ${id} not found')
	//     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ if not found, return an error
}
```

As you can see, if the user is not found, we return an error using the `error()` function.
This special function takes a string from which it creates an error instance that implements the
special `IError` interface.
You can also create your own errors based on this interface.
This will be discussed in the next article.

## Option/Result types handling

Unlike Go with return errors or unchecked exceptions in Java, V does not allow you to ignore errors.
This means that if an Option or Result type is returned from a function, then you must process it
before using its value.

### Propagating none/errors

The first option for handling errors/none is to propagate them up the call stack.
This causes the current function to return an error/none as its result.
However, for a function to return an error/none, its return type must be the Result or Option type,
respectively.
Thus, to propagate an error/none higher up the call stack, the enclosing function itself must return
a Result or Option type.

In order to propagate an error, after calling the function, you must add an exclamation mark `!`.
For `none`, you need to add a question mark `?`.

Let us take a look at a simple example with a Result type:

```v
import net.http

fn get_body(url string) !string {
	//                  ^ Result type
	resp := http.get(url)!
	//                   ^ if error, propagate it
	return resp.body
}
```

Here the `http.get(url)` function returns a Result type, we want that if an error occurs, it will be
propagated and handled by the one who calls `get_body()` function.

For example:

```v failcompile
fn business_logic() {
	body := get_body('https://gogle.com') or {
		// handle error
		return
	}
	// ... work with body
}
```

This is somewhat similar to exceptions, but which is not automatically propagated, but
is only propagated when you explicitly specify it.
In conjunction with the mandatory error handling, this avoids a lot of problems, since you cannot
forget to handle the error.

> **Note**
> If you propagate an error in the `main()` function, the program will panic because it is not
> possible to propagate the error further up the call stack.

### `or` blocks

The second option for error handling/none is to use `or` blocks.
In the previous example, we already used the `or` block to handle the error on the
business logic side.

`or` blocks allow you to describe the behavior that will be performed if the function
returns an error/none.
The `or` block must be wrapped in curly braces `{}`.
If the function returns a value, then the `or` block will be ignored.

The `or` block is specified after a function call that returns a Result or Option type.
In the case of Option types, it can also be used for structure fields, function parameters,
and so on.
You cannot use the `or` block for regular types.

Let us look at a simple example where we want to find a user by id in the database:

```v play
struct User {
	id   int
	name string
}

struct Repo {
	users []User
}

fn (r Repo) find_user_by_id(id int) !User {
	for user in r.users {
		if user.id == id {
			return user
		}
	}
	return error('User ${id} not found')
}

fn main() {
	repo := Repo{
		users: [User{1, 'Andrew'}, User{2, 'Bob'}]
	}
	user := repo.find_user_by_id(10) or { return }
	println(user)
}
```

Here we use the `or` block to handle the error that can be returned from the `find_user_by_id()`
function.
In this example, we simply return from the `main()` function if an error occurs, however, we can add
any logic to the `or` block that will be executed in case of an error, such as logging the error or
displaying a message to the user.

The `or` block can also return values, this can be useful if you want to return a default value on
error/none:

```v play
struct User {
	id   int
	name string
}

struct Repo {
	users []User
}

fn (r Repo) find_user_by_id(id int) !User {
	for user in r.users {
		if user.id == id {
			return user
		}
	}
	return error('User ${id} not found')
}

//code::start
fn main() {
	repo := Repo{
		users: [User{1, 'Andrew'}, User{2, 'Bob'}]
	}
	user := repo.find_user_by_id(10) or { User{-1, 'Unknown'} }
	println(user)
}
//code::end
```

V uses the last statement in the `or` block as the value, so the following example will return
the `default_user` variable from it:

```v play
struct User {
	id   int
	name string
}

struct Repo {
	users []User
}

fn (r Repo) find_user_by_id(id int) !User {
	for user in r.users {
		if user.id == id {
			return user
		}
	}
	return error('User ${id} not found')
}

//code::start
fn main() {
	repo := Repo{
		users: [User{1, 'Andrew'}, User{2, 'Bob'}]
	}
	user := repo.find_user_by_id(10) or {
		default_user := User{-1, 'Unknown'}
		default_user
	}
	println(user)
}
//code::end
```

Note that if the result of a function call is used, then the `or` block must either return a value
of the same type as shown above, or do a `return` or call `panic()` or `exit()`.
In case the call is inside a loop, you can also use `break` or `continue`:

The `or` block can also be used as a propagation if you specify `return err` or `return none` in the
body.

```v
import net.http

fn get_body(url string) !string {
	resp := http.get(url) or { return err }
	//                         ^^^^^^^^^^^ propagate error explicitly
	return resp.body
}
```

For Result types, a special variable `err` is defined in the `or` block, which contains the error
that was returned from the function.
For Option types, it will always be `none` and therefore it is not recommended to use it.

```v
import net.http

fn get_body(url string) !string {
	resp := http.get(url) or {
		println(err)
		return err
	}
	return resp.body
}
```

In the example above, in case of an error, we print it to the console and return it from the
function, thereby propagating, but also writing a message to standard output.

### If unwrapping

Another way to handle errors/none is to use `if` unwrapping.

```v
import net.http

if resp := http.get('https://google.com') {
	println(resp.body) // resp is a http.Response, not an Error
} else {
	println(err)
}
```

In the example above, `http.get()` returns `!http.Response`.
The `if` branch will only be executed if `http.get()` returns a value, not an error.
If `http.get()` returns an error, the `else` branch will be executed.

As with the `or` block, the `else` block defines a special variable `err` that contains the error
that was returned from the function.

If unwrapping can be used anywhere an `or` block can be used, for example, for map/array access:

```v play
mp := {
	'a': 1
	'b': 2
}

if val := mp['c'] {
	println(val)
} else {
	println('key not found')
}

// key not found
```

### Force unwrapping

Unlike Rust with `unwrap()` and Swift with `!`, V does not have a special operator to force a value
to be unwrapped from a Result/Option type.
Instead, use `or { panic(err) }`.

## Bare Result type

In the examples above, Result types were used with other types, however, the functions do not always
return values, but may fail.

To do this, functions can define their return type as simply `!`:

```v failcompile
fn foo() ! {
	resp := http.get(url)!
	println(resp.body)
}
```

Such function calls must also be handled, but their result cannot be used because the function does
not return any value.

```v play
import net.http

fn foo() ! {
	resp := http.get("https://gogle.com")!
	println(resp.body)
}

fn main() {
	foo() or {
		panic(err)
	}

	a := foo() or {
		panic(err)
	}
	// assignment mismatch: 1 variable(s) but `foo()` returns 0 value(s)
}
```
