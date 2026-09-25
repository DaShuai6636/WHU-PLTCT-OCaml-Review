open Ast

module StringMap = Map.Make (String)
type value_env = int StringMap.t

let rec interpret_program program = ignore (exec_stmt_seq StringMap.empty program)
and exec_stmt_seq env stmts = List.fold_left exec_stmt env stmts
and exec_stmt env = function
  | AssignStmt (name, expr) -> StringMap.add name (eval_exp env expr) env
  | PrintStmt expr -> print_endline (string_of_int (eval_exp env expr)); env
  | IfStmt (condition, then_body, else_body) ->
    if eval_exp env condition <> 0 then exec_stmt_seq env then_body
    else (match else_body with None -> env | Some body -> exec_stmt_seq env body)
  | RepeatStmt (body, condition) ->
    let rec loop current_env =
      let next_env = exec_stmt_seq current_env body in
      if eval_exp next_env condition <> 0 then next_env else loop next_env
    in loop env
and eval_exp env = function
  | IntExp n -> n | BoolExp true -> 1 | BoolExp false -> 0
  | VarRefExp name ->
    (match StringMap.find_opt name env with
     | Some value -> value | None -> failwith ("Undefined variable " ^ name))
  | BinaryExp (left, op, right) ->
    let l = eval_exp env left and r = eval_exp env right in
    match op with
    | AddOp -> l + r | SubOp -> l - r | MulOp -> l * r | DivOp -> l / r
    | LtOp -> if l < r then 1 else 0
    | EqOp -> if l = r then 1 else 0
