module type QUEUE = sig
    type 'a t
    exception Empty
    val empty : 'a t
    val is_empty : 'a t -> bool
    val push : 'a t -> 'a -> 'a t
    val pop : 'a t -> 'a t
    val front : 'a t -> 'a
end

module Queue : QUEUE = struct
    type 'a t = {
        front : 'a list;
        back : 'a list
    }

    exception Empty

    let normalize q = 
        match q.front with
        | [] -> {front = (List.rev q.back); back = []}
        | _ -> q

    let empty = {front = []; back = []}
    
    let is_empty q = q = empty

    let push q x =
        {q with back = x :: q.back}

    let pop q =
        let q' = normalize q in
        match q'.front with
        | [] -> raise Empty
        | _ :: tl -> {q' with front = tl}

    let front q =
        let q' = normalize q in
        match q'.front with
        | [] -> raise Empty
        | hd :: _ -> hd
end