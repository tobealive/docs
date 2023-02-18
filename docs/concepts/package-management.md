# Package management

A V *module* is a single folder with **.v** files inside.
A V *package* can contain one or more V modules.
A V *package* must have a `v.mod` file at its top folder, describing the contents of the package.

V packages are installed normally in your `~/.vmodules` folder.
That location can be overridden by setting the env variable `VMODULES`.

## Package commands

You can use the V frontend to do package operations, just like you can
use it for compiling code, formatting code, vetting code etc.

```bash
v [package_command] [param]
```

Where a package command can be one of:

```text
install           Install a package from VPM.
remove            Remove a package that was installed from VPM.
search            Search for a package from VPM.
update            Update an installed package from VPM.
upgrade           Upgrade all the outdated packages.
list              List all installed packages.
outdated          Show installed packages that need updates.
```

You can install packages already created by someone else with [VPM](https://vpm.vlang.io/):

```bash
v install [package]
```

**Example:**

```bash
v install ui
```

Packages can be installed directly from git or mercurial repositories.

```bash
v install [--once] [--git|--hg] [url]
```

**Example:**

```bash
v install --git https://github.com/vlang/markdown
```

Sometimes you may want to install the dependencies **ONLY** if those are not installed:

```text
v install --once [package]
```

Removing a package with V:

```bash
v remove [package]
```

**Example:**

```bash
v remove ui
```

Updating an installed package from [VPM](https://vpm.vlang.io/):

```bash
v update [package]
```

**Example:**

```bash
v update ui
```

Or you can update all your packages:

```bash
v update
```

To see all the packages you have installed, you can use:

```bash
v list
```

**Example:**

```bash
> v list
Installed packages:
  markdown
  ui
```

To see all the packages that need updates:

```bash
v outdated
```

**Example:**

```bash
> v outdated
Package are up to date.
```

## Publish package

1. Put a `v.mod` file inside the toplevel folder of your package (if you
   created your package with the command `v new mypackage` or `v init`
   you already have a `v.mod` file).

   ```sh
   v new mypackage
   Input your project description: My nice package.
   Input your project version: (0.0.0) 0.0.1
   Input your project license: (MIT)
   Initialising ...
   Complete!
   ```

   Example `v.mod`:

   ```v ignore
   Module {
       name: 'mypackage'
       description: 'My nice package.'
       version: '0.0.1'
       license: 'MIT'
       dependencies: []
   }
   ```

   Minimal file structure:

   ```text
   v.mod
   mypackage.v
   ```

   The name of your package should be used with the `module` directive
   at the top of all files in your package. For **mypackage.v**:

   ```v
   module mypackage

   pub fn hello_world() {
       println('Hello World!')
   }
   ```

2. Create a git repository in the folder with the `v.mod` file
   (this is not required if you used `v new` or `v init`):

   ```sh
   git init
   git add .
   git commit -m "INIT"
   ````

3. Create a public repository on GitHub.com.
4. Connect your local repository to the remote repository and push the changes.
5. Add your package to the public V package registry VPM:
   <https://vpm.vlang.io/new>

   You will have to log in with your GitHub account to register the package.

   > **Warning**
   > Currently it is not possible to edit your entry after submitting.
   > Check your package name and GitHub url twice as this cannot be changed by you later.
6. The final package name is a combination of your GitHub account and
   the package name you provided e.g. `mygithubname.mypackage`.

**Optional:** tag your V package with `vlang` and `vlang-package` on github.com
to allow for a better search experience.
