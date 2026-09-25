# 武汉大学《程序语言理论与编译技术》OCaml 复习项目

本项目面向武汉大学《程序语言理论与编译技术》课程机考复习。内容按“基础语法 → 数据结构与算法 → 模拟机考 → 小语言实现 → 综合练习”组织；每个独立 Dune 项目都可在其自身目录中运行。

## 学习路线

| 目录 | 内容 | 建议操作 |
| --- | --- | --- |
| [`foundation/`](foundation/) | 表达式、尾递归、列表 API 与小练习 | 阅读 `foundation.md`，在 `list.ml`、`rec.ml` 中跟写 |
| [`advancement/`](advancement/) | 自定义类型、树、队列等进阶内容 | 阅读 `advancement.md`，运行对应 `.ml` 文件 |
| [`exercises/Intermediate/`](exercises/Intermediate/) | 52 道 OCaml.org Intermediate 练习 | `make test`；保留 `TODO` 供练习使用 |
| [`ocaml_test/`](ocaml_test/) | 短题与 ToyLang 模拟机考 | 重点运行 `toylang_examver` |
| [`plc/simpl/`](plc/simpl/) | 含函数和类型推导的 SimPL 解释器 | `dune test` |
| [`plc/blocklang/`](plc/blocklang/) | 带块作用域的 BlockLang 综合题 | `dune test` |
| [`comprehensive/toylang/`](comprehensive/toylang/) | 以模拟题为原题的“融汇贯通”独立项目 | `dune test` |


## 融汇贯通：独立综合项目

[`comprehensive/toylang/`](comprehensive/toylang/) 将 ToyLang 模拟题整理成与 `SimPL`、`BlockLang` 同风格的项目：有题面、分层 `lib/`、命令行入口、样例和回归测试。默认运行时会先静态检查、再解释执行。

```sh
cd comprehensive/toylang
dune test
dune exec toylang-comprehensive -- test/cases/factorial.toy
```

题目规则、类型规则及建议完成顺序见 [comprehensive/toylang/problem.md](comprehensive/toylang/problem.md)。

## 说明

- `SimPL` 是完整参考实现，并含可执行测试；`BlockLang` 当前可通过其样例测试。
- 建议使用与各子项目 `dune-project` 匹配的 Dune 版本，并在对应子目录运行命令。
