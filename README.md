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

###Status
[![Build Status](https://travis-ci.org/adzerk/zerkel.png?branch=master)](https://travis-ci.org/adzerk/zerkel)

###License
Apache 2.0
