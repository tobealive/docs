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

V provides a handy `@VMODROOT` constant to get the path of the nearest `v.mod` file:

```v play
fn main() {
    println(@VMODROOT)
}
```

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
