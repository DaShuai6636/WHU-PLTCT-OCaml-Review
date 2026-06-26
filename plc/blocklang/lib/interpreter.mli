type value =
  | IntVal of int
  | BoolVal of bool

type env

val empty_env : env
val eval_expr : env -> Ast.expr -> value * env
val eval_stmt : env -> Ast.stmt -> env
val eval_stmts : env -> Ast.stmt list -> env
val eval_program : Ast.program -> unit
