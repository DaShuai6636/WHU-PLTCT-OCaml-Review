# OCaml.org Intermediate 练习项目

这个目录对应仓库根目录的 `ocaml_org_intermediate_exercises_statements.md`，包含 52 道 Intermediate 题目的函数骨架和中文测试。

## 目录

- `lib/solutions.ml`：你要实现的函数都在这里，按 `Ex01` 到 `Ex52` 分模块。
- `test/test_intermediate.ml`：中文测试程序，会检查示例结果和一些关键性质。
- `Makefile`：不依赖 dune，直接用 `ocamlc` 编译运行。

## 运行测试

在当前目录执行：

```sh
make test
```

未实现的函数会显示 `未实现`；实现后如果结果正确会显示 `通过`，结果不对会显示 `失败` 并打印期望值和实际值。

## 实现方式

打开 `lib/solutions.ml`，把类似下面的占位代码：

```ocaml
let compress (_ : 'a list) : 'a list = todo "Ex02.compress"
```

替换成你的实现即可。每道题都放在独立模块中，例如第 2 题是 `Solutions.Ex02.compress`，第 14 题是 `Solutions.Ex14.is_prime`。

## 约定

- 图相关题目使用无向图表示：`{ nodes; edges }`，其中 `edges` 是节点对列表。
- 第 41 题最小生成树使用带权无向图：`{ nodes; edges = (u, v, weight) list }`。
- 第 48 题 `knights_tour n` 返回 `(int * int) list option`，棋盘坐标从 `(1, 1)` 到 `(n, n)`。
- 第 51 题 `sudoku` 使用 `int array array`，空格用 `0` 表示，成功时返回 `Some grid`。
- 第 38 题 Lisp 风格多叉树测试采用形如 `(a (f g) c (b d e))` 的字符串。
