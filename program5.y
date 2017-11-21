%{
/*
 * Author: Jordan Cooper
 * cosc4785
 *
 * Create the grammar for the Decaf language
 */

#include <iostream>
#include <string>
//#include <list>

#include <FlexLexer.h>
#include "program5.hpp"

using std::cerr;
using std::cout;
using std::endl;
//using std::list;

extern Node *tree;
//extern list<string> outputList;
extern yyFlexLexer scanner;
extern char *yytext;
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;

#define yylex() scanner.yylex()

void yyerror(string s);

%}

%union
{
    Node* ttype;
}

/*
 * Bison Declarations
 */

%type<ttype> Program ClassDeclaration ConstructorDeclaration ClassBody Statement
%type<ttype> MultiVarDec MultiConstructorDec MultiMethodDec MultiStatement
%type<ttype> MethodDeclaration ParameterList
%type<ttype> Type ResultType OptionalExpression
%type<ttype> MultiParam Parameter
%type<ttype> SimpleType
%type<ttype> Name LocalVarDeclaration
%type<ttype> exp Element Assignment
%type<ttype> NewExpression
%type<ttype> VariableDeclaration ArgList MultiExpression ConditionalStatement
%type<ttype> MultiBrackets MultiExpressionBrackets MultiLocalVarDec
%type<ttype> Block
/*%type<ttype> MultiBracketsExpressionBrackets
%type<ttype> Brackets*/

%token<ttype> LEFTBRACKET RIGHTBRACKET ERROR
%token<ttype> NUM IDENTIFIER INT VOID CLASS NEW PRINT READ RETURN
%token<ttype> WHILE IF ELSE THIS PERIOD NULLVAL SEMICOLON LESSTHAN
%token<ttype> LEFTPARENTH RIGHTPARENTH COMMA

%token<ttype> LEFTCURLYBRACE RIGHTCURLYBRACE
%token NOTEQUAL EQUIVALENT GREATERTHAN LESSTHANEQUAL GREATERTHANEQUAL
%token NOT
%token EQUALS AND OR
%left TIMES DIVIDE PLUS MINUS MODULO   /* Group expressions together with left associativity here*/
%precedence NEG
%precedence POS
%precedence N

%% /* Create the grammar */

input: Program
{
    tree = $1;
};

Program:
      ClassDeclaration

      | Program ClassDeclaration

ClassDeclaration:
        CLASS IDENTIFIER ClassBody
                {
                  $$ = new Node(ClassDeclarationNode(), $3);
                };

ClassBody:
 LEFTCURLYBRACE MultiVarDec MultiConstructorDec MultiMethodDec RIGHTCURLYBRACE
        {
          $$ = new Node(new ClassBodyNode(),
          (new Node()-> setVal("{ <MultiVarDeclaration> <MultiConstructorDeclaration> <MultiMethodDeclaration> }\n")));
        };

MultiVarDec:
      %empty
      | VariableDeclaration MultiVarDec
                  {
                      $$ = new Node(new MultiVariableDeclarationNode(),
                      new Node()->setVal("<VariableDeclaration> <MultiVariableDeclaration>\n"));
                      //outputList.push_front("<MultiVaiablerDeclaration> --> <VariableDeclaration> <MultiVariableDeclaration>");
                  }
      | ConstructorDeclaration MultiConstructorDec
                  {
                      $$ = new Node(new MultiVariablerDeclarationNode(),
                      new Node()->setVal("<MultiConstructorDeclaration>\n"));
                      ///outputList.push_front("<MultiVaiablerDeclaration> --> <MultiConstructorDeclaration>");
                  };


