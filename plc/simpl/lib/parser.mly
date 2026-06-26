%{
    open Ast
%}

%token EOF
%token <string> ID
%token <int> INT
%token TRUE FALSE
%token IF THEN ELSE
%token FUN ARROW
%token PLUS MUL LEQ
%token LET IN REC EQUAL
%token LPAREN RPAREN

%start main
%type <Ast.expr> main

%%

main :
    expr EOF { $1 }
;

expr :
    | IF expr THEN expr ELSE expr { If ($2, $4, $6) }
    | FUN ID ARROW expr { Fun ($2, $4) }
    | LET ID EQUAL expr IN expr { Let ($2, $4, $6) }
    | LET REC ID ID EQUAL expr IN expr { LetRec ($3, $4, $6, $8) }
    | cmp_expr { $1 }
;

cmp_expr :
    | add_expr LEQ add_expr { Binop (Leq, $1, $3) }
    | add_expr { $1 }
;

add_expr :
    | add_expr PLUS mul_expr { Binop (Add, $1, $3) }
    | mul_expr { $1 }
;

mul_expr :
    | mul_expr MUL app_expr { Binop (Mul, $1, $3) }
    | app_expr { $1 }
;

app_expr :
    | app_expr atom { App ($1, $2) }
    | atom { $1 }
;

atom :
    | ID { Id $1 }
    | INT { Num $1 }
    | TRUE { True }
    | FALSE { False }
    | LPAREN expr RPAREN { $2 }
;
