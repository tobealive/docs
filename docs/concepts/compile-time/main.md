# Compile-time

V provides compile-time features, which allow you to do things at compile-time, instead of at runtime.
This is useful for things like generating code, or doing things that are not possible at runtime.

Thanks to [reflection](./reflection.md), 
you can write efficient data serializers in V that do not require runtime reflection.

Due to the fact that files can be [embedded](./file-embedding.md) 
in binaries, V programs are more boxed and do not require additional files to be transferred with the binary file.