MultiConstructorDec:
      %empty
      | ConstructorDeclaration MultiConstructorDec
                  {
                      $$ = new Node(new MultiConstructorDeclarationNode(),
                      new Node()->setVal("<ConstructorDeclaration> <MultiConstructorDeclaration>\n"));
                      //outputList.push_front("<MultiConstructorDeclaration> --> <ConstructorDeclaration> <ConstructorDeclaration>*");
                  }
      | MethodDeclaration MultiMethodDec
                  {
                      $$ = new Node(new MultiConstructorDeclarationNode(),
                      new Node()->setVal("<MultiMethodDeclaration>\n"));
                      //outputList.push_front("<MultiConstructorDeclaration> --> <MultiMethodDeclaration>");
                  };

MultiMethodDec:
      %empty
      | MethodDeclaration MultiMethodDec
                  {
                      $$ = new Node(new MultiMethodDeclarationNode(),
                      new Node()->setVal("<MethodDeclaration> <MultiMethodDeclaration>\n"));
                      //outputList.push_front("<MultiMethodDeclaration> --> <MethodDeclaration> <MultiMethodDeclaration>");
                  };

VariableDeclaration:
      Type IDENTIFIER SEMICOLON
              {
                $$ = new Node(new VariableDeclarationNode(),
                new Node()->setVal("<Type> identifier ;\n"));
                //outputList.push_front("<VariableDeclaration> --> <Type> identifier ;");
              }
      | Type IDENTIFIER error
                    {
                        cerr<< std::to_string(@3.first_line) << ": "<< $1->getString() << " " << $2->getString() << " " << (string)scanner.YYText() <<endl;
                    };

Type:
      SimpleType
                    {
                        $$ = new Node(new TypeNode(), new Node()->setVal("<SimpleType>\n"));
                      //outputList.push_front("<Type> --> <SimpleType>");
                    }
      | Type MultiBrackets
                    {
                        $$ = new Node(new TypeNode(), new Node()->setVal("<Type> <MultiBrackets>\n"));
                        //outputList.push_front("<Type> --> <Type> <Brackets>*");
                    }

SimpleType:
            INT     {
                        $$ = new Node(new SimpleTypeNode(), new Node()->setVal("int\n"));
                        //outputList.push_front("<SimpleType> --> int");
                    }
            | IDENTIFIER
                    {
                        $$ = new Node(new SimpleTypeNode(), new Node()->setVal("identifier\n"));
                        //outputList.push_front("<SimpleType> --> identifier");
                    }


ConstructorDeclaration:
        IDENTIFIER LEFTPARENTH ParameterList RIGHTPARENTH Block
                    {
                        $$ = new Node(new ConstructorDeclarationNode(),
                        new Node()->setVal("identifier ( <ParameterList> ) <Block>\n"));
                        //outputList.push_front("<ConstructorDeclaration> --> identifier ( <ParameterList> ) <Block>");
                    }

MethodDeclaration:
        ResultType IDENTIFIER  LEFTPARENTH ParameterList RIGHTPARENTH Block
                    {
                        $$ = new Node(new MethodDeclarationNode(),
                        new Node()->setVal("<ResultType> identifier ( <ParameterList> ) <Block>\n"));
                        //outputList.push_front("<MethodDeclaration> --> <ResultType> identifier ( ParameterList ) <Block>");
                    }

ResultType:
        Type        {
                        $$ = new Node(new ResultTypeNode(),
                        new Node()->setVal("<Type>\n"));
                        //outputList.push_front("<ResultType> --> <Type>");
                    }
        | VOID
                  {
                      $$ = new Node(new ResultTypeNode(),
                      new Node()->setVal("void\n"));
                  }

ParameterList:
        %empty
        | Parameter MultiParam
                  {
                      $$ = new Node(new ParameterListNode(),
                      new Node()->setVal("<Parameter> <MultiParameter>\n"));
                  }

Parameter:
        Type IDENTIFIER
                  {
                      $$ = new Node(new ParameterNode(),
                      new Node()->setVal("<Type> identifier\n"));
                  }

MultiParam:
        %empty
        | COMMA Parameter MultiParam
                  {
                      $$ = new Node(new MultiParameterNode(),
                      new Node()->setVal(", <Parameter> <MultiParameter>\n"));
                  }

