# Attributes

Attributes offer the ability to add structured, machine-readable metadata information on
declarations in code.

Structures, interfaces, enums, methods, functions, fields, constants, and modules can be the target
of an attribute.
The metadata defined by attributes can then be inspected at compile-time using the
[Reflection APIs](../compile-time/reflection.md).
Attributes could therefore be thought of as a configuration language embedded directly into code.

Attributes in V are declared inside square brackets `[]` before the declaration.

```v
[inline]
fn foo() {}
```

If multiple attributes need to be declared, they must be separated by `;` (semicolon):

```v
[inline; unsafe]
fn foo() {}
```

You can also declare attributes on multiple lines:

```v nofmt
[inline]
[unsafe]
fn foo() {}
```

Attributes can have a value that is specified after the attribute name:

```v
[deprecated: 'use new_function() instead']
fn foo() {}
```

Field attributes of structures or interfaces are specified after the field declaration:

```v
struct Foo {
	name string [sql: 'Name']
}
```

The special syntax of the `if` attribute allows you to specify a condition under which the
definition will be compiled:

```v
[if debug]
fn log() {}
```

For custom options:

```v
[if my_trace ?]
fn log() {}
```

You also can declare string attribute:

```v
['/run']
fn run() {}
```
