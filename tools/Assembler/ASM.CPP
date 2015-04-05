#include <fstream.h>
#include <cstring.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "Parser.h"
#include "LinkList.h"
#include "assem.h"

//this is the start of the initialization code section

unsigned AddrStart=0, CurrentAddr=0;
LinkedList<Holder> list;
LinkedList<OpCode> codes, asmcode;
LinkedList<Label> variables, labels;


// this code reads in all the opcodes for the 8085 microprocessor
// it reads in its hex value, mnemomic name, and the length of the instruction
// in bytes. ie) 3 means it is a 3 byte instruction
void CodeReader()
{
ifstream infile("codes.txt");

if(infile.fail())
	Error("file could not be opened");

while( !infile.eof() )
	{string men, op;
	 int size;

	 infile >> men >>op >> size;
	 men.to_lower(); op.to_lower();
	 OpCode opc(men, op, size);
	 if(!infile.eof() ) codes.AppendEntry(opc);
	}
}




// This is the start of the code that defines the first pass
// the first pass finds the variables and removes them from the word list
// it finds out how big a variable buffer to put at the head of the asm code
// and it finds the labels.


// This function makes sure that there is a variable name that was associated
// with a long or int keyword
void inline CheckName(Holder *name, Holder *ip)
{
if(!name)
	{string err("Can Not Find Label for Int on Line ");
	 char st[20];
	 itoa(ip->GetLineNum(), st, 10);
	 err+=st;
	 Error(err.c_str());
	}
}




// this function adds a variable to the variable list and removes it and
// its keyword from the word list
void AddVarible(Holder *name, int size)
{
extern unsigned CurrentAddr;
Data d(CurrentAddr, 2);
Label l(name->GetString(), d, size);

// add the variable to the vaible list
variables.AppendEntry(l);

// remove that data from the other list to keep it cleaned up
list--; list.RemoveCurrentEntry(); list.RemoveCurrentEntry();
}




// this function performs the bulk of the work for pass 1. It checks through
// the word list for the long or int keywords. If it finds them then it
// makes sure there is a name associated with them and puts it on the
// variable list. It also finds the labels and puts them in the label list
// without assigning them an address. That is done later
void ReadVaribles()
{
extern unsigned AddrStart, CurrentAddr;
Holder *ip = list.FirstEntry();

while ( (ip = list++) != 0 )
	{int found = 0;
	 if(*ip == "int")
		{Holder *name = list++;
		 CheckName(name, ip);  // check to see if there is label
		  //add the variable to the varlist. It has one byte
		 AddVarible(name, 1); found = 1;
		 CurrentAddr+=1;
		}

	 // the found variable tells whether or not a int was found. If one was
	 //found then it obviously can't be a long
	 if(!found && *ip == "long")
		{Holder *name = list++;
		 CheckName(name, ip);  // check to see if there is label
		  //add the variable to the varlist. It has 2 bytes
		 AddVarible(name, 2);
		 CurrentAddr+=2;
		}

	 // check for a label if you find one put it in the list of labels for later
	 if( !found && ip->IsLabel() )
		{Data d;
		 string s = ip->GetString();
		 int size = s.length();
		 //if size is 1 then there is only a : and no name and this is illegal
		 if(size == 1)
			{string err;
			 err = ": On Line ";
			 char st[20];
			 itoa(ip->GetLineNum(), st, 10);
			 err+=st;
			 err+="Is not valid. Must have some type of label name";
			 Error(err.c_str());
			}

		 // if size >1 then chop off the : and save the name in the label list
		 s.remove(s.length()-1);

		 Label l(s, d, 2);
		 labels.AppendEntry(l);
		}

	}

Label *var = variables.FirstEntry();
string zero("00");

while ( (var = variables++) != 0 )
	{OpCode op(var->GetName(), zero, 1);
	 asmcode.AppendEntry(op);
	 if(var->GetSize() == 2)
		  asmcode.AppendEntry(op);
	}
}




// checks through the opcodes looking for a match to a 8085 instruction mnemomic
int MatchCode(Holder *ip, OpCode &op)
{
OpCode *c = codes.FirstEntry();

while ( (c = codes++) != 0 )
	if( c->GetMen() == ip->GetString() )
		{op = *c;

		 //set the size of the op put in the list to 1 byte
		 OpCode oplist = op; oplist.SetSize(1);

		// put the operator in the list.
		asmcode.AppendEntry(oplist); CurrentAddr++;
		return 1;
		}

return 0;
}




// this function checks the operand to see if it is a valid label. If it is
// then it as 00 00 to the asm code so that at a later date, when the
// addresses of all the labels are known then it can go back and put the
// correct values into these places
int IsValidLabel(Holder *ip, OpCode op)
{
Label *l = labels.FirstEntry();

while ( (l = labels++) != 0 )
	if( l->GetName() == ip->GetString() )
		{// first make sure this op uses 2 byte operands
		 if( op.GetSize() == 2)
			{string err;
			 err = op.GetMen() + " On Line ";
			 char st[20];
			 itoa(ip->GetLineNum(), st, 10);
			 err+=st;
			 err+="Uses a 1 byte operand and a label can not be used here. ";
			 Error(err.c_str());
			}
		else
			{// set up the ops with -1,and -2 sizes to indicate that they have
			 // not been set yet.
			 OpCode opl(ip->GetString(), "00", -1);
			 OpCode oph(ip->GetString(), "00", -2);

			 //put it into the list as hhll for intels ass backwards notation
			 asmcode.AppendEntry(opl);
			 asmcode.AppendEntry(oph);
			 CurrentAddr+=2;
			 return 1;
			}
		}
return 0;
}




// this function checks if the operand is a valid variable. If it is then it
// puts the address into the asm code as LL HH
int IsValidVar(Holder *ip, OpCode op)
{
Label *v = variables.FirstEntry();

while ( (v = variables++) != 0 )
	if( v->GetName() == ip->GetString() )
		{// first make sure this op uses 2 byte operands
		 if( op.GetSize() == 2)
			{string err;
			 err = op.GetMen() + " On Line ";
			 char st[20];
			 itoa(ip->GetLineNum(), st, 10);
			 err+=st;
			 err+="Uses a 1 byte operand and a label can not be used here. ";
			 Error(err.c_str());
			}
		 else
			{// set up ops to put into the asm code
			Data d = v->GetAddr();
			// Borland Sucks!!!
			// I dont know why but if I put d.GetLow() .. into the OpCode
			// definition then the program crashes, so I moved it out
			string sl = d.GetLow();
			string sh = d.GetHigh();

			// set up the opcodes
			OpCode opl(v->GetName(), sl, 1);
			OpCode oph(v->GetName(), sh, 1);

			// put them into the ams code
			asmcode.AppendEntry(opl);
			asmcode.AppendEntry(oph);
			CurrentAddr+=2;
			return 1;
			}

		}
return 0;
}




// This function takes a string that is supposed to be a number(hex, octal or
// decimal) and stores it in a Data object.  The program checks for the
// radix change symbols that mean that the number is something other than
// a hex number.  If this is not a number then it returns a data with a
// negative size value.
Data CrackNumber(string s)
{
char ch = ' ', radix = 'h';
Data d("00", "00", -1);

// get the first charachter in the string
if(s.length() > 0 ) ch = s.get_at(0);

// check to see if there is a radix change for this number
if( ch == '#')
	{s.remove(0, 1); // remove first charchter from position 0

	 if(s.length() > 0)
		{radix = s.get_at(0); s.remove(0, 1);}
	 else return d;
	}

// if after taking away the radix change there is no number left then this
// is an error
if(!s.length()) return d;

int size = s.length();

// make sure the rest of the charachters are valid
for(int i  = 1; i < (size-1); i++)
	{char c = s.get_at(i);
	 if(radix == 'h') //if it is a hex it can have digits and ABCDEF
		{if( !(isdigit(c) || (c >= 97 && c <= 102) ) )
			return d;
		}
	 else  // but if it is a octal or decimal it can only have digits
		{if( !isdigit(c) )
			return d;
		}
	}

if(radix == 'd') d.SetDecimal(s);
else if(radix == 'h') d.SetHex(s);
else if(radix == 'o') d.SetOctal(s);

return d;
}




// This function checks if the operand is a valid number if it is then it places
// the number in the asm code exatly as it appears
int IsValidNumber(Holder *ip, OpCode op)
{
string s = ip->GetString();

Data d = CrackNumber(s);

if(d.GetSize() < 0) return 0;


// if operand is 1 byte and number is 2 bytes then this is an error
if(d.GetSize() == 2 && op.GetSize() == 2)
	{string err;
	 err = op.GetMen() + " On Line ";
	 char st[20];
	 itoa(ip->GetLineNum(), st, 10);
	 err+=st;
	 err+="Uses a 1 byte operand and a 2 byte number can not be used here.";
	 Error(err.c_str());
	}


// if it got through all of these error checks ok then plop it onto the list
// Note: data goes onto the list exactly as input it is not switched llhh
// like the labels and variables
OpCode op1("Number", d.GetHigh(), 1);
OpCode op2("Number", d.GetLow(), 1);

// if it is a 2 byte operand then put the high byte on the list first
if( op.GetSize() == 3)
	{asmcode.AppendEntry(op1); CurrentAddr++;}

// put the low byte on the list
asmcode.AppendEntry(op2);
CurrentAddr++;
return 1;
}




// this function checks whether or not the word group after a instruction is
// a valid operand or not and if it is then it takes the necessary steps
// if not it causes an error
int CrackOperands(Holder *ip, OpCode op)
{

// first check to see if it matches a label
if( IsValidLabel(ip, op) )
	return 1;

// then check to see if it is a variable
if( IsValidVar(ip, op) )
	return 1;

// if not then check to see if it is a number
if( IsValidNumber(ip, op) )
	return 1;

return 0;
}




// determines if there are any operands and put them on the list as well.
void GetOperands(OpCode op)
{

if( op.GetSize() > 1)
	{//then there is a 1 or 2 byte operand
	 Holder *ip = list++;

	 if( !(ip && CrackOperands(ip, op)) )
		{string err("Missing Operand for ");
		 err+= op.GetMen() + " On Line ";
		 char st[20];
		 itoa(ip->GetLineNum(), st, 10);
		 err+=st;
		 Error(err.c_str());
		}
	}
}




// if the current word under test is not an opcode and its operands
// Then check to see if it is a label. if it is then assign its address
// for the 3rd pass and go on. If it is not then there is an error somewhere
int MatchLabel(Holder *ip)
{
Label *l = labels.FirstEntry();
string s;

// if it is not a label the retrun 0 for an error
if( ip->IsLabel() )
	{s = ip->GetString();

	 // if size >1 then chop off the : and save the name in the label list
	 s.remove(s.length()-1);
	}
else
	return 0;

while ( (l = labels++) != 0 )
	if( l->GetName() == s )
		{Data d; d.SetDecimal(CurrentAddr);
		 l->SetAddr(d); return 1;}

return 0;
}




// this pass goes through and builds all of the asmcode. It assigns address
// to the labels. The onlything left to do after this pass is to go back
// through the asmcode and find all the places where labels were used and
// fill in the correct address
void DoTheOpCodes()
{

Holder *ip = list.FirstEntry();
OpCode op;

// Go through every remaining word grouping one at a time in order
// A valid program can only have two possibilities.
// 1. the current group is a command. if it is then check for its operands
// 2. the current group is a label
// Anything else is an error.
while ( (ip = list++) != 0 )
	if( MatchCode(ip, op) )
		GetOperands(op);
	else if( !MatchLabel(ip) )
			{string err("Incorrect syntax on line ");
			 char st[20];
			 itoa(ip->GetLineNum(), st, 10);
			 err+=st;
			 err+=" with " + ip->GetString() + "\nDoes not match any opcode or label";
			 Error(err.c_str());
			}

}


// this is the code for pass 3


