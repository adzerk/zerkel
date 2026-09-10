/* lexical grammar */
%lex
%x selector
%%
<INITIAL,selector>"/*"(.|\r|\n)*?"*/"          {/* skip comments*/}
<INITIAL,selector>"//".*($|\r\n|\r|\n)         {/* skip comments*/}
<INITIAL,selector>\s+                          {/* skip whitespace */}
/* don't simplify with "and"|"AND" because that triggers boolean operators to be found inside variables */
"and"                        {return 'AND';}
"AND"                        {return 'AND';}
"or"                         {return 'OR';}
"OR"                         {return 'OR';}
"not"                        {return 'NOT';}
"NOT"                        {return 'NOT';}
"=~"                         {return '=~';}
"!~"                         {return '!~';}
"="                          {return '=';}
"<>"                         {return '<>';}
"<="                         {return '<=';}
">="                         {return '>=';}
"<"                          {return '<';}
">"                          {return '>';}
"."                          {this.begin("selector"); return '.';}
"contains"                   {return 'CONTAINS';}
"CONTAINS"                   {return 'CONTAINS';}
"like"                       {return 'LIKE';}
"LIKE"                       {return 'LIKE';}
[\-]?[0-9]+                  {return 'INTEGER';}
\"[^\"]*\"                   {return 'STRING';}
[A-Za-z_$]([A-Za-z0-9_$]+)*  {return 'VAR';}
<selector>[A-Za-z_$]([A-Za-z0-9_$]+)*  {this.popState(); return 'VAR';}
<selector>.                  { throw "expecting VAR after '.'" }
"("                          {return '(';}
")"                          {return ')';}
"["                          {return '[';}
"]"                          {return ']';}
","                          {return ',';}
<<EOF>>                      { return 'EOF';}
/lex

/* operator associations and precedence */

%left DOT
%left '=' '<>' '=~' '!~'
%left '<=' '>=' '<' '>'
%left AND OR
%left NOT
%left CONTAINS LIKE

%start expressions

%% /* language grammar */

expressions
    : e EOF
        %{
          var refs = uniqueSortedSafeIntegers($1.references);
          var complete = $1.segmentUses === $1.supportedSegmentUses;
          var code = "(_helpers['captureSegmentMetadata'](" + JSON.stringify(refs) + "," + complete + ")," + $1.code + ")";
          return (code.length >= exports.MIN_GZIP_SIZE) ? "GZ:" + require('zlib').gzipSync(Buffer.from(code)).toString('base64') : code;
        }
    ;
e
    : NOT e
        {$$ = combine("!" + $2.code, [$2]);}
    | '(' e ')'
        {$$ = combine("(" + $2.code + ")", [$2]);}
    | e AND e
        {$$ = combine($1.code + " && " + $3.code, [$1, $3]);}
    | e OR e
        {$$ = combine($1.code + " || " + $3.code, [$1, $3]);}
    | value '=' value
        {$$ = combine($1.code + "==" + $3.code, [$1, $3]);}
    | value '<>' value
        {$$ = combine($1.code + "!=" + $3.code, [$1, $3]);}
    | value '<=' value
        {$$ = combine($1.code + $2 + $3.code, [$1, $3]);}
    | value '>=' value
        {$$ = combine($1.code + $2 + $3.code, [$1, $3]);}
    | value '<' value
        {$$ = combine($1.code + $2 + $3.code, [$1, $3]);}
    | value '>' value
        {$$ = combine($1.code + $2 + $3.code, [$1, $3]);}
    | arrayvalue CONTAINS value
        {$$ = containsValue($1, $3);}
    | value CONTAINS value
        {$$ = containsValue($1, $3);}
    | value LIKE value
        {$$ = combine("_helpers['match'](" + $1.code + "," + $3.code + ")", [$1, $3]);}
    | value '=~' STRING
        {new RegExp($3.substr(1, $3.length - 2)); $$ = combine("_helpers['regex'](" + $1.code + "," + JSON.stringify($3.substr(1, $3.length - 2)) + ")", [$1]);}
    | value '!~' STRING
        {new RegExp($3.substr(1, $3.length - 2)); $$ = combine("!_helpers['regex'](" + $1.code + "," + JSON.stringify($3.substr(1, $3.length - 2)) + ")", [$1]);}
    | value
        {$$ = $1;}
    ;
arrayitems
    : INTEGER
        {$$ = integerValue(yytext);}
    | STRING
        {$$ = literalValue(yytext, 'string');}
    | arrayitems ',' INTEGER
        {$$ = combine($1.code + $2 + Number($3), [$1]);}
    | arrayitems ',' STRING
        {$$ = combine($1.code + $2 + $3, [$1]);}
    ;
arrayvalue
    : '[' ']'
        {$$ = combine($1+$2, []);}
    | '[' arrayitems ']'
        {$$ = combine($1+$2.code+$3, [$2]);}
    ;
value
    : INTEGER
        {$$ = integerValue(yytext);}
    | STRING
        {$$ = literalValue(yytext, 'string');}
    | variable
        {$$ = $1;}
    ;
variable
    : VAR
        {$$ = variableValue(yytext, "_env." + yytext);}
    | variable '.' VAR
        {$$ = variableValue($1.path + "." + $3, "(" + $1.code + "||{})." + $3);}
    ;

%%

MIN_GZIP_SIZE = exports.MIN_GZIP_SIZE = Infinity;

function semanticValue(code, kind, path, integer, references, segmentUses, supportedSegmentUses) {
  return {
    code: code,
    kind: kind || 'expression',
    path: path,
    integer: integer,
    references: references || [],
    segmentUses: segmentUses || 0,
    supportedSegmentUses: supportedSegmentUses || 0
  };
}

function combine(code, values) {
  var references = [];
  var segmentUses = 0;
  var supportedSegmentUses = 0;

  values.forEach(function(value) {
    references = references.concat(value.references);
    segmentUses += value.segmentUses;
    supportedSegmentUses += value.supportedSegmentUses;
  });

  return semanticValue(code, 'expression', undefined, undefined,
    references, segmentUses, supportedSegmentUses);
}

function literalValue(code, kind) {
  return semanticValue(code, kind);
}

function integerValue(text) {
  var value = Number(text);
  return semanticValue(String(value), 'integer', undefined, value);
}

function variableValue(path, code) {
  var usesSegments = path === '$user.segments' || path.indexOf('$user.segments.') === 0;
  return semanticValue(code, 'variable', path, undefined, [], usesSegments ? 1 : 0, 0);
}

function containsValue(left, right) {
  var result = combine("_helpers['idxof'](" + left.code + "," + right.code + ")", [left, right]);
  if (left.path === '$user.segments' && right.kind === 'integer' && Number.isSafeInteger(right.integer)) {
    result.references.push(right.integer);
    result.supportedSegmentUses += 1;
  }
  return result;
}

function uniqueSortedSafeIntegers(values) {
  var seen = Object.create(null);
  var result = [];

  values.forEach(function(value) {
    var key = String(value);
    if (!Number.isSafeInteger(value) || seen[key]) return;
    seen[key] = true;
    result.push(value);
  });

  return result.sort(function(left, right) { return left - right; });
}
