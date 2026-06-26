# OCaml.org Exercises — Intermediate

*中等难度题目原文整理（Statement + 示例，不含官方 Solution 代码）*

| Source | https://ocaml.org/exercises |
| --- | --- |
| Scope | 52 exercises with difficulty = Intermediate |
| License note | OCaml.org repository: content under CC BY-SA 4.0; code examples within content under the UNLICENSE. |
| 整理说明 | 保留英文题名、题干、示例输出；为避免过长，未收录页面中的官方解答代码。 |

Original page: <https://ocaml.org/exercises>

# Index

| # | Category | Title | Difficulty |
| --- | --- | --- | --- |
| 1 | Lists | Flatten a List | Intermediate |
| 2 | Lists | Eliminate Duplicates | Intermediate |
| 3 | Lists | Pack Consecutive Duplicates | Intermediate |
| 4 | Lists | Decode a Run-Length Encoded List | Intermediate |
| 5 | Lists | Run-Length Encoding of a List (Direct Solution) | Intermediate |
| 6 | Lists | Replicate the Elements of a List a Given Number of Times | Intermediate |
| 7 | Lists | Drop Every N'th Element From a List | Intermediate |
| 8 | Lists | Extract a Slice From a List | Intermediate |
| 9 | Lists | Rotate a List N Places to the Left | Intermediate |
| 10 | Lists | Extract a Given Number of Randomly Selected Elements From a List | Intermediate |
| 11 | Lists | Generate the Combinations of K Distinct Objects Chosen From the N Elements of a List | Intermediate |
| 12 | Lists | Group the Elements of a Set Into Disjoint Subsets | Intermediate |
| 13 | Lists | Sorting a List of Lists According to Length of Sublists | Intermediate |
| 14 | Arithmetic | Determine Whether a Given Integer Number Is Prime | Intermediate |
| 15 | Arithmetic | Determine the Greatest Common Divisor of Two Positive Integer Numbers | Intermediate |
| 16 | Arithmetic | Calculate Euler's Totient Function Φ(m) | Intermediate |
| 17 | Arithmetic | Determine the Prime Factors of a Given Positive Integer | Intermediate |
| 18 | Arithmetic | Determine the Prime Factors of a Given Positive Integer (2) | Intermediate |
| 19 | Arithmetic | Calculate Euler's Totient Function Φ(m) (Improved) | Intermediate |
| 20 | Arithmetic | Goldbach's Conjecture | Intermediate |
| 21 | Arithmetic | A List of Goldbach Compositions | Intermediate |
| 22 | Logic and Codes | Truth Tables for Logical Expressions (2 Variables) | Intermediate |
| 23 | Logic and Codes | Truth Tables for Logical Expressions | Intermediate |
| 24 | Logic and Codes | Gray Code | Intermediate |
| 25 | Binary Trees | Construct Completely Balanced Binary Trees | Intermediate |
| 26 | Binary Trees | Symmetric Binary Trees | Intermediate |
| 27 | Binary Trees | Binary Search Trees (Dictionaries) | Intermediate |
| 28 | Binary Trees | Generate-and-Test Paradigm | Intermediate |
| 29 | Binary Trees | Construct Height-Balanced Binary Trees | Intermediate |
| 30 | Binary Trees | Construct Height-Balanced Binary Trees With a Given Number of Nodes | Intermediate |
| 31 | Binary Trees | Construct a Complete Binary Tree | Intermediate |
| 32 | Binary Trees | Layout a Binary Tree (1) | Intermediate |
| 33 | Binary Trees | Layout a Binary Tree (2) | Intermediate |
| 34 | Binary Trees | A String Representation of Binary Trees | Intermediate |
| 35 | Binary Trees | Preorder and Inorder Sequences of Binary Trees | Intermediate |
| 36 | Binary Trees | Dotstring Representation of Binary Trees | Intermediate |
| 37 | Multiway Trees | Tree Construction From a Node String | Intermediate |
| 38 | Multiway Trees | Lisp-Like Tree Representation | Intermediate |
| 39 | Graphs | Path From One Node to Another One | Intermediate |
| 40 | Graphs | Construct All Spanning Trees | Intermediate |
| 41 | Graphs | Construct the Minimal Spanning Tree | Intermediate |
| 42 | Graphs | Graph Isomorphism | Intermediate |
| 43 | Graphs | Node Degree and Graph Coloration | Intermediate |
| 44 | Graphs | Depth-First Order Graph Traversal | Intermediate |
| 45 | Graphs | Connected Components | Intermediate |
| 46 | Graphs | Bipartite Graphs | Intermediate |
| 47 | Miscellaneous | Eight Queens Problem | Intermediate |
| 48 | Miscellaneous | Knight's Tour | Intermediate |
| 49 | Miscellaneous | English Number Words | Intermediate |
| 50 | Miscellaneous | Syntax Checker | Intermediate |
| 51 | Miscellaneous | Sudoku | Intermediate |
| 52 | Miscellaneous | Diagonal of a Sequence of Sequences | Intermediate |

