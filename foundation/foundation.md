# Ocaml 基础理解
## 1 表达式导向语言
OCaml 是一种典型的**表达式导向（expression-oriented）语言**。理解这一特点，对于学习 OCaml 的语法、函数式编程风格以及代码组织方式都非常重要。
### 1.1 什么是表达式
在编程语言中，**表达式（Expression）**是指能够经过求值（evaluation）后产生一个结果的代码片段。

### 1.2 OCaml 中大多数计算结构都是表达式
与一些以语句（statement）为主的语言不同，OCaml 中很多常见的语言结构本身就是表达式，因此它们都能够返回值。
`if...then...else...`、`模式匹配`、`let...=...in...`都是表达式，都可以随意组合。

### 1.3 函数也是值
在 OCaml 中，函数不仅仅是可调用的代码，它们本身也是一种值（value）。
- 函数可以赋给变量
- 也可以作为参数传递
- 函数还可以作为返回值
这种“函数也是值”的特性是函数式编程的重要基础，也使得高阶函数（Higher-Order Functions）成为 OCaml 中非常常见的编程方式。

## 2 尾递归
尾递归指递归调用是当前函数执行的最后一步。也就是说，递归调用返回之后，当前函数不再做任何额外计算。
### 2.1 累加器
为了把非尾递归改成尾递归，通常引入一个累加器 accumulator，简称`acc`。
### 2.2 检查
OCaml 可以用 [@tailcall] 检查某个递归调用是否真的是尾调用。

## 3 List
### 3.1 构造与拼接

- `[] : 'a list`：空列表
- `(::) : 'a -> 'a list -> 'a list`：把元素加到列表头部，O(1)
- `(@) : 'a list -> 'a list -> 'a list`：拼接两个列表，复制左列表

### 3.2 基本查询

- `List.length : 'a list -> int`：返回列表长度
- `List.hd : 'a list -> 'a`：返回第一个元素，空列表报错
- `List.tl : 'a list -> 'a list`：返回尾列表，空列表报错
- `List.nth : 'a list -> int -> 'a`：返回指定下标元素，越界报错
- `List.nth_opt : 'a list -> int -> 'a option`：返回指定下标元素，越界返回 `None`

### 3.3 反转与压平

- `List.rev : 'a list -> 'a list`：反转列表
- `List.rev_append : 'a list -> 'a list -> 'a list`：反转第一个列表并接到第二个列表前
- `List.concat : 'a list list -> 'a list`：把嵌套一层的列表压平
- `List.flatten : 'a list list -> 'a list`：等同于 `List.concat`

### 3.4 映射

- `List.map : ('a -> 'b) -> 'a list -> 'b list`：对每个元素应用函数，生成新列表
- `List.mapi : (int -> 'a -> 'b) -> 'a list -> 'b list`：带下标地对每个元素应用函数
- `List.map2 : ('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list`：同时遍历两个列表，对对应元素应用函数，长度不同报错

### 3.5 过滤

- `List.filter : ('a -> bool) -> 'a list -> 'a list`：保留满足条件的元素
- `List.filter_map : ('a -> 'b option) -> 'a list -> 'b list`：返回 `Some x` 的保留为 `x`，返回 `None` 的丢弃
- `List.partition : ('a -> bool) -> 'a list -> 'a list * 'a list`：按条件把列表分成满足和不满足两部分

### 3.6 判断

- `List.exists : ('a -> bool) -> 'a list -> bool`：是否存在至少一个元素满足条件
- `List.for_all : ('a -> bool) -> 'a list -> bool`：是否所有元素都满足条件
- `List.mem : 'a -> 'a list -> bool`：判断元素是否在列表中，使用 `=`
- `List.memq : 'a -> 'a list -> bool`：判断元素是否在列表中，使用 `==`

### 3.7 查找

- `List.find : ('a -> bool) -> 'a list -> 'a`：返回第一个满足条件的元素，找不到报错
- `List.find_opt : ('a -> bool) -> 'a list -> 'a option`：返回第一个满足条件的元素，找不到返回 `None`
- `List.assoc : 'a -> ('a * 'b) list -> 'b`：在关联列表中按 key 查 value，找不到报错
- `List.assoc_opt : 'a -> ('a * 'b) list -> 'b option`：在关联列表中按 key 查 value，找不到返回 `None`
- `List.mem_assoc : 'a -> ('a * 'b) list -> bool`：判断关联列表中是否存在某个 key
- `List.remove_assoc : 'a -> ('a * 'b) list -> ('a * 'b) list`：删除第一个匹配 key 的键值对

### 3.8 折叠

- `List.fold_left : ('acc -> 'a -> 'acc) -> 'acc -> 'a list -> 'acc`：从左到右累积，适合求和、计数、统计
- `List.fold_right : ('a -> 'acc -> 'acc) -> 'a list -> 'acc -> 'acc`：从右到左累积，适合保持顺序构造新列表

### 3.9 遍历副作用

- `List.iter : ('a -> unit) -> 'a list -> unit`：对每个元素执行副作用函数，不返回新列表
- `List.iteri : (int -> 'a -> unit) -> 'a list -> unit`：带下标执行副作用函数
- `List.iter2 : ('a -> 'b -> unit) -> 'a list -> 'b list -> unit`：同时遍历两个列表执行副作用，长度不同报错

### 3.10 排序

- `List.sort : ('a -> 'a -> int) -> 'a list -> 'a list`：根据比较函数排序
- `List.stable_sort : ('a -> 'a -> int) -> 'a list -> 'a list`：稳定排序
- `List.fast_sort : ('a -> 'a -> int) -> 'a list -> 'a list`：偏性能的排序
- `compare : 'a -> 'a -> int`：通用比较函数，常用于排序

### 3.11 组合与拆分

- `List.combine : 'a list -> 'b list -> ('a * 'b) list`：把两个列表合成 pair 列表，长度不同报错
- `List.split : ('a * 'b) list -> 'a list * 'b list`：把 pair 列表拆成两个列表

### 3.12 创建列表

- `List.init : int -> (int -> 'a) -> 'a list`：根据长度和下标函数生成列表


6道大题，ocaml
前三道大题送分：比如两个有序表归并成一个有序表，list，type，rec
后三题编译：递归下降法或ocamlyacc、语义分析与计算（类型、求值、属性）、中间代码生成（不是汇编）

采用赋分