prog
  = combination

combination
  = and / or / not / clause

clause
  = eq / notEq / numComp / contains / like / primary

primary
  = value / "(" comb:combination ")" { return "(" + comb + ")"; }

/* Compound Ops */
andOp
  = "AND" / "and"

orOp
  = "OR" / "or"

notOp
  = "NOT" / "not"

and
  = left:clause space andOp space right:combination { return left + "&&" + right; }

or
  = left:clause space orOp space right:combination { return left + "||" + right; }

not
  = notOp space clause:clause { return "!" + clause; }

/* Ops */
containsOp
  = "CONTAINS" / "contains"

likeOp
  = "LIKE" / "like"

eqOp
  = "="

notEqOp
  = "<>"

numCompOp
  = ">" / "<" / ">=" / "<="

stringEq
  = left:stringOrVar space eqOp space right:stringOrVar { return "(_helpers['strEqual'](" + left + "," + right + "))"; }

stringNotEq
  = left:stringOrVar space notEqOp space right:stringOrVar { return "(!_helpers['strEqual'](" + left + "," + right + "))"; }

eq
  = stringEq / left:value space eqOp space right:value { return left + "==" + right; }

notEq
  = stringNotEq / left:value space notEqOp space right:value { return left + "!=" + right; }

numComp
  = left:value space op:numCompOp space right:value { return left + op + right; }

contains
  = left:value space containsOp space right:value { return "(" + left + ".indexOf(" + right + ")" + " >= 0)"; }

like
  = left:value space likeOp space right:value { return "_helpers['match'](" + left + "," + right + ")"; }

/* values */
letter
  = [A-Za-z]

space
  = [ \n\t\r]+

value
  = integer / string / var

stringOrVar
  = string / var

var
  = letters:letter+ { return "_env['" + letters.join("").toLowerCase() + "']"; }

string
  = "\"" letters:[^\"]+ "\"" { return "\"" + letters.join("") + "\""; }

integer
  = digits:[0-9]+ { return parseInt(digits.join(""), 10); }
