(*1. 所有元素平方*)
let squares (l:'float list) =
  let square x = x*x in
  List.map square l
