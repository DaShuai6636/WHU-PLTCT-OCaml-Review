# SimPL 核心解释器

实现一个小语言 SimPL 的 lexer、parser、类型推导和求值器。语言现在包含整数、布尔、let、if、匿名函数和函数应用。

## 语法

```text
e ::= x
    | n
    | true
    | false
    | fun x -> e
    | e e
    | e + e
    | e * e
    | e <= e
    | if e then e else e
    | let x = e in e
    | (e)
```

整数为 `[0-9]+`，变量名建议支持 `[a-zA-Z_][a-zA-Z0-9_]*`。关键字：`true false if then else let in fun`。符号：`+ * <= = -> ( )`。空白字符忽略，非法字符抛出 `Lexer.SyntaxError` 或其他异常均可。

优先级从高到低：

```text
( )
e e        函数应用，左结合
*
+
<=         非结合，1 <= 2 <= 3 应报语法错误
fun x -> e
if e then e else e
let x = e in e
```

## AST 与接口

`lib/ast.ml` 已固定：

```ocaml
module StringMap = Map.Make (String)

type binop = Add | Mul | Leq

type expr =
  | Var of string
  | Int of int
  | Bool of bool
  | Fun of string * expr
  | App of expr * expr
  | Binop of binop * expr * expr
  | If of expr * expr * expr
  | Let of string * expr * expr

type typ =
  | TInt
  | TBool
  | TVar of string
  | TFun of typ * typ

type tyenv = typ StringMap.t

type value =
  | VInt of int
  | VBool of bool
  | VClosure of string * expr * env

and env = value StringMap.t
```

你需要实现：

```ocaml
val infer : Ast.tyenv -> Ast.expr -> Ast.typ
val eval : Ast.env -> Ast.expr -> Ast.value
```

## 类型规则

- `+`、`*`：两个操作数必须是 `int`，结果是 `int`。
- `<=`：两个操作数必须是 `int`，结果是 `bool`。
- `if`：条件必须是 `bool`，两个分支类型必须相同。
- `fun x -> e`：给 `x` 生成一个新类型变量，用 `StringMap.add x tx env` 扩展类型环境后推导 `e`，结果是函数类型。
- `e1 e2`：`e1` 必须能统一为 `arg -> result`，`e2` 必须能统一为 `arg`，整体类型是 `result`。
- `let x = e1 in e2`：先在原环境推导 `e1`，再用 `StringMap.add x t1 env` 扩展类型环境后推导 `e2`。本题不要求实现 let 多态；测试不会要求同一个 let 绑定以不同类型重复使用。
- `fun x -> x x` 一类无限类型应当报类型错误。

## 求值规则

- `fun x -> e` 求值为闭包 `VClosure (x, e, env)`，闭包保存创建时的环境。
- `e1 e2`：先求值 `e1`，它必须是闭包；再求值参数，用 `StringMap.add x arg closure_env` 把参数绑定到闭包参数名，再在闭包保存的环境中求值函数体。

环境说明：

- 查找变量使用 `StringMap.find_opt x env`。
- 扩展环境使用 `StringMap.add x v env` 或 `StringMap.add x t env`。
- `StringMap` 是不可变 Map；`add` 返回新环境，不会修改旧环境。因此变量遮蔽、let 作用域和闭包保存定义时环境都能正常表达。
- 初始类型环境和运行时环境分别是 `StringMap.empty`。

## 错误信息要求

请使用下面这些固定错误信息。除 lexer/parser 外，直接用 `failwith` 即可。

| 场景 | 要求 |
|---|---|
| 未绑定变量 `x` | `failwith ("Unbound variable " ^ x)` |
| `+` 或 `*` 的操作数不是 `int` | `failwith "Arithmetic operations require int operands"` |
| `<=` 的操作数不是 `int` | `failwith "Comparison requires int operands"` |
| `if` 条件不是 `bool` | `failwith "Condition of if must be bool"` |
| `if` 两个分支类型不同 | `failwith "Branches of if must have same type"` |
| 函数应用左侧不是函数类型 | `failwith "Application requires a function"` |
| 函数实参类型和形参类型不一致 | `failwith "Function argument type mismatch"` |
| 类型统一时出现其它不兼容类型 | `failwith "Type mismatch"` |
| 出现无限类型，例如 `fun x -> x x` | `failwith "Occurs check failed"` |
| 运行时 `+`、`*`、`<=`、`if`、函数应用遇到错误值 | `failwith "Runtime type error"` |
| lexer 遇到非法字符 `c` | `raise (Lexer.SyntaxError (Printf.sprintf "unexpected character %C" c))` |
| parser 遇到非法语法 | 让 parser 抛出 `Parsing.Parse_error` 即可 |

说明：

- `infer` 应该在类型错误时失败；顶层 `run_string` 会先调用 `infer`，只有类型推导成功才调用 `eval`。
- 测试主要检查是否成功或失败，但请按上表写错误信息，方便人工调试和后续扩展隐藏测试。
- 如果某个错误同时可归为多个场景，优先报更具体的错误。例如 `(fun x -> x + 1) true` 报 `Function argument type mismatch`，而不是普通 `Type mismatch`。

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
