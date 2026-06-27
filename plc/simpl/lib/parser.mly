%{
open Ast
%}

%token EOF
%token <string> ID
%token <int> INT
%token TRUE FALSE
%token IF THEN ELSE
%token PLUS MUL LEQ
%token LET IN EQUAL
%token LPAREN RPAREN

%start main
%type <Ast.expr> main

%%

main :
    expr EOF { $1 }
;

expr :
    | INT { failwith "TODO: parser" }
;
