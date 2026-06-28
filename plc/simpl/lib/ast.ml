module StringMap = Map.Make (String)

type binop =
  | Add
  | Mul
  | Leq

type expr =
  | Var of string
  | Int of int
  | Bool of bool
  | Fun of string * expr
  | App of expr * expr
  | Binop of binop * expr * expr
  | If of expr * expr * expr
  | Let of string * expr * expr

type typ =
  | TInt
  | TBool
  | TVar of string
  | TFun of typ * typ

type tyenv = typ StringMap.t

type value =
  | VInt of int
  | VBool of bool
  | VClosure of string * expr * env

and env = value StringMap.t
