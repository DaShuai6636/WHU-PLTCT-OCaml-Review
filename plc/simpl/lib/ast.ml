type binop =
  | Add
  | Mul
  | Leq

type expr =
  | Var of string
  | Int of int
  | Bool of bool
  | Binop of binop * expr * expr
  | If of expr * expr * expr
  | Let of string * expr * expr

type typ =
  | TInt
  | TBool

type tyenv = (string * typ) list

type value =
  | VInt of int
  | VBool of bool

type env = (string * value) list
