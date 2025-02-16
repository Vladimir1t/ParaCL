#ifndef FRONT_HPP
#define FRONT_HPP

#include <memory>
#include <string>
#include <iostream>
class Expression {
public:
    virtual void print() const = 0;
    virtual ~Expression() = default;
};
class Integer : public Expression {
public:
    int value;
    Integer(int val) : value(val) {}
    void print() const override  {
        std::cout << "value of interger: " << value << std::endl;
    }
};
class Identifier : public Expression {
public:
    std::string name;
    Identifier(const std::string& n) : name(n) {}
    void print() const override {
        std::cout << "value of identifier: " << name << std::endl;
    }
};
#endif // FRONT_HPP
