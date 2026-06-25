module S = Solutions

exception Check_failed of string

let starts_with s prefix =
  let n = String.length prefix in
  String.length s >= n && String.sub s 0 n = prefix

let fail msg = raise (Check_failed msg)

let check msg condition =
  if not condition then fail msg

let assert_equal pp expected actual =
  if expected <> actual then
    fail
      (Printf.sprintf "期望 %s，实际 %s" (pp expected) (pp actual))

let pp_int = string_of_int
let pp_bool = string_of_bool
let pp_char c = Printf.sprintf "%C" c
let pp_string s = Printf.sprintf "%S" s

let pp_pair pp_a pp_b (a, b) =
  Printf.sprintf "(%s, %s)" (pp_a a) (pp_b b)

let pp_triple pp_a pp_b pp_c (a, b, c) =
  Printf.sprintf "(%s, %s, %s)" (pp_a a) (pp_b b) (pp_c c)

let pp_list pp xs = "[" ^ String.concat "; " (List.map pp xs) ^ "]"
let pp_option pp = function None -> "None" | Some x -> "Some " ^ pp x

let sort_unique xs = List.sort_uniq compare xs

let rec take_seq n seq =
  if n <= 0 then []
  else
    match seq () with
    | Seq.Nil -> []
    | Seq.Cons (x, rest) -> x :: take_seq (n - 1) rest

let has_no_duplicates xs = List.length xs = List.length (sort_unique xs)

let is_prime_for_test n =
  let rec loop d =
    d * d > n || (n mod d <> 0 && loop (d + 1))
  in
  n >= 2 && loop 2

let rec pow a b =
  if b = 0 then 1 else a * pow a (b - 1)

let total = ref 0
let passed = ref 0
let failed = ref 0
let todos = ref 0

let run name f =
  incr total;
  Printf.printf "测试 %-64s " name;
  try
    f ();
    incr passed;
    print_endline "通过"
  with
  | Failure msg when starts_with msg "TODO:" ->
      incr todos;
      Printf.printf "未实现：%s\n" msg
  | Check_failed msg ->
      incr failed;
      Printf.printf "失败：%s\n" msg
  | exn ->
      incr failed;
      Printf.printf "异常：%s\n" (Printexc.to_string exn)