# Lists

## 1. Flatten a List

**Difficulty:** Intermediate

**Statement.** Flatten a nested list structure.

Example / signature / test shown on source page:

```ocaml
type 'a node =
  | One of 'a
  | Many of 'a node list

# flatten [One "a"; Many [One "b"; Many [One "c" ;One "d"]; One "e"]];;
- : string list = ["a"; "b"; "c"; "d"; "e"]
```

## 2. Eliminate Duplicates

**Difficulty:** Intermediate

**Statement.** Eliminate consecutive duplicates of list elements.

Example / signature / test shown on source page:

```ocaml
# compress ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"];;
- : string list = ["a"; "b"; "c"; "a"; "d"; "e"]
```

## 3. Pack Consecutive Duplicates

**Difficulty:** Intermediate

**Statement.** Pack consecutive duplicates of list elements into sublists.

Example / signature / test shown on source page:

```ocaml
# pack ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "d"; "e"; "e"; "e"; "e"];;
- : string list list =
[["a"; "a"; "a"; "a"]; ["b"]; ["c"; "c"]; ["a"; "a"]; ["d"; "d"];
 ["e"; "e"; "e"; "e"]]
```

## 4. Decode a Run-Length Encoded List

**Difficulty:** Intermediate

**Statement.** Given a run-length code list generated as specified in the previous problem, construct its uncompressed version.

Example / signature / test shown on source page:

```ocaml
# decode [Many (4, "a"); One "b"; Many (2, "c"); Many (2, "a"); One "d"; Many (4, "e")];;
- : string list =
["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"]
```

## 5. Run-Length Encoding of a List (Direct Solution)

**Difficulty:** Intermediate

**Statement.** Implement the so-called run-length encoding data compression method directly. I.e. don't explicitly create the sublists containing the duplicates, as in problem "Pack consecutive duplicates of list elements into sublists", but only count them. As in problem "Modified run-length encoding", simplify the result list by replacing the singleton lists (1 X) by X.

Example / signature / test shown on source page:

```ocaml
# encode ["a";"a";"a";"a";"b";"c";"c";"a";"a";"d";"e";"e";"e";"e"];;
- : string rle list =
[Many (4, "a"); One "b"; Many (2, "c"); Many (2, "a"); One "d";
 Many (4, "e")]
```

## 6. Replicate the Elements of a List a Given Number of Times

**Difficulty:** Intermediate

**Statement.** Replicate the elements of a list a given number of times.

Example / signature / test shown on source page:

```ocaml
# replicate ["a"; "b"; "c"] 3;;
- : string list = ["a"; "a"; "a"; "b"; "b"; "b"; "c"; "c"; "c"]
```

## 7. Drop Every N'th Element From a List

**Difficulty:** Intermediate

**Statement.** Drop every N'th element from a list.

Example / signature / test shown on source page:

```ocaml
# drop ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 3;;
- : string list = ["a"; "b"; "d"; "e"; "g"; "h"; "j"]
```

