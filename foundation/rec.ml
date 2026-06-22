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




(*尾递归*)
(*本质还是显式写出栈等结构、让隐式递归变成显式循环*)

(*3. 展开嵌套列表*)
type 'a nested =
  | Elem of 'a
  | List of 'a nested list

let rec flatten (n:'a nested list):'a list=
  match n with
  | (Elem x)::t -> x::(flatten t)
  | (List nest)::t ->(flatten nest)@(flatten t)
  | _->[]

let flatten_tr (nl:'a nested list):'a list=
  let rec aux rest acc curr =
    match curr with
    | (Elem x) :: t -> aux rest acc t
    | (List x) :: t -> aux (t::rest) acc x
    | [] -> match rest with
      | [] -> List.rev acc
      | h::t -> aux t acc h
  in aux [] [] nl

(*4. BFS，假设没有环*)
type 'a graph = ('a * 'a list) list

(* 定义squeue数据结构及其相关函数 *)
type 'a queue = {
  front : 'a list;
  back : 'a list
}

let empty = {
  front = [] ; back = []
}

let isempty q =
  q.front = [] && q.back = []
  
let normalize q =
  match q.front,q.back with
  | [],back -> {front = List.rev back;back = []}
  | _ -> q

let push q x =
  {q with back = x :: q.back}

let pop q =
  let q = normalize q in
  match q.front with 
  |[] -> None
  |h::t -> Some(h,{q with front = t})

let top q =
  let q = normalize q in
  match q.front with
  | [] -> None
  | h::t -> Some h

let pushlist q l= 
  List.fold_left (fun acc a -> push acc a) q l

let bfs (graph:string graph) (start:string) (dest:string):string list = 
  let rec loop queue res=
    match pop queue with
    | None -> failwith "Error!"
    | Some (curr,queue) -> 
      if curr = dest then
        List.rev (curr::res) else
          let next = List.find (fun a -> (fst a)=curr) graph in
            loop (pushlist queue (snd next)) (curr::res)
        in loop {front = [start];back = []} []

let print_string_list name l =
  Printf.printf "%s = [%s]\n" name (String.concat "; " l)

let graph : string graph =
  [
    ("A", ["B"; "C"]);
    ("B", ["D"; "E"]);
    ("C", ["F"]);
    ("D", []);
    ("F", ["H";"G"]);
    ("E", ["G"]);
    ("G", []);
    ("H", []);
  ]

let () =
  print_string_list "bfs A->G" (bfs graph "A" "G");