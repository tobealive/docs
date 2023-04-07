# First project

In the previous article, we ran a single V file, but projects typically consist of multiple files.
Let us create a new project, V provides the handy `v new` command for this:

```bash
v new our_first_project
```

The command will ask you to provide additional information about the project, which you can skip by
pressing `Enter`.

As a result, the command will create a new folder **our_first_project** and add several files to it:

```bash
cd our_first_project
tree .
#.
# ├── src
# │   └── main.v
# └── v.mod
#
# 2 directories, 2 files
```

Let us check that everything is fine by running our project:

```bash
v run .

# Hello, World!
```

## Project structure

V is a modular language, any projects on it consist of a set of modules.
Each module is a separate folder containing code files.

Modules can be located both in the project root folder and in the **src** folder.
The **src** folder itself is not a module, it is used to store all project modules in one place.

> **Tip**
> To learn more about modules, see [Modules](../concepts/modules/overview.md) section.

### v.mod

The **v.mod** file contains information about the project, such as its name and version.
It also contains a list of the project's dependencies, which we'll look
at [Module config files](../concepts/modules/vmod.md) article.

This file can be used as a marker for the project's root folder, `@VMODROOT` constant
can be used to get the path to the project's root folder.

## Additional commands

We already saw the `v new` command above, but V provides a few more commands for working with
projects:

- `v init` – adds the necessary files to the current folder to make it a V project.
- `v new web-project web` – creates a new project in the new folder **web-project**, using the web
  template.
