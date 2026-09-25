# ToyLang 融汇贯通练习

这是从模拟机考题提炼出的独立综合项目，目录结构与 `plc/simpl`、`plc/blocklang` 一致。

```sh
dune test
dune exec bin/toylang.exe -- test/cases/factorial.toy
```

完整题目见 [problem.md](problem.md)。可将 `lib/` 中的实现替换为自己的版本，再用 `test/` 回归验证。
