# Operators

V supports the following operators.
It can be used with [primitive types](../concepts/types/primitive-types.md) only.

```v ignore
+    sum                    integers, floats, strings
-    difference             integers, floats
*    product                integers, floats
/    quotient               integers, floats
%    remainder              integers

~    bitwise NOT            integers
&    bitwise AND            integers
|    bitwise OR             integers
^    bitwise XOR            integers

!    logical NOT            bools
&&   logical AND            bools
||   logical OR             bools
!=   logical XOR            bools

<<   left shift             integer << unsigned integer
>>   right shift            integer >> unsigned integer
>>>  unsigned right shift   integer >> unsigned integer

Assignment Operators
+=   -=   *=   /=   %=
&=   |=   ^=
>>=  <<=  >>>=
```

## Operator Precedence

| Precedence | Operator                            |
|------------|-------------------------------------|
| 5          | `*`  `/`  `%`  `<<`  `>>` `>>>` `&` |
| 4          | `+`  `-`  `^`                       |
| 3          | `==`  `!=`  `<`  `<=`  `>`  `>=`    |
| 2          | `&&`                                |
| 1          | `&#124;&#124;`                      |

See also [Limited Operator Overloading](../concepts/functions/limited-operator-overloading.md).
