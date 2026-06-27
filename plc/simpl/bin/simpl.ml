let read_all channel =
  let buffer = Buffer.create 128 in
  (try
     while true do
       Buffer.add_string buffer (input_line channel);
       Buffer.add_char buffer '\n'
     done
   with End_of_file -> ());
  Buffer.contents buffer

let with_input_file path f =
  let channel = open_in path in
  Fun.protect
    ~finally:(fun () -> close_in_noerr channel)
    (fun () -> f channel)

let run path =
  let input = with_input_file path read_all in
  let typ, value = Simpl.Driver.run_string input in
  Printf.printf "type: %s\n" (Simpl.Driver.string_of_typ typ);
  Printf.printf "value: %s\n" (Simpl.Driver.string_of_value value)

let () =
  match Array.to_list Sys.argv with
  | [ _; path ] -> (
      try run path with
      | Failure message -> Printf.printf "Error: %s\n" message
      | Simpl.Lexer.SyntaxError message -> Printf.printf "Error: %s\n" message
      | Parsing.Parse_error -> print_endline "Error: syntax error"
      | Sys_error message -> Printf.printf "Error: %s\n" message)
  | _ -> print_endline "Usage: simpl <input-file>"
