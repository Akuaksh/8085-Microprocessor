// ------------ Assem.h
// David Cofer   7/6/96
// this file contains the class definitions needed by the assembler

class Data
{
	string high;
	string low;
	int size;

public:
	Data() {};
	Data(string h, string l, int s);
	Data(string num, int s);
	Data(int num, int s);
	Data operator=(Data d);
	int operator==(Data d);

	void SetHigh(string h);
	void SetLow(string l);
	void SetSize(int s);
	void SetDecimal(string num);  //takes a decimal string and stores it
	void SetDecimal(unsigned num);  //takes a decimal number and stores it
	void SetOctal(string num);    //takes an octal string and stores it
	int  GetOctalVal(string num);
	void SetHex(string num);      //takes a hex string and stores it
	string GetHexNibble(unsigned place, unsigned num);
	int  GetHexVal(string num);

	string GetHigh() {return high;};
	string GetLow() {return low;};
	string GetHex();              //returns the data as a hex string
	int GetValue() {return GetHexVal(GetHex());}; //returns int value of data
	int GetSize() {return size;};

	friend ostream& operator<<(ostream& os, Data d);
};

// I did not do these inline because it gave me a bunch of warnings about
// class by value or something
Data::Data(string h, string l, int s)
{high = h; low = l; size = s;}

Data::Data(string num, int s)
{SetHex(num); size = s;}

//takes an integer and converts it to a hex string and stores it
Data::Data(int num, int s)
{SetDecimal(num); size = s;}

void Data::SetHigh(string h)
{high = h;}

void Data::SetLow(string l)
{low = l;}

void Data::SetSize(int s)
{size = s;}


//this function finds either 1,2,3 or 4 nibble in a 16 bit number and
//returns the nibble in string format
string Data::GetHexNibble(unsigned place, unsigned num)
{
string val; val.resize(1);

//isolates the specific bits that are needed
num = num & (0xF * (int) pow(2.0, (place*4.0) ) );

num = num >> place*4; //move it into the lowest nibble

if(num >=0 && num <=9)
	val.put_at( 0, (char)  (num+48)); //convert to ascii
else
	val.put_at( 0, (char) (num+87)); //convert to ascii
return val;
}

//takes a decimal string and stores it
void Data::SetDecimal(string num)
{
int number = atoi(num.c_str());
size = 1;

if(number > 255)
	{size = 2;
	 //gets the hex value of the highest byte
	 high = GetHexNibble(3, number) + GetHexNibble(2, number);
	}

//gets the hex value of the lowest byte
low = GetHexNibble(1, number) + GetHexNibble(0, number);
}

//takes a decimal number and stores it
void Data::SetDecimal(unsigned num)
{
unsigned number = (unsigned) num;
size = 1;

if(number > 255)
	{size = 2;
	 //gets the hex value of the highest byte
	 high =  GetHexNibble(3, number) + GetHexNibble(2, number);
	}
else high = "00";

 //gets the hex value of the lowest byte
low = GetHexNibble(1, number) + GetHexNibble(0, number);
}

//takes a octal string and returns the integer value of that string
int Data::GetOctalVal(string num)
{
int total=0;
int thissize = num.length();

for(int i=(thissize-1); i>=0; i--)
	{char ch = num.get_at(i); //get the char at pos i
	 int val = (ch-48);  //convert it to a number
	 total += (val * (int) pow(8.0, (double) (thissize-i-1) ));
	}

return total;
}

//takes an octal string and stores it
void Data::SetOctal(string num)
{
int total = GetOctalVal(num);
SetDecimal(total);
}

