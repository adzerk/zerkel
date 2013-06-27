prog
  = combination

combination
  = and / or / not / clause

clause
  = eq / gt / lt / contains / primary

primary
  = value / "(" comb:combination ")" { return "(" + comb + ")"; }

and
  = left:clause space andStmt space right:combination { return left + "&&" + right; }

or
  = left:clause space orStmt space right:combination { return left + "||" + right; }

not
  = notStmt space clause:clause { return "!" + clause; }

eq
  = left:value space eqStmt space right:value { return left + "===" + right; }

gt
  = left:value space ">" space right:value { return left + ">" + right; }

lt
  = left:value space "<" space right:value { return left + "<" + right; }

contains
  = left:value space containsStmt space right:value { return "(" + left + ".indexOf(" + right + ")" + " >= 0)"}

/* Statements */
andStmt
  = "AND" / "and"

orStmt
  = "OR" / "or"

notStmt
  = "NOT" / "not"

containsStmt
  = "CONTAINS" / "contains"

eqStmt
  = "is" / "IS" / "="

/* builders */
letter
  = [A-Za-z]

space
  = [ ]+

/* values */
value
  = integer / string / var

var
  = letters:letter+ { return "_s['" + letters.join("") + "']"; }

string
  = "\"" letters:[^\"]+ "\"" { return "\"" + letters.join("") + "\""; }

integer
  = digits:[0-9]+ { return parseInt(digits.join(""), 10); }