## 8. Extract a Slice From a List

**Difficulty:** Intermediate

**Statement.** Given two indices, i and k, the slice is the list containing the elements between the i'th and k'th element of the original list (both limits included). Start counting the elements with 0 (this is the way the List module numbers elements).

Example / signature / test shown on source page:

```ocaml
# slice ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 2 6;;
- : string list = ["c"; "d"; "e"; "f"; "g"]
```

## 9. Rotate a List N Places to the Left

**Difficulty:** Intermediate

**Statement.** Rotate a list N places to the left.

Example / signature / test shown on source page:

```ocaml
# rotate ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 3;;
- : string list = ["d"; "e"; "f"; "g"; "h"; "a"; "b"; "c"]
```

## 10. Extract a Given Number of Randomly Selected Elements From a List

**Difficulty:** Intermediate

**Statement.** Extract a given number of randomly selected elements from a list.

Example / signature / test shown on source page:

```ocaml
# rand_select ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 3;;
- : string list = ["g"; "d"; "a"]
```

## 11. Generate the Combinations of K Distinct Objects Chosen From the N Elements of a List

**Difficulty:** Intermediate

**Statement.** Generate the combinations of K distinct objects chosen from the N elements of a list. In how many ways can a committee of 3 be chosen from a group of 12 people? We all know that there are C(12,3) = 220 possibilities (C(N,K) denotes the well-known binomial coefficients). For pure mathematicians, this result may be great. But we want to really generate all the possibilities in a list.

Example / signature / test shown on source page:

```ocaml
# extract 2 ["a"; "b"; "c"; "d"];;
- : string list list =
[["a"; "b"]; ["a"; "c"]; ["a"; "d"]; ["b"; "c"]; ["b"; "d"]; ["c"; "d"]]
```

## 12. Group the Elements of a Set Into Disjoint Subsets

**Difficulty:** Intermediate

**Statement.** Group the elements of a set into disjoint subsets. 1. In how many ways can a group of 9 people work in 3 disjoint subgroups of 2, 3 and 4 persons? Write a function that generates all the possibilities and returns them in a list. 2. Generalize the above function in a way that we can specify a list of group sizes and the function will return a list of groups.

Example / signature / test shown on source page:

```ocaml
# group ["a"; "b"; "c"; "d"] [2; 1];;
- : string list list list =
[[["a"; "b"]; ["c"]]; [["a"; "c"]; ["b"]]; [["b"; "c"]; ["a"]]; ...]
```

## 13. Sorting a List of Lists According to Length of Sublists

**Difficulty:** Intermediate

**Statement.** Sorting a list of lists according to length of sublists. 1. We suppose that a list contains elements that are lists themselves. The objective is to sort the elements of this list according to their length. E.g. short lists first, longer lists later, or vice versa. 2. Again, we suppose that a list contains elements that are lists themselves. But this time the objective is to sort the elements of this list according to their length frequency; i.e., in the default, where sorting is done ascendingly, lists with rare lengths are placed first, others with a more frequent length come later.

Example / signature / test shown on source page:

```ocaml
# length_sort [["a"; "b"; "c"]; ["d"; "e"]; ["f"; "g"; "h"]; ["d"; "e"]; ["i"; "j"; "k"; "l"]; ["m"; "n"]; ["o"]];;
- : string list list =
[["o"]; ["d"; "e"]; ["d"; "e"]; ["m"; "n"]; ["a"; "b"; "c"]; ["f"; "g"; "h"]; ["i"; "j"; "k"; "l"]]
```

# Arithmetic

## 14. Determine Whether a Given Integer Number Is Prime

**Difficulty:** Intermediate

**Statement.** Determine whether a given integer number is prime.

Example / signature / test shown on source page:

```ocaml
# not (is_prime 1);;
- : bool = true
# is_prime 7;;
- : bool = true
# not (is_prime 12);;
- : bool = true
```

## 15. Determine the Greatest Common Divisor of Two Positive Integer Numbers

**Difficulty:** Intermediate

