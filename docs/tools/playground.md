# Playground

[V Playground](https://play.vosca.dev/) is a web-based playground for V
where you can run, edit and share V code online.

Playground is an
[open source project](https://github.com/vlang-association/playground)
that you can help develop or study its source code for yourself.
If you find any problems, please let us know by creating a new
[issue](https://github.com/vlang-association/playground/issues/new).

In the playground editor, you can write any code as if you were writing it in a file on your
computer.
You can add structures, functions, import modules, etc.

The playground saves your code in your browser's local storage.
So you can close the tab and come back later to continue working on your code.

## Features

### Run code

To run the code, press <kbd>Ctrl + R</kbd> or click the **Run** button on the toolbar.
See also [available configurations](#configurations).

![Run button](/assets/_images/tools/playground/run.png)

### Format code

To format the code, press <kbd>Ctrl + L</kbd> or click the **Format** button on the toolbar.

![Format button](/assets/_images/tools/playground/format.png)

### Share code

To share the code, press the **Share** button on the toolbar.
It is creating a new URL to your code and copy it to your clipboard.
The created link is also available in the **Terminal**.

![Share button](/assets/_images/tools/playground/share.png)

### Select predefined examples

On the toolbar on the right side, there is a drop-down list of **Examples**.
These examples have comments to help you understand how V works.

![Examples drop-down list](/assets/_images/tools/playground/examples.png)

### Pass arguments to compiler

Optionally, you can pass arguments to the compiler that it will use when compiling.
To do this, add them to the **Build arguments** field in the toolbar.

![Build arguments input](/assets/_images/tools/playground/build-arguments.png)

### Pass arguments to your program

Sometimes you may need to pass command line arguments, for example,
if your program accepts some flags.
You can add them to the **Run Arguments** field on the toolbar.

![Run arguments input](/assets/_images/tools/playground/run-arguments.png)

## Configurations

By default, playground runs your code like a normal program.
However, the Playground also provides configurations for tests and for viewing the generated C code.

![Configuration options](/assets/_images/tools/playground/configurations.png)

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

![Show C generated mode](/assets/_images/tools/playground/cgen-mode.png)

In this mode, the source code in V is shown on the left,
and the generated C code is shown on the right.
You can click on any line in the source code
to jump to the corresponding line in the generated code.

To exit this mode, close the tab with the C code.

## Limitations

### Memory

The amount of memory the compiler and resulting executable use is limited.

### Execution Time

The total compilation and execution time is limited.

### Disk

The total disk space available to the compiler and resulting executable is limited.

### Network

The playground does not have access to the network.

### Persistence

The playground saves your code in your browser's local storage.
But, local storage is a singleton resource, so if you use multiple windows,
only the most recently saved code will be persisted.
