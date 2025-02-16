#pragma once
#include <iostream>
#include <memory>
#include <string>
#include <vector>

// базовый узел AST
class ASTNode {
public:
    virtual ~ASTNode() = default;
    virtual void print(int indent = 0) const = 0;

protected:
    void printIndent(int indent) const {
        for (int i = 0; i < indent; ++i) {
            std::cout << "  ";
        }
    }
};

// значение 
class ExprNode : public ASTNode {
public:
    virtual ~ExprNode() = default;
};

// инты
class IntegerNode : public ExprNode {
public:
    explicit IntegerNode(int value) : value(value) {}
    void print(int indent = 0) const override {
        printIndent(indent);
        std::cout << "Integer: " << value << "\n";
    }

private:
    int value;
};

// идентификатора
class IdentifierNode : public ExprNode {
public:
    explicit IdentifierNode(const std::string& name) : name(name) {}
    void print(int indent = 0) const override {
        printIndent(indent);
        std::cout << "Identifier: " << name << "\n";
    }

private:
    std::string name;
};

// бинопы
class BinaryOpNode : public ExprNode {
public:
    BinaryOpNode(std::unique_ptr<ExprNode> left, std::unique_ptr<ExprNode> right, const std::string& op)
        : left(std::move(left)), right(std::move(right)), op(op) {}
    void print(int indent = 0) const override {
        printIndent(indent);
        std::cout << "BinaryOp: " << op << "\n";
        left->print(indent + 1);
        right->print(indent + 1);
    }

private:
    std::unique_ptr<ExprNode> left;
    std::unique_ptr<ExprNode> right;
    std::string op;
};

// присваиваниe
class AssignmentNode : public ASTNode {
public:
    AssignmentNode(const std::string& name, std::unique_ptr<ExprNode> value)
        : name(name), value(std::move(value)) {}
    void print(int indent = 0) const override {
        printIndent(indent);
        std::cout << "Assignment: " << name << "\n";
        value->print(indent + 1);
    }

private:
    std::string name;
    std::unique_ptr<ExprNode> value;
};

// if-выражения
class IfNode : public ASTNode {
public:
    IfNode(std::unique_ptr<ExprNode> condition, std::vector<std::unique_ptr<ASTNode>> thenBody,
           std::vector<std::unique_ptr<ASTNode>> elseBody = {})
        : condition(std::move(condition)), thenBody(std::move(thenBody)), elseBody(std::move(elseBody)) {}
    void print(int indent = 0) const override {
        printIndent(indent);
        std::cout << "If Statement\n";
        printIndent(indent + 1);
        std::cout << "Condition:\n";
        condition->print(indent + 2);

        printIndent(indent + 1);
        std::cout << "Then Body:\n";
        for (const auto& stmt : thenBody) {
            stmt->print(indent + 2);
        }

        if (!elseBody.empty()) {
            printIndent(indent + 1);
            std::cout << "Else Body:\n";
            for (const auto& stmt : elseBody) {
                stmt->print(indent + 2);
            }
        }
    }

private:
    std::unique_ptr<ExprNode> condition;
    std::vector<std::unique_ptr<ASTNode>> thenBody;
    std::vector<std::unique_ptr<ASTNode>> elseBody;
};
