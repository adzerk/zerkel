#zerkel
An adzerk-based query-ish language.

###Language
Zerkel exposes basic logic operators. The included operators are:
 * AND
 * OR
 * NOT
 * =
 * <> (not equal)
 * >
 * <
 * >=
 * <=
 * CONTAINS

Thus, queries may be written like:

```sql
count > 43 and (user = "bob" or user = "alice")
keywords contains "awesome"
```

All operators are available in upper and lowercase forms.

###Usage
Queries can executed in coffeescript/javascript using the zerkel module, like so:

```coffeescript
zerkel = require 'zerkel'

query = 'count > 43 and (user = "bob" or user = "alice")'
matchFn = zerkel.compile query
matchFn {count: 50, user: 'bob'} # true
matchFn {count: 12, user: 'alice'} # false
matchFn {count: 50, user: 'George Michael'} # terribly, unfortunately, false
```

You can also access properties on passed in objects, like so:

```coffeescript
zerkel = require 'zerkel'

query = 'user.location = "open field west of a white house"'
matchFn = zerkel.compile query
matchFn {user: {name: 'bob', location: 'open field west of a white house'}} # true
matchFn {user: {name: 'alice', location: 'middle earth'}} # false
```

###Gzip
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

###Status
[![Build Status](https://travis-ci.org/adzerk/zerkel.png?branch=master)](https://travis-ci.org/adzerk/zerkel)

###License
Apache 2.0
