open Toylang

let () =
  let file = ref None in
  let usage = "Usage: toylang <file>" in
  Arg.parse [] (fun name -> file := Some name) usage;
  match !file with
  | None -> Arg.usage [] usage
  | Some name ->
    (try
       let input = open_in name in
       let program = Parser.program Lexer.read (Lexing.from_channel input) in
       close_in input;
       Typechecker.check_program program;
       Interpreter.interpret_program program
     with
     | Failure message | Sys_error message ->
       Printf.eprintf "Error: %s\n" message; exit 1
     | error ->
       Printf.eprintf "Error: %s\n" (Printexc.to_string error); exit 1)
