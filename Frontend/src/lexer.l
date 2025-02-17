%{
#include <cstdlib>
#include <iostream>
#include "parser.hpp"

extern YYSTYPE yylval;
%}

DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*

%%

[ \t\r\n]+            { /* skip */        }
"if"                  { return IF;        }
"else"                { return ELSE;      }
"="                   { return ASSIGN;    }
"=="                  { return EQ;        }
[+-/*]                { return yytext[0]; }
"("                   { return '(';       }
")"                   { return ')';       }
"{"                   { return LSKOPE;    }
"}"                   { return RSKOPE;    }
";"                   { return ';';       }
{IDENTIFIER}          {
                        yylval.str = strdup(yytext); 
                        return IDENTIFIER;
                      }
{DIGIT}+              {
                        yylval.intval = std::atoi(yytext);
                        return INTEGER;
                      }
.                     { return yytext[0]; }

%%

int yywrap() {
    return 1;
}