Block:
        LEFTCURLYBRACE MultiLocalVarDec MultiStatement RIGHTCURLYBRACE
                    {
                        $$ = new Node(new BlockNode(),
                        new Node()->setVal("{ <MultiLocalVarDec> <MultiStatement> }\n"));
                    }

LocalVarDeclaration:
        Type IDENTIFIER
                    {
                        $$ = new Node(new LocalVarDecNode(),
                        new Node()->setVal("<Type> identifier\n"));
                    }

Statement:
      SEMICOLON
              {
                  $$ = new Node(new StatementNode(),
                  new Node()->setVal(";\n"));
              }
      | Name EQUALS exp SEMICOLON
              {
                  $$ = new Node(new StatementNode(),
                  new Node()->setVal("<Name> = <Expression> ;\n"));
              }
      | Name LEFTPARENTH ArgList RIGHTPARENTH SEMICOLON
              {
                  $$ = new Node(new StatementNode(),
                  new Node()->setVal("<Name> ( <ArgList> ) ;\n"));
              }
      | PRINT LEFTPARENTH ArgList RIGHTPARENTH SEMICOLON
              {
                  $$ = new Node(new StatementNode(),
                  new Node()->setVal("print ( <Arglist> ) ;\n"));
              }
      | ConditionalStatement
              {
                  $$ = new Node(new StatementNode(),
                  new Node()->setVal("<ConditionalStatement>\n"));
              }
      | WHILE LEFTPARENTH exp RIGHTPARENTH Statement
              {
                  $$ = new Node(new StatementNode(),
                  new Node("while ( <Expression> ) <Statement>\n"));
              }
      | RETURN OptionalExpression SEMICOLON
              {
                  $$ = new Node(new StatementNode(),
                  new Node()->setVal("return <OptionalExpression> ;\n"));
              }

ArgList:
      %empty
      | exp MultiExpression
              {
                  $$ = new Node(new ArgListNode(),
                  new Node()->setVal("<Expression> <MultiExpression>\n"));
              }

MultiExpression:
      %empty
      | COMMA exp MultiExpression
              {
                  $$ = new Node(new ArglistNode(),
                  new Node()->setVal(", <Expression> <MultiExpression>\n"));
              }

ConditionalStatement:
      IF LEFTPARENTH exp RIGHTPARENTH Statement
              {
                  $$ = new Node(new ConditionalStatementNode(),
                  new Node()->setVal("if ( <Expression> ) <Statement>\n"));
              }
      | IF LEFTPARENTH exp RIGHTPARENTH Statement ELSE Statement
              {
                  $$ = new Node(new ConditionalStatementNode(),
                  new Node()->setVal("if ( <Expression> ) <Statement> else <Statement>\n"));
              }

OptionalExpression:
      %empty
      | exp
              {
                  $$ = new Node(new OptionalExpressionNode(),
                  new Node()->setVal("<Expression>\n"));
              }

Name:       THIS    {
                        $$ = new Node(new NameNode(),
                        new Node()->setVal("this\n"));
                    }
            |  IDENTIFIER
                    {
                        $$ = new Node(new NameNode(),
                        new Node()->setVal("identifier\n"));
                    }
            | Name PERIOD IDENTIFIER
                    {
                        $$ = new Node(new NameNode(),
                        new Node()->setVal("name . identifier\n"));
                    }
            | Name LEFTBRACKET exp RIGHTBRACKET
                    {
                        $$ = new Node(new NameNode(),
                        new Node()->setVal("name [ <Expression> ]\n"));
                    }

