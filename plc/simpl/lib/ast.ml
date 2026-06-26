type binop =
  | Add
  | Mul
  | Leq

type id = string

type expr =
  | Id of id
  | Num of int
  | True
  | False
  | Fun of id * expr
  | Binop of binop * expr * expr
  | If of expr * expr * expr
  | Let of id * expr * expr 
  | App of expr * expr
  | LetRec of id * id * expr * expr