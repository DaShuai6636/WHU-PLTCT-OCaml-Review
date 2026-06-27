{
open Parser

exception SyntaxError of string
}

rule token = parse
  | [' ' '\t' '\r' '\n'] { token lexbuf }
  | eof { EOF }
  | ['0'-'9']+ as num { INT (int_of_string num) }
  | "TRUE" { TRUE }
  | "FALSE" { FALSE }
  | "IF" { IF }
  | "THEN" { THEN }
  | "ELSE" { ELSE }
  | "BLOCK" { BLOCK }
  | "RETURN" { RETURN }
  | "END" { END }
  | "PRINT" { PRINT }
  | ":=" { ASSIGN }
  | ";" { SEMI }
  | "+" { PLUS }
  | "*" { MUL }
  | "<" { LT }
  | "=" { EQ }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | ['a'-'z']+ as id { ID id }
  | _ { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }
