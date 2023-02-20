# Loops

V has only one looping keyword: `for`, with several forms.

## Array `for`

The `for value in arr` form is used for going through elements of an array.
If an index is required, an alternative form `for index, value in arr` can be used.

```v play
numbers := [1, 2, 3]
for num in numbers {
	println(num)
}
// 1
// 2
// 3

names := ['Sam', 'Peter']
for i, name in names {
	println('${i + 1}. ${name}')
}
// 1. Sam
// 2. Peter
```

Note, that the value is read-only.
If you need to modify the array while looping, you need to declare the element as mutable:

```v
mut numbers := [1, 2, 3]
for mut num in numbers {
	num++
}
println(numbers) // [1, 2, 3]
```

When an identifier is just a single underscore, it is ignored.

## Map `for`

The `for key, value in map` form is used for going through elements of a map.

```v play
m := {
	'one': 1
	'two': 2
}
for key, value in m {
	println('${key} -> ${value}')
}
// one -> 1
// two -> 2
```

Either key or value can be ignored by using a single underscore as the identifier.

```v play
m := {
	'one': 1
	'two': 2
}

// iterate over keys
for key, _ in m {
	println(key)
}
// one
// two

// iterate over values
for _, value in m {
	println(value)
}
// 1
// 2
```

## Range `for`

```v play
for i in 0 .. 5 {
	print(i)
}
// 01234
```

`low..high` means an *exclusive* range, which represents all values from `low`
up to *but not including* `high`.

## Condition `for`

This form of the loop is similar to `while` loops in other languages.
The loop will stop iterating once the boolean condition evaluates to false.

```v play
mut sum := 0
mut i := 0
for i <= 100 {
	sum += i
	i++
}
println(sum) // 5050
```

## Bare `for`

The condition can be omitted, resulting in an infinite loop.

```v play
mut num := 0
for {
	num += 2
	if num >= 10 {
		break
	}
}
println(num) // 10
```

## C `for`

Finally, there's the traditional C style `for` loop.
It's safer than the `while` form because with the latter it's easy to forget
to update the counter and get stuck in an infinite loop.

```v play
for i := 0; i < 10; i += 2 {
	if i == 6 {
		continue
	}
	println(i)
}
// 0
// 2
// 4
// 8
```

Here `i` doesn't need to be declared with `mut` since it's always going to be mutable by definition.

## Break & continue

`break` and `continue` control the innermost `for` loop.

- `break` terminates the innermost `for` loop.
- `continue` skips the rest of the current iteration and proceeds to the next step of the nearest enclosing loop.

## Labelled break & continue

`break` and `continue` control the innermost `for` loop by default.
You can also use `break` and `continue` followed by a label name to refer to an outer `for` loop:

```v play
outer: for i := 4; true; i++ {
	println(i)
	for {
		if i < 7 {
			continue outer
		} else {
			break outer
		}
	}
}

// 4
// 5
// 6
// 7
```

The label must immediately precede the outer loop.

## Custom iterators

Types that implement a `next()` method returning an
[`Option`](../error-handling.md#optionresult-types)
can be iterated with a `for` loop.

```v play
struct SquareIterator {
	arr []int
mut:
	idx int
}

fn (mut iter SquareIterator) next() ?int {
	if iter.idx >= iter.arr.len {
		return none
	}
	defer {
		iter.idx++
	}
	return iter.arr[iter.idx] * iter.arr[iter.idx]
}

nums := [1, 2, 3, 4, 5]
iter := SquareIterator{
	arr: nums
}

for squared in iter {
	println(squared)
}

// 1
// 4
// 9
// 16
// 25
```
