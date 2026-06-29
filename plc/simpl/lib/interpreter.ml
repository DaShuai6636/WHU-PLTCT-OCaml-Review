open Ast

let rec eval (env : env) (expr : expr) : value =
  match expr with
  | Int n ->
      VInt n

  | Bool b ->
      VBool b

  | Var x ->
      (match StringMap.find_opt x env with
      | Some v -> v
      | None -> failwith ("Unbound variable " ^ x) )

  | Fun (x, body) ->
      VClosure (x, body, env)

  | App (fn_expr, arg_expr) ->
      (match eval env fn_expr with
      | VClosure (x, body, f_env) ->
          let arg_val = eval env arg_expr in
          let new_env = StringMap.add x arg_val f_env in
          eval new_env body
      | _ ->
          failwith "Runtime type error")

  | Binop (op, left, right) ->
      (match (op, eval env left, eval env right) with
      | Add, VInt left, VInt right ->
          VInt (left + right)
      | Mul, VInt left, VInt right ->
          VInt (left * right)
      | Leq, VInt left, VInt right ->
          VBool (left <= right)
      | _ ->
          failwith "Runtime type error")

  | If (cond, then_expr, else_expr) ->
      (match eval env cond with
      | VBool true ->
          eval env then_expr
      | VBool false ->
          eval env else_expr
      | _ ->
          failwith "Runtime type error")

  | Let (x, bound_expr, body_expr) ->
      let bound_val = eval env bound_expr in
      let new_env = StringMap.add x bound_val env in
      eval new_env body_expr
