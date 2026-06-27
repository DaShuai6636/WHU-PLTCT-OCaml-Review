open Simpl
open Ast

type test_result =
  | Pass
  | Fail of string

let string_of_binop = function
  | Add -> "Add"
  | Mul -> "Mul"
  | Leq -> "Leq"

let rec string_of_expr = function
  | Var x -> "Var " ^ x
  | Int n -> "Int " ^ string_of_int n
  | Bool b -> "Bool " ^ string_of_bool b
  | Binop (op, left, right) ->
      "Binop("
      ^ String.concat ", "
          [ string_of_binop op; string_of_expr left; string_of_expr right ]
      ^ ")"
  | If (cond, yes_branch, no_branch) ->
      "If("
      ^ String.concat ", "
          [
            string_of_expr cond;
            string_of_expr yes_branch;
            string_of_expr no_branch;
          ]
      ^ ")"
  | Let (name, bound, body) ->
      "Let(" ^ name ^ ", " ^ string_of_expr bound ^ ", "
      ^ string_of_expr body ^ ")"

let string_of_typ = Driver.string_of_typ
let string_of_value = Driver.string_of_value

let same_typ actual expected =
  match (actual, expected) with
  | TInt, TInt | TBool, TBool -> true
  | _ -> false

let same_value actual expected =
  match (actual, expected) with
  | VInt a, VInt b -> a = b
  | VBool a, VBool b -> Bool.equal a b
  | _ -> false

let same_expr actual expected = actual = expected

let contains_substring text needle =
  let text_len = String.length text in
  let needle_len = String.length needle in
  let rec loop index =
    index + needle_len <= text_len
    && (String.sub text index needle_len = needle || loop (index + 1))
  in
  needle_len = 0 || loop 0

let is_todo_error message =
  contains_substring (String.lowercase_ascii message) "todo"

let protect f =
  try Ok (f ()) with
  | Failure message -> Error ("Failure: " ^ message)
  | Lexer.SyntaxError message -> Error ("Lexer.SyntaxError: " ^ message)
  | Parsing.Parse_error -> Error "Parsing.Parse_error"
  | exn -> Error (Printexc.to_string exn)

let check_parse name input expected =
  let detail =
    match protect (fun () -> Driver.parse_string input) with
    | Ok actual when same_expr actual expected -> Pass
    | Ok actual ->
        Fail
          ("input: " ^ input ^ "\n  expected AST: " ^ string_of_expr expected
         ^ "\n  actual AST:   " ^ string_of_expr actual)
    | Error message ->
        Fail
          ("input: " ^ input ^ "\n  expected AST: " ^ string_of_expr expected
         ^ "\n  actual error: " ^ message)
  in
  ("parse", name, detail)

let check_run name input expected_typ expected_value =
  let detail =
    match protect (fun () -> Driver.run_string input) with
    | Ok (actual_typ, actual_value)
      when same_typ actual_typ expected_typ
           && same_value actual_value expected_value ->
        Pass
    | Ok (actual_typ, actual_value) ->
        Fail
          ("input: " ^ input ^ "\n  expected: "
          ^ string_of_typ expected_typ
          ^ " / " ^ string_of_value expected_value ^ "\n  actual:   "
          ^ string_of_typ actual_typ ^ " / " ^ string_of_value actual_value)
    | Error message ->
        Fail
          ("input: " ^ input ^ "\n  expected: "
          ^ string_of_typ expected_typ
          ^ " / " ^ string_of_value expected_value ^ "\n  actual error: "
          ^ message)
  in
  ("run", name, detail)

let check_parse_error name input =
  let detail =
    match protect (fun () -> Driver.parse_string input) with
    | Ok actual ->
        Fail
          ("input: " ^ input ^ "\n  expected parse error\n  actual AST: "
         ^ string_of_expr actual)
    | Error message ->
        if is_todo_error message then
          Fail ("input: " ^ input ^ "\n  still hit unfinished code: " ^ message)
        else Pass
  in
  ("parse-error", name, detail)

let check_type_error name input =
  let detail =
    match protect (fun () -> Driver.parse_string input) with
    | Error message ->
        Fail
          ("input: " ^ input
         ^ "\n  expected parser to succeed, but got: " ^ message)
    | Ok expr -> (
        match protect (fun () -> Typechecker.infer [] expr) with
        | Ok typ ->
            Fail
              ("input: " ^ input ^ "\n  expected type error\n  actual type: "
             ^ string_of_typ typ)
        | Error message ->
            if is_todo_error message then
              Fail ("input: " ^ input ^ "\n  still hit unfinished code: " ^ message)
            else Pass)
  in
  ("type-error", name, detail)

