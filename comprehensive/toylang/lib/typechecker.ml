open Ast

type typ = IntType | BoolType
module StringMap = Map.Make (String)
type type_env = typ StringMap.t

let rec check_program program = ignore (check_stmt_seq StringMap.empty program)
and check_stmt_seq env stmts = List.fold_left check_stmt env stmts
and check_stmt env = function
  | AssignStmt (name, expr) ->
    let typ = infer_exp_type env expr in
    (match StringMap.find_opt name env with
     | None -> StringMap.add name typ env
     | Some old_typ when old_typ = typ -> env
     | Some _ -> failwith ("Type mismatch in assignment to " ^ name))
  | IfStmt (condition, then_body, else_body) ->
    if infer_exp_type env condition <> BoolType then
      failwith "Condition of if must be bool";
    ignore (check_stmt_seq env then_body);
    Option.iter (fun body -> ignore (check_stmt_seq env body)) else_body;
    env
  | RepeatStmt (body, condition) ->
    let body_env = check_stmt_seq env body in
    if infer_exp_type body_env condition <> BoolType then
      failwith "Condition of repeat must be bool";
    body_env
  | PrintStmt expr -> ignore (infer_exp_type env expr); env
and infer_exp_type env = function
  | IntExp _ -> IntType
  | BoolExp _ -> BoolType
  | VarRefExp name ->
    (match StringMap.find_opt name env with
     | Some typ -> typ | None -> failwith ("Undefined variable " ^ name))
  | BinaryExp (left, op, right) ->
    let left_typ = infer_exp_type env left in
    let right_typ = infer_exp_type env right in
    match op with
    | AddOp | SubOp | MulOp | DivOp ->
      if left_typ = IntType && right_typ = IntType then IntType
      else failwith "Operands of arithmetic must be int"
    | LtOp ->
      if left_typ = IntType && right_typ = IntType then BoolType
      else failwith "Operands of comparison must be int"
    | EqOp ->
      if left_typ = right_typ then BoolType
      else failwith "Operands of comparison must be of same type"
