# Keywords

V has 44 reserved keywords (3 are literals).
The following tokens are always interpreted as keywords and cannot be used as identifiers:

- `as`
    - used in [sum types](../concepts/sum-types.md#is-and-as-operators)
    - specify an [alias for an import](../concepts/modules/module-imports.md)
    - specify a inner type for a [enum](../concepts/enums.md)
- `asm` – used in [inline assembly](../concepts/inline-assembly.md)
- `assert` – used in [testing](../concepts/testing.md)
- `atomic` – used in [atomics](../concepts/atomics.md)
- `break` – [terminates the execution of a loop](../concepts/control-flow/loops.md#break--continue)
- `const` – declares a [constant](../concepts/constants.md)
- `continue` – [proceeds to the next step of the nearest enclosing loop](../concepts/control-flow/loops.md#break--continue)
- `defer` – defines [deferred block](../concepts/control-flow/defer.md)
- `else` – defines the branch of an [if expression](../concepts/control-flow/conditions.md#if-expression) that is
  executed when the condition is false.
- `enum` – declares an [enum](../concepts/enums.md)
- `false` – literal falsely boolean value
- `fn` – declares a [function](../concepts/functions/overview.md)
- `for` – begins a [for loop](../concepts/control-flow/loops.md)
- `go` – starts a [separate thread](../concepts/concurrency.md)
- `goto` – [jumps to a label](../concepts/control-flow/jumps.md)
- `if` – begins an [if expression](../concepts/control-flow/conditions.md#if-expression)
- `import` – [imports a module](../concepts/modules/module-imports.md)
- `in`
    - used in [for loops](../concepts/control-flow/loops.md)
    - used in [arrays](../concepts/types/arrays.md) and [maps](../concepts/types/maps.md)
- `interface` – declares an [interface](../concepts/interfaces.md)
- `is`
    - used in [sum types](../concepts/sum-types.md#is-and-as-operators)
    - used in [interfaces](../concepts/interfaces.md)
- `isreftype` – [checks if a type is a reference type](../concepts/builtin-functions.md#isreftype--checking-if-a-type-is-a-reference-type)
- `lock` – used in [locking](../concepts/concurrency.md)
- `match` – begins a [match expression](../concepts/control-flow/conditions.md#match-expression)
- `module` – declares a [module](../concepts/modules/overview.md)
- `mut`
    - declares a [mutable variable](../concepts/variables.md)
    - starts a [mutable fields block](../concepts/structs/overview.md#fields)
    - declares method receiver as [mutable](../concepts/structs/overview.md#mutable-receivers)
- `none` – literal value of the [none type](../concepts/error-handling.md)
- `or` – defines the branch for [result or option type](../concepts/error-handling.md)
- `pub`
    - makes a [declaration](../concepts/modules/overview.md#symbol-visibility) public
    - starts a [public fields block](../concepts/structs/overview.md#fields)
- `return` – [returns a value from a function](../concepts/functions/overview.md)
- `rlock` – used in [locking](../concepts/concurrency.md)
- `select` – used in [select statement](../concepts/concurrency.md)
- `shared` – used in [shared variables](../concepts/concurrency.md)
- `sizeof` – returns the [size of a type](../concepts/builtin-functions.md#sizeof--getting-the-size-of-a-type)
- `spawn` – starts a [separate thread](../concepts/concurrency.md)
- `static` – used in [static variables](../concepts/variables.md)
- `struct` – declares a [struct](../concepts/structs/overview.md)
- `true` – literal truthy boolean value
- `type` – declares a [type alias](../concepts/type-aliases.md) or [sum types](../concepts/sum-types.md)
- `typeof` – returns the [type of expression](../concepts/builtin-functions.md#typeof--getting-the-type-of-expression)
- `union` – declares a [union](../concepts/unions.md)
- `unsafe` – starts an [unsafe block](../concepts/memory-unsafe-code.md)
- `volatile` – used in [volatile variables](../concepts/variables.md)
- `__global` – declares a [global variable](../concepts/global-variables.md)
- `__offsetof` – returns
  the [offset of a field](../concepts/builtin-functions.md#offsetof--getting-the-offset-of-a-struct-field)

## Special identifiers

The following identifiers are defined by the compiler in specific contexts, and they can be used as regular
identifiers in other contexts:

- `it` is used inside a `array` or `map` method calls to
  [refer to its parameter implicitly](../concepts/types/arrays.md#it-variable).
- `a` and `b` is used inside a `sort()` method for `array` to
  [refer left and right elements](../concepts/types/arrays.md#sorting-arrays)
  respectively.
