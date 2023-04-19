# Compile-time constants

V provides access to some constants at compile time.

- `@FN` – name of the current V function
- `@METHOD` – ReceiverType.MethodName
- `@MOD` – name of the current V module
- `@STRUCT` – name of the current V struct
- `@FILE` – absolute path of the V source file
- `@LINE` – line number where it appears (as a string).
- `@FILE_LINE` – like `@FILE:@LINE`, but the file part is a relative path
- `@COLUMN` – column where it appears (as a string).
- `@VEXE` – path to the V compiler
- `@VEXEROOT` – folder, where the V executable is (as a string).
- `@VHASH` – shortened commit hash of the V compiler (as a string).
- `@VMOD_FILE` – contents of the nearest **v.mod** file (as a string).
- `@VMODROOT` – folder, where the nearest **v.mod** file is (as a string).

That allows you to do the following example, useful while
debugging/logging/tracing your code:

```v play
eprintln('file: ' + @FILE + ' | line: ' + @LINE + ' | fn: ' + @MOD + '../..' + @FN)
```

Another example is if you want to embed the version/name from **v.mod**
*inside* your executable:

```v ignore
import v.vmod

vm := vmod.decode(@VMOD_FILE) or { panic(err) }
println('${vm.name} ${vm.version}\n ${vm.description}')
```
