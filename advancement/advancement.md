# Ocaml 进阶

## 1 type 定义你自己的类型

`type` 用来给类型命名，或定义新的数据结构。

基本形式：

```ocaml
type 类型名 = 类型表达式
```

常见用途：

- 给已有类型起别名
- 定义变体类型 variant
- 定义记录类型 record
- 定义递归数据结构
- 定义参数化类型，也就是带类型参数的类型

类型名通常小写，构造器名必须大写。

```ocaml
type user_id = int
type color = Red | Green | Blue
```

### 1.1 类型别名

类型别名是给已有类型起一个新名字。

语法：

```ocaml
type 新类型名 = 已有类型
```

例子：

```ocaml
type name = string
type age = int
type point = float * float

let p : point = (3.0, 4.0)
```

类型别名不会创建新的运行时结构，它只是让类型含义更清楚。

```ocaml
type user_id = int

let next_id (id : user_id) : user_id =
  id + 1
```

这里 `user_id` 本质上仍然是 `int`，所以可以直接参与整数运算。

适合使用类型别名的场景：

- 提高代码可读性
- 给复杂类型命名
- 表达业务含义

```ocaml
type student = string * int

let s : student = ("Alice", 20)
```

### 1.2 变体

变体类型 variant 表示“一个值可能属于几种情况之一”。

语法：

```ocaml
type 类型名 =
  | 构造器1
  | 构造器2
  | 构造器3
```

每个构造器表示一种可能情况。构造器名必须以大写字母开头。

#### 普通变体

普通变体的构造器不携带额外数据，常用于枚举。

```ocaml
type direction =
  | North
  | South
  | East
  | West
```

使用模式匹配处理不同情况：

```ocaml
let turn_back d =
  match d with
  | North -> South
  | South -> North
  | East -> West
  | West -> East
```

普通变体的重点：

- 每个构造器只是一个标签
- 值只能是其中一种情况
- `match` 应该覆盖所有构造器

#### 数据变体

数据变体的构造器可以携带数据。

语法：

```ocaml
type 类型名 =
  | 构造器 of 类型
  | 构造器 of 类型1 * 类型2
```

例子：

```ocaml
type shape =
  | Circle of float
  | Rectangle of float * float
```

构造值：

```ocaml
let c = Circle 3.0
let r = Rectangle (4.0, 5.0)
```

匹配并取出数据：

```ocaml
let area s =
  match s with
  | Circle radius -> 3.14 *. radius *. radius
  | Rectangle (width, height) -> width *. height
```

再看一个常见例子：

```ocaml
type result =
  | Success of string
  | Error of string

let message r =
  match r with
  | Success value -> "success: " ^ value
  | Error reason -> "error: " ^ reason
```

数据变体的重点：

- 构造器不仅区分情况，还能保存数据
- 取数据时通常使用模式匹配
- 不同构造器可以携带不同类型、不同数量的数据

#### 递归变体

递归变体指类型定义中引用了它自己，常用于树、表达式、链表等递归结构。

例子：二叉树

```ocaml
type int_tree =
  | Empty
  | Node of int * int_tree * int_tree
```

构造一棵树：

```ocaml
let tree =
  Node (1,
    Node (2, Empty, Empty),
    Node (3, Empty, Empty))
```

计算节点数量：

```ocaml
let rec size t =
  match t with
  | Empty -> 0
  | Node (_, left, right) -> 1 + size left + size right
```

例子：表达式语法树

```ocaml
type expr =
  | Int of int
  | Add of expr * expr
  | Mul of expr * expr
```

求值：

```ocaml
let rec eval e =
  match e with
  | Int n -> n
  | Add (a, b) -> eval a + eval b
  | Mul (a, b) -> eval a * eval b
```

使用：

```ocaml
let e = Add (Int 1, Mul (Int 2, Int 3))
let n = eval e
```

递归变体的重点：

- 类型可以引用自身
- 处理递归数据通常也需要递归函数
- `match` 负责拆分当前层，递归调用处理子结构

#### 参数化变体

参数化变体指类型中带有类型参数，类似泛型。

语法：

```ocaml
type 'a 类型名 =
  | 构造器 of 'a
```

`'a` 表示任意类型。

例子：自己定义一个 `option`

```ocaml
type 'a my_option =
  | My_none
  | My_some of 'a
```

使用：

```ocaml
let a : int my_option = My_some 10
let b : string my_option = My_some "hello"
let c : int my_option = My_none
```

取值：

```ocaml
let default d x =
  match x with
  | My_none -> d
  | My_some value -> value
```

例子：参数化二叉树

```ocaml
type 'a tree =
  | Leaf
  | Branch of 'a * 'a tree * 'a tree
```

统计节点数：

```ocaml
let rec tree_size t =
  match t with
  | Leaf -> 0
  | Branch (_, left, right) -> 1 + tree_size left + tree_size right
```

多个类型参数：

```ocaml
type ('k, 'v) entry =
  | Entry of 'k * 'v
```

