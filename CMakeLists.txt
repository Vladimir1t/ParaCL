cmake_minimum_required(VERSION 3.10)
project(ParaCL)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/Frontend/include
    ${CMAKE_CURRENT_BINARY_DIR}  
)

# parcer
BISON_TARGET(Parser Frontend/src/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp
             DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parser.hpp)

# lexer
FLEX_TARGET(Lexer Frontend/src/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

add_executable(ParaCL
    Frontend/src/main.cpp
    ${BISON_Parser_OUTPUTS}  # parser.cpp
    ${FLEX_Lexer_OUTPUTS}    # lexer.cpp
)

if(FLEX_LIBRARIES)
    target_link_libraries(ParaCL ${FLEX_LIBRARIES} ${BISON_LIBRARIES})
else()
    message(WARNING "Flex libraries not found. Proceeding without linking to Flex.")
    target_link_libraries(ParaCL ${BISON_LIBRARIES})
endif()

# rm -rf build && mkdir build && cd build
# cmake ..
# ./ParaCL

# or
# flex -o Frontend/src/lexer.cpp Frontend/src/lexer.l 
# bison -d -o Frontend/src/parser.cpp Frontend/src/parser.y     
# g++ -o parser Frontend/src/parser.cpp Frontend/src/lexer.cpp -std=c++17
# echo "if (10 == 10) { x = 42; }" | ./parser  
