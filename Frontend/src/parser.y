%{
#include <iostream>
#include <string>
#include "parser.hpp"

int yylex();
void yyerror(const std::string str);
%}

%union {
    int intval;
    char* str;
}

%token <intval> INTEGER
%token <str> IDENTIFIER
%token IF ELSE ASSIGN EQ
%token '(' ')' LSKOPE RSKOPE
%type <intval> expr
%type <str> assignment

%%

program:
    statement_list
    ;

statement_list:
    statement 
    | statement_list statement 
    ;

statement:
    assignment ';'
    | if_statement
    ;

assignment:
    IDENTIFIER ASSIGN expr
    { std::cout << "Assign " << $1 << " = " << $3 << std::endl; }
    ;

if_statement:
    IF '(' expr ')' LSKOPE statement_list RSKOPE
    { std::cout << "IF condition" << std::endl; }
    | IF   '(' expr ')' LSKOPE statement_list RSKOPE 
      ELSE LSKOPE statement_list RSKOPE 
    { std::cout << "IF-ELSE condition" << std::endl; }
    ;

expr:
    INTEGER
    { $$ = $1; }
    | IDENTIFIER
    { $$ = 0; }
    | expr '+' expr
    { $$ = $1 + $3; }
    | expr '-' expr
    { $$ = $1 - $3; }
    | expr '*' expr
    { $$ = $1 * $3; }
    | expr '/' expr
    { $$ = $1 / $3; }
    | expr EQ expr
    { $$ = ($1 == $3); }
    | '(' expr ')'
    { $$ = $2; }
    ;


%%

void yyerror(const std::string str) {
    std::cerr << "Error: " << str << std::endl;
} 

int main() {
    yyparse();
    return 0;
}