/*
 * $Author: kbuckner $
 * $Date: 2017-10-04 13:20:53-06 $
 * $Id: tester.cpp,v 1.1 2017-10-04 13:20:53-06 kbuckner Exp kbuckner $
 *
 * A simple expression evaluator based on the examples from the
 * bison documentation. This works with the C++ flex scanner but
 * NOT the C++ parser. However, the parser code is all C++. Concerned
 * about the union that bison uses but so far it seems to work fine.
 *
 * $Log: tester.cpp,v $
 * Revision 1.1  2017-10-04 13:20:53-06  kbuckner
 * Finally working version
 *
 *
 *
 */
#include<iostream>
#include<fstream>
#include<string>

#include"program5.hpp"
#include"program5.tab.h"
#include<FlexLexer.h>

using std::ifstream;
using std::ofstream;
using std::string;
using std::cout;
using std::cerr;
using std::endl;

/*
 * These will be made available to the parser via externs
 * Need the scanner here in main so that I can change the input
 * file stream.
 *
 * The "Node" so that I can print it.
 */

yyFlexLexer scanner;
Node *Node;

int main(int argc, char **argv)
{
  string infile, outfile;
  int position;
  ifstream input;
  ofstream output;

  Node=0;

  int i;
  if(argc>1)
    for(i=1;i<argc;i++) {
      infile=argv[i];
      position=infile.find('.');
      if(position == 0) {
        cerr << "invalid filename: " << infile << endl;
        continue;
      }
      if(position > 0) {
        outfile=infile.substr(0,infile.size()-position) + "output";
      }
      else {
        outfile=infile + ".output";
      }
      if(input.is_open()) {
        input.close();
      }
      if(output.is_open()) {
        output.close();
      }
      input.open(infile);
      if(!input) {
        cerr << "Could not open input file: " << infile << endl;
        continue;
      }
      output.open(outfile);
      if(!output) {
        cerr << "Could not open output file: " << outfile << endl;
        input.close();
        cerr << "Skipping: " << infile << endl;
        continue;
      }
      scanner.switch_streams(&input);
      yyparse();
      if(1)
      {
        Node->print(&output);
         output << endl;
        Node->print(&cout);
         cout << endl;
      }
    }
  else {
    /*
     * using stdin
     */
     yyparse();
    cout << "PRINTING Node\n" << endl;
    list<string>::iterator i;
    for(i = outputList.begin(); i != outputList.end(); ++i)
    {

        cout << *i << "\n";
    }
    cout << endl;
  }

  return 0;
}
