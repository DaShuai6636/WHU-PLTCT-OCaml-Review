{
open Parser

exception SyntaxError of string
}

rule token = parse
  | [' ' '\t' '\r' '\n'] { token lexbuf }
  | eof { EOF }
  | _ { failwith "TODO: implement lexer" }