//takes a hex string and stores it
void Data::SetHex(string num)
{
int ch[4];
int thissize = num.length();

for(int i=0; i < thissize && i < 5; i++)
	ch[i] = num.get_at(i);

low.resize(2); high.resize(2); // make sure the varibles are big enough
switch(thissize)
	{
	 case 1: high = "00";
				low.put_at(1, '0'); low.put_at(0, ch[0]); size = 1; break;
	 case 2: high = "00";
				low.put_at(1, ch[1]); low.put_at(0, ch[0]);  size = 1; break;
	 case 3: high.put_at(1, '0'); high.put_at(0, ch[0]);
				low.put_at(1, ch[3]); low.put_at(0, ch[2]);
				if(ch[0] == '0') size = 1; //if it is 0012 then it is really 1 byte
				else size = 2;
				break;
	 case 4: high.put_at(1, ch[1]); high.put_at(0, ch[0]);
				low.put_at(1, ch[3]); low.put_at(0, ch[2]);
				if(ch[0] == '0' && ch[1] == '0') size = 1;
				else size = 2;      //if it is 0012 then it is really one byte
				break;
	}
}

//returns the data as a hex string
string Data::GetHex()
{
string val = high+low;
return val;
}


//takes a hex string  and returns the integer value of the string
int Data::GetHexVal(string num)
{
int total=0;
int thissize = num.length();

for(int i=(thissize-1); i>=0; i--)
	{char ch = num.get_at(i); //get the char at pos i
	 int val = 0;

	 if(ch >= '0' && ch <= '9')
		val = (ch-48);  //convert it to a number
	 else
		val = (ch-87);

	 total += (val * (int) pow(16.0, (double) (thissize-i-1) ));
	}

return total;
}


Data Data::operator=(Data d)
{
high = d.high; low = d.low; size = d.size;
return d;
}

int Data::operator==(Data d)
{
if(size == 2)
	if( high == d.high && low == d.low) return 1;
else
	if( low == d.low) return 1;

return 0;
}

ostream& operator<<(ostream& os, Data d)
{
if(d.GetSize() == 2)
	cout << d.GetHigh() << d.GetLow();
else
	cout << d.GetLow();
return os;
}



//this class holds the label names and address for the varibles and labels
class Label
{
	string name;
	int size; //tells whether or not it refers to a long(2 bytes) or int(1 byte)
	Data addr;

public:
	Label() {};
	Label(string n, Data d, int size);
	string GetName() {return name;};
	Data GetAddr() {return addr;};
	int GetSize() {return size;};
	void SetName(string n);
	void SetAddr(Data d);
	void SetSize(int s) {size = s;};

	Label operator=(Label l);
	int operator==(Label l);
	friend ostream& operator<<(ostream& os, Label l);
};

Label::Label(string n, Data d, int s)
{name = n; addr = d; size = s;}

void Label::SetName(string n)
{name = n;}

void Label::SetAddr(Data d)
{addr = d;}

Label Label::operator=(Label l)
{name = l.name; addr = l.addr; size = l.size; return l;}

int Label::operator==(Label l)
{
if(name == l.name && addr == l.addr && size == l.size)
	return 1;
else return 0;
}

ostream& operator<<(ostream& os, Label l)
{
os << l.GetName() << '\t' << l.GetAddr() << '\t' << l.GetSize();
return os;
}





// this class is used to store the asm menomics( ADDA, MOVA .. ect) their
// opcodes and
class OpCode
{	string men, op;
	int size;

 public:
	OpCode()
		{size = 1;}
	OpCode(string menomic, string code, int s = 1)
		{men = menomic; op = code; size = s;}
	OpCode operator=(OpCode code);
	int operator==(OpCode code);
	int operator==(string menomic);

	string GetMen() {return men;}
	string GetOp() {return op;}
	int GetSize() {return size;}

	void SetMen(string m);
	void SetOp(string o);
	void SetSize(int s) {size = s;};
	friend ostream& operator<<(ostream& os, OpCode code);
};


void OpCode::SetMen(string m)
{men = m;}

void OpCode::SetOp(string o)
{op = o;}

OpCode OpCode::operator=(OpCode code)
	{men = code.men; op = code.op; size = code.size;
	 return code;
	}

int OpCode::operator==(OpCode code)
	{if(men == code.men && op == code.op && size == code.size)
		return 1;
	 else return 0;
	}

int OpCode::operator==(string menomic)
	 {if(men == menomic) return 1;
	 else return 0;}

ostream& operator<<(ostream& os, OpCode code)
{
os << code.GetMen() << '\t' << code.GetOp() << "\t" << code.GetSize();
return os;
}

