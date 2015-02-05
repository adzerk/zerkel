/* lexical grammar */
%lex
%%
\s+                          {/* skip whitespace */}
"and"|"AND"                  {return 'AND';}
"or"|"OR"                    {return 'OR';}
"not"|"NOT"                  {return 'NOT';}
"="                          {return '=';}
"<>"                         {return '<>';}
"<="|">="|"<"|">"            {return 'LTGT';}
"contains"|"CONTAINS"        {return 'CONTAINS';}
"like"|"LIKE"                {return 'LIKE';}
[\-0-9]+([0-9]+)*            {return 'INTEGER';}
\"[^\"]*\"                   {return 'STRING';}
[\$A-Za-z_]+([A-Za-z0-9_\.]+)*  {return 'VAR';}
"("                          {return 'OPEN';}
")"                          {return 'CLOSE';}
"/*"(.|\r|\n)*?"*/"          {/* skip comments*/}
<<EOF>>                      {return 'EOF';}

/lex

/* operator associations and precedence */

%left '=' '<>'
%left 'LTGT'
%left 'AND' 'OR'
%left 'NOT'
%left 'CONTAINS' 'LIKE'

%start expressions

%% /* language grammar */

expressions
    : e EOF
        {return $1;}
    ;
e
    : 'NOT' e
        {$$ = "!" + $2;}
    | 'OPEN' e 'CLOSE'
        {$$ = "(" + $2 + ")";}
    | e 'AND' e
        {$$ = $1 + " && " + $3;}
    | e 'OR' e
        {$$ = $1 + " || " + $3;}
    | value '=' value
        {$$ = $1 + "==" + $3;}
    | value '<>' value
        {$$ = $1 + "!=" + $3;}
    | value 'LTGT' value
        {$$ = $1 + $2 + $3}
    | value 'CONTAINS' value
        {$$ = "(" + $1 + "&&" + $1 + ".indexOf(" + $3 + ")" + " >= 0)"; }
    | value 'LIKE' value
        {$$ = "_helpers['match'](" + $1 + "," + $3 + ")";}
    | value
        {$$ = $1;}
    ;
value
    : INTEGER
        {$$ = Number(yytext);}
    | STRING
        {$$ = yytext;}
    | VAR
        {$$ = "_helpers['getIn'](_env, '" + yytext + "')";}
    ;
