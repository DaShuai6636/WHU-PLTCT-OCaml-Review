type env

val empty_env : env
val type_of_expr : env -> Ast.expr -> Ast.typ
val typecheck_stmt : env -> Ast.stmt -> env
val typecheck_stmts : env -> Ast.stmt list -> env
val typecheck_program : Ast.program -> unit
