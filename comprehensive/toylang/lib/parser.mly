%{
open Ast
%}

%token <int> NUM
%token <string> ID
%token TRUE FALSE
%token PLUS MINUS TIMES DIVIDE LT EQ LPAREN RPAREN
%token IF THEN ELSE END REPEAT UNTIL ASSIGN PRINT SEMICOLON EOF
%nonassoc LT EQ
%left PLUS MINUS
%left TIMES DIVIDE
%start program
%type <Ast.program> program
%%
program:
  | stmt_seq EOF { $1 }
;
stmt_seq:
  | stmt SEMICOLON { [$1] }
  | stmt_seq stmt SEMICOLON { $1 @ [$2] }
;
stmt:
  | IF exp THEN stmt_seq END { IfStmt ($2, $4, None) }
  | IF exp THEN stmt_seq ELSE stmt_seq END { IfStmt ($2, $4, Some $6) }
  | REPEAT stmt_seq UNTIL exp { RepeatStmt ($2, $4) }
  | ID ASSIGN exp { AssignStmt ($1, $3) }
  | PRINT exp { PrintStmt $2 }
;
exp:
  | simple_exp { $1 }
  | simple_exp LT simple_exp { BinaryExp ($1, LtOp, $3) }
  | simple_exp EQ simple_exp { BinaryExp ($1, EqOp, $3) }
;
simple_exp:
  | simple_exp PLUS term { BinaryExp ($1, AddOp, $3) }
  | simple_exp MINUS term { BinaryExp ($1, SubOp, $3) }
  | term { $1 }
;
term:
  | term TIMES factor { BinaryExp ($1, MulOp, $3) }
  | term DIVIDE factor { BinaryExp ($1, DivOp, $3) }
  | factor { $1 }
;
factor:
  | NUM { IntExp $1 } | ID { VarRefExp $1 }
  | TRUE { BoolExp true } | FALSE { BoolExp false }
  | LPAREN exp RPAREN { $2 }
;
