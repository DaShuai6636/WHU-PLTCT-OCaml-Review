%{
open Ast
%}

%token EOF
%token <string> ID
%token <int> INT
%token TRUE FALSE
%token IF THEN ELSE
%token BLOCK RETURN END PRINT
%token ASSIGN SEMI
%token PLUS MUL LT EQ
%token LPAREN RPAREN

%start main
%type <Ast.program> main

%%

main :
    program EOF { $1 }
;

program :
    | /* empty */ { [] }
    | stmt program { $1 :: $2 }
;

stmt :
    | ID ASSIGN expr SEMI { AssignStmt ($1 , $3) }
    | PRINT expr SEMI { PrintStmt ($2) } 
;

expr :
    | IF expr THEN expr ELSE expr { IfExp ($2 , $4 , $6) }
    | BLOCK program RETURN expr END { BlockExp ($2 , $4) }
    | cmp_expr { $1 }
;

cmp_expr :
    | add_expr EQ add_expr { BinopExp (Eq , $1 ,$3) }
    | add_expr LT add_expr { BinopExp (Lt , $1 ,$3) }
    | add_expr { $1 }
;

add_expr :
    | add_expr PLUS mul_expr { BinopExp (Add, $1, $3) }
    | mul_expr { $1 }
;

mul_expr :
    | mul_expr MUL atom { BinopExp (Mul, $1, $3) }
    | atom { $1 }
;

atom :
    | ID { VarExp $1 }
    | INT { IntExp $1 }
    | TRUE { BoolExp true }
    | FALSE { BoolExp false }
    | LPAREN expr RPAREN { $2 }
;