**Statement.** Determine the greatest common divisor of two positive integer numbers. Use Euclid's algorithm.

Example / signature / test shown on source page:

```ocaml
# gcd 13 27;;
- : int = 1
# gcd 20536 7826;;
- : int = 2
```

## 16. Calculate Euler's Totient Function Φ(m)

**Difficulty:** Intermediate

**Statement.** Euler's so-called totient function φ(m) is defined as the number of positive integers r (1 ≤ r < m) that are coprime to m. We let φ(1) = 1. Find out what the value of φ(m) is if m is a prime number. Euler's totient function plays an important role in one of the most widely used public key cryptography methods (RSA). In this exercise you should use the most primitive method to calculate this function (there are smarter ways that we shall discuss later).

Example / signature / test shown on source page:

```ocaml
# phi 10;;
- : int = 4
```

## 17. Determine the Prime Factors of a Given Positive Integer

**Difficulty:** Intermediate

**Statement.** Construct a flat list containing the prime factors in ascending order.

Example / signature / test shown on source page:

```ocaml
# factors 315;;
- : int list = [3; 3; 5; 7]
```

## 18. Determine the Prime Factors of a Given Positive Integer (2)

**Difficulty:** Intermediate

**Statement.** Construct a list containing the prime factors and their multiplicity. Hint: The problem is similar to problem Run-length encoding of a list (direct solution).

Example / signature / test shown on source page:

```ocaml
# factors 315;;
- : (int * int) list = [(3, 2); (5, 1); (7, 1)]
```

## 19. Calculate Euler's Totient Function Φ(m) (Improved)

**Difficulty:** Intermediate

**Statement.** See problem Calculate Euler's totient function φ(m) for the definition of Euler's totient function. If the list of the prime factors of a number m is known in the form of problem Determine the prime factors of a given positive integer (2), then the function φ(m) can be efficiently calculated as follows: Let [(p1, m1); (p2, m2); (p3, m3); ...] be the list of prime factors (and their multiplicities) of a given number m. Then φ(m) can be calculated with the following formula: φ(m) = (p1 - 1) × p1^(m1 - 1) × (p2 - 1) × p2^(m2 - 1) × (p3 - 1) × p3^(m3 - 1) × ...

Example / signature / test shown on source page:

```ocaml
# phi_improved 10;;
- : int = 4
# phi_improved 13;;
- : int = 12
```

## 20. Goldbach's Conjecture

**Difficulty:** Intermediate

**Statement.** Goldbach's conjecture says that every positive even number greater than 2 is the sum of two prime numbers. Example: 28 = 5 + 23. It is one of the most famous facts in number theory that has not been proved to be correct in the general case. It has been numerically confirmed up to very large numbers. Write a function to find the two prime numbers that sum up to a given even integer.

Example / signature / test shown on source page:

```ocaml
# goldbach 28;;
- : int * int = (5, 23)
```

## 21. A List of Goldbach Compositions

**Difficulty:** Intermediate

**Statement.** Given a range of integers by its lower and upper limit, print a list of all even numbers and their Goldbach composition. In most cases, if an even number is written as the sum of two prime numbers, one of them is very small. Very rarely, the primes are both bigger than say 50. Try to find out how many such cases there are in the range 2..3000.

Example / signature / test shown on source page:

```ocaml
# goldbach_list 9 20;;
- : (int * (int * int)) list =
[(10, (3, 7)); (12, (5, 7)); (14, (3, 11)); (16, (3, 13)); (18, (5, 13));
 (20, (3, 17))]
```

# Logic and Codes

## 22. Truth Tables for Logical Expressions (2 Variables)

**Difficulty:** Intermediate

**Statement.** Let us define a small "language" for boolean expressions containing variables. A logical expression in two variables can then be written in prefix notation. Define a function, table2 which returns the truth table of a given logical expression in two variables (specified as arguments). The return value must be a list of triples containing (value_of_a, value_of_b, value_of_expr).

Example / signature / test shown on source page:

