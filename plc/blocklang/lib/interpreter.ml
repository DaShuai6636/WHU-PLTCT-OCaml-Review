open Ast

type value =
  | IntVal of int
  | BoolVal of bool

type env = (string * value) list

let find_x env x =
  List.find_opt (fun a -> (fst a) = x) env

let empty_env = []

let keep_outer_bindings outer_env inner_env =
  List.map
    (fun (name, old_value) ->
      match find_x inner_env name with
      | Some (_, value) -> (name, value)
      | None -> (name, old_value))
    outer_env
let todo name = failwith ("TODO: implement Interpreter." ^ name)

let rec eval_expr env expr = 
  match expr with
  | IntExp x -> (IntVal x, env) 
  | BoolExp x -> (BoolVal x, env)
  | VarExp x -> 
    (match find_x env x with
    | Some (_,value) -> (value, env)
    | None -> failwith ("Unbound name " ^ x))
  | BinopExp (binop,e1,e2) -> 
    (match binop with
    | Add -> 
      let v1, _ = eval_expr env e1 in
      let v2, _ = eval_expr env e2 in
      (match (v1, v2) with
      | IntVal i1, IntVal i2 -> (IntVal (i1 + i2), env)
      | _ -> failwith "Runtime type error")
    | Mul -> 
      let v1, _ = eval_expr env e1 in
      let v2, _ = eval_expr env e2 in
      (match (v1, v2) with
      | IntVal i1, IntVal i2 -> (IntVal (i1 * i2), env)
      | _ -> failwith "Runtime type error")
    | Lt ->
      let v1, _ = eval_expr env e1 in
      let v2, _ = eval_expr env e2 in
      (match (v1, v2) with
      | IntVal i1, IntVal i2 -> (BoolVal (i1 < i2), env)
      | _ -> failwith "Runtime type error")
    | Eq ->
      let v1, _ = eval_expr env e1 in
      let v2, _ = eval_expr env e2 in
      (match (v1, v2) with
      | IntVal i1, IntVal i2 -> (BoolVal (i1 = i2), env)
      | BoolVal b1, BoolVal b2 -> (BoolVal (b1 = b2), env)
      | _ -> failwith "Runtime type error"))
  | IfExp (e1,e2,e3) ->
    let v1, _ = eval_expr env e1 in
    (match v1 with
    | BoolVal true -> eval_expr env e2
    | BoolVal false -> eval_expr env e3
    | _ -> failwith "Expected a boolean value in IfExp")
  | BlockExp (stmts, e) ->
    (let block_env = eval_stmts env stmts in
     let value, block_env = eval_expr block_env e in
     (value, keep_outer_bindings env block_env))
and eval_stmt env stmt = 
  match stmt with
  | AssignStmt (x, e) ->
      let v, env = eval_expr env e in
      (x, v) :: List.remove_assoc x env
  | PrintStmt e ->
      let v, _ = eval_expr env e in
      (match v with
      | IntVal i -> print_endline (string_of_int i)
      | BoolVal true -> print_endline "TRUE"
      | BoolVal false -> print_endline "FALSE");
      env

and eval_stmts env stmts = List.fold_left eval_stmt env stmts

let eval_program program = 
  match program with
  | [] -> ()
  | _ -> ignore (eval_stmts empty_env program)
