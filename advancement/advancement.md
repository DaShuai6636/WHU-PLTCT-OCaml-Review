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


## 2 模块系统

模块系统用来组织代码、隐藏实现细节、表达组件之间的关系。

可以先这样理解：

- `module` 是一组定义的容器
- `module type` 是模块的接口
- 函子 functor 是接收模块并返回模块的函数

模块系统解决的主要问题：

- 避免名字冲突
- 把相关函数和类型放在一起
- 只暴露必要的接口
- 对不同实现复用同一套代码

### 2.1 模块

模块 module 是一组值、类型、异常、子模块的集合。

语法：

```ocaml
module 模块名 = struct
  定义
end
```

模块名必须以大写字母开头。

例子：

```ocaml
module Counter = struct
  type t = int

  let zero = 0

  let incr n =
    n + 1

  let to_int n =
    n
end
```

访问模块中的内容使用 `.`：

```ocaml
let a = Counter.zero
let b = Counter.incr a
let n = Counter.to_int b
```

模块的重点：

- 把相关定义放在同一个命名空间中
- 外部通过 `模块名.名字` 访问内容
- 模块内部可以自由使用自己的定义

#### 模块中的类型

模块常常把类型和操作这个类型的函数放在一起。

```ocaml
module Point = struct
  type t = {
    x : float;
    y : float;
  }

  let make x y =
    { x; y }

  let distance p =
    sqrt (p.x *. p.x +. p.y *. p.y)
end
```

使用：

```ocaml
let p = Point.make 3.0 4.0
let d = Point.distance p
```

这里 `Point.t` 表示模块 `Point` 中定义的类型 `t`。

```ocaml
let origin : Point.t =
  Point.make 0.0 0.0
```

把主要类型命名为 `t` 是 OCaml 中很常见的习惯。
这样外部使用时会自然写成 `Point.t`、`Counter.t`、`Queue.t`。

#### open

`open` 可以把一个模块中的名字引入当前作用域。

```ocaml
open Point

let p = make 1.0 2.0
let d = distance p
```

`open` 的好处是代码更短，坏处是名字来源可能不够清楚。

更推荐在较小范围内使用局部打开：

```ocaml
let d =
  let open Point in
  distance (make 3.0 4.0)
```

也可以只对一个表达式打开：

```ocaml
let d =
  Point.(distance (make 3.0 4.0))
```

`open` 的重点：

- 少量使用可以减少重复
- 过度使用会降低可读性
- 公共代码中通常保留 `Module.name` 会更清楚

#### 文件与模块

在 OCaml 中，一个 `.ml` 文件天然对应一个模块。

例如文件名是：

```text
myqueue.ml
```

它在其他文件中对应的模块名通常是：

```ocaml
Myqueue
```

文件名小写，模块名首字母大写。

如果 `myqueue.ml` 中有：

```ocaml
let empty = []
```

其他文件中可以通过：

```ocaml
Myqueue.empty
```

来访问它。

### 2.2 模块签名

模块签名 module signature 描述一个模块对外暴露什么。

语法：

```ocaml
module type 签名名 = sig
  声明
end
```

例子：

```ocaml
module type COUNTER = sig
  type t

  val zero : t
  val incr : t -> t
  val to_int : t -> int
end
```

签名中只写“有什么”，不写“怎么实现”。

- `type t` 表示有一个类型 `t`
- `val zero : t` 表示有一个值 `zero`
- `val incr : t -> t` 表示有一个函数 `incr`

让模块满足某个签名：

```ocaml
module Counter : COUNTER = struct
  type t = int

  let zero = 0

  let incr n =
    n + 1

  let to_int n =
    n
end
```

使用：

```ocaml
let n =
  Counter.zero
  |> Counter.incr
  |> Counter.to_int
```

模块签名的重点：

- 签名是模块的接口
- 实现必须提供签名中要求的内容
- 签名之外的内容不会暴露给外部

#### 隐藏实现

签名可以隐藏具体实现，让外部只能通过函数操作数据。

```ocaml
module type STACK = sig
  type 'a t

  val empty : 'a t
  val is_empty : 'a t -> bool
  val push : 'a -> 'a t -> 'a t
  val pop : 'a t -> 'a t
  val top : 'a t -> 'a
end
```

实现：

```ocaml
module Stack : STACK = struct
  type 'a t = 'a list

  let empty = []

  let is_empty s =
    s = []

  let push x s =
    x :: s

  let pop s =
    match s with
    | [] -> failwith "empty stack"
    | _ :: rest -> rest

  let top s =
    match s with
    | [] -> failwith "empty stack"
    | x :: _ -> x
end
```