```ocaml
type bool_expr =
  | Var of string
  | Not of bool_expr
  | And of bool_expr * bool_expr
  | Or of bool_expr * bool_expr

# table2 "a" "b" (And (Var "a", Or (Var "a", Var "b")));;
- : (bool * bool * bool) list =
[(true, true, true); (true, false, true); (false, true, false); (false, false, false)]
```

## 23. Truth Tables for Logical Expressions

**Difficulty:** Intermediate

**Statement.** Generalize the previous problem in such a way that the logical expression may contain any number of logical variables. Define table in a way that table variables expr returns the truth table for the expression expr, which contains the logical variables enumerated in variables.

Example / signature / test shown on source page:

```ocaml
# table ["a"; "b"] (And (Var "a", Or (Var "a", Var "b")));;
- : ((string * bool) list * bool) list =
[([("a", true); ("b", true)], true); (["a", true); ("b", false)], true); ...]
```

## 24. Gray Code

**Difficulty:** Intermediate

**Statement.** An n-bit Gray code is a sequence of n-bit strings constructed according to certain rules. Find out the construction rules and write a function with the following specification: gray n returns the n-bit Gray code.

Example / signature / test shown on source page:

```ocaml
n = 1: C(1) = ['0', '1'].
n = 2: C(2) = ['00', '01', '11', '10'].
n = 3: C(3) = ['000', '001', '011', '010', '110', '111', '101', '100'].

# gray 3;;
- : string list = ["000"; "001"; "011"; "010"; "110"; "111"; "101"; "100"]
```

# Binary Trees

## 25. Construct Completely Balanced Binary Trees

**Difficulty:** Intermediate

**Statement.** A binary tree is either empty or it is composed of a root element and two successors, which are binary trees themselves. In a completely balanced binary tree, the following property holds for every node: The number of nodes in its left subtree and the number of nodes in its right subtree are almost equal, which means their difference is not greater than one. Write a function cbal_tree to construct completely balanced binary trees for a given number of nodes. The function should generate all solutions via backtracking. Put the letter 'x' as information into all nodes of the tree.

Example / signature / test shown on source page:

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

# cbal_tree 4;;
- : char binary_tree list = [ ... ]
```

## 26. Symmetric Binary Trees

**Difficulty:** Intermediate

**Statement.** Let us call a binary tree symmetric if you can draw a vertical line through the root node and then the right subtree is the mirror image of the left subtree. Write a function is_symmetric to check whether a given binary tree is symmetric. Hint: Write a function is_mirror first to check whether one tree is the mirror image of another. We are only interested in the structure, not in the contents of the nodes.

## 27. Binary Search Trees (Dictionaries)

**Difficulty:** Intermediate

**Statement.** Construct a binary search tree from a list of integer numbers. Then use this function to test the solution of the previous problem.

Example / signature / test shown on source page:

```ocaml
# construct [3; 2; 5; 7; 1];;
- : int binary_tree =
Node (3, Node (2, Node (1, Empty, Empty), Empty), Node (5, Empty, Node (7, Empty, Empty)))

