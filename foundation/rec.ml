(*1. 去除连续重复元素：只删除连续重复，不删除非连续重复。*)
let rec compress (l : 'a list) : 'a list =
  match l with
  | [] -> []
  | [x] -> [x]
  | f :: s :: t ->
      if f = s then
        compress (s :: t)
      else
        f :: compress (s :: t)

(*2. 把代码按照奇偶位置拆开val split_index : 'a list -> 'a list * 'a list*)
let rec split_index (l:'a list):('a list * 'a list) =
  let rec aux (left,right) l = 
    match l with
    | [] -> ((List.rev left),(List.rev right))
    | [x]-> (x::left,right)
    | f::s::t -> aux (f::left,s::right) t
  in aux ([],[]) l