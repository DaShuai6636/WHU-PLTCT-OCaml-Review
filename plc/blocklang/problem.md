# BlockLang 综合题

实现一个小型语言 BlockLang，完成 AST、lexer、parser、静态类型检查器和解释器。程序运行方式：

```sh
dune exec blocklang -- <input-file>
```

运行流程：读取文件，解析为 AST，先做静态类型检查；检查通过后解释执行。任意阶段出错时输出：

```text
Error: <错误信息>
```

## 语法

```text
p ::= s*

s ::= x := e;
    | PRINT e;

e ::= n
    | TRUE
    | FALSE
    | x
    | e + e
    | e * e
    | e < e
    | e = e
    | IF e THEN e ELSE e
    | BLOCK s* RETURN e END
    | (e)
```

变量名为 `[a-z]+`，整数为 `[0-9]+`。空白字符忽略。关键字和符号：

```text
TRUE FALSE IF THEN ELSE BLOCK RETURN END PRINT
:= ; + * < = ( )
```

运算符优先级从高到低：`*`，`+`，`<` 和 `=`。`<`、`=` 不要求支持连续结合。

## AST

`lib/ast.ml` 已给出目标 AST 类型。你需要让 parser 解析出等价 AST。

## 类型规则

BlockLang 只有两种类型：`IntType` 和 `BoolType`。

- `+`、`*`：两个操作数必须都是 `IntType`，结果为 `IntType`。否则 `failwith "Arithmetic operations require int operands"`。
- `<`：两个操作数必须都是 `IntType`，结果为 `BoolType`。否则 `failwith "Comparison requires int operands"`。
- `=`：两个操作数类型必须相同，结果为 `BoolType`。否则 `failwith "Equality requires operands of same type"`。
- `IF c THEN a ELSE b`：`c` 必须是 `BoolType`，否则 `failwith "Condition of if must be bool"`；两个分支类型必须相同，否则 `failwith "Branches of if must have same type"`。
- 未定义变量：`failwith ("Undefined variable " ^ x)`。
- 赋值：若变量已在当前或外层作用域定义，右侧类型必须一致；否则在当前作用域定义新变量。类型不一致时报 `failwith ("Type mismatch in assignment to " ^ x)`。
- `BLOCK s* RETURN e END`：创建内层作用域，块内可访问外层变量；块内新变量离开块后不可见；块内对外层已有变量的更新保留；块表达式类型为 `RETURN e` 的类型。
- `PRINT e`：只要求 `e` 类型合法，可打印整数或布尔值。

## 运行规则

运行时值：

```ocaml
type value =
  | IntVal of int
  | BoolVal of bool
```

未绑定变量报 `failwith ("Unbound name " ^ x)`。运行时类型错误统一报 `failwith "Runtime type error"`。

`PRINT` 输出整数，或输出布尔值 `TRUE` / `FALSE`，每次输出后换行。

## 待完成文件

- `lib/lexer.mll`
- `lib/parser.mly`
- `lib/typechecker.ml`
- `lib/interpreter.ml`

## 验证

完成实现后运行：

```sh
dune test
```

验证样例放在 `test/cases/`，Cram 测试写在 `test/validate.t`。
