type typ =
  | IntType
  | BoolType

type binop =
  | Add
  | Mul
  | Lt
  | Eq

type expr =
  | IntExp of int
  | BoolExp of bool
  | VarExp of string
  | BinopExp of binop * expr * expr
  | IfExp of expr * expr * expr
  | BlockExp of stmt list * expr

and stmt =
  | AssignStmt of string * expr
  | PrintStmt of expr

type program = stmt list
