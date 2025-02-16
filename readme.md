# Para C Language
---

## Brief
C-style language.
Is using Flex and Bison for syntax, lexical analysis and parsing.

## Using
Flex - A tool for generating lexical analyzers (scanners) from regular expressions.
Bison - A parser generator that builds syntax analyzers from context-free grammars.

## Example 
```lang
  y = 5;
  z = y + 2;
  
  if (z == 10) { 
      x = 12; 
  }
```

## How to build Flex and Bison 
```shell
  flex -o Frontend/src/lexer.cpp Frontend/src/lexer.l 
  bison -d -o Frontend/src/parser.cpp Frontend/src/parser.y     
  g++ -o parser Frontend/src/parser.cpp Frontend/src/lexer.cpp -std=c++17
```

## How to build
```shell
  cmake -DCMAKE_BUILD_TYPE=Release -S . -B build
  cmake --build build
  ./build/para_cl.x
```


## Authors
- Андрей Глисанов 
- Владимир Вехов