# Arrays

## Overview

Like many other modern languages, V has built-in support for arrays.
An array is a collection of elements of the same type.
Array literals are lists of expressions surrounded by square brackets.

An individual element can be retrieved using an *index* expression.
Indexes start at `0`.

```v play
mut nums := [1, 2, 3]
println(nums) // [1, 2, 3]
println(nums[0]) // 1
println(nums[1]) // 2

nums[1] = 5
println(nums) // [1, 5, 3]
```

Arrays in V can only contain elements of the same type.
This means that code like `[1, 'a']` will not compile:

```v failcompile play
mut names := ['John']
names << 'Fred'
names << 'Sam'
names << 10
//    ^^ error: cannot append `int literal` to `[]string`
```

## Array Initialization

The type of array is determined by the first element:

- `[1, 2, 3]` is an array of ints (`[]int`).
- `['a', 'b']` is an array of strings (`[]string`).

The user can explicitly specify the type for the first element: `[u8(16), 32, 64, 128]`.

The above syntax is fine for a small number of known elements, but for very large or empty
arrays there is a second initialization syntax:

```v
mut a := []int{len: 10000, cap: 30000, init: 3}
```

This creates an array of 10000 `int` elements that are all initialized with `3`.
Memory space is reserved for 30000 elements.
The parameters `len`, `cap` and `init` are optional;
`len` defaults to `0` and `init` to the
[Zero-value](./zero-values.md)
of the element type.
The run time system makes sure that the capacity is not smaller than `len`
(even if a smaller value is specified explicitly):

```v
arr := []int{len: 5, init: -1}
// `arr == [-1, -1, -1, -1, -1]`, arr.cap == 5

// Declare an empty array:
users := []int{}
```

Setting the capacity improves the performance of pushing elements to the array
as reallocations can be avoided:

```v play
mut numbers := []int{cap: 1000}
println(numbers.len) // 0
// Now appending elements won't reallocate
for i in 0 .. 1000 {
	numbers << i
}
```

