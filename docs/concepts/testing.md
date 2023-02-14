# Testing

Testing in V is similar to Go.
Just like in Go, test files are usually located next to the code under test and have the **_test.v** suffix.
Each test function must be prefixed with `test_`.
However, unlike Go, test functions do not take any parameters.

```v
fn test_add() {
	assert 1 + 1 == 2
}
```

In the tests themselves, the `assert` statement is used for checks.
If the expression inside `assert` is not true, then the test will fail.

```v
fn test_add() {
	assert 1 + 1 == 2
	assert 1 + 1 == 3 // this will fail
}
```

In test files, you can declare ordinary functions that will be available in tests.
This is convenient if you need to move some common logic into a separate function.

## Asserts

Asserts are the main tool for testing in V.

When `assert` fails, V tries to display the values on both sides of the comparison operator
(e.g. `<`, `==`).
This is useful for quickly finding an unexpected value.

`assert` can however be used outside of test functions, which can be useful when developing a new
functionality.

```v
fn foo(mut v []int) {
	v[0] = 1
}

mut v := [20]
foo(mut v)
assert v[0] < 4
```

> **Note**
> All `assert` statements outside of test functions will be removed when compiled with the `-prod` flag.

### Asserts with an extra message

This form of the `assert` statement, will print the extra message when it fails.
Note, that you can use any string expression there – string literals, functions returning a string,
strings that interpolate variables, etc.

```v
fn test_assertion_with_extra_message_failure() {
	for i in 0 .. 100 {
		assert i * 2 - 45 < 75 + 10, 'assertion failed for i: ${i}'
	}
}
```

### Asserts that do not abort your program

When initially prototyping functionality and tests, it is sometimes desirable to have asserts,
that do not stop the program, but just print their failures.
That can be achieved by tagging your assert containing functions with an `[assert_continues]`
tag, for example running this program:

```v
[assert_continues]
fn check(num int) {
	assert num == 2
}

for i in 0 .. 4 {
	check(i)
}
```

will produce this output:

```
assert_continues_example.v:3: FAIL: fn main.abc: assert num == 2
   left value: num = 0
   right value: 2
assert_continues_example.v:3: FAIL: fn main.abc: assert num == 2
   left value: num = 1
  right value: 2
assert_continues_example.v:3: FAIL: fn main.abc: assert num == 2
   left value: num = 3
  right value: 2
```

> **Note**
> V also supports a command line flag `-assert continues`, which will change the
> behaviour of all asserts globally, as if you had tagged every function with `[assert_continues]`.

## Test runner

For example, let's take the following code that we want to test:

**hello.v:**

```v play
module main

fn hello() string {
	return 'Hello, World!'
}

fn main() {
	println(hello())
}
```

**hello_test.v:**

```v play-test
module main

fn test_hello() {
	assert hello() == 'Hello world'
}
```

To run the test file above, use `v hello_test.v`.
This will check that the function `hello` is producing the correct output.
V executes all test functions in the file.

To test an entire module, use `v test mymodule`.
You can also use `v test .` to test everything inside your current folder (and sub folders).
You can pass the `-stats` option to see more details about the individual tests run.

### Running specific tests

You can only run certain tests using the `-run-only GLOB_PATTERN` flag.
In this case, only tests that match the `GLOB_PATTERN` pattern will be run.
[Glob patterns](https://www.malikbrowne.com/blog/a-beginners-guide-glob-patterns)
can be separated by commas.

```shell
v test -run-only 'test_hello,test_add'
```

Will only run the `test_hello` and `test_add` tests.

> **Note**
> Glob patterns support `*` which matches anything, and `?`, that matches any single character.
> They are *NOT* regular expressions, however.

### Alternative test runners

For ease integration, V supports alternative test runners.
You can specify a test runner using the `-test-runner RUNNER_NAME` flag.
See an up-to-date list of test runners using `v help test`.

## Internal and external tests

There are two kinds of tests in V: internal and external.

### Internal

Internal tests must have a module name declaration (`module foo`), like all other **.v** files from the same module.

Internal tests can call private functions from the unit under test.

In the example above, `test_hello` is an internal test that can call the private `hello()` function,
because **hello_test.v** has a `module main`, as does **hello.v**.

### External

External tests must import the modules they are testing.

They do not have access to private functions/module types.
They can only test the external/public API that the module exposes.

```v play-test
module foo

import arrays

fn test_arrays() {
    assert arrays.contains([1, 2, 3], 2)
}
```

## Special begin/end functions

V provides a path to execute code before and after all test functions in a test file.

* `testsuite_begin` which will be run *before* all other test functions.
* `testsuite_end` which will be run *after* all other test functions.

## Error propagation

If a test function has an error return type, any propagated errors will fail the test:

```v
import strconv

fn test_atoi() ? {
	assert strconv.atoi('1')? == 1
	assert strconv.atoi('one')? == 1 // test will fail
}
```

## Additional test data

You can put additional test data, including **.v** source files in a folder, named
`testdata`, right next to your **_test.v** files.
V's test framework will *ignore* such folders, while scanning for tests to run.
This is useful, if you want to put **.v** files with invalid V source code, or other tests,
including known failing ones, that should be run in a specific way/options by a parent **_test.v** file.

## Running other test files in a test

If necessary, you can run other test files inside the test file.

```v oksyntax
import os

fn test_subtest() {
	res := os.execute('${os.quoted_path(@VEXE)} other_test.v')
	assert res.exit_code == 1
	assert res.output.contains('other_test.v does not exist')
}
```

With `@VEXE` you can call the V compiler and run another test file.

## Under the hood

All **_test.v** files (both external and internal ones), are compiled as *separate programs*.
In other words, you may have as many **_test.v** files, and tests in them as you like, they will
not affect the compilation of your other code in **.v.v** files normally at all, but only when you
do explicitly `v file_test.v` or `v test .`.
