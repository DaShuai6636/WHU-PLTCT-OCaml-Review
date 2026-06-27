# SimPL 核心解释器

实现一个小语言 SimPL 的 lexer、parser、类型推导和求值器。项目框架、AST、接口、命令行和测试已经给好，你只需要补全：

- `lib/lexer.mll`
- `lib/parser.mly`
- `lib/typechecker.ml`
- `lib/interpreter.ml`

## 语法

```text
e ::= x
    | n
    | true
    | false
    | e + e
    | e * e
    | e <= e
    | if e then e else e
    | let x = e in e
    | (e)
```

整数为 `[0-9]+`，变量名建议支持 `[a-zA-Z_][a-zA-Z0-9_]*`。关键字：`true false if then else let in`。空白字符忽略，非法字符抛出 `Lexer.SyntaxError` 或其他异常均可。

运算符优先级从高到低：

```text
( )
*
+
<=
if then else
let x = e in e
```

`+`、`*` 左结合；`<=` 非结合，`1 <= 2 <= 3` 应为语法错误。

## AST 与接口

`lib/ast.ml` 已固定：

```ocaml
type binop = Add | Mul | Leq

type expr =
  | Var of string
  | Int of int
  | Bool of bool
  | Binop of binop * expr * expr
  | If of expr * expr * expr
  | Let of string * expr * expr

type typ = TInt | TBool
type tyenv = (string * typ) list

type value = VInt of int | VBool of bool
type env = (string * value) list
```

你需要实现：

```ocaml
val infer : Ast.tyenv -> Ast.expr -> Ast.typ
val eval : Ast.env -> Ast.expr -> Ast.value
```

## 规则

- `+`、`*`：两个操作数必须是 `int`，结果是 `int`。
- `<=`：两个操作数必须是 `int`，结果是 `bool`。
- `if`：条件必须是 `bool`，两个分支类型必须相同。
- `let x = e1 in e2`：先在原环境检查/求值 `e1`，再在扩展环境中检查/求值 `e2`。
- 未绑定变量、类型错误、运行时类型错误都可以用异常报告；测试只要求正确区分“成功”和“应报错”。

## 验证

自动测试：

```sh
dune test
```

更直观的测试输出：

```sh
dune exec test/run_tests.exe
```

也可以运行单个文件：

```sh
dune exec bin/simpl.exe -- test/cases/sample1.simpl
```
