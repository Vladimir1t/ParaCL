#pragma once
#include <memory>
#include <string>
#include <iostream>

class Expression {
public:
    virtual ~Expression() = default;
    virtual void print() const = 0;
};

// Конкретный класс для целых чисел
class Integer : public Expression {
public:
    int value;
    Integer(int val) : value(val) {}
    void print() const override;
};

class Identifier : public Expression {
public:
    std::string name;
    Identifier(const std::string& n) : name(n) {}
    void print() const override;
};

inline void Integer::print() const {
    std::cout << "Integer: " << value << std::endl;
}

inline void Identifier::print() const {
    std::cout << "Identifier: " << name << std::endl;
}