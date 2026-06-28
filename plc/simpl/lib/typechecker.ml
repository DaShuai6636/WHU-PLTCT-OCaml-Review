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

(*
   apply subst typ 的作用是：把 typ 里面已经知道答案的类型变量替换掉。

   如果 subst 里面有 a0 -> int，那么：
     apply subst (TFun (TVar "a0", TVar "a0"))
   应该得到：
     TFun (TInt, TInt)
*)
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

(*
   occurs name typ 检查类型变量 name 是否出现在 typ 里面。

   它用来阻止无限类型，例如 a0 = a0 -> a1。
   这种情况会出现在：
     fun x -> x x
*)
let rec occurs (name : string) (typ : typ) : bool =
  match typ with
  | TInt | TBool -> false
  | TVar other -> String.equal name other
  | TFun (arg_typ, result_typ) ->
      occurs name arg_typ || occurs name result_typ

(*
   bind_var subst name typ 表示记录一个等式：
     name := typ

   你需要处理：
   - 如果 typ 本身就是同一个类型变量，什么都不用做。
   - 如果 name 出现在 typ 里面，说明会产生无限类型，报：
       failwith "Occurs check failed"
   - 否则，把 name -> typ 加入 subst。
*)
let bind_var (subst : subst) (name : string) (typ : typ) : subst =
  match typ with
  | TVar x when x = name -> subst
  | _ when occurs name typ -> failwith "Occurs check failed"
  | _ -> StringMap.add name typ subst 

(*
   unify subst t1 t2 的作用是：在当前替换 subst 的基础上，让 t1 和 t2 变成同一个类型。

   常见情况：
   - int 和 int：不用改 subst
   - bool 和 bool：不用改 subst
   - 类型变量 和 任意类型：调用 bind_var
   - 函数类型 和 函数类型：先统一参数类型，再统一返回类型
   - 其它情况：报 failwith "Type mismatch"

   注意：匹配 t1 和 t2 之前，应该先对它们 apply 当前 subst。
*)
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

(*
   infer_expr 返回两个东西：
   - 更新后的 substitution
   - 当前表达式推断出的类型

   env 是一个 Map，记录变量名到类型的绑定。
*)
let rec infer_expr (subst : subst) (env : tyenv) (expr : expr) : subst * typ =
  match expr with
  | Int _ -> (subst, TInt)
  | Bool _ -> (subst, TBool)
  | Var x -> (subst, apply subst (lookup x env))

  | Fun (x, body) ->
      (*
         fun x -> body 的推断步骤：
         1. 给参数 x 创建一个新的类型变量 param_typ。
         2. 用 StringMap.add x param_typ env 扩展类型环境。
         3. 在扩展后的环境里推断 body。
         4. 返回函数类型 TFun (最终参数类型, body 类型)。

         注意：最后的参数类型要 apply 最终 substitution，
         因为参数类型可能在 body 里被约束成 int、bool 或函数类型。
      *)
      let _param_typ = fresh_type_var () in
      failwith "TODO: infer fun"

  | App (fn_expr, arg_expr) ->
      (*
         e1 e2 的推断步骤：
         1. 推断 e1，得到 fn_typ。
         2. 推断 e2，得到 arg_typ。这里要使用更新后的 substitution/env。
         3. 创建一个新的结果类型变量 result_typ。
         4. 统一 fn_typ 和 TFun (arg_typ, result_typ)。
         5. 返回 apply 之后的 result_typ。

         错误信息：
         - 如果左侧不能作为函数，报：
             failwith "Application requires a function"
         - 如果实参类型和形参类型不一致，报：
             failwith "Function argument type mismatch"

         这两个错误可以在这个分支里包一层处理，
         也可以在 unify 里根据情况处理。
      *)
      failwith "TODO: infer application"

  | Binop ((Add | Mul), left, right) ->
      (*
         + 和 * 的规则：两个操作数都必须是 int，结果也是 int。

         推荐步骤：
         - 推断 left
         - 统一 left 的类型和 TInt
         - 用更新后的 substitution/env 推断 right
         - 统一 right 的类型和 TInt
         - 返回 TInt

         操作数类型错误时，报：
           failwith "Arithmetic operations require int operands"
      *)
      failwith "TODO: infer arithmetic"

  | Binop (Leq, left, right) ->
      (*
         <= 的规则：两个操作数都必须是 int，结果是 bool。

         操作数类型错误时，报：
           failwith "Comparison requires int operands"
      *)
      failwith "TODO: infer comparison"

  | If (cond, then_expr, else_expr) ->
      (*
         if c then e1 else e2 的规则：
         - c 必须是 bool
         - e1 和 e2 的类型必须相同
         - 整个 if 的类型就是分支类型

         错误信息：
           failwith "Condition of if must be bool"
           failwith "Branches of if must have same type"
      *)
      failwith "TODO: infer if"

  | Let (x, bound_expr, body_expr) ->
      (*
         let x = e1 in e2 的推断步骤：
         - 在原环境里推断 e1
         - 把 x -> e1 的类型加入环境
         - 在扩展后的环境里推断 e2

         本题不要求 let 多态，所以不需要 generalize。
         也就是说，直接把 e1 的类型放进环境即可。
      *)
      failwith "TODO: infer let"

let infer (env : tyenv) (expr : expr) : typ =
  fresh_counter := 0;
  let subst, typ = infer_expr empty_subst env expr in
  apply subst typ
