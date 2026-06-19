(*1. 所有元素平方*)
let squares (l:'float list) =
  let square x = x*x in
  List.map square l

(*2. 保留偶数*)
let evens (l:'int list):'int list =
  List.filter (fun x -> if x mod 2 = 0 then true else false) l

(*3. 正数平方*)
let positive_squares (l:'int list):'int list =
  let positive_l = List.filter (fun x -> if x > 0 then true else false) l
in List.map (fun x -> x*x) positive_l

(*4. 判断是否全是正数*)
let all_positive (l:'a list):'bool =
  List.for_all (fun x -> x>0) l

(*5. 给列表元素编号*)
let indexed (l:'a list):(int*'a) list =
 List.mapi (fun i x -> (i,x)) l

(*6. 求平均值*)
let average (l : int list) : float =
  match l with
  | [] -> failwith "empty list"
  | _ ->
      let sum = List.fold_left ( + ) 0 l in
      let len = List.length l in
      float_of_int sum /. float_of_int len

(*7. 统计满足条件的元素个数*)
let count_if f l =
  List.fold_left (fun acc a -> if (f a) then acc+1 else acc) 0 l

(*8. 用 fold_right 实现 map*)
let map f l =
  List.fold_right (fun a acc -> (f a)::acc) l []

(*9. 用 fold_right 实现 filter*)
let filter f l =
  List.fold_right (fun a acc -> if (f a) then a::acc else acc) l []

(*
fold函数是无副作用的 迭代器 
OCaml 的部分应用只能从左往右固定参数，不能跳过中间参数。
*)

(*10. 分组*)
let in_curr t f a=
 if (f a) = (fst t) then ((fst t),a::(snd t)) else t

let group_by f l =
  let aux curr v =
    List.fold_left 