let parse_string input =
  let lexbuf = Lexing.from_string input in
  Parser.main Lexer.token lexbuf

let run_string input =
  let expr = parse_string input in
  let typ = Typechecker.infer [] expr in
  let value = Interpreter.eval [] expr in
  (typ, value)

let string_of_typ = function
  | Ast.TInt -> "int"
  | Ast.TBool -> "bool"

let string_of_value = function
  | Ast.VInt n -> string_of_int n
  | Ast.VBool true -> "true"
  | Ast.VBool false -> "false"
