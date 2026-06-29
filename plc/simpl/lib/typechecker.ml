open Ast

(*
   类型推断的核心思路是：一边遍历表达式，一边收集“类型必须相等”的约束。
*)

type subst = typ StringMap.t

let empty_subst : subst = StringMap.empty

let fresh_counter = ref 0

let fresh_type_var () : typ =
  let name = "a" ^ string_of_int !fresh_counter in
  incr fresh_counter;
  TVar name

let lookup (x : string) (env : tyenv) : typ =
  match StringMap.find_opt x env with
  | Some typ -> typ
  | None -> failwith ("Unbound variable " ^ x)

let rec apply (subst : subst) (typ : typ) : typ =
  match typ with
  | TInt -> TInt
  | TBool -> TBool
  | TVar name -> (
      match StringMap.find_opt name subst with
      | None -> TVar name
      | Some replacement -> apply subst replacement)
  | TFun (arg_typ, result_typ) ->
      TFun (apply subst arg_typ, apply subst result_typ)

let apply_env (subst : subst) (env : tyenv) : tyenv =
  StringMap.map (apply subst) env

let rec occurs (name : string) (typ : typ) : bool =
  match typ with
  | TInt | TBool -> false
  | TVar other -> String.equal name other
  | TFun (arg_typ, result_typ) ->
      occurs name arg_typ || occurs name result_typ


let bind_var (subst : subst) (name : string) (typ : typ) : subst =
  match typ with
  | TVar x when x = name -> subst
  | _ when occurs name typ -> failwith "Occurs check failed"
  | _ -> StringMap.add name typ subst 


let rec unify (subst : subst) (left : typ) (right : typ) : subst =
  let left = apply subst left in
  let right = apply subst right in
  if left = right then
    subst
  else
    match (left, right) with
    | TVar name, typ ->
        bind_var subst name typ

    | typ, TVar name ->
        bind_var subst name typ

    | TFun (arg1, ret1), TFun (arg2, ret2) ->
        let subst = unify subst arg1 arg2 in
        unify subst ret1 ret2

    | _ ->
        failwith "Type mismatch"


let rec infer_expr (subst : subst) (env : tyenv) (expr : expr) : subst * typ =
  match expr with
  | Int _ -> (subst, TInt)
  | Bool _ -> (subst, TBool)
  | Var x -> (subst, apply subst (lookup x env))

  | Fun (x, body) ->
      let param_typ = fresh_type_var () in
      let new_env = StringMap.add x param_typ env in
      let new_subst,body_typ = infer_expr subst new_env body in
      (new_subst, TFun (apply new_subst param_typ,apply new_subst body_typ))

  | App (fn_expr, arg_expr) ->
      let f_subst, fn_typ = infer_expr subst env fn_expr in
      let a_subst, arg_typ = infer_expr f_subst env arg_expr in
      let fn_typ = apply a_subst fn_typ in
      let arg_typ = apply a_subst arg_typ in
      (match fn_typ with
      | TFun (param_typ, result_typ) ->
          let new_subst =
            try unify a_subst param_typ arg_typ
            with Failure _ ->
              failwith "Function argument type mismatch"
          in
          (new_subst, apply new_subst result_typ)
      | TVar _ ->
          let result_typ = fresh_type_var () in
          let new_subst = unify a_subst fn_typ (TFun (arg_typ, result_typ)) in
          (new_subst, apply new_subst result_typ)
      | _ ->
          failwith "Application requires a function")
  | Binop ((Add | Mul), left, right) ->
    let l_subst, left_typ = infer_expr subst env left in
    let r_subst, right_typ = infer_expr l_subst env right in
    let new_subst =
      try
        let s = unify r_subst (apply r_subst left_typ) TInt in
        unify s (apply s right_typ) TInt
      with Failure _ ->
        failwith "Arithmetic operations require int operands"
    in
    (new_subst, TInt)

| Binop (Leq, left, right) ->
    let l_subst, left_typ = infer_expr subst env left in
    let r_subst, right_typ = infer_expr l_subst env right in
    let new_subst =
      try
        let s = unify r_subst (apply r_subst left_typ) TInt in
        unify s (apply s right_typ) TInt
      with Failure _ ->
        failwith "Comparison requires int operands"
    in
    (new_subst, TBool)

  | If (cond, then_expr, else_expr) ->
    let cond_subst, cond_typ = infer_expr subst env cond in

    let cond_subst =
      try unify cond_subst cond_typ TBool
      with Failure _ ->
        failwith "Condition of if must be bool"
    in

    let then_subst, then_typ = infer_expr cond_subst env then_expr in
    let else_subst, else_typ = infer_expr then_subst env else_expr in

    let new_subst =
      try
        unify else_subst
          (apply else_subst then_typ)
          (apply else_subst else_typ)
      with Failure _ ->
        failwith "Branches of if must have same type"
    in

    (new_subst, apply new_subst then_typ)
    

  | Let (x, bound_expr, body_expr) ->
    let bound_subst, bound_typ = infer_expr subst env bound_expr in
    let bound_typ = apply bound_subst bound_typ in
    let new_env = apply_env bound_subst env in
    let new_env = StringMap.add x bound_typ new_env in
    infer_expr bound_subst new_env body_expr
    
let infer (env : tyenv) (expr : expr) : typ =
  fresh_counter := 0;
  let subst, typ = infer_expr empty_subst env expr in
  apply subst typ
