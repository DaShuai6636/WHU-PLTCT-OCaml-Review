let parse_channel channel =
  let lexbuf = Lexing.from_channel channel in
  Blocklang.Parser.main Blocklang.Lexer.token lexbuf

let with_input_file path f =
  let channel = open_in path in
  Fun.protect
    ~finally:(fun () -> close_in_noerr channel)
    (fun () -> f channel)

let run path =
  let program = with_input_file path parse_channel in
  Blocklang.Typechecker.typecheck_program program;
  Blocklang.Interpreter.eval_program program

let () =
  match Array.to_list Sys.argv with
  | [ _; path ] -> (
      try run path with
      | Failure message -> Printf.printf "Error: %s\n" message
      | Blocklang.Lexer.SyntaxError message -> Printf.printf "Error: %s\n" message
      | Parsing.Parse_error -> print_endline "Error: syntax error"
      | Sys_error message -> Printf.printf "Error: %s\n" message)
  | _ -> print_endline "Usage: blocklang <input-file>"
