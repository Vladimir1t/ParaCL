%{
#include <iostream>
#include <string>
#include "parser.hpp"

extern int yylex();
void yyerror(const std::string str);
%}

%union {
    int intval;
    double doubleval;
    char* str;
    ASTNode* ast;
    Declaration* decl;
    Assignment* assign;
    IfStatement* ifstmt;
}

%type <ast> program
%type <decl> declaration
%type <assign> assignment
%type <ifstmt> if_statement
%type <ast> expr


%token <intval> INTEGER
%token <doubleval> FLOAT
%token <str> IDENTIFIER

%%

program:
      declarations statements
    ;

declarations:
      declaration ';'
    | declarations declaration ';'
    ;

declaration:
      /* ваша логика для объявления */
      { $$ = new Declaration(/* параметры */); }
    |
      { $$ = nullptr; }
    ;

assignment:
      IDENTIFIER '=' expr
      { $$ = new Assignment($1, $3); }
    | /* другие варианты */
      { $$ = nullptr; }
    ;

if_statement:
      "if" '(' expr ')' statement
      { $$ = new IfStatement($3, $5); }
    | /* другие варианты */
      { $$ = nullptr; }
    ;

expr:
      INTEGER
      { $$ = new IntegerExpression($1); }
    | IDENTIFIER
      { $$ = new VariableExpression($1); }
    | expr '+' expr
      { $$ = new BinaryExpression("+", $1, $3); }
    |
      { $$ = nullptr; }
    ;


%%

void yyerror(const std::string str) {
    std::cerr << "Error: " << str <<< std::endl;
} 