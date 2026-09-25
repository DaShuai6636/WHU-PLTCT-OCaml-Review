# ToyLang 融汇贯通

本题把 OCaml 基础、递归、代数数据类型、`Map` 环境、lexer/parser、静态类型检查和解释器串成一个可运行的小语言。它以 `ocaml_test/toylang_examver` 的模拟题为原题，整理为独立的综合练习项目。

## 目标

完成 `lib/` 下的 AST、词法分析器、yacc 语法分析器、类型检查器和解释器，使得：

```sh
dune test
dune exec bin/toylang.exe -- test/cases/factorial.toy
```

均可运行。

## 语言

```text
program ::= stmt* EOF
stmt    ::= ID := exp ;
          | PRINT exp ;
          | IF exp THEN stmt+ [ELSE stmt+] END ;
          | REPEAT stmt+ UNTIL exp ;

exp     ::= simple_exp [ ( < | = ) simple_exp ]
simple_exp ::= simple_exp (+|-) term | term
term    ::= term (*|/) factor | factor
factor  ::= NUM | TRUE | FALSE | ID | ( exp )
```

`*`、`/` 高于 `+`、`-`，比较最低，且比较不允许链式结合。

## 语义与类型规则

- 变量第一次赋值时确定类型，之后重赋值必须保持类型相同。
- `+ - * /` 仅接受整数，`<` 仅比较整数，`=` 两侧必须同类型。
- `IF` 和 `REPEAT ... UNTIL` 的条件必须为布尔值。
- `IF` 内部新建的变量不流出分支；`REPEAT` 成功检查后带出循环体环境。
- 运行时用 `int` 表示值：`0` 为假，非 `0` 为真；布尔值在 `PRINT` 时同样打印为 `0/1`。

## 建议顺序

1. 先完成 AST 与 lexer，使用 `lexer.mll` 的 token 自测。
2. 按优先级完成 `parser.mly`，先让样例解析成功。
3. 以不可变 `Map` 实现类型环境，再实现表达式推导。
4. 用另一份 `Map` 实现运行时环境和循环。
5. 执行 `dune test`，并补充边界案例。
