# Module config files (`v.mod`)

`v.mod` are special files that are located at the root of the module and
contain information about it.
Usually projects contain a `v.mod` file at the root, not in each module, as this is optional, in
which case it will contain the description of the entire project.

`v.mod` example:

```vmod skip
Module {
    name: 'myproject'
    version: '0.1.0'
    description: 'My project description'
    license: 'MIT'
}
```

## Get nearest `v.mod` file

V provides a handy `@VMODROOT` constant to get the path of the folder with `v.mod` file:

```v play
fn main() {
    println(@VMODROOT)
}
```

To get content of the nearest `v.mod` file, use `@VMOD_FILE`:

```v play
fn main() {
    println(@VMOD_FILE)
}
```

## Working with `v.mod` files in V code

V provides a handy
[`vmod`](https://modules.vosca.dev/standard_library/v/vmod.html)
module to work with `v.mod` files in V code.

To get `Manifest` struct from `v.mod` file, use `vmod.decode()`:

```v skip
module main

import v.vmod

fn main() {
    manifest := vmod.decode(@VMOD_FILE) or { panic(err) }
    println(manifest)
}
```

The `Manifest` structure contains the fields from the `v.mod` file.
The `unknown` field contains a map of all non-standard fields.

## `v.mod` file structure

### Name field

The `name` field describes the name of the module.

```vmod
Module {
    name: 'myproject'
}
```

### Version field

The `version` field describes the version of the module.

```vmod
Module {
    version: '0.1.0'
}
```

### License field

The `license` field describes the license of the module.

```vmod
Module {
    license: 'MIT'
}
```

### Repo URL field

The `repo_url` field describes the URL of the module repository.

```vmod
Module {
    repo_url: 'https://github,com/vlang/v'
}
```

### Description field

The `description` field contains the description of the module.

```vmod
Module {
    description: 'My project description'
}
```

### Author field

The `author` field contains the name of the module author.

```vmod
Module {
    author: 'John Doe'
}
```

### Dependencies field

The `dependencies` field contains the list of module dependencies.

```vmod
Module {
    dependencies: [
        'markdown'
        'pcre'
    ]
}
```

> **Note**
> You can't specify dependency versions at this time.
