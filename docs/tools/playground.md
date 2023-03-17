# Playground

[V Playground](https://play.vlang.foundation/) is a web-based playground for V
where you can run, edit and share V code online.

Playground is an
[open source project](https://github.com/vlang-foundation/playground)
that you can help develop or study its source code for yourself.
If you find any problems, please let us know by creating a new
[issue](https://github.com/vlang-foundation/playground/issues/new).

In the playground editor, you can write any code as if you were writing it in a file on your
computer.
You can add structures, functions, import modules, etc.

The playground saves your code in your browser's local storage.
So you can close the tab and come back later to continue working on your code.

## Features

### Run code

To run the code, press <kbd>Ctrl + R</kbd> or click the **Run** button on the toolbar.
See also [available configurations](#configurations).

### Format code

To format the code, press <kbd>Ctrl + L</kbd> or click the **Format** button on the toolbar.

### Share code

To share the code, press the **Share** button on the toolbar.
It's creating a new URL to your code and copy it to your clipboard.
Created link is also available in the **Terminal**.

### Select predefined examples

On the toolbar on the right side, there is a drop-down list of **Examples**.
These examples have comments to help you understand how V works.

### Pass arguments to your program

Sometimes, in order to test your code, you need to pass command line arguments.
You can do this by adding them to the **Arguments** field in the toolbar.

## Configurations

By default, playground runs your code like a normal program.
However, the Playground also provides configurations for tests and for viewing the generated C code.

### Run

The default configuration runs your code like a normal program.

### Test

The **Test** configuration runs your code as
[tests](../concepts/testing.md).
That is, if functions with the `test_` prefix are defined in the file, then all of them will be run
as tests.

### Show Generated C code

The **Show Generated C code** configuration shows the generated C code.
This configuration is very useful to understand how V translates your code to C.

## Limitations

### Memory

The amount of memory the compiler and resulting executable use is limited.

### Execution Time

The total compilation and execution time is limited.

### Disk

The total disk space available to the compiler and resulting executable is limited.

### Persistence

The playground saves your code in your browser's local storage.
But, local storage is a singleton resource, so if you use multiple windows,
only the most recently saved code will be persisted.
