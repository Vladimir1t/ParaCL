%{
#include <iostream>
#include <string>
#include <memory>
#include <vector>
#include "ast.hpp"

int yylex();
void yyerror(const std::string& str);

std::unique_ptr<ASTNode> root;  // глобальный указатель на корень дерева
%}

%union {
    int intval;
    char* str;
    ASTNode* node;
    ExprNode* exprnode;
    std::vector<std::unique_ptr<ASTNode>>* stmtlist;
}

%token <intval> INTEGER
%token <str> IDENTIFIER
%token IF ELSE ASSIGN EQ
%token '+' '-' '*' '/'
%token '(' ')' LSKOPE RSKOPE
%type <node> assignment
%type <node> if_statement
%type <node> program
%type <node> statement
%type <exprnode> expr
%type <stmtlist> statement_list

%%

program:
    statement_list
    { root = std::unique_ptr<ASTNode>(new std::vector<std::unique_ptr<ASTNode>>(std::move(*$1))); delete $1; }
    ;

statement_list:
    statement  
    { $$ = new std::vector<std::unique_ptr<ASTNode>>(); $$->emplace_back($1); }
    | statement_list statement 
    { $$ = $1; $$->emplace_back($2); }
    ;

statement:
    assignment ';'
    | if_statement
    ;

assignment:
    IDENTIFIER ASSIGN expr
    {
        $$ = new AssignmentNode($1, std::unique_ptr<ExprNode>($3));
        std::cout << "Assignment created for " << $1 << "\n";
    }
    ;

if_statement:
    IF '(' expr ')' LSKOPE statement_list RSKOPE
    { 
        $$ = new IfNode(std::unique_ptr<ExprNode>($3), std::move(*$6));
        delete $6;
        std::cout << "If statement created\n"; 
    }
    | IF '(' expr ')' LSKOPE statement_list RSKOPE ELSE LSKOPE statement_list RSKOPE
    { 
        $$ = new IfNode(std::unique_ptr<ExprNode>($3), std::move(*$6), std::move(*$10));
        delete $6;
        delete $10;
        std::cout << "If-Else statement created\n"; 
    }
    ;

expr:
    INTEGER
    { $$ = new IntegerNode($1); }
    | IDENTIFIER
    { $$ = new IdentifierNode($1); }
    | expr '+' expr
    { $$ = new BinaryOpNode(std::unique_ptr<ExprNode>($1), std::unique_ptr<ExprNode>($3), "+"); }
    | expr '-' expr
    { $$ = new BinaryOpNode(std::unique_ptr<ExprNode>($1), std::unique_ptr<ExprNode>($3), "-"); }
    | expr '*' expr
    { $$ = new BinaryOpNode(std::unique_ptr<ExprNode>($1), std::unique_ptr<ExprNode>($3), "*"); }
    | expr '/' expr
    { $$ = new BinaryOpNode(std::unique_ptr<ExprNode>($1), std::unique_ptr<ExprNode>($3), "/"); }
    | '(' expr ')'
    { $$ = $2; }
    ;

%%

void yyerror(const std::string& str) {
    std::cerr << "Error: " << str << std::endl;
} 

int main() {
    yyparse();
    if (root) {
        root->print();
        std::cout << "AST generated successfully." << std::endl;
    }
    return 0;
}
