# Modules

Modules are the building blocks of V programs.
They allow you to split your code into separate files and organize it into logical units.
Modules can be imported and reused in other modules.

A module is a folder that contains at least one file with a V source code.
Module names should be kept short, no more than 10 characters, and use `snake_case`.
As in Go, circular imports are not allowed.
All modules are compiled statically into a single executable file.

## Create new modules

To create a new module, create a folder with the name of the module
and place the V source files in it.

```shell
cd your-project
mkdir mymodule
```

Let's add the file **mymodule/myfile.v**:

```v failcompile
module mymodule

pub fn say_hi() {
	println('Hi from mymodule!')
}
```

Each file in a module must have the `module` keyword with the name of the module
at the beginning of the file.
The folder cannot contain files that define another module.

Now you can use the module in your code:

**main.v:**

```v failcompile
import mymodule

fn main() {
	mymodule.say_hi()
}
```

To learn more about importing modules, see the [import documentation](module-imports.md).

## Nested modules

Sometimes it is useful to combine several modules into one.

To do this, just create another folder inside the folder of the existing module with
the name of the submodule:

```shell
mkdir mymodule/submodule
```

Let's create a file **mymodule/submodule/myfile.v**:

```v failcompile
module submodule

pub fn say_hello() {
	println('Hello from mymodule.submodule!')
}
```

Now, to use a submodule, you need to specify the full path to it, separating the names with a dot:

```v failcompile
import mymodule.submodule

fn main() {
	submodule.say_hello()
}
```

## Symbol visibility

In the examples above, we used the `pub` keyword when declaring the functions.
By default, all functions, structures, constants, and types are private (not exported).
To make them available to other modules, add `pub` before their declaration.
This allows other modules to use them in their own code.

The following function can only be used inside the `mymodule` module:

```v
fn private_function() {
}
```

And this function can be used in any other module:

```v
pub fn public_function() {
}
```

## `init` functions

If you want a module to automatically call some setup/initialization code when it is imported,
you can use a module `init` function:

```v
fn init() {
	// your setup code here ...
}
```

The `init` function cannot be public – it will be called automatically.
This feature is particularly useful for initializing a C library.
