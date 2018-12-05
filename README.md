# zerkel [![Build Status](https://travis-ci.org/adzerk/zerkel.png?branch=master)](https://travis-ci.org/adzerk/zerkel)

The Adzerk custom targeting query language.

### Language

Zerkel provides primitive integer and string literals, identifiers, sets, and a
selection of boolean operators:

| operator/type     | comment                     | examples   |
|-------------------|-----------------------------|------------|
| *integers*        | syntax                      | `42`, `-7` |
| *strings*         | syntax                      | `"foo"`, `"C:\\\\Windows\\System32"`, `"^(foo\|bar)\s+"` |
| *variables*       | syntax                      | `count`, `_foo_bar`, `$location.postalCode` |
| **`.`**           | property accessor           | `$location.postalCode`, `foo.bar.baz` |
| **`[`**, **`]`**  | set construction            | `[42, "foo"]` |
| **`(`**, **`)`**  | expression grouping         | `x < 100 AND (y < 50 OR z < 10)` |
| **`=`**           | equality                    | `foo = 42` |
| **`<>`**          | not equal                   | `foo <> "bar"` |
| **`=~`**          | regex match                 | `foo =~ "^(some\|regular\|expression).*$"` |
| **`!~`**          | not regex match             | `foo !~ "^(some\|regular\|expression).*$"` |
| **`>`**           |                             | `foo > 42` |
| **`<`**           |                             | `foo < 42` |
| **`>=`**          |                             | `foo >= 42` |
| **`<=`**          |                             | `foo <= 42` |
| **`AND`**         |                             | `foo = 42 AND bar < 100` |
| **`OR`**          |                             | `foo = 42 OR bar < 100` |
| **`NOT`**         |                             | `NOT (bar =~ "^foo")` |
| **`LIKE`**        | wildcard match              | `foo LIKE "ba*"` |
| **`CONTAINS`**    | set membership / substring  | `["foo", "bar"] CONTAINS "foo"`, `"foobar" CONTAINS "foo"` |

Thus, queries may be written like:

```sql
count > 43 and (user = "bob" or user = "alice")
keywords contains "awesome"
```

All operators are available in upper and lowercase forms.

### Demo

Check out the live [Zerkel scratchpad][demo] demo app and try some zerkel
queries in your browser.

### Usage

Queries can executed in coffeescript/javascript using the zerkel module, like so:

```coffeescript
zerkel = require 'zerkel'

query = 'count > 43 and (user = "bob" or user = "alice")'
matchFn = zerkel.compile query
matchFn {count: 50, user: 'bob'} # true
matchFn {count: 12, user: 'alice'} # false
matchFn {count: 50, user: 'george'} # false
```

You can also access properties on passed in objects, like so:

```coffeescript
zerkel = require 'zerkel'

query = 'user.location = "open field west of a white house"'
matchFn = zerkel.compile query
matchFn {user: {name: 'bob', location: 'open field west of a white house'}} # true
matchFn {user: {name: 'alice', location: 'middle earth'}} # false
```

## Clientside

Precompiled a Zerkel queries can be evaluated in a browser client, as well.

In NodeJS:

```coffeescript
zerkel = require 'zerkel'

precompiled = zerkel.parser.parse 'count > 43 and ["bob", "alice"] contains user'
```

In the client:

```html
<script src="dist/zerkel-runtime.min.js"></script>
<script>
var precompiled = '...'; // The precompiled query from NodeJS above.
var predicateFn = zerkelRuntime.makePredicate(precompiled);
var result      = predicateFn({count: 50, user: 'bob'});
</script>
```

> **Note:** The clientside Zerkel runtime does not support gzip.

### Gzip

Set the `parser.MIN_GZIP_SIZE` to a number, and if the length of the compiled
JavaScript is greater than that it will be gzipped and base64 encoded, with
`GZ:` prepended. The `zerkel#makePredicate` function will unzip automatically
as necessary.

```coffeescript
parser = require 'zerkel-parser'

parser.MIN_GZIP_SIZE = 50
parser.parse 'foo = 42'              # _helpers['getIn'](_env, 'foo')==42'
parser.parse '[42, 43] contains foo' # GZ:H4sIAAAAAAAAA9OINjHSMTGOVVODMvQy81JSK/zTNOIzUnMKUouKo9XTU0s889RjNeJT88p0FNTT8vPVNTUV7GwVDDQBm8CsuD8AAAA=
```

### License

Copyright © 2017 Adzerk, Inc.
Distributed under the [Apache License, Version 2.0][apache].

[apache]: https://www.apache.org/licenses/LICENSE-2.0
[demo]: https://adzerk.github.io/zerkel/