let check_eval_error name expr =
  let detail =
    match protect (fun () -> Interpreter.eval [] expr) with
    | Ok value ->
        Fail
          ("expected runtime error\n  actual value: " ^ string_of_value value)
    | Error message ->
        if is_todo_error message then
          Fail ("still hit unfinished code: " ^ message)
        else Pass
  in
  ("eval-error", name, detail)

let parser_tests =
  [
    check_parse "integer literal" "42" (Int 42);
    check_parse "boolean literal" "true" (Bool true);
    check_parse "variable" "foo" (Var "foo");
    check_parse "multiplication before addition" "1 + 2 * 3"
      (Binop (Add, Int 1, Binop (Mul, Int 2, Int 3)));
    check_parse "parentheses override precedence" "(1 + 2) * 3"
      (Binop (Mul, Binop (Add, Int 1, Int 2), Int 3));
    check_parse "left associative addition" "1 + 2 + 3"
      (Binop (Add, Binop (Add, Int 1, Int 2), Int 3));
    check_parse "left associative multiplication" "2 * 3 * 4"
      (Binop (Mul, Binop (Mul, Int 2, Int 3), Int 4));
    check_parse "comparison after addition" "1 + 2 <= 3 * 4"
      (Binop
         ( Leq,
           Binop (Add, Int 1, Int 2),
           Binop (Mul, Int 3, Int 4) ));
    check_parse "if expression" "if 1 <= 2 then 3 else 4"
      (If (Binop (Leq, Int 1, Int 2), Int 3, Int 4));
    check_parse "let expression" "let x = 3 in x + 1"
      (Let ("x", Int 3, Binop (Add, Var "x", Int 1)));
    check_parse_error "chained comparison is rejected" "1 <= 2 <= 3";
    check_parse_error "keyword is not an identifier" "let true = 1 in true";
    check_parse_error "illegal character" "1 @ 2";
  ]

let run_tests =
  [
    check_run "integer" "5" TInt (VInt 5);
    check_run "true" "true" TBool (VBool true);
    check_run "false" "false" TBool (VBool false);
    check_run "arithmetic precedence" "1 + 2 * 3" TInt (VInt 7);
    check_run "parenthesized arithmetic" "(1 + 2) * 3" TInt (VInt 9);
    check_run "comparison true" "1 <= 2" TBool (VBool true);
    check_run "comparison false" "3 <= 2" TBool (VBool false);
    check_run "if chooses then" "if 1 <= 2 then 10 else 20" TInt
      (VInt 10);
    check_run "if chooses else" "if false then 10 else 20" TInt (VInt 20);
    check_run "let binding" "let x = 3 in x + 4" TInt (VInt 7);
    check_run "shadowing" "let x = 1 in let x = 2 in x" TInt (VInt 2);
    check_run "shadowing is local"
      "let x = 1 in let y = (let x = 2 in x) in x + y" TInt (VInt 3);
    check_run "boolean let" "let ok = 1 <= 1 in if ok then 8 else 9" TInt
      (VInt 8);
    check_run "let body can be bool" "let x = 2 in x <= 3" TBool
      (VBool true);
  ]

let type_error_tests =
  [
    check_type_error "branch mismatch" "if true then 1 else false";
    check_type_error "condition must be bool" "if 1 then 2 else 3";
    check_type_error "addition needs ints" "true + 1";
    check_type_error "multiplication needs ints" "2 * false";
    check_type_error "comparison needs ints" "true <= false";
    check_type_error "unbound variable" "x + 1";
    check_type_error "let does not bind in its own rhs" "let x = x + 1 in x";
    check_type_error "let-bound bool used as int" "let x = true in x + 1";
  ]

let eval_error_tests =
  [
    check_eval_error "unbound variable" (Var "x");
    check_eval_error "addition runtime type check" (Binop (Add, Bool true, Int 1));
    check_eval_error "if runtime condition check" (If (Int 0, Int 1, Int 2));
  ]

let all_tests =
  List.concat [ parser_tests; run_tests; type_error_tests; eval_error_tests ]

let print_result index total (group, name, result) =
  match result with
  | Pass -> Printf.printf "[PASS %02d/%02d] %-11s %s\n" index total group name
  | Fail detail ->
      Printf.printf "[FAIL %02d/%02d] %-11s %s\n  %s\n" index total group name
        detail

let () =
  let total = List.length all_tests in
  print_endline "== SimPL visible test suite ==";
  List.iteri (fun i test -> print_result (i + 1) total test) all_tests;
  let failures =
    List.filter
      (function
        | _, _, Pass -> false
        | _, _, Fail _ -> true)
      all_tests
  in
  print_endline "== Summary ==";
  Printf.printf "Passed: %d/%d\n" (total - List.length failures) total;
  if failures <> [] then exit 1
