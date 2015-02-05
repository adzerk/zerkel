zerkel = require './'

query = "(athleteId = 36 OR athleteId = 2170721) AND NOT (email)"

fn = zerkel.compile query

console.log fn {athleteId: 36, email: false}
