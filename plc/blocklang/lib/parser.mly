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
    /* TODO: implement BlockLang program grammar. */
    /* empty */ { [] }
;
