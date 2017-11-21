/*
 * Jordan Cooper
 * A Node class that handles tokens, and contains a lot of sub-classes
 *  that inherit from Node.
 *  They perform functions to produce different types of output mainly
 *
 */

#ifndef Node_HPP
#define Node_HPP
#include<iostream>
#include<string>

using std::string;
using std::endl;
using std::ostream;
using std::cout;


class Node
{
protected:
    int yyline;
    int yycol;
    int ival;
    double dval;
    string sval;
    int nextcol;// not needed?
    int nextline;// not needed?
    Node *left,*right;

public:
    // set the pointers to 0 C++ is trying to get away from NULL
    Node(Node *lf=0,Node *rt=0)
    {
      reset();
      dval=0.0;
      ival=0;
      left=lf;
      right=rt;
    }

    virtual ~Node()
    {
      if(left) delete left;
      if(right) delete right;
    }

    int getInt() const
    {
      return ival;
    }

    double getDouble() const
    {
      return dval;
    }

    string getString() const
    {
      return sval;
    }

    void setVal(const char *v)
    {
      sval=v;
    }

    void setVal(const string s)
    {
      sval=s;
    }

    void setVal(int i)
    {
      ival=i;
    }

    void setVal(double d)
    {
      dval=d;
    }

    void reset() {
      yyline=yycol=nextline=nextcol=1;
      sval.clear();
    }

    void setLeft(Node *p)
    {
      left=p;
      return;
    }

    void setRight(Node *p)
    {
      right=p;
      return;
    }

    Node* getLeft()
    {
      return left;
    }

    Node* getRight()
    {
      return right;
    }

    // Prints the nodes of the Node
    virtual void print(ostream *out = 0)
    {
      if(left) left->print(out);
      *out << " " << sval << " ";
      if(right) right->print(out);
      *out << endl;
      return;
    }
};

// Handle newlines here
class EmptyNode: public Node
{
public:
  EmptyNode()
  {
    // Handle newlines here
    sval = "\n";
  }
};

class ClassDeclarationNode: public Node
{
public:
  ClassDeclarationNode()
  {  }

  virtual void print(ostream* out)
  {
    *out << "<ClassDeclarationNode> --> class Identifier <ClassBody>\n";
  }
};

class ClassBodyNode : public Node
{
public:
  ClassBodyNode()
  {  }

  virtual void print(ostream* out)
  {
    *out << "<ClassBody> --> { <MultiVariableDeclaration> MultiConstructorDeclaration> MultiMethodDeclaration> }\n";
  }
};

class MultiVariableDeclarationMultiVarDecNode: public Node
{
public:
    MultiVariableDeclarationVarDecNode()
  {  }

  virtual void print(ostream* out)
  {
    *out << "<MultiVariableDeclaration> --> <VariableDeclaration> <MultiVariableDeclaration>\n";
  }
};

class MultiVariableDeclarationConsDecNode: public Node
{
public:
    MultiVariableDeclarationConsDecNode()
  {  }

  virtual void print(ostream* out)
  {
    *out << "<MultiVariableDeclaration> --> <ConstructorDeclaration> <MultiConstructorDeclaration>\n";
  }
};

class VariableDeclarationNode : public Node
{
public:
  VariableDeclarationNode()
  {
    sval = "<VariableDeclaration> -->";
  }
};

class MultiBracketsNode: public Node
{
public:
  MultiBracketsNode()
  {
    sval = "<MultiBrackets> -->";
  }
};

class MultiStatementNode: public Node
{
public:
  MultiStatementNode()
  {
    sval = "<MultiStatement> -->";
  }
};

class MultiLocalVarDecNode: public Node
{
public:
  MultiLocalVarDecNode()
  {
    sval = "<MultiLocalVarDeclaration> -->";
  }
};

class MultiExpressionBracketsNode: public Node
{
public:
  MultiExpressionBracketsNode()
  {
    sval = "<MultiExpressionBrackets> -->";
  }
};

class MultiConstructorDeclarationNode: public Node
{
public:
  MultiConstructorDeclarationNode()
  {
    sval = "<MultiConstructorDeclaration> -->";
  }
};

class MultiMethodDeclarationNode: public Node
{
public:
  MultiMethodDeclarationNode()
  {
    sval = "<MultiMethodDeclaration> -->";
  }
};

class MultiParameterNode: public Node
{
public:
  MultiParameterNode()
  {
    sval = "<MultiParameter> -->";
  }
};

class TypeNode: public Node
{
public:
  TypeNode()
  {
    sval = "<Type> -->";
  }
};

class SimpleTypeNode: public Node
{
public:
  SimpleTypeNode()
  {
    sval = "<SimpleType> -->";
  }
};

class ConstructorDeclarationNode: public Node
{
public:
  ConstructorDeclarationNode()
  {
    sval = "<ConstructorDeclaration> -->";
  }
};

class MethodDeclarationNode: public Node
{
public:
  MethodDeclarationNode()
  {
    sval = "<MethodDeclaration> -->";
  }
};

class ResultTypeNode: public Node
{
public:
  ResultTypeNode()
  {
    sval = "<ResultType> -->";
  }
};

class ParameterListNode: public Node
{
public:
  ParameterListNode()
  {
    sval = "<ParameterList> -->";
  }
};

class ParameterNode: public Node
{
public:
  ParameterNode()
  {
    sval = "<Parameter> -->";
  }
};

class BlockNode: public Node
{
public:
  BlockNode()
  {
    sval = "<Block> -->";
  }
};

class LocalVarDecNode: public Node
{
public:
  LocalVarDecNode()
  {
    sval = "<LocalVarDeclaration> -->";
  }
};

class StatementNode: public Node
{
public:
  StatementNode()
  {
    sval = "<Statement> -->";
  }
};

class NameNode: public Node
{
public:
  NameNode()
  {
    sval = "<Name> -->";
  }
};

class ArgListNode: public Node
{
public:
  ArgListNode()
  {
    sval = "<ArgList> -->";
  }
};

class ConditionalStatementNode: public Node
{
public:
  ConditionalStatementNode()
  {
    sval = "<Conditional Statement> -->";
  }
};

class OptionalExpressionNode: public Node
{
public:
  OptionalExpressionNode()
  {
    sval = "<OptionalExpression> -->";
  }
};

class ExpressionNode: public Node
{
public:
  ExpressionNode()
  {
    sval = "<Expression> -->";
  }
};

class NewExpressionNode: public Node
{
public:
  NewExpressionNode()
  {
    sval = "<NewExpression> -->";
  }
};

class UnaryOpNode: public Node
{
public:
  UnaryOpNode()
  {
    sval = "<UnaryOp> -->";
  }
};

class RelationOpNode: public Node
{
public:
  RelationOpNode()
  {
    sval = "<RelationOp> -->";
  }
};

class SumOpNode: public Node
{
public:
  SumOpNode()
  {
    sval = "<SumOp> -->";
  }
};

class ProductOpNode: public Node
{
public:
  ProductOpNode()
  {
    sval = "<ProductOp> -->";
  }
};


#endif
