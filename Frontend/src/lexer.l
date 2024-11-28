%{
#include "parser.hpp"
#include <cstdlib>

extern int yylval;
%}

DIGIT       [0-9]
LETTER      [a-zA-Z_]
ID          {LETTER}({LETTER}|{DIGIT})*

%%

[ \t\r\n]+              ; // Пропуск пробельных символов
"if"                    { return IF; }
"else"                  { return ELSE; }
"="                     { return '='; }
"+"                     { return '+'; }
"("                     { return '('; }
")"                     { return ')'; }
";"                     { return ';'; }
{ID}                    {
                            yylval.string = new std::string(yytext);
                            return IDENTIFIER;
                        }
{DIGIT}+                {
                            yylval.intval = std::atoi(yytext);
                            return INTEGER;
                        }
.                       { return yytext[0]; }

%%

int yywrap() {
    return 1;
}
