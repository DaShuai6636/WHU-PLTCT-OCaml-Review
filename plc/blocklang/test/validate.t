  $ dune exec blocklang -- cases/sample1.bl
  7

  $ dune exec blocklang -- cases/sample2.bl
  1

  $ dune exec blocklang -- cases/sample3.bl
  2
  20

  $ dune exec blocklang -- cases/sample4.bl
  Error: Undefined variable y

  $ dune exec blocklang -- cases/sample5.bl
  Error: Type mismatch in assignment to x

  $ dune exec blocklang -- cases/sample6.bl
  Error: Condition of if must be bool

  $ dune exec blocklang -- cases/sample7.bl
  Error: Branches of if must have same type

  $ dune exec blocklang -- cases/sample8.bl
  TRUE
