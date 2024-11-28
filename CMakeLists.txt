cmake_minimum_required(VERSION 3.10)
project(MyLanguage)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Frontend/include)

BISON_TARGET(Parser Frontend/src/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp
             DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parser.hpp)

FLEX_TARGET(Lexer Frontend/src/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

add_executable(MyLanguage
    Frontend/src/main.cpp
    Frontend/src/para_cl.cpp
    ${BISON_Parser_OUTPUTS}
    ${FLEX_Lexer_OUTPUTS}
)

if(FLEX_LIBRARIES)
    target_link_libraries(MyLanguage ${FLEX_LIBRARIES} ${BISON_LIBRARIES})
else()
    message(WARNING "Flex libraries not found. Proceeding without linking to Flex.")
    target_link_libraries(MyLanguage ${BISON_LIBRARIES})
endif()