# is_symmetric (construct [5; 3; 18; 1; 4; 12; 21]);;
- : bool = true
```

## 28. Generate-and-Test Paradigm

**Difficulty:** Intermediate

**Statement.** Apply the generate-and-test paradigm to construct all symmetric, completely balanced binary trees with a given number of nodes. How many such trees are there with 57 nodes? Investigate about how many solutions there are for a given number of nodes? What if the number is even? Write an appropriate function.

Example / signature / test shown on source page:

```ocaml
# sym_cbal_trees 5;;
- : char binary_tree list = [ ... ]
# List.length (sym_cbal_trees 57);;
- : int = 256
```

## 29. Construct Height-Balanced Binary Trees

**Difficulty:** Intermediate

**Statement.** In a height-balanced binary tree, the following property holds for every node: The height of its left subtree and the height of its right subtree are almost equal, which means their difference is not greater than one. Write a function hbal_tree to construct height-balanced binary trees for a given height. The function should generate all solutions via backtracking. Put the letter 'x' as information into all nodes of the tree.

Example / signature / test shown on source page:

```ocaml
# let t = hbal_tree 3;;
val t : char binary_tree list = [ ... ]
```

## 30. Construct Height-Balanced Binary Trees With a Given Number of Nodes

**Difficulty:** Intermediate

**Statement.** Consider a height-balanced binary tree of height h. What is the maximum number of nodes it can contain? Clearly, max_nodes = 2^h - 1. However, what is the minimum number min_nodes? This question is more difficult. Try to find a recursive statement and turn it into a function min_nodes defined as follows: min_nodes h returns the minimum number of nodes in a height-balanced binary tree of height h. Now, we can attack the main problem: construct all the height-balanced binary trees with a given number of nodes. hbal_tree_nodes n returns a list of all height-balanced binary tree with n nodes. Find out how many height-balanced trees exist for n = 15.

Example / signature / test shown on source page:

```ocaml
# List.length (hbal_tree_nodes 15);;
- : int = 1553
```

## 31. Construct a Complete Binary Tree

**Difficulty:** Intermediate

**Statement.** A complete binary tree with height H is defined as follows: The levels 1,2,3,...,H-1 contain the maximum number of nodes (i.e. 2^{i-1} at the level i, note that we start counting the levels from 1 at the root). In level H, which may contain less than the maximum possible number of nodes, all the nodes are "left-adjusted". Particularly, complete binary trees are used as data structures (or addressing schemes) for heaps. Write a function is_complete_binary_tree with the following specification: is_complete_binary_tree n t returns true if and only if t is a complete binary tree with n nodes.

Example / signature / test shown on source page:

```ocaml
# complete_binary_tree [1; 2; 3; 4; 5; 6];;
- : int binary_tree =
Node (1, Node (2, Node (4, Empty, Empty), Node (5, Empty, Empty)), Node (3, Node (6, Empty, Empty), Empty))
```

## 32. Layout a Binary Tree (1)

**Difficulty:** Intermediate

**Statement.** As a preparation for drawing the tree, a layout algorithm is required to determine the position of each node in a rectangular grid. In this layout strategy, the position of a node v is obtained by the following two rules: x(v) is equal to the position of the node v in the inorder sequence; y(v) is equal to the depth of the node v in the tree. In order to store the position of the nodes, we will enrich the value at each node with the position (x,y).

Example / signature / test shown on source page:

```ocaml
# layout_binary_tree_1 example_layout_tree;;
- : (char * int * int) binary_tree = Node (('n', 8, 1), ... )
```

## 33. Layout a Binary Tree (2)

**Difficulty:** Intermediate

**Statement.** An alternative layout method is depicted in this illustration. Find out the rules and write the corresponding OCaml function. Hint: On a given level, the horizontal distance between neighbouring nodes is constant.

Example / signature / test shown on source page:

```ocaml
# layout_binary_tree_2 example_layout_tree ;;
- : (char * int * int) binary_tree = Node (('n', 15, 1), ... )
```

## 34. A String Representation of Binary Trees

**Difficulty:** Intermediate

**Statement.** Somebody represents binary trees as strings of the following type (see example): "a(b(d,e),c(,f(g,)))". Write an OCaml function string_of_tree which generates this string representation, if the tree is given as usual (as Empty or Node(x,l,r) term). Then write a function tree_of_string which does this inverse; i.e. given the string representation, construct the tree in the usual form. Finally, combine the two predicates in a single function tree_string which can be used in both directions. Write the same predicate tree_string using difference lists and a single predicate tree_dlist which does the conversion between a tree and a difference list in both directions. For simplicity, suppose the information in the nodes is a single letter and there are no spaces in the string.

Example / signature / test shown on source page:

```ocaml
"a(b(d,e),c(,f(g,)))
```

## 35. Preorder and Inorder Sequences of Binary Trees

**Difficulty:** Intermediate

**Statement.** We consider binary trees with nodes that are identified by single lower-case letters, as in the example of the previous problem. 1. Write functions preorder and inorder that construct the preorder and inorder sequence of a given binary tree, respectively. 2. Can you use preorder from problem part 1 in the reverse direction; i.e. given a preorder sequence, construct a corresponding tree? If not, make the necessary arrangements. 3. If both the preorder sequence and the inorder sequence of the nodes of a binary tree are given, then the tree is determined unambiguously. Write a function pre_in_tree that does the job. 4. Solve problems 1 to 3 using difference lists.

Example / signature / test shown on source page:

```ocaml
# preorder (Node (1, Node (2, Empty, Empty), Empty));;
- : int list = [1; 2]
```

## 36. Dotstring Representation of Binary Trees

**Difficulty:** Intermediate

**Statement.** We consider again binary trees with nodes that are identified by single lower-case letters, as in the example of problem "A string representation of binary trees". Such a tree can be represented by the preorder sequence of its nodes in which dots (.) are inserted where an empty subtree (nil) is encountered during the tree traversal. For example, the tree shown in problem "A string representation of binary trees" is represented as 'abd..e..c.fg...'. First, try to establish a syntax (BNF or syntax diagrams) and then write a function tree_dotstring which does the conversion in both directions. Use difference lists.

Example / signature / test shown on source page:

```ocaml
'abd..e..c.fg...'
```

# Multiway Trees

## 37. Tree Construction From a Node String

**Difficulty:** Intermediate

**Statement.** A multiway tree is composed of a root element and a (possibly empty) set of successors which are multiway trees themselves. A multiway tree is never empty. The set of successor trees is sometimes called a forest. To represent multiway trees, we will use the following type which is a direct translation of the definition. Write a function string_of_tree which constructs the string representation of a multiway tree.

Example / signature / test shown on source page:

```ocaml
type 'a mult_tree = T of 'a * 'a mult_tree list
```

## 38. Lisp-Like Tree Representation

**Difficulty:** Intermediate

**Statement.** There is a particular notation for multiway trees in Lisp. Lisp is a prominent functional programming language. In Lisp almost everything is a list. Write a function lispy : char mult_tree -> string that returns the Lisp-like representation of a multiway tree.

# Graphs

## 39. Path From One Node to Another One

**Difficulty:** Intermediate

**Statement.** Write a function paths g a b that returns all acyclic paths p from node a to node b in the graph g. The function should return the list of all paths via backtracking.

## 40. Construct All Spanning Trees

**Difficulty:** Intermediate

**Statement.** Write a function s_tree g to construct all spanning trees of a given graph g. With this predicate, find out how many spanning trees there are for the graph depicted to the left. The data of this example graph can be found in the test below. When you have a correct solution for the s_tree function, use it to define two other useful functions: is_tree graph and is_connected graph. Both are five-minutes tasks.

## 41. Construct the Minimal Spanning Tree

**Difficulty:** Intermediate

**Statement.** Write a function ms_tree graph to construct the minimal spanning tree of a given labelled graph. Hint: Use Prim's algorithm. A small modification of the solution of problem Construct all spanning trees does the trick. The data of the example graph to the right can be found below.

## 42. Graph Isomorphism

**Difficulty:** Intermediate

**Statement.** Two graphs G1(N1,E1) and G2(N2,E2) are isomorphic if there is a bijection f: N1 → N2 such that for any nodes X,Y of N1, X and Y are adjacent if and only if f(X) and f(Y) are adjacent. Write a function that determines whether two graphs are isomorphic. Hint: Use an open-ended list to represent the function f.

## 43. Node Degree and Graph Coloration

**Difficulty:** Intermediate

**Statement.** Write functions degree graph node that determines the degree of a given node, and color graph that generates a list of nodes and their corresponding colors, so that adjacent nodes have different colors.

## 44. Depth-First Order Graph Traversal

**Difficulty:** Intermediate

**Statement.** Write a function that generates a depth-first order graph traversal sequence. The starting point should be specified, and the output should be a list of nodes that are reachable from this starting point, in depth-first order.

## 45. Connected Components

**Difficulty:** Intermediate

**Statement.** Write a predicate that splits a graph into its connected components.

## 46. Bipartite Graphs

**Difficulty:** Intermediate

**Statement.** Write a function that finds out whether a given graph is bipartite.

# Miscellaneous

## 47. Eight Queens Problem

**Difficulty:** Intermediate

**Statement.** This is a classical problem in computer science. The objective is to place eight queens on a chessboard so that no two queens attack each other; i.e., no two queens are in the same row, the same column, or on the same diagonal. Hint: Represent the positions of the queens as a list of numbers 1..N.

## 48. Knight's Tour

**Difficulty:** Intermediate

**Statement.** Another famous problem is this one: How can a knight jump on an N×N chessboard in such a way that it visits every square exactly once?

## 49. English Number Words

**Difficulty:** Intermediate

**Statement.** On financial documents, like cheques, numbers must sometimes be written in full words. Example: 175 must be written as one-seven-five. Write a function full_words to print (non-negative) integer numbers in full words.

Example / signature / test shown on source page:

```ocaml
# full_words 175;;
- : string = "one-seven-five
```

## 50. Syntax Checker

**Difficulty:** Intermediate

**Statement.** In a certain programming language (Ada) identifiers are defined by the syntax diagram (railroad chart) opposite. Transform the syntax diagram into a system of syntax diagrams which do not contain loops; i.e. which are purely recursive. Using these modified diagrams, write a function identifier : string -> bool that can check whether or not a given string is a legal identifier.

Example / signature / test shown on source page:

```ocaml
# identifier "this-is-a-long-identifier";;
- : bool = true
```

## 51. Sudoku

**Difficulty:** Intermediate

**Statement.** Sudoku puzzles go like this: Every spot in the puzzle belongs to a (horizontal) row and a (vertical) column, as well as to one single 3x3 square (which we call "square" for short). At the beginning, some of the spots carry a single-digit number between 1 and 9. The problem is to fill the missing spots with digits in such a way that every number between 1 and 9 appears exactly once in each row, in each column, and in each square.

Example / signature / test shown on source page:

```ocaml
Problem statement                 Solution
 .  .  4 | 8  .  . | .  1  7      9  3  4 | 8  2  5 | 6  1  7
 6  7  . | 9  .  . | .  .  .      6  7  2 | 9  1  4 | 8  5  3
 5  .  8 | .  3  . | .  .  4      5  1  8 | 6  3  7 | 9  2  4
 --------+---------+--------      --------+---------+--------
 3  .  . | 7  4  . | 1  .  .      3  2  5 | 7  4  8 | 1  6  9
 .  6  9 | .  .  . | 7  8  .      4  6  9 | 1  5  3 | 7  8  2
 .  .  1 | .  6  9 | .  .  5      7  8  1 | 2  6  9 | 4  3  5
 --------+---------+--------      --------+---------+--------
 1  .  . | .  8  . | 3  .  6      1  9  7 | 5  8  2 | 3  4  6
 .  .  . | .  .  6 | .  9  1      8  5  3 | 4  7  6 | 2  9  1
 2  4  . | .  .  1 | 5  .  .      2  4  6 | 3  9  1 | 5  7  8
```

## 52. Diagonal of a Sequence of Sequences

**Difficulty:** Intermediate

**Statement.** Write a function diag : 'a Seq.t Seq.t -> 'a Seq that returns the diagonal of a sequence of sequences. The returned sequence is formed as follows: The first element of the returned sequence is the first element of the first sequence; the second element of the returned sequence is the second element of the second sequence; the third element of the returned sequence is the third element of the third sequence; and so on.

# Attribution and License

Source: OCaml.org Exercises. The OCaml.org page states that the source of the problems is available on GitHub and that every exercise has a difficulty level ranging from beginner to advanced. The OCaml.org repository license states that content is released under CC BY-SA 4.0 and code examples within content are released under the UNLICENSE. This document is a study compilation of intermediate-level exercise statements and examples, with no endorsement implied.
