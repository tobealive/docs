# Production Builds

By default, when you compile your code, the compiler doesn't perform any optimizations to finish
compilation as quickly as possible.
This is useful for development, as you quickly get the binary after changes in the code.
However, when you want to deploy your application, you want to make it as optimized as possible so
that it runs as quickly as possible.

To do this, V provides the `-prod` flag:

```shell
v -prod myprogram.v
```

This flag tells the compiler to use optimizations to speed up your program.
However, these optimizations significantly increase compilation time.
