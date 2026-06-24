module type BINARY_TREE = sig
  type 'a t

  val empty : 'a t
  val leaf : 'a -> 'a t
  val is_empty : 'a t -> bool

  val size : 'a t -> int
  val height : 'a t -> int
  val count_leaves : 'a t -> int

  val inorder : 'a t -> 'a list
  val postorder : 'a t -> 'a list
  val level_order : 'a t -> 'a list
end

module BNtree : BINARY_TREE = struct
  type 'a t =
    | Empty
    | Node of 'a * 'a t * 'a t

  let empty = Empty

  let leaf a =
    Node (a, Empty, Empty)

  let is_empty t =
    match t with
    | Empty -> true
    | Node _ -> false

  let rec size t =
    match t with
    | Empty -> 0
    | Node (_, left, right) ->
        1 + size left + size right

  let rec height t =
    match t with
    | Empty -> 0
    | Node (_, left, right) ->
        1 + max (height left) (height right)

  let rec count_leaves t =
    match t with
    | Empty -> 0
    | Node (_, Empty, Empty) -> 1
    | Node (_, left, right) ->
        count_leaves left + count_leaves right

  let rec inorder t =
    match t with
    | Empty -> []
    | Node (x, left, right) ->
        inorder left @ [x] @ inorder right

  let rec postorder t =
    match t with
    | Empty -> []
    | Node (x, left, right) ->
        postorder left @ postorder right @ [x]

  let inorder_tl t =
    let rec loop acc st =
      match st with
      | [] -> List.rev acc
      | (Empty, _) :: rest ->
          loop acc rest
      | (Node (x, left, right), 0) :: rest ->
          loop acc ((left, 0) :: (Node (x, left, right), 1) :: rest)
      | (Node (x, _, right), _) :: rest ->
          loop (x :: acc) ((right, 0) :: rest)
    in
    loop [] [(t, 0)]

  let postorder_tl t =
    let rec loop acc st =
      match st with
      | [] -> List.rev acc
      | (Empty, _) :: rest ->
          loop acc rest
      | (Node (x, left, right), 0) :: rest ->
          loop acc ((left, 0) :: (Node (x, left, right), 1) :: rest)
      | (Node (x, left, right), 1) :: rest ->
          loop acc ((right, 0) :: (Node (x, left, right), 2) :: rest)
      | (Node (x, _, _), _) :: rest ->
          loop (x :: acc) rest
    in
    loop [] [(t, 0)]

  let level_order t =
    let q = Queue.create () in
    Queue.add t q;
    let rec loop acc =
      try
        let a = Queue.take q in
        match a with
        | Empty ->
            loop acc
        | Node (x, left, right) ->
            Queue.add left q;
            Queue.add right q;
            loop (x :: acc)
      with
      | Queue.Empty ->
          List.rev acc
    in
    loop []
end