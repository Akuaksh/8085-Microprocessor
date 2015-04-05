// ------------ Parser.h
// David Cofer   7/5/96
// This code Parsers a given Assembly language file into specific word groupings
// that the assembler can then use to do its job.
// only these characters are accepted a-z A-z 0-9 ; # : Anything else will
// cause an error and termination of the program
// The charchter groupings will be seperated by blanks commas or tabs.

#ifndef PARSER_H
#define PARSER_H

#include <fstream.h>
#include <string.h>
#include <cstring.h>
#include "LinkList.h"

class Holder
{
	string s;
	int linenum;
public:
	Holder() {};
	Holder(string st, int ln);

	Holder operator=(Holder h);
	int operator==(Holder h);
	int operator==(char *st);
	int IsLabel();
	string GetString() {return s;};
	int GetLineNum() {return linenum;};
	void SetString(string st);
	void SetLineNum(int l);
	friend ostream& operator<<(ostream& os, Holder h);
};

Holder::Holder(string st, int ln)
{s = st; linenum = ln;}

Holder Holder::operator=(Holder h)
{s = h.s; linenum = h.linenum; return h;}

int Holder::operator==(Holder h)
{if(s == h.s && linenum == h.linenum) return 1; else return 0;}

int Holder::operator==(char *st)
{if(s == st) return 1; else return 0;}

void Holder::SetString(string st)
{s = st;}

void Holder::SetLineNum(int l)
{linenum = l;}

int Holder::IsLabel()
{
int size = s.length();
// get the last character in the string
char ch = s.get_at(size-1);

// if the last character in the string is a colon then it is a label
if( ch == ':' ) return 1;
return 0;
}

ostream& operator<<(ostream& os, Holder h)
{
os << h.GetString() << '\t' << h.GetLineNum();
return os;
}



// this function writes any errors that occured to the cout and then
// terminates this program.
inline void Error(const char *errorstring)
{
cout << errorstring << '\n';
exit(0);
}

// this function writes any Warnings that occured to the cout.
inline void Warning(const char *errorstring)
{cout << errorstring << '\n';}


//skips the rest of a line after a comment( ; )
void SkipRestOfLine(ifstream &infile)
{
char ch;
do {
	 infile.get(ch);
	} while(ch != '\n' && !infile.eof());
}


// this function reads in the input from a given file and then parses it and
// saves the output in the list
void Parse(LinkedList<Holder> &List, const char *filename)
{
int line = 1, nextline = 0;  //keeps track of the current line number
ifstream infile(filename);

if(infile.fail())
	Error("file could not be opened");

while( !infile.eof() ) //do this till you reach the end of the file
	{string s;
	 char ch, ok = 1;

	 while(ok)
		{infile.get(ch); //get one character at a time and test it

		 if( ch >= '0' && ch <= '9' )   //test for numbers
			s += ch; //add ch to the end of the string
		 else if(ch >= 'A' && ch <= 'Z') //test for cap letters
			s += ch; //add ch to the end of the string
		 else if(ch >= 'a' && ch <= 'z') //test for lower letters
			s += ch; //add ch to the end of the string
		 else if(ch == ':') //test for :
			s += ch; //add ch to the end of the string
		 else if(ch == ';')  //if you find a ; for a comment then skip the rest of
			{SkipRestOfLine(infile); ok = 0; nextline = 1;} // that line
		 //test for all of the characters that break up the file into groupings
		 else if(ch == '#') // change of radix charachter
			s+=ch; //add ch to the end of the string
		 else if(ch == ' ' || ch == ',' || ch == '\t')
			ok = 0;
		 else if(ch == '\n' || ch == '\r')
			{ok = 0; nextline = 1;}
		 else if(infile.eof())
			ok = 0;
		 else
			Error("file could not be opened");


		}
	 // only put it in the list if the string is not null
	 // and make sure to convert to lowercase for further testing
	 if( !s.is_null() )
		{s.to_lower();
		 Holder h(s, line);
		 List.AppendEntry(h);}

	 //if you found a carrige return then increment the line varible
	 if(nextline) {line++; nextline = 0;}
	}
}
#endif
