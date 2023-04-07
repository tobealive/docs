# ORM

V has a built-in ORM (object-relational mapping) which supports SQLite, MySQL, and Postgres.

V's ORM provides a number of benefits:

- One syntax for all SQL dialects. (Migrating between databases becomes much easier.)
- Queries are constructed using V's syntax. (There's no need to learn another syntax.)
- Safety. (All queries are automatically sanitised to prevent SQL injection.)
- Compile time checks. (This prevents typos which can only be caught during runtime.)
- Readability and simplicity. (You don't need to manually parse the results of a query and
  then manually construct objects from the parsed results.)

```v
import db.sqlite

// Sets a custom table name. Default is struct name (case-sensitive)
[table: 'customers']
struct Customer {
	id        int    [primary; sql: serial] // A field named `id` of integer type must be the first field
	name      string [nonull]
	nr_orders int
	country   string [nonull]
}

db := sqlite.connect(':memory:')!

// You can create tables:
// CREATE TABLE IF NOT EXISTS `Customer` (
//      `id` INTEGER PRIMARY KEY,
//      `name` TEXT NOT NULL,
//      `nr_orders` INTEGER,
//      `country` TEXT NOT NULL
// )
sql db {
	create table Customer
}!

// Insert a new customer
new_customer := Customer{
	name: 'Bob'
	nr_orders: 10
	country: 'uk'
}
sql db {
	insert new_customer into Customer
}!

// select count(*) from customers
nr_customers := sql db {
	select count from Customer
} or { 0 }
println('Number of all customers: ${nr_customers}')

// V syntax can be used to build queries
uk_customers := sql db {
	select from Customer where country == 'uk' && nr_orders > 0
}!

for customer in uk_customers {
	println('${customer.id} - ${customer.name}')
}
```

For more examples and the docs, see [vlib/orm](https://github.com/vlang/v/tree/master/vlib/orm).
