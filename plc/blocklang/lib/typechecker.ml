type env = unit

let empty_env = ()

let todo name = failwith ("TODO: implement Typechecker." ^ name)

let type_of_expr _env _expr = todo "type_of_expr"

let typecheck_stmt _env _stmt = todo "typecheck_stmt"

let typecheck_stmts _env _stmts = todo "typecheck_stmts"

let typecheck_program _program = todo "typecheck_program"
