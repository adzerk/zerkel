/* lexical grammar */
%lex
%%
"/*"(.|\r|\n)*?"*/"          {/* skip comments*/}
"//".*($|\r\n|\r|\n)         {/* skip comments*/}
\s+                          {/* skip whitespace */}
"and"|"AND"                  {return 'AND';}
"or"|"OR"                    {return 'OR';}
"not"|"NOT"                  {return 'NOT';}
"=~"                         {return '=~';}
"!~"                         {return '!~';}
"="                          {return '=';}
"<>"                         {return '<>';}
"<="                         {return '<=';}
">="                         {return '>=';}
"<"                          {return '<';}
">"                          {return '>';}
"contains"|"CONTAINS"        {return 'CONTAINS';}
"like"|"LIKE"                {return 'LIKE';}
[\-]?[0-9]+                  {return 'INTEGER';}
\"[^\"]*\"                   {return 'STRING';}
[A-Za-z_$]([A-Za-z0-9_$]+)*  {return 'VAR';}
"("                          {return '(';}
")"                          {return ')';}
"["                          {return '[';}
"]"                          {return ']';}
","                          {return ',';}
"."                          {return '.';}
<<EOF>>                      {return 'EOF';}

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
        {return $1;}
    ;
e
    : NOT e
        {$$ = ['not', $2];}
    | '(' e ')'
        {$$ = $2;}
    | e AND e
        {$$ = ['and', $1, $3];}
    | e OR e
        {$$ = ['or', $1, $3];}
    | value '=' value
        {$$ = ['eq', $1, $3];}
    | value '<>' value
        {$$ = ['ne', $1, $3];}
    | value '<=' value
        {$$ = ['le', $1, $3];}
    | value '>=' value
        {$$ = ['ge', $1, $3];}
    | value '<' value
        {$$ = ['lt', $1, $3];}
    | value '>' value
        {$$ = ['gt', $1, $3];}
    | arrayvalue CONTAINS value
        {$$ = ['in', $1, $3];}
    | value CONTAINS value
        {$$ = ['in', $1, $3];}
    | value LIKE value
        {$$ = ['like', $1, $3];}
    | value '=~' string
        {$$ = ['match', $1, $3];}
    | value '!~' string
        {$$ = ['nomatch', $1, $3];}
    | value
        {$$ = $1;}
    ;
arrayitems
    : integer
        {$$ = [$1];}
    | string
        {$$ = [$1];}
    | arrayitems ',' integer
        {$$ = $1.concat([$3]);}
    | arrayitems ',' string
        {$$ = $1.concat([$3]);}
    ;
arrayvalue
    : '[' ']'
        {$$ = ['array'];}
    | '[' arrayitems ']'
        {$$ = ['array'].concat($2);}
    ;
value
    : integer
        {$$ = $1;}
    | string
        {$$ = $1;}
    | variable
        {$$ = $1;}
    ;
integer
    : INTEGER
        {$$ = Number(yytext);}
    ;
string
    : STRING
        {$$ = yytext.substr(1, yytext.length - 2);}
    ;
variable
    : VAR
        {$$ = ['var', yytext];}
    | variable '.' VAR
        {$$ = $1.concat([$3]);}
    ;

%%
