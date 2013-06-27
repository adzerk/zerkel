zerkel = require './'

query = "(x > 1) and ((y is 0) OR (y > 2))"

fn = zerkel.parse query

console.log fn {x: 10, y: 3}
