{
open Parser
}

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let id = alpha (alpha | digit | '_')*

rule read = parse
  | [' ' '\t' '\r' '\n']+ { read lexbuf }
  | ";" { SEMICOLON } | ":=" { ASSIGN }
  | "+" { PLUS } | "-" { MINUS } | "*" { TIMES } | "/" { DIVIDE }
  | "(" { LPAREN } | ")" { RPAREN } | "<" { LT } | "=" { EQ }
  | "IF" { IF } | "THEN" { THEN } | "ELSE" { ELSE } | "END" { END }
  | "REPEAT" { REPEAT } | "UNTIL" { UNTIL } | "PRINT" { PRINT }
  | "TRUE" { TRUE } | "FALSE" { FALSE }
  | digit+ as n { NUM (int_of_string n) }
  | id as name { ID name }
  | eof { EOF }
  | _ as c { failwith (Printf.sprintf "Lexical error: unexpected character %c" c) }
