{
open Parser

exception SyntaxError of string
}

let digit = ['0'-'9']
let ident_start = ['a'-'z' 'A'-'Z' '_']
let ident_char = ['a'-'z' 'A'-'Z' '0'-'9' '_']

rule token = parse
  | [' ' '\t' '\r' '\n'] { token lexbuf }
  | "(*" { comment 1 lexbuf; token lexbuf }
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
      | "if" -> IF
      | "then" -> THEN
      | "else" -> ELSE
      | "fun" -> FUN
      | "let" -> LET
      | "in" -> IN
      | "rec" -> REC
      | "true" -> TRUE
      | "false" -> FALSE
      | _ -> ID id
    }
  | eof { EOF }
  | _ as c {
      raise (SyntaxError (Printf.sprintf "unexpected character: %c" c))
    }

and comment depth = parse
  | "(*" { comment (depth + 1) lexbuf }
  | "*)" { if depth = 1 then () else comment (depth - 1) lexbuf }
  | eof { raise (SyntaxError "unterminated comment") }
  | _ { comment depth lexbuf }
