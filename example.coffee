#!/usr/bin/env coffee

zerkel = require './'

query = "(x > 1) and ((y = 0) OR (y > 2))"

fn = zerkel.compile query

# prints "true"
console.log fn {x: 10, y: 3}

# print "false"
console.log fn {x: 10, y: 2}

# print "false"
console.log fn {x: 1, y: 3}
