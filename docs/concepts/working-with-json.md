# Working with JSON

Because of the ubiquitous nature of JSON, support for it is built directly into V.

V generates code for JSON encoding and decoding using [compile-time reflection](compile-time/reflection.md).

Since any JSON object must be represented as a structure, the first step in working with
JSON is to create a structure that will represent the JSON object.

Each structure field describes one field of the JSON object.

For example, let's consider the following JSON object:

```json
{
  "name": "Frodo",
  "lastName": "Baggins",
  "age": 25
}
```

To represent it in V, we need to create the following structure:

```v
struct User {
	name      string
	last_name string [json: lastName]
	age       int
}
```

In this example, we have created a `User` structure that contains three fields: `name`, `last_name` and `age`.
As you can see from the example, the field name `last_name` in the structure is different from the field name in the
JSON object.
To specify which field name to use when decoding JSON, use `json`
[attribute](attributes.md).
The value of this attribute is the name of the field in the JSON object.

V provides the following attributes for structure fields:

- `[json: name]` – describes the field name in the JSON object
- `[required]` – indicates that the field must be present in the JSON object,
  otherwise decoding will fail.
  Without the attribute, in this case the field will be assigned a default value,
- `[skip]` – indicates that the field may not be present in the JSON object and will be skipped during encoding
- `[omitempty]` – indicates that the field may not be present in the JSON object and will be skipped during encoding,
  if it has a default value

## Decoding JSON

The `json.decode()` function allows you to decode a JSON object into a structure.

It takes two arguments:

1. the type to decode the JSON object into
2. a string containing a JSON object

```v play
import json

struct Foo {
	x int
}

struct User {
	name      string [required]
	age       int
	foo       Foo    [skip]
	last_name string [json: lastName]
}

data := '{ "name": "Frodo", "lastName": "Baggins", "age": 25 }'
user := json.decode(User, data) or {
	eprintln('Failed to decode json, error: ${err}')
	return
}

println(user.name) // Frodo
println(user.last_name) // Baggins
println(user.age) // 25
```

With this function, you can decode both JSON objects and JSON arrays.

```v play
import json

struct Foo {
	x int
}

sfoos := '[{"x":123},{"x":456}]'
foos := json.decode([]Foo, sfoos)!
println(foos[0].x) // 123
println(foos[1].x) // 456
```

## Encoding JSON

The `json.encode()` function is used to encode a structure into JSON.
It takes one argument, the structure to be encoded in JSON.

```v play
import json

struct User {
	name  string
	score i64
}

mut data := map[string]int{}
user := &User{
	name: 'Pierre'
	score: 1024
}

data['x'] = 42
data['y'] = 360

println(json.encode(data)) // {"x":42,"y":360}
println(json.encode(user)) // {"name":"Pierre","score":1024}
```
