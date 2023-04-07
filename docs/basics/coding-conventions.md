# Coding conventions

V was originally designed as a language with very strict coding rules.
This avoids a lot of problems when code is written in different styles, which makes maintaining
large codebases a big problem.

As with Go, V has a special built-in code formatter,
[vfmt](../tools/builtin-tools.md#v-fmt)
which brings the code to a single style.

## Source code organization

V is a very modular language, so any programs should be organized into modules, which are located in
separate folders within the project.
You can read more in the [Modules](../concepts/modules/overview.md) article.

The root of all modules can be either the project root or the special `src/` folder.

```text
project/
├── src/
│   ├── module1/
│   │   ├── module1.v
│   │   └── module1_test.v
│   └── module2/
│       ├── module2.v
│       └── module2_test.v
└── v.mod
```

At the root of the project, there should be a `v.mod` file with a description of the module.

Example of `v.mod`:

```vmod
Module {
    name: 'myproject'
    description: 'My nice project'
    version: '0.0.1'
    dependencies: []
}
```

## Naming rules

Unlike Go, V also requires structs/functions/etc. naming in one allowed style.

- Structures, interfaces, types - `PascalCase`
- Functions, methods, variables, constants - `snake_case`

If structs/functions/etc. are not named according to these rules,
the compiler will throw an error.

```v play
struct my_struct {
//     ^^^^^^^^^ error: struct name `my_struct` must begin with capital letter
    name string
}
```
