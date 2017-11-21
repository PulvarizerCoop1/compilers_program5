##
# $Author: Jordan Cooper
#
###############################################################

CXX=g++
CXXFLAGS=-ggdb -std=c++11 -Wall
YACC=bison
YFLAGS=--report=state -W -d
LEX=flex
LEXXX=flex++
LFLAGS=--warn

.PHONY: clean

program5: program5.tab.c program5.tab.h program5_lex.cpp program5.cpp program5.hpp
	$(CXX) $(CXXFLAGS) program5.cpp program5.tab.c program5_lex.cpp -o program5

program5.tab.c : program5.y program5.hpp
	$(YACC) $(YFLAGS) program5.y

program5_lex.cpp: program5.lpp program5.hpp
	$(LEXXX) $(LFLAGS) program5.lpp

tidy:
	/bin/rm -f a.out core.* program5.tab.* program5.output \
	program5_lex.cpp

clean: tidy
	/bin/rm -f program5
