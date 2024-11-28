#include <iostream>
#include "parser.hpp"

int main(int argc, char** argv) {
    std::cout << "Simple Language Interpreter" << std::endl;
    if (yyparse() == 0) {
        std::cout << "Parsing completed successfully." << std::endl;
    } else {
        std::cerr << "Parsing failed." << std::endl;
    }
    return 0;
}
