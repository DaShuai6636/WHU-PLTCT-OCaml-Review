type value =
  | IntVal of int
  | BoolVal of bool

type env = unit

let empty_env = ()

let todo name = failwith ("TODO: implement Interpreter." ^ name)

let eval_expr _env _expr = todo "eval_expr"

let eval_stmt _env _stmt = todo "eval_stmt"

let eval_stmts _env _stmts = todo "eval_stmts"

let eval_program _program = todo "eval_program"
