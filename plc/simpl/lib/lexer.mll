{
open Parser

exception SyntaxError of string
}

let digit = ['0'-'9']
let ident_start = ['a'-'z' 'A'-'Z' '_']
let ident_char = ['a'-'z' 'A'-'Z' '0'-'9' '_']

rule token = parse
  | [' ' '\t' '\r' '\n'] { token lexbuf }
  | "->" { ARROW }
  | "<=" { LEQ }
  | "+" { PLUS }
  | "*" { MUL }
  | "=" { EQUAL }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | digit+ as n { INT (int_of_string n) }
  | ident_start ident_char* as id {
      match id with
      | "true" -> TRUE
      | "false" -> FALSE
      | "if" -> IF
      | "then" -> THEN
      | "else" -> ELSE
      | "let" -> LET
      | "in" -> IN
      | "fun" -> FUN
      | _ -> ID id
    }
  | eof { EOF }
  | _ as c {
      raise (SyntaxError (Printf.sprintf "unexpected character %C" c))
    }
