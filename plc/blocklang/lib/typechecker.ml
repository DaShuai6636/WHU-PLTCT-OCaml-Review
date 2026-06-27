open Ast

type env = (string * Ast.typ) list

let empty_env = []

let find_x env x= 
  List.find_opt (fun a -> (fst a) = x) env

let todo name = failwith ("TODO: implement Typechecker." ^ name)

let rec type_of_expr (env:env) (expr:Ast.expr):Ast.typ = 
  match expr with
  | IntExp  _ -> IntType
  | BoolExp _ -> BoolType
  | VarExp x -> 
    (match (find_x env x) with
    | Some (_,typ) -> typ
    | None -> failwith ("Undefined variable " ^ x))
  | BinopExp (binop,e1,e2) ->
    (let e1_typ = type_of_expr env e1 in
    let e2_typ = type_of_expr env e2 in
    match binop with
    | Eq -> 
      if e1_typ = e2_typ then BoolType else failwith "Equality requires operands of same type"
    | Lt ->
      if e1_typ = IntType && e2_typ = IntType then BoolType else failwith "Comparison requires int operands"
    | Add ->
      if e1_typ = IntType && e2_typ = IntType then IntType else failwith "Arithmetic operations require int operands"
    | Mul ->
      if e1_typ = IntType && e2_typ = IntType then IntType else failwith "Arithmetic operations require int operands")
  | IfExp (cond,e1,e2) -> 
    (let cond_typ = type_of_expr env cond in
    let e1_typ = type_of_expr env e1 in
    let e2_typ = type_of_expr env e2 in
    if cond_typ <> BoolType then
      failwith "Condition of if must be bool" 
    else
        if  e1_typ = e2_typ then
          e1_typ 
        else
         failwith "Branches of if must have same type")
  | BlockExp (sl,e) ->
    (let env_sl = typecheck_stmts env sl in
    type_of_expr env_sl e)

and typecheck_stmt (env:env) (stmt:Ast.stmt):env =
  match stmt with
  | AssignStmt (x,e) ->
    (
      let e_typ = type_of_expr env e in
      match find_x env x with
      | Some (_,typ) -> 
        if e_typ = typ then env else failwith ("Type mismatch in assignment to " ^ x)
      | None -> (x,e_typ)::env
    )
  | PrintStmt e -> 
    ignore (type_of_expr env e);
    env

and typecheck_stmts env stmts =
  List.fold_left typecheck_stmt env stmts

and typecheck_program program =
  match program with
  | [] -> ()
  | x -> ignore (typecheck_stmts empty_env x)