let tests =
  [
    ( "01 flatten 展平嵌套列表",
      fun () ->
        let module E = S.Ex01 in
        let input =
          [
            E.One "a";
            E.Many [ E.One "b"; E.Many [ E.One "c"; E.One "d" ]; E.One "e" ];
          ]
        in
        assert_equal (pp_list pp_string) [ "a"; "b"; "c"; "d"; "e" ]
          (E.flatten input) );
    ( "02 compress 删除连续重复元素",
      fun () ->
        let module E = S.Ex02 in
        assert_equal (pp_list pp_string)
          [ "a"; "b"; "c"; "a"; "d"; "e" ]
          (E.compress
             [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e" ])
    );
    ( "03 pack 打包连续重复元素",
      fun () ->
        let module E = S.Ex03 in
        assert_equal (pp_list (pp_list pp_string))
          [
            [ "a"; "a"; "a"; "a" ];
            [ "b" ];
            [ "c"; "c" ];
            [ "a"; "a" ];
            [ "d"; "d" ];
            [ "e"; "e"; "e"; "e" ];
          ]
          (E.pack
             [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "d"; "e"; "e"; "e"; "e" ])
    );
    ( "04 decode 解码游程编码",
      fun () ->
        let module E = S.Ex04 in
        let input =
          [
            E.Many (4, "a");
            E.One "b";
            E.Many (2, "c");
            E.Many (2, "a");
            E.One "d";
            E.Many (4, "e");
          ]
        in
        assert_equal (pp_list pp_string)
          [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e" ]
          (E.decode input) );
    ( "05 encode 直接游程编码",
      fun () ->
        let module E = S.Ex05 in
        let pp = function
          | E.One x -> "One " ^ pp_string x
          | E.Many (n, x) -> Printf.sprintf "Many (%d, %s)" n (pp_string x)
        in
        assert_equal (pp_list pp)
          [
            E.Many (4, "a");
            E.One "b";
            E.Many (2, "c");
            E.Many (2, "a");
            E.One "d";
            E.Many (4, "e");
          ]
          (E.encode [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e" ])
    );
    ( "06 replicate 复制元素",
      fun () ->
        let module E = S.Ex06 in
        assert_equal (pp_list pp_string)
          [ "a"; "a"; "a"; "b"; "b"; "b"; "c"; "c"; "c" ]
          (E.replicate [ "a"; "b"; "c" ] 3) );
    ( "07 drop 删除每第 n 个元素",
      fun () ->
        let module E = S.Ex07 in
        assert_equal (pp_list pp_string)
          [ "a"; "b"; "d"; "e"; "g"; "h"; "j" ]
          (E.drop [ "a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j" ] 3) );
    ( "08 slice 提取切片",
      fun () ->
        let module E = S.Ex08 in
        assert_equal (pp_list pp_string)
          [ "c"; "d"; "e"; "f"; "g" ]
          (E.slice [ "a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j" ] 2 6) );
    ( "09 rotate 左旋列表",
      fun () ->
        let module E = S.Ex09 in
        assert_equal (pp_list pp_string)
          [ "d"; "e"; "f"; "g"; "h"; "a"; "b"; "c" ]
          (E.rotate [ "a"; "b"; "c"; "d"; "e"; "f"; "g"; "h" ] 3);
        assert_equal (pp_list pp_string)
          [ "g"; "h"; "a"; "b"; "c"; "d"; "e"; "f" ]
          (E.rotate [ "a"; "b"; "c"; "d"; "e"; "f"; "g"; "h" ] (-2)) );
    ( "10 rand_select 随机抽取",
      fun () ->
        let module E = S.Ex10 in
        let input = [ "a"; "b"; "c"; "d"; "e"; "f"; "g"; "h" ] in
        let result = E.rand_select input 3 in
        check "结果长度应为 3" (List.length result = 3);
        check "抽出的元素必须来自原列表" (List.for_all (fun x -> List.mem x input) result);
        check "不应重复抽取同一个元素" (has_no_duplicates result) );
    ( "11 extract 组合",
      fun () ->
        let module E = S.Ex11 in
        assert_equal (pp_list (pp_list pp_string))
          [
            [ "a"; "b" ];
            [ "a"; "c" ];
            [ "a"; "d" ];
            [ "b"; "c" ];
            [ "b"; "d" ];
            [ "c"; "d" ];
          ]
          (E.extract 2 [ "a"; "b"; "c"; "d" ]) );
    ( "12 group 分组",
      fun () ->
        let module E = S.Ex12 in
        let result = E.group [ "a"; "b"; "c"; "d" ] [ 2; 1 ] in
        check "4 个元素分成 2 人组和 1 人组应有 12 种结果" (List.length result = 12);
        check "每个结果都应符合给定组大小"
          (List.for_all
             (fun groups -> List.map List.length groups = [ 2; 1 ])
             result);
        check "应包含 [[a; b]; [c]] 这个分组"
          (List.mem [ [ "a"; "b" ]; [ "c" ] ] result) );
    ( "13 length_sort / frequency_sort 排序",
      fun () ->
        let module E = S.Ex13 in
        let input =
          [
            [ "a"; "b"; "c" ];
            [ "d"; "e" ];
            [ "f"; "g"; "h" ];
            [ "d"; "e" ];
            [ "i"; "j"; "k"; "l" ];
            [ "m"; "n" ];
            [ "o" ];
          ]
        in
        assert_equal (pp_list (pp_list pp_string))
          [
            [ "o" ];
            [ "d"; "e" ];
            [ "d"; "e" ];
            [ "m"; "n" ];
            [ "a"; "b"; "c" ];
            [ "f"; "g"; "h" ];
            [ "i"; "j"; "k"; "l" ];
          ]
          (E.length_sort input);
        let frequency_sorted = E.frequency_sort input in
        let freq len =
          List.length (List.filter (fun xs -> List.length xs = len) input)
        in
        let weights = List.map (fun xs -> freq (List.length xs)) frequency_sorted in
        check "frequency_sort 应按子列表长度出现频率非递减排序"
          (weights = List.sort compare weights) );
    ( "14 is_prime 判断素数",
      fun () ->
        let module E = S.Ex14 in
        assert_equal pp_bool false (E.is_prime 1);
        assert_equal pp_bool true (E.is_prime 7);
        assert_equal pp_bool false (E.is_prime 12) );
    ( "15 gcd 最大公约数",
      fun () ->
        let module E = S.Ex15 in
        assert_equal pp_int 1 (E.gcd 13 27);
        assert_equal pp_int 2 (E.gcd 20536 7826) );
    ( "16 phi 欧拉函数朴素版",
      fun () ->
        let module E = S.Ex16 in
        assert_equal pp_int 1 (E.phi 1);
        assert_equal pp_int 4 (E.phi 10);
        assert_equal pp_int 12 (E.phi 13) );
    ( "17 factors 素因子列表",
      fun () ->
        let module E = S.Ex17 in
        assert_equal (pp_list pp_int) [ 3; 3; 5; 7 ] (E.factors 315) );
    ( "18 factors 带重数素因子",
      fun () ->
        let module E = S.Ex18 in
        assert_equal (pp_list (pp_pair pp_int pp_int))
          [ (3, 2); (5, 1); (7, 1) ] (E.factors 315) );
    ( "19 phi_improved 欧拉函数改进版",
      fun () ->
        let module E = S.Ex19 in
        assert_equal pp_int 4 (E.phi_improved 10);
        assert_equal pp_int 12 (E.phi_improved 13) );
    ( "20 goldbach 哥德巴赫分解",
      fun () ->
        let module E = S.Ex20 in
        let a, b = E.goldbach 28 in
        check "两个数之和应为输入偶数" (a + b = 28);
        check "两个数都应为素数" (is_prime_for_test a && is_prime_for_test b);
        assert_equal (pp_pair pp_int pp_int) (5, 23) (a, b) );
    ( "21 goldbach_list 区间哥德巴赫分解",
      fun () ->
        let module E = S.Ex21 in
        assert_equal
          (pp_list (pp_pair pp_int (pp_pair pp_int pp_int)))
          [
            (10, (3, 7));
            (12, (5, 7));
            (14, (3, 11));
            (16, (3, 13));
            (18, (5, 13));
            (20, (3, 17));
          ]
          (E.goldbach_list 9 20) );
    ( "22 table2 二元真值表",
      fun () ->
        let module E = S.Ex22 in
        let expr = E.And (E.Var "a", E.Or (E.Var "a", E.Var "b")) in
        assert_equal (pp_list (pp_triple pp_bool pp_bool pp_bool))
          [ (true, true, true); (true, false, true); (false, true, false); (false, false, false) ]
          (E.table2 "a" "b" expr) );
    ( "23 table 多变量真值表",
      fun () ->
        let module E = S.Ex23 in
        let expr = E.And (E.Var "a", E.Or (E.Var "a", E.Var "b")) in
        let result = E.table [ "a"; "b" ] expr in
        check "两个变量应生成 4 行真值表" (List.length result = 4);
        check "a=true,b=false 时表达式为 true"
          (List.mem ([ ("a", true); ("b", false) ], true) result);
        check "a=false,b=true 时表达式为 false"
          (List.mem ([ ("a", false); ("b", true) ], false) result) );
    ( "24 gray 格雷码",
      fun () ->
        let module E = S.Ex24 in
        let result = E.gray 3 in
        assert_equal (pp_list pp_string)
          [ "000"; "001"; "011"; "010"; "110"; "111"; "101"; "100" ]
          result;
        check "n 位格雷码应有 2^n 个不同编码"
          (List.length result = pow 2 3 && has_no_duplicates result) );
    ( "25 cbal_tree 完全平衡二叉树",
      fun () ->
        let module E = S.Ex25 in
        let rec size = function E.Empty -> 0 | E.Node (_, l, r) -> 1 + size l + size r in
        let rec balanced = function
          | E.Empty -> true
          | E.Node (_, l, r) ->
              abs (size l - size r) <= 1 && balanced l && balanced r
        in
        let result = E.cbal_tree 4 in
        assert_equal pp_int 4 (List.length result);
        check "每棵树都应有 4 个节点且完全平衡"
          (List.for_all (fun t -> size t = 4 && balanced t) result) );
    ( "26 is_symmetric 判断对称二叉树",
      fun () ->
        let module E = S.Ex26 in
        let symmetric =
          E.Node
            ( 'x',
              E.Node ('x', E.Empty, E.Node ('x', E.Empty, E.Empty)),
              E.Node ('x', E.Node ('x', E.Empty, E.Empty), E.Empty) )
        in
        let asymmetric =
          E.Node ('x', E.Node ('x', E.Empty, E.Empty), E.Empty)
        in
        assert_equal pp_bool true (E.is_symmetric symmetric);
        assert_equal pp_bool false (E.is_symmetric asymmetric) );
    ( "27 construct 构造二叉搜索树",
      fun () ->
        let module E = S.Ex27 in
        let expected =
          E.Node
            ( 3,
              E.Node (2, E.Node (1, E.Empty, E.Empty), E.Empty),
              E.Node (5, E.Empty, E.Node (7, E.Empty, E.Empty)) )
        in
        assert_equal (fun _ -> "<tree>") expected (E.construct [ 3; 2; 5; 7; 1 ]);
        assert_equal pp_bool true
          (E.is_symmetric (E.construct [ 5; 3; 18; 1; 4; 12; 21 ])) );
    ( "28 sym_cbal_trees 对称完全平衡树",
      fun () ->
        let module E = S.Ex28 in
        let rec size = function E.Empty -> 0 | E.Node (_, l, r) -> 1 + size l + size r in
        let rec mirror a b =
          match (a, b) with
          | E.Empty, E.Empty -> true
          | E.Node (_, l1, r1), E.Node (_, l2, r2) -> mirror l1 r2 && mirror r1 l2
          | _ -> false
        in
        let symmetric = function E.Empty -> true | E.Node (_, l, r) -> mirror l r in
        let result = E.sym_cbal_trees 5 in
        assert_equal pp_int 2 (List.length result);
        check "每棵树都应有 5 个节点并且对称"
          (List.for_all (fun t -> size t = 5 && symmetric t) result) );
    ( "29 hbal_tree 高度平衡树",
      fun () ->
        let module E = S.Ex29 in
        let rec height = function E.Empty -> 0 | E.Node (_, l, r) -> 1 + max (height l) (height r) in
        let rec hbalanced = function
          | E.Empty -> true
          | E.Node (_, l, r) ->
              abs (height l - height r) <= 1 && hbalanced l && hbalanced r
        in
        let result = E.hbal_tree 3 in
        assert_equal pp_int 15 (List.length result);
        check "每棵树高度应为 3 且高度平衡"
          (List.for_all (fun t -> height t = 3 && hbalanced t) result) );
    ( "30 hbal_tree_nodes 指定节点数的高度平衡树",
      fun () ->
        let module E = S.Ex30 in
        let rec size = function E.Empty -> 0 | E.Node (_, l, r) -> 1 + size l + size r in
        let rec height = function E.Empty -> 0 | E.Node (_, l, r) -> 1 + max (height l) (height r) in
        let rec hbalanced = function
          | E.Empty -> true
          | E.Node (_, l, r) ->
              abs (height l - height r) <= 1 && hbalanced l && hbalanced r
        in
        assert_equal pp_int 0 (E.min_nodes 0);
        assert_equal pp_int 7 (E.min_nodes 4);
        assert_equal pp_int 15 (E.max_nodes 4);
        let result = E.hbal_tree_nodes 4 in
        check "结果中每棵树都应有 4 个节点且高度平衡"
          (List.for_all (fun t -> size t = 4 && hbalanced t) result) );
    ( "31 complete_binary_tree 完全二叉树",
      fun () ->
        let module E = S.Ex31 in
        let expected =
          E.Node
            ( 1,
              E.Node (2, E.Node (4, E.Empty, E.Empty), E.Node (5, E.Empty, E.Empty)),
              E.Node (3, E.Node (6, E.Empty, E.Empty), E.Empty) )
        in
        let tree = E.complete_binary_tree [ 1; 2; 3; 4; 5; 6 ] in
        assert_equal (fun _ -> "<tree>") expected tree;
        assert_equal pp_bool true (E.is_complete_binary_tree 6 tree) );
    ( "32 layout_binary_tree_1 中序布局",
      fun () ->
        let module E = S.Ex32 in
        let input =
          E.Node ('a', E.Node ('b', E.Empty, E.Empty), E.Node ('c', E.Empty, E.Empty))
        in
        let expected =
          E.Node
            ( ('a', 2, 1),
              E.Node (('b', 1, 2), E.Empty, E.Empty),
              E.Node (('c', 3, 2), E.Empty, E.Empty) )
        in
        assert_equal (fun _ -> "<layout tree>") expected (E.layout_binary_tree_1 input) );
    ( "33 layout_binary_tree_2 固定间距布局",
      fun () ->
        let module E = S.Ex33 in
        let input =
          E.Node ('a', E.Node ('b', E.Empty, E.Empty), E.Node ('c', E.Empty, E.Empty))
        in
        let expected =
          E.Node
            ( ('a', 2, 1),
              E.Node (('b', 1, 2), E.Empty, E.Empty),
              E.Node (('c', 3, 2), E.Empty, E.Empty) )
        in
        assert_equal (fun _ -> "<layout tree>") expected (E.layout_binary_tree_2 input) );
    ( "34 string_of_tree / tree_of_string 二叉树字符串",
      fun () ->
        let module E = S.Ex34 in
        let tree =
          E.Node
            ( 'a',
              E.Node ('b', E.Node ('d', E.Empty, E.Empty), E.Node ('e', E.Empty, E.Empty)),
              E.Node ('c', E.Empty, E.Node ('f', E.Node ('g', E.Empty, E.Empty), E.Empty)) )
        in
        let text = "a(b(d,e),c(,f(g,)))" in
        assert_equal pp_string text (E.string_of_tree tree);
        assert_equal (fun _ -> "<tree>") tree (E.tree_of_string text) );
    ( "35 preorder / inorder / pre_in_tree",
      fun () ->
        let module E = S.Ex35 in
        let tree =
          E.Node
            ( 1,
              E.Node (2, E.Node (4, E.Empty, E.Empty), E.Node (5, E.Empty, E.Empty)),
              E.Node (3, E.Empty, E.Empty) )
        in
        assert_equal (pp_list pp_int) [ 1; 2; 4; 5; 3 ] (E.preorder tree);
        assert_equal (pp_list pp_int) [ 4; 2; 5; 1; 3 ] (E.inorder tree);
        assert_equal (fun _ -> "<tree>") tree
          (E.pre_in_tree [ 1; 2; 4; 5; 3 ] [ 4; 2; 5; 1; 3 ]) );
    ( "36 dotstring 二叉树点字符串",
      fun () ->
        let module E = S.Ex36 in
        let tree =
          E.Node
            ( 'a',
              E.Node ('b', E.Node ('d', E.Empty, E.Empty), E.Node ('e', E.Empty, E.Empty)),
              E.Node ('c', E.Empty, E.Node ('f', E.Node ('g', E.Empty, E.Empty), E.Empty)) )
        in
        let text = "abd..e..c.fg..." in
        assert_equal pp_string text (E.tree_to_dotstring tree);
        assert_equal (fun _ -> "<tree>") tree (E.tree_of_dotstring text) );
    ( "37 multiway tree 节点字符串",
      fun () ->
        let module E = S.Ex37 in
        let tree =
          E.T
            ( 'a',
              [
                E.T ('f', [ E.T ('g', []) ]);
                E.T ('c', []);
                E.T ('b', [ E.T ('d', []); E.T ('e', []) ]);
              ] )
        in
        let text = "afg^^c^bd^e^^^" in
        assert_equal pp_string text (E.string_of_tree tree);
        assert_equal (fun _ -> "<multiway tree>") tree (E.tree_of_string text) );
    ( "38 lispy Lisp 风格多叉树表示",
      fun () ->
        let module E = S.Ex38 in
        let tree =
          E.T
            ( 'a',
              [
                E.T ('f', [ E.T ('g', []) ]);
                E.T ('c', []);
                E.T ('b', [ E.T ('d', []); E.T ('e', []) ]);
              ] )
        in
        assert_equal pp_string "(a (f g) c (b d e))" (E.lispy tree) );
    ( "39 paths 图中所有简单路径",
      fun () ->
        let module E = S.Ex39 in
        let graph : string E.graph =
          { E.nodes = [ "a"; "b"; "c"; "d" ]; edges = [ ("a", "b"); ("b", "c"); ("a", "c"); ("c", "d") ] }
        in
        let expected = sort_unique [ [ "a"; "b"; "c"; "d" ]; [ "a"; "c"; "d" ] ] in
        assert_equal (pp_list (pp_list pp_string)) expected
          (sort_unique (E.paths graph "a" "d")) );
    ( "40 s_tree / is_tree / is_connected 生成树",
      fun () ->
        let module E = S.Ex40 in
        let triangle : string E.graph =
          { E.nodes = [ "a"; "b"; "c" ]; edges = [ ("a", "b"); ("b", "c"); ("a", "c") ] }
        in
        let path : string E.graph =
          { E.nodes = [ "a"; "b"; "c" ]; edges = [ ("a", "b"); ("b", "c") ] }
        in
        let disconnected : string E.graph =
          { E.nodes = [ "a"; "b"; "c" ]; edges = [ ("a", "b") ] }
        in
        let trees = E.s_tree triangle in
        assert_equal pp_int 3 (List.length trees);
        check "每棵生成树都应有 n - 1 条边"
          (List.for_all (fun (g : string E.graph) -> List.length g.edges = 2) trees);
        assert_equal pp_bool true (E.is_tree path);
        assert_equal pp_bool false (E.is_tree triangle);
        assert_equal pp_bool false (E.is_connected disconnected) );
    ( "41 ms_tree 最小生成树",
      fun () ->
        let module E = S.Ex41 in
        let graph : string E.weighted_graph =
          {
            E.nodes = [ "a"; "b"; "c"; "d" ];
            edges =
              [
                ("a", "b", 1);
                ("b", "c", 2);
                ("a", "c", 5);
                ("c", "d", 1);
                ("b", "d", 4);
              ];
          }
        in
        let tree = E.ms_tree graph in
        let weight = List.fold_left (fun acc (_, _, w) -> acc + w) 0 tree.edges in
        assert_equal pp_int 3 (List.length tree.edges);
        assert_equal pp_int 4 weight );
    ( "42 isomorphic 图同构",
      fun () ->
        let module E = S.Ex42 in
        let triangle1 : string E.graph =
          { E.nodes = [ "a"; "b"; "c" ]; edges = [ ("a", "b"); ("b", "c"); ("a", "c") ] }
        in
        let triangle2 : int E.graph =
          { E.nodes = [ 1; 2; 3 ]; edges = [ (1, 2); (2, 3); (1, 3) ] }
        in
        let path3 : int E.graph =
          { E.nodes = [ 1; 2; 3 ]; edges = [ (1, 2); (2, 3) ] }
        in
        assert_equal pp_bool true (E.isomorphic triangle1 triangle2);
        assert_equal pp_bool false (E.isomorphic triangle1 path3) );
    ( "43 degree / color 图度数与着色",
      fun () ->
        let module E = S.Ex43 in
        let graph : string E.graph =
          { E.nodes = [ "a"; "b"; "c" ]; edges = [ ("a", "b"); ("b", "c"); ("a", "c") ] }
        in
        assert_equal pp_int 2 (E.degree graph "a");
        let coloring = E.color graph in
        check "每个节点都应有颜色" (List.for_all (fun n -> List.mem_assoc n coloring) graph.nodes);
        check "相邻节点颜色必须不同"
          (List.for_all
             (fun (a, b) -> List.assoc a coloring <> List.assoc b coloring)
             graph.edges) );
    ( "44 depth_first_order 深度优先遍历",
      fun () ->
        let module E = S.Ex44 in
        let graph : string E.graph =
          { E.nodes = [ "a"; "b"; "c"; "d" ]; edges = [ ("a", "b"); ("a", "c"); ("b", "d") ] }
        in
        let result = E.depth_first_order graph "a" in
        check "遍历应从起点开始" (match result with "a" :: _ -> true | _ -> false);
        assert_equal (pp_list pp_string)
          [ "a"; "b"; "c"; "d" ]
          (sort_unique result) );
    ( "45 connected_components 连通分量",
      fun () ->
        let module E = S.Ex45 in
        let graph : string E.graph =
          { E.nodes = [ "a"; "b"; "c"; "d"; "e" ]; edges = [ ("a", "b"); ("b", "c"); ("d", "e") ] }
        in
        let normalize comps = sort_unique (List.map sort_unique comps) in
        assert_equal (pp_list (pp_list pp_string))
          (normalize [ [ "a"; "b"; "c" ]; [ "d"; "e" ] ])
          (normalize (E.connected_components graph)) );
    ( "46 bipartite 二分图",
      fun () ->
        let module E = S.Ex46 in
        let path4 : string E.graph =
          { E.nodes = [ "a"; "b"; "c"; "d" ]; edges = [ ("a", "b"); ("b", "c"); ("c", "d") ] }
        in
        let triangle : string E.graph =
          { E.nodes = [ "a"; "b"; "c" ]; edges = [ ("a", "b"); ("b", "c"); ("a", "c") ] }
        in
        assert_equal pp_bool true (E.bipartite path4);
        assert_equal pp_bool false (E.bipartite triangle) );
    ( "47 queens 八皇后",
      fun () ->
        let module E = S.Ex47 in
        let valid solution =
          let n = List.length solution in
          has_no_duplicates solution
          && List.for_all (fun row -> row >= 1 && row <= n) solution
          &&
          let indexed = List.mapi (fun col row -> (col + 1, row)) solution in
          List.for_all
            (fun (c1, r1) ->
              List.for_all
                (fun (c2, r2) -> c1 = c2 || abs (c1 - c2) <> abs (r1 - r2))
                indexed)
            indexed
        in
        let result = E.queens 4 in
        assert_equal pp_int 2 (List.length result);
        check "每个 4 皇后解都应合法" (List.for_all valid result) );
    ( "48 knights_tour 骑士周游",
      fun () ->
        let module E = S.Ex48 in
        assert_equal (pp_option (pp_list (pp_pair pp_int pp_int))) (Some [ (1, 1) ])
          (E.knights_tour 1) );
    ( "49 full_words 英文数字",
      fun () ->
        let module E = S.Ex49 in
        assert_equal pp_string "one-seven-five" (E.full_words 175);
        assert_equal pp_string "zero" (E.full_words 0) );
    ( "50 identifier 语法检查",
      fun () ->
        let module E = S.Ex50 in
        assert_equal pp_bool true (E.identifier "this-is-a-long-identifier");
        assert_equal pp_bool false (E.identifier "-bad");
        assert_equal pp_bool false (E.identifier "bad-");
        assert_equal pp_bool false (E.identifier "bad--dash") );
    ( "51 sudoku 数独",
      fun () ->
        let module E = S.Ex51 in
        let puzzle =
          [|
            [| 0; 0; 4; 8; 0; 0; 0; 1; 7 |];
            [| 6; 7; 0; 9; 0; 0; 0; 0; 0 |];
            [| 5; 0; 8; 0; 3; 0; 0; 0; 4 |];
            [| 3; 0; 0; 7; 4; 0; 1; 0; 0 |];
            [| 0; 6; 9; 0; 0; 0; 7; 8; 0 |];
            [| 0; 0; 1; 0; 6; 9; 0; 0; 5 |];
            [| 1; 0; 0; 0; 8; 0; 3; 0; 6 |];
            [| 0; 0; 0; 0; 0; 6; 0; 9; 1 |];
            [| 2; 4; 0; 0; 0; 1; 5; 0; 0 |];
          |]
        in
        let solution =
          [|
            [| 9; 3; 4; 8; 2; 5; 6; 1; 7 |];
            [| 6; 7; 2; 9; 1; 4; 8; 5; 3 |];
            [| 5; 1; 8; 6; 3; 7; 9; 2; 4 |];
            [| 3; 2; 5; 7; 4; 8; 1; 6; 9 |];
            [| 4; 6; 9; 1; 5; 3; 7; 8; 2 |];
            [| 7; 8; 1; 2; 6; 9; 4; 3; 5 |];
            [| 1; 9; 7; 5; 8; 2; 3; 4; 6 |];
            [| 8; 5; 3; 4; 7; 6; 2; 9; 1 |];
            [| 2; 4; 6; 3; 9; 1; 5; 7; 8 |];
          |]
        in
        assert_equal (pp_option (fun _ -> "<grid>")) (Some solution) (E.sudoku puzzle) );
    ( "52 diag 序列的对角线",
      fun () ->
        let module E = S.Ex52 in
        let rows = Seq.init 5 (fun i -> Seq.init 5 (fun j -> (i * 10) + j)) in
        assert_equal (pp_list pp_int) [ 0; 11; 22; 33; 44 ]
          (take_seq 5 (E.diag rows)) );
  ]

let () =
  List.iter (fun (name, f) -> run name f) tests;
  Printf.printf "\n汇总：共 %d 项，通过 %d 项，失败 %d 项，未实现 %d 项。\n"
    !total !passed !failed !todos;
  if !failed > 0 then exit 1 else exit 0
