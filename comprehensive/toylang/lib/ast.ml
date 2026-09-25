type program = stmt list

and stmt =
  | IfStmt of expr * stmt list * stmt list option
  | RepeatStmt of stmt list * expr
  | AssignStmt of string * expr
  | PrintStmt of expr

and expr =
  | IntExp of int
  | BoolExp of bool
  | VarRefExp of string
  | BinaryExp of expr * binop * expr

and binop = AddOp | SubOp | MulOp | DivOp | LtOp | EqOp