参数化变体的重点：

- `'a`、`'b` 是类型参数
- 同一个结构可以保存不同类型的数据
- 标准库中的 `'a option`、`'a list` 都是参数化类型

#### 多态变体与子类型

普通变体需要先用 `type` 定义，多态变体 polymorphic variant 可以直接使用。

语法特点：

- 构造器名前有反引号 `` ` ``
- 不一定需要提前定义类型
- 可以通过子类型约束表达“至少包含”或“至多包含”某些标签

例子：

```ocaml
let color_name c =
  match c with
  | `Red -> "red"
  | `Green -> "green"
  | `Blue -> "blue"
```

OCaml 会推断出：

```ocaml
color_name : [< `Blue | `Green | `Red ] -> string
```

含义：参数类型至多包含 `` `Red ``、`` `Green ``、`` `Blue `` 这些标签。

可以直接调用：

```ocaml
let r = color_name `Red
```

多态变体可以在不同函数之间共享部分标签：

```ocaml
let is_warm c =
  match c with
  | `Red -> true
  | `Orange -> true
  | `Blue -> false
```

也可以显式写类型：

```ocaml
type basic_color = [ `Red | `Green | `Blue ]

let show_basic (c : basic_color) =
  match c with
  | `Red -> "red"
  | `Green -> "green"
  | `Blue -> "blue"
```

常见类型符号：

- `[< ... ]`：至多包含这些标签，常出现在只消费数据的函数中
- `[> ... ]`：至少包含这些标签，常出现在会返回某些标签的函数中
- `[ ... ]`：刚好是这些标签

多态变体的重点：

- 写法更灵活，适合组合开放的标签集合
- 类型推断结果可能比普通变体复杂
- 初学时优先使用普通变体，只有需要开放扩展时再使用多态变体

### 1.3 记录

记录 record 是一组带名字的字段，适合表示结构化数据。

语法：

```ocaml
type 类型名 = {
  字段1 : 类型1;
  字段2 : 类型2;
}
```

例子：

```ocaml
type student = {
  name : string;
  age : int;
  score : float;
}
```

创建记录：

```ocaml
let alice = {
  name = "Alice";
  age = 20;
  score = 92.5;
}
```

访问字段：

```ocaml
let alice_name = alice.name
let alice_score = alice.score
```

记录字段可以用于模式匹配：

```ocaml
let describe s =
  match s with
  | { name; age; score } ->
      name ^ " is " ^ string_of_int age
```

只匹配需要的字段：

```ocaml
let get_name { name; _ } =
  name
```

不可变更新：

```ocaml
let birthday s =
  { s with age = s.age + 1 }
```

`{ s with age = ... }` 会创建一个新记录，原来的 `s` 不变。

记录的重点：

- 字段有名字，比元组更清楚
- 默认不可变
- 更新记录时通常创建新值
- 字段名在同一作用域内可能需要避免冲突

#### mutable

记录字段默认不可变。如果希望字段可以被修改，需要使用 `mutable`。

语法：

```ocaml
type 类型名 = {
  mutable 字段名 : 类型;
}
```

例子：

```ocaml
type counter = {
  mutable value : int;
}

let c = { value = 0 }
```

修改字段使用 `<-`：

```ocaml
c.value <- c.value + 1
```

封装成函数：

```ocaml
let incr_counter c =
  c.value <- c.value + 1

let get_counter c =
  c.value
```

注意：

- `=` 用于创建记录或比较值
- `<-` 用于修改 `mutable` 字段
- 修改字段是副作用，表达式结果类型通常是 `unit`

```ocaml
let reset c =
  c.value <- 0
```

`mutable` 适合需要原地更新的场景，例如计数器、缓存、状态对象。
普通数据建模仍然优先使用不可变记录。

#### ref

`ref` 是标准库提供的可变引用，本质上可以理解为只有一个可变字段的记录。

可以近似理解为：

```ocaml
type 'a ref = {
  mutable contents : 'a;
}
```

创建引用：

```ocaml
let count = ref 0
```

读取引用：

```ocaml
let n = !count
```

修改引用：

```ocaml
count := !count + 1
```

常用操作：

- `ref x`：创建引用
- `!r`：读取引用内容
- `r := x`：修改引用内容

例子：

```ocaml
let counter () =
  let count = ref 0 in
  fun () ->
    count := !count + 1;
    !count
```

使用：

```ocaml
let next = counter ()

let a = next ()
let b = next ()
```

这里 `count` 被闭包保存，每次调用 `next` 都会更新同一个引用。

`ref` 与 `mutable` 的区别：

- `mutable` 修改记录中的某个字段
- `ref` 修改一个独立的可变单元
- `ref` 更轻量，适合局部状态
- `mutable` 更适合结构化对象中的状态字段

总结：

- 能用不可变值时，优先用不可变值
- 需要局部可变状态时，用 `ref`
- 需要多个字段组成的可变状态时，用 `mutable record`

