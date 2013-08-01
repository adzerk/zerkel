prog
  = optionalSpace comb:combination optionalSpace { return comb; }

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
  = left:clause requiredSpace andOp requiredSpace right:combination { return left + "&&" + right; }

or
  = left:clause requiredSpace orOp requiredSpace right:combination { return left + "||" + right; }

not
  = notOp requiredSpace clause:clause { return "!" + clause; }

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
eq
  = left:value optionalSpace eqOp optionalSpace right:value { return left + "==" + right; }

notEq
  = left:value optionalSpace notEqOp optionalSpace right:value { return left + "!=" + right; }

numComp
  = left:value optionalSpace op:numCompOp optionalSpace right:value { return left + op + right; }

contains
  = left:value requiredSpace containsOp requiredSpace right:value { return "(" + left + "&&" + left + ".indexOf(" + right + ")" + " >= 0)"; }

like
  = left:value requiredSpace likeOp requiredSpace right:value { return "_helpers['match'](" + left + "," + right + ")"; }

/* values */
letter
  = [A-Za-z]

space
  = [ \n\t\r]

optionalSpace
  = space*

requiredSpace
  = space+

value
  = integer / string / var

var
  = letters:letter+ { return "_env['" + letters.join("") + "']"; }

string
  = "\"" letters:[^\"]+ "\"" { return "\"" + letters.join("") + "\""; }

integer
  = digits:[0-9]+ { return parseInt(digits.join(""), 10); }
