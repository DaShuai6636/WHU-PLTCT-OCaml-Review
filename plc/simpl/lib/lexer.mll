{
open Parser

exception SyntaxError of string
}

rule token = parse
  | [' ' '\t' '\r' '\n'] { token lexbuf }
  | eof { EOF }
  | _ as c {
      raise (SyntaxError (Printf.sprintf "TODO lexer: unexpected character %C" c))
    }