exp:
        NULLVAL {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("null\n"));
                }

        | LEFTPARENTH exp RIGHTPARENTH
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("( <Expression> )\n"));
                }

        | NewExpression
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("<NewExpression>\n"));
                }


        | READ LEFTPARENTH RIGHTPARENTH
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("read ( )\n"));
                }
        | Name
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("<Name>\n"));
                }

        | Name LEFTPARENTH RIGHTPARENTH
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("<Name> ( )\n"));
                }

        | NUM   {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("number\n"));
                }

        | PLUS exp %prec POS
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("UnaryOp <Expression>\n"));
                }
        | MINUS exp %prec NEG
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("UnaryOp <Expression>\n"));
                }
        | NOT exp %prec N
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("RelationOp <Expression>\n"));
                }

        | exp EQUIVALENT exp
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("<Expression> RelationOp <Expression>\n"));
                }
        | exp NOTEQUAL exp
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("<Expression> RelationOp <Expression>\n"));
                }
        | exp LESSTHANEQUAL exp
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("<Expression> RelationOp <Expression>\n"));
                }
        | exp GREATERTHANEQUAL exp
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("<Expression> RelationOp <Expression>\n"));
                }
        | exp LESSTHAN exp
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("<Expression> RelationOp <Expression>\n"));
                }
        | exp GREATERTHAN exp
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("<Expression> RelationOp <Expression>\n"));
                }

        | exp PLUS exp
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("<Expression> SumOp <Expression>\n"));
                }
        | exp MINUS exp
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("<Expression> SumOp <Expression>\n"));
                }
        | exp OR exp
                {
                    $$ = new Node(new ExpressionNode(),
                    new Node()->setVal("<Expression> SumOp <Expression>\n"));
                }

       | exp TIMES exp
               {
                   $$ = new Node(new ExpressionNode(),
                   new Node()->setVal("<Expression> ProductOp <Expression>\n"));
               }
       | exp DIVIDE exp
            {
                $$ = new Node(new ExpressionNode(),
                new Node()->setVal("<Expression> ProductOp <Expression>\n"));
            }
       | exp MODULO exp
            {
                $$ = new Node(new ExpressionNode(),
                new Node()->setVal("<Expression> ProductOp <Expression>\n"));
            }
       | exp AND exp
            {
                $$ = new Node(new ExpressionNode(),
                new Node()->setVal("<Expression> ProductOp <Expression>\n"));
            };

NewExpression:
          NEW SimpleType LEFTPARENTH ArgList RIGHTPARENTH
              {
                  $$ = new Node(new NewExpressionNode(),
                  new Node()->setVal("new <SimpleType> ( <ArgList> )\n"));
                  //outputList.push_front("<NewExpression> --> new <SimpleType> ( )");//////////////////////////////////////////
              }
          |   NEW SimpleType
              {
                  $$ = new Node(new NewExpressionNode(),
                  new Node()->setVal("new <SimpleType>\n"));
                  //outputList.push_front("<NewExpression> --> new <SimpleType> <[Expression]>* <[]>*");//////////////////////////
              };

MultiBrackets:
            LEFTBRACKET RIGHTBRACKET
                    {
                        $$ = new Node(new MultiBracketsNode(),
                        new Node()->setVal("[ ]\n"));
                    }
            | MultiBrackets LEFTBRACKET RIGHTBRACKET
                    {
                        $$ = new Node(new MultiBracketsNode(),
                        new Node()->setVal("<MultiBrackets> [ ]\n"));
                    };

MultiExpressionBrackets:
        %empty
        | LEFTBRACKET exp RIGHTBRACKET MultiExpressionBrackets
                  {
                      $$ = new Node(new MultiExpressionBracketsNode(),
                      new Node()->setVal("[ <Expression> ] <MultiExpressionBrackets>\n"));
                  }

MultiLocalVarDec:
              %empty
      | VariableDeclaration
                  {
                      $$ = new Node(new MultiLocalVarDecNode(),
                      new Node()->setVal("<VariableDeclaration>\n"));
                  }

MultiStatement:
      %empty
      | Statement MultiStatement
                {
                    $$ = new Node(new MultiStatementNode(),
                    new Node()->setVal("<Statement> <MultiStatement>\n"));
                }

%%

void yyerror(string s)
{
    cerr << "Error on line: " << endl;
}