> **Note**
> The above code uses a [range `for`](../control-flow/loops.md#range-for) statement.

You can initialize the array by accessing the `index` variable which gives
the index as shown here:

```v play
count := []int{len: 4, init: index}
println(count) // [0, 1, 2, 3]

squares := []int{len: 6, init: index * index}
println(squares) // [0, 1, 4, 9, 16, 25]
```

## Array with initial length

You can create an array with a specific length using the `len` field:

```v play
nums := []int{len: 10}
println(nums.len) // 10
println(nums) // [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
```

`len`: *length* – the number of pre-allocated and initialized elements in the array.

## Array with initial capacity

You can create an array with a specific capacity using the `cap` field:

```v play
nums := []int{cap: 10}
println(nums.cap) // 10
println(nums.len) // 0
println(nums) // []
```

`cap`: *capacity* – the amount of memory space which has been reserved for elements,
but not initialized or counted as elements.
The array can grow up to this size without being reallocated.
Usually, V takes care of this field automatically, but there are cases where the user
may want to do manual optimizations (see [below](#array-initialization)).

## Array with initial length and capacity

You can use both `len` and `cap` fields to create an array with a specific length and capacity:

```v play
nums := []int{len: 10, cap: 20}
println(nums.len) // 10
println(nums.cap) // 20
println(nums) // [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
```

## Array element fetching

You can fetch an element from an array using the index operator `[]`:

```v play
mut nums := [1, 2, 3]
println(nums[0]) // 1
println(nums[1]) // 2
```

If the index is out of bounds of the array,
then a panic will be triggered and the program will end with an error:

```v play
mut nums := [1, 2, 3]
println(nums[3]) // panic: index out of range (i == 3, a.len == 3)
```

To return the default value if the array is out of bounds, use the `or` block:

```v play
mut nums := [1, 2, 3]
println(nums[3] or { 100 }) // 100
```

`or` block, as in the case of
[handling Result/Option types](../error-handling/overview.md#or-blocks),
can contain several statements:

```v play
mut nums := [1, 2, 3]
println(nums[3] or {
    println('index out of range')
    100
})
// index out of range
// 100
```

## Append to an array

An element can be appended to the end of an array using the push operator `<<`.

```v play
mut nums := [1, 2, 3]
nums << 4
println(nums) // [1, 2, 3, 4]
```

You can also add all the elements of another array using it:

```v play
mut nums := [1, 2, 3]
nums << [5, 6, 7]
println(nums) // [1, 2, 3, 4, 5, 6, 7]
```

## Check if an array contains a value

To check if an array contains a specific value, you can use the `in` operator:

```v play
names := ['John', 'Peter', 'Sam']
println('John' in names) // true
```

To check the opposite, use `!in`:

```v play
names := ['John', 'Peter', 'Sam']
println('John' !in names) // false
```

> **Note**
> Complexity of the `in` and `!in` operation for arrays is `O(n)`, where n is the length of the
> array.

## Multidimensional Arrays

Arrays can have more than one dimension.

2d array example:

```v play
mut a := [][]int{len: 2, init: []int{len: 3}}
a[0][1] = 2
println(a) // [[0, 2, 0], [0, 0, 0]]
```

3d array example:

```v play
mut a := [][][]int{len: 2, init: [][]int{len: 3, init: []int{len: 2}}}
a[0][1][1] = 2
println(a) // [[[0, 0], [0, 2], [0, 0]], [[0, 0], [0, 0], [0, 0]]]
```

## Array methods

All arrays can be easily printed with `println(arr)` and converted to a string
with `s := arr.str()`.

Copying the data from the array is done with `.clone()`:

```v
nums := [1, 2, 3]
nums_copy := nums.clone()
```

Arrays can be efficiently filtered and mapped with the `.filter()` and
`.map()` methods:

```v play
nums := [1, 2, 3, 4, 5, 6]
even := nums.filter(it % 2 == 0)
println(even) // [2, 4, 6]

// filter can accept anonymous functions
even_fn := nums.filter(fn (x int) bool {
	return x % 2 == 0
})
println(even_fn) // [2, 4, 6]
```

`.map()`:

```v play
words := ['hello', 'world']
upper := words.map(it.to_upper())
println(upper) // ['HELLO', 'WORLD']
// map can also accept anonymous functions
upper_fn := words.map(fn (w string) string {
	return w.to_upper()
})
println(upper_fn) // ['HELLO', 'WORLD']
```

### `it` variable

`it` is a special variable which refers to the element currently being
processed in filter/map methods.

Additionally, `.any()` and `.all()` can be used to conveniently test
for elements that satisfy a condition.

```v play
nums := [1, 2, 3]
println(nums.any(it == 2)) // true
println(nums.all(it >= 2)) // false
```

There are further built-in methods for arrays:

- `a.repeat(n)` concatenates the array elements `n` times
- `a.insert(i, val)` inserts a new element `val` at index `i` and
  shifts all following elements to the right
- `a.insert(i, [3, 4, 5])` inserts several elements
- `a.prepend(val)` inserts a value at the beginning, equivalent to `a.insert(0, val)`
- `a.prepend(arr)` inserts elements of array `arr` at the beginning
- `a.trim(new_len)` truncates the length (if `new_length < a.len`, otherwise does nothing)
- `a.clear()` empties the array without changing `cap` (equivalent to `a.trim(0)`)
- `a.delete_many(start, size)` removes `size` consecutive elements from index `start`
  – triggers reallocation
- `a.delete(index)` equivalent to `a.delete_many(index, 1)`
- `a.delete_last()` removes the last element
- `a.first()` equivalent to `a[0]`
- `a.last()` equivalent to `a[a.len - 1]`
- `a.pop()` removes the last element and returns it
- `a.reverse()` makes a new array with the elements of `a` in reverse order
- `a.reverse_in_place()` reverses the order of elements in `a`
- `a.join(joiner)` concatenates an array of strings into one string
  using `joiner` string as a separator

See all methods of [array](https://modules.vlang.io/index.html#array)

See also [vlib/arrays](https://modules.vlang.io/arrays.html).

### Array method chaining

You can chain the calls of array methods like `.filter()` and `.map()` and use the
[`it` built-in variable](#it-variable)
to achieve a classic `map/filter` functional paradigm:

```v play
// using filter, map and negatives array slices
files := ['pippo.jpg', '01.bmp', '_v.txt', 'img_02.jpg', 'img_01.JPG']
filtered := files.filter(it#[-4..].to_lower() == '.jpg').map(it.to_upper())
println(filtered) // ['PIPPO.JPG', 'IMG_02.JPG', 'IMG_01.JPG']
```

## Sorting arrays

Sorting arrays of all kinds is elementary and intuitive.
Special variables `a` and `b` are used when providing a custom sorting condition.

```v play
mut numbers := [1, 3, 2]
numbers.sort() // 1, 2, 3
numbers.sort(a > b) // 3, 2, 1
```

Through the variables `a` and `b`, you can also access the fields of structures:

```v play
struct User {
	age  int
	name string
}

mut users := [User{21, 'Bob'}, User{20, 'Zarkon'}, User{25, 'Alice'}]
users.sort(a.age < b.age) // sort by User.age int field
users.sort(a.name > b.name) // reverse sort by User.name string field
```

V also supports custom sorting, through the `sort_with_compare` array method.
Which expects a comparing function which will define the sort order.
Useful for sorting on multiple fields at the same time by custom sorting rules.
The code below sorts the array ascending on `name` and descending `age`.

```v play
struct User {
	age  int
	name string
}

mut users := [User{21, 'Bob'}, User{65, 'Bob'}, User{25, 'Alice'}]

custom_sort_fn := fn (a &User, b &User) int {
	// return -1 when a comes before b
	// return 0, when both are in same order
	// return 1 when b comes before a
	if a.name == b.name {
		if a.age < b.age {
			return 1
		}
		if a.age > b.age {
			return -1
		}
		return 0
	}
	if a.name < b.name {
		return -1
	} else if a.name > b.name {
		return 1
	}
	return 0
}
users.sort_with_compare(custom_sort_fn)
```

## Array slices

A slice is a part of a parent array.
Initially it refers to the elements between two indices separated by a `..` operator.
The right-side index must be greater than or equal to the left-side index.

If a right-side index is absent, it is assumed to be the array length.
If a left-side index is absent, it is assumed to be 0.

```v play
nums := [0, 10, 20, 30, 40]
println(nums[1..4]) // [10, 20, 30]
println(nums[..4]) // [0, 10, 20, 30]
println(nums[1..]) // [10, 20, 30, 40]
```

In V slices are arrays themselves (they are not distinct types).
As a result, all array operations may be performed on them.
E.g. they can be pushed onto an array of the same type:

```v play
array_1 := [3, 5, 4, 7, 6]
mut array_2 := [0, 1]
array_2 << array_1[..3]
println(array_2) // `[0, 1, 3, 5, 4]`
```

A slice is always created with the smallest possible capacity `cap == len` (see
[`cap` above](#array-initialization)) no matter what the capacity or length
of the parent array is.

As a result, it is immediately reallocated and copied to another memory location when
the size increases, thus becoming independent of the parent array (*copy on grow*).
In particular, pushing elements to a slice does not alter the parent:

```v play
mut a := [0, 1, 2, 3, 4, 5]
mut b := a[2..4]
b[0] = 7 // `b[0]` is referring to `a[2]`
println(a) // `[0, 1, 7, 3, 4, 5]`
b << 9

// `b` has been reallocated and is now independent from `a`
println(a) // `[0, 1, 7, 3, 4, 5]` – no change
println(b) // `[7, 3, 9]`
```

Appending the parent array may or may not make it independent of its child slices.
The behaviour depends on the parent's capacity and is predictable:

```v play
mut a := []int{len: 5, cap: 6, init: 2}
mut b := a[1..4]
a << 3

// no reallocation – fits in `cap`
b[2] = 13 // `a[3]` is modified
a << 4

// a has been reallocated and is now independent from `b` (`cap` was exceeded)
b[1] = 3 // no change in `a`
println(a) // `[2, 2, 2, 13, 2, 3, 4]`
println(b) // `[2, 3, 13]`
```

You can call `.clone()` on the slice, if you do want to have an independent copy right away:

```v nofmt play
mut a := [0, 1, 2, 3, 4, 5]
mut b := a[2..4].clone()
b[0] = 7 // `b[0]` is NOT referring to `a[2]`,
         //  as it would have been, without the `.clone()`
println(a) // [0, 1, 2, 3, 4, 5]
println(b) // [7, 3]
```

### Slices with negative indexes

V supports array and string slices with negative indexes.
Negative indexing starts from the end of the array towards the start,
for example `-3` is equal to `array.len - 3`.
Negative slices have a different syntax from normal slices, i.e. you need
to add a `gate` between the array name and the square bracket: `a#[..-3]`.
The `gate` specifies that this is a different type of slice and remember that
the result is "locked" inside the array.
The returned slice is always a valid array, though it may be empty:

```v play
a := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
println(a#[-3..]) // [7, 8, 9]
println(a#[-20..]) // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
println(a#[-20..-8]) // [0, 1]
println(a#[..-3]) // [0, 1, 2, 3, 4, 5, 6]

// empty arrays
println(a#[-20..-10]) // []
println(a#[20..10]) // []
println(a#[20..30]) // []
```

## Fixed size arrays

V also supports arrays with fixed size.
Unlike ordinary arrays, their length is constant.
You cannot append elements to them, nor shrink them.
You can only modify their elements in place.

However, access to the elements of fixed size arrays is more efficient,
they need less memory than ordinary arrays, and unlike ordinary arrays,
their data are on the stack, so you may want to use them as buffers if you
do not want additional heap allocations.

Most methods are defined to work on ordinary arrays, not on fixed size arrays.
You can convert a fixed size array to an ordinary array with slicing:

```v play
mut fnums := [3]int{} // fnums is a fixed size array with 3 elements.
fnums[0] = 1
fnums[1] = 10
fnums[2] = 100

println(fnums) // [1, 10, 100]
println(typeof(fnums).name) // [3]int

fnums2 := [1, 10, 100]! // short init syntax that does the same

anums := fnums[..] // same as `anums := fnums[0..fnums.len]`
println(anums) // [1, 10, 100]
println(typeof(anums).name) // []int
```

Note that slicing will cause the data of the fixed size array to be copied to
the newly created ordinary array.
