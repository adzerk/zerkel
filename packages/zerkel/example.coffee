#!/usr/bin/env coffee

zerkel = require './'

query = "(x > 1) and ((y = 0) OR (y > 2)) OR [5,4,3,2,1] contains z"

fn = zerkel.compile query

# prints "true"
console.log fn {x: 10, y: 3}

# print "false"
console.log fn {x: 10, y: 2}

# print "false"
console.log fn {x: 1, y: 3}

# print "true"
console.log fn {z: 3}