外部知道 `Stack.t` 是一个栈，但不知道它其实用 list 实现。

```ocaml
let s =
  Stack.empty
  |> Stack.push 1
  |> Stack.push 2
```

由于 `type 'a t` 是抽象类型，外部不能直接把它当作 list 使用。
这样可以保护模块内部的不变量。

隐藏实现的重点：

- 抽象类型让使用者依赖接口，而不是依赖内部结构
- 以后可以把 list 实现换成别的实现，外部代码不需要改
- 模块负责保证自己的数据始终合法

#### 暴露类型实现

有时也希望在签名中暴露类型的具体定义。

```ocaml
module type INT_COUNTER = sig
  type t = int

  val zero : t
  val incr : t -> t
end
```

这时外部知道 `t` 就是 `int`。

```ocaml
module Int_counter : INT_COUNTER = struct
  type t = int

  let zero = 0

  let incr n =
    n + 1
end
```

使用：

```ocaml
let n : int =
  Int_counter.incr Int_counter.zero
```

是否暴露类型实现，取决于你是否希望外部依赖这个实现。

### 2.3 函子

函子 functor，也常被直译为函数子，是从模块到模块的函数。

普通函数接收值：

```ocaml
let add_one x =
  x + 1
```

函子接收模块：

```ocaml
module F (M : 模块签名) = struct
  定义
end
```

函子适合表达：

- 同一套逻辑依赖某个模块提供的能力
- 不同模块满足同一个接口，就能复用同一套代码
- 生成的模块带有固定的类型和函数

#### 一个简单函子

先定义一个签名，表示“某个类型可以转成字符串”。

```ocaml
module type SHOW = sig
  type t

  val to_string : t -> string
end
```

定义函子：

```ocaml
module Make_printer (S : SHOW) = struct
  let print x =
    print_endline (S.to_string x)
end
```

给 `int` 提供一个满足 `SHOW` 的模块：

```ocaml
module Int_show = struct
  type t = int

  let to_string =
    string_of_int
end
```

应用函子，生成新模块：

```ocaml
module Int_printer = Make_printer (Int_show)

let () =
  Int_printer.print 42
```

这里的关系是：

- `Int_show` 提供能力
- `Make_printer` 复用这份能力
- `Int_printer` 是生成出来的具体模块

#### 带类型约束的函子

有些时候，生成模块中的函数参数类型需要和输入模块的类型保持一致。

```ocaml
module type ORDERED = sig
  type t

  val compare : t -> t -> int
end
```

定义一个生成 `min` 函数的函子：

```ocaml
module Make_min (Ord : ORDERED) = struct
  let min a b =
    if Ord.compare a b <= 0 then a else b
end
```

为整数提供比较模块：

```ocaml
module Int_ordered = struct
  type t = int

  let compare a b =
    Stdlib.compare a b
end
```

生成整数版本：

```ocaml
module Int_min = Make_min (Int_ordered)

let a =
  Int_min.min 3 5
```

这个例子表达的思想是：`Make_min` 不关心具体类型是什么，只关心这个类型能不能比较。

函子的重点：

- 函子让“模块级别的复用”成为可能
- 输入模块必须满足指定签名
- 输出模块可以使用输入模块提供的类型和值
- 初学时先把函子理解为“模块工厂”

### 2.4 模块、签名、函子的关系

三者可以这样对应：

- 模块：具体实现
- 模块签名：接口约束
- 函子：根据模块生成模块

一个常见设计顺序：

1. 先写普通模块，把功能跑通
2. 再抽出模块签名，明确对外接口
3. 如果发现多种实现共享同一套逻辑，再考虑函子

例子：

```ocaml
module type STORAGE = sig
  type key
  type value
  type t

  val empty : t
  val get : key -> t -> value option
  val put : key -> value -> t -> t
end
```

这个签名没有规定如何存储，只规定一个存储模块应该提供什么能力。

以后可以有不同实现：

- 用 list 实现
- 用 tree 实现
- 用 hash table 实现

只要它们满足同一个签名，使用者就可以依赖同一个接口。

模块系统的总结：

- 用 `module` 组织实现
- 用 `module type` 描述接口
- 用抽象类型隐藏内部结构
- 用函子复用依赖模块能力的代码
- 不需要一开始就写复杂模块系统，先从清楚的模块边界开始
