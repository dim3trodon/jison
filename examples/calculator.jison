
/* description: Parses end executes mathematical expressions. */

//var symbol_table = {};

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"!"                   return '!'
"%"                   return '%'
"("                   return '('
")"                   return ')'
"PI"                  return 'PI'
"E"                   return 'E'
<<EOF>>               return 'EOF'
.                     return 'INVALID'
[0-9azAZ_]+\w*        return 'ID'

/lex

/* operator associations and precedence */
%right '='
%left '+' '-'
%left '*' '/'
%left '^'
%right '!'
%right '%'
%left UMINUS


%start expressions

%% /* language grammar */

prog
 : expressions EOF
 {
   $$ = $1;
   console.log($$);
   return [$$, symbol_table];
}
;


expressions
    : s 
      { $$ = $1? [ $1 ] : []; }
    | expressions ';' s
      { $$ = $1; if($3) $$.push($3); console.log($$); }
    //: e EOF //no está
      //  { typeof console !== 'undefined' ? console.log($1) : print($1);
        //  return $1; }
    ;

s 
	: /* empty */
	| e
	;

e
	: ID '=' e
	  { if(/*($3.match(/[0-9a-zA-Z_]+\w) && */(symbol_table[$3] === undefined))
              throw new Error("Variable hasn't been initialized");
            else
              symbol_table[$1] = $$ = $3; 
          } // Hash de símbolos
	| PI '=' e
         { throw new Error("Can't assign to constant PI"); }
	| E '=' e
         { throw new Error("Can't assign to constant E"); }
	| e '+' e
	  {$$ = $1+$3;}
	| e '-' e
	  {$$ = $1-$3;}
	| e '*' e
	  {$$ = $1*$3;}
	| e '/' e
	  { if ($3 == 0) throw new Error("Division by zero"); else $$ = $1/$3; }
	| e '^' e
	  {$$ = Math.pow($1, $3);}
	| e '!'
	  {{
	    $$ = (function fact (n) { return n==0 ? 1 : fact(n-1) * n })($1);
	  }}
	| e '%'
	  {$$ = $1/100;}
	| '-' e %prec UMINUS
	  {$$ = -$2;}
	| '(' e ')'
	  {$$ = $2;}
	| NUMBER
	  {$$ = Number(yytext);}
	| E
	  {$$ = Math.E;}
	| PI
	  {$$ = Math.PI;}
	| ID
	  {$$ = symbol_table[$1];}
        //Para hacer listas de sentencias mirar la gramática de la práctica anterior
        ;