// this function searches through the label list to try and find the label
// that matches and then sets l to that label
void FindThisLabel(OpCode *c, Label &l)
{
Label *ip = labels.FirstEntry();

while ( (ip = labels++) != 0 )
	if( c->GetMen() == ip->GetName() )
		{l = *ip; return; }
}




// This function fills in the correct address for this label
// a size with -1 is for the low byte of the address
// a size with -2 is for the high byte of the address
void FillAddress(OpCode *c)
{
Label l;

FindThisLabel(c, l);
Data addr = l.GetAddr();

if(c->GetSize() == -1)
	c->SetOp( addr.GetLow() );
else
	 c->SetOp( addr.GetHigh() );

c->SetSize(1);
}




// This function goes through the asmcode that was generated in pass 1 and 2
// and looks for any opcodes with negative sizes. The only ones like that
// are the ones that refered to labels. When it finds one it now goes back
// and puts the correct address in instead of 00 00.
void FillInLabels()
{
OpCode *c = asmcode.FirstEntry();

while ( (c = asmcode++) != 0 )
	if( c->GetSize() < 0)
		FillAddress(c);
}




// This function reads in the filename of the program to assemble and
// gets the starting address of the program
void GetInfo(string &dir, string &name, string &filename)
{
cout << "\nPlease enter the name of the file to assemble: ";
cin >> filename;

// now extract the dir name and file name
int size = filename.length(), GotIt=0;

for(int i=(size-1); i>=0; i--)
	if(!GotIt)
		{if( filename.get_at(i) == '\\' )
			{dir = '\\'; GotIt = 1;}
		 else
			name = filename.get_at(i) + name;
		}
	else
		dir = filename.get_at(i) + dir;


// now check to see if the file included .asm in the filename
// if it did not then add it.
// if it did then remove it from the name string for later use

//this puts the last 4 charachters of the filename into the
string extension("    ");
if(size >4) extension = filename.substr(size-4);


if( extension == ".asm")
	name.remove( name.length()-4 );
else
	filename+=".asm";



string number;
cout << "\nPlease enter the starting address of the program: ";
cin >> number; number.to_lower();

Data d = CrackNumber(number);

if(d.GetSize() < 0) Error("This is an invalid starting address");
AddrStart = CurrentAddr = d.GetValue();
}


// This function writes the output file. This file first lists the name of
// the assembly file that this comes from and then tells the size of the
// program in the number of bytes, and finally it lists the address, mnemomic,
// and opcode for every address of the program.
void WriteOutFile(string dir, string name)
{
int Length = CurrentAddr - AddrStart;
string filename = dir + name + ".out";

ofstream outfile(filename.c_str());

if(outfile.fail())
	Error("output file could not be opened");

outfile << "Assembly OutPut file for the file " << name << ".asm\n\n";
outfile << "Length:  " << Length << " Bytes\n\n";

OpCode *c = asmcode.FirstEntry();
unsigned addr = AddrStart;

while ( (c = asmcode++) != 0 )
	{Data d;
	 d.SetDecimal(addr);
	 outfile << d.GetHigh() << d. GetLow() << '\t' << c->GetMen() << "\t\t" << c->GetOp() << '\n';
	 addr++;
	}

outfile.close();
}




// this is the program body. It has five main stages
//	1. Initialization
//		a. read in the arguments
//		b. read in the 8085 opcodes
//		c. parse the text file into individual word groupings
//	2. Pass #1. Find all the variables and labels
// 3. Pass #2. Wrtie all of the asm code except for the label addresses
// 4. Pass #3. Go back and fill in the label addresses
// 5. Write out the asm file
void main()
{
string dir, name, filename;

// this is the init phase
GetInfo(dir, name, filename);
//cout << "\n1. " << dir << "\n2. " << name << "\n3. " << filename << '\n';
CodeReader();
Parse(list, filename.c_str());

// this is pass 1
ReadVaribles();

// this is pass 2
DoTheOpCodes();

// this is pass 3
FillInLabels();

// now part 5. Writing the asm code to a file
WriteOutFile(dir, name);


// farewell
cout << "The file has been assembled\nThe output can be found in the file: ";
string f = dir + name + ".out";
cout << f << "\n";
}
