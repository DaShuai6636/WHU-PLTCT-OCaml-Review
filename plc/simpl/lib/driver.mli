val parse_string : string -> Ast.expr
val run_string : string -> Ast.typ * Ast.value
val string_of_typ : Ast.typ -> string
val string_of_value : Ast.value -> string
