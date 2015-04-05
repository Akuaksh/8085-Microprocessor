// ------------ linklist.h
// David Cofer   2/16/96
// a template for a linked list
// NOTE: any class used with this template must have the == operator
// overloaded to function properly. If it does not the code will not
// compile.

#ifndef LINKLIST_H
#define LINKLIST_H

template <class T> class LinkedList;

template <class T>
// An entry in the linked list
class ListEntry
{
	 T thisentry;             //The data stored in the current node
	 ListEntry *nextentry;    //pointer to the next entry
	 ListEntry *preventry;    //pointer to the previous entry
	 ListEntry(const T& entry);     //constructor for an entry
	 friend class LinkedList<T>;
	 // Lets Linked List Class operators use an entry of ListEntry while keeping
	 // its Data private
};

template <class T>
// construct a linked list entry
ListEntry<T>::ListEntry(const T &entry)
{
thisentry = entry;
nextentry = 0;
preventry = 0;
}

template <class T>
// the linked list class
class LinkedList
{
protected:
	 // the listhead
	 ListEntry<T> *firstentry;  //head of list
	 ListEntry<T> *lastentry;   //tail of list
	 //this is pointer that is used internally by several functions.
	 //it's used as a position holder in the list
	 ListEntry<T> *iterator;
	 void RemoveEntry(ListEntry<T> *lentry);
	 void InsertEntry(const T& entry, ListEntry<T> *lentry);
public:
	 LinkedList();
	 ~LinkedList();
	 void AppendEntry(const T& entry);
	 void RemoveEntry(int pos = -1);
	 void RemoveCurrentEntry()
		{RemoveEntry(iterator);
		 if(!iterator) iterator = firstentry;}
	 void InsertEntry(const T& entry, int pos = -1);
	 void ClearList();
	 T *FindEntry(int pos);
	 T *FindEntry(const ListEntry<T> *lentry) const;
	 T *FindElement(const T& entry);
	 T *CurrentEntry() //returns a pointer to the data being stored in the list node
		 {return iterator ? &(iterator->thisentry) : 0;}

	 T *FirstEntry();
	 T *LastEntry();
	 T *NextEntry();
	 T *PrevEntry();
	 T *operator++(int);
	 T *operator++();
	 T *operator--(int);
	 T *operator--();


	 const LinkedList<T>& ListCopy(const LinkedList<T>& list);
	 const LinkedList<T>& operator=(const LinkedList<T>& list);
	 const LinkedList<T>& operator=(const T& data);
	 const LinkedList<T>& operator=(int x);
	 const LinkedList<T>& operator+(const T& data) const;
	 const LinkedList<T>& operator+(const LinkedList<T>& list) const;
	 const LinkedList<T>& operator-(const T& data) const;
	 const LinkedList<T>& operator-(const LinkedList<T>& list) const;

	 const LinkedList<T>& operator+=(const T& data)
		{return *this = *this + data;}
	 const LinkedList<T>& operator+=(const LinkedList<T>& list)
		{return *this = *this + list;}
	 const LinkedList<T>& operator-=(const T& data)
		{return *this = *this - data;}
	 const LinkedList<T>& operator-=(const LinkedList<T>& list)
		{return *this = *this - list;}


	 int operator==(const LinkedList<T>& list) const;
	 friend ostream& operator<<(ostream& os, LinkedList<T>& list);
};

template <class T>
// construct a linked list
LinkedList<T>::LinkedList()
{
iterator = 0;
firstentry = 0;
lastentry = 0;
}

template <class T>
// destroy a linked list
LinkedList<T>::~LinkedList()
{
while (firstentry)
  RemoveEntry(firstentry);
}


template <class T>
// copy constructor for a linkedlist
const LinkedList<T>& LinkedList<T>::ListCopy(const LinkedList<T>& list)
{
ListEntry<T> *it = list.firstentry;
int i=0;

ClearList();
while(it)
	{const T ip = it->thisentry; i++;
	 AppendEntry(ip);
	 it = it->nextentry;
	}
return *this;
}


template <class T>
// overloaded = operator
const LinkedList<T>& LinkedList<T>::operator=(const LinkedList<T>& list)
{
return ListCopy(list);
}


template <class T>
// overloaded = operator: initializer clears the list
const LinkedList<T>& LinkedList<T>::operator=(int x = 0)
{
x++; //to get rid of that anoying warning
ClearList();
return *this;
}

template <class T>
// overloaded = operator: initializes the list to 1 element
const LinkedList<T>&  LinkedList<T>::operator=(const T& data)
{
ClearList();
*this += data;
return *this;
}


template <class T>
// overloaded + operator to add an element to the list
const LinkedList<T>& LinkedList<T>::operator+(const T& data) const
{
LinkedList<T> *templist = new LinkedList<T>;
*templist = *this;

templist->AppendEntry(data);
return *templist;
}

template <class T>
// overloaded + operator  for a list
const LinkedList<T>& LinkedList<T>::operator+(const LinkedList<T>& list) const
{
LinkedList<T> *templist = new LinkedList<T>;
*templist = *this;

ListEntry<T> *it = list.firstentry;

while(it)
	{const T ip = it->thisentry;
	 templist->AppendEntry(ip);
	 it = it->nextentry;
	}

return *templist;
}


template <class T>
// overloaded - operator to delete an element from the list if it is already
//in the list. deletes the first occurrence of the element
const LinkedList<T>& LinkedList<T>::operator-(const T& data) const
{
LinkedList<T> *templist = new LinkedList<T>;
*templist = *this;

if( templist->FindElement(data) )
	templist->RemoveCurrentEntry();

return *templist;
}


template <class T>
// overloaded l1 - l2 operator for a list. deletes only those elements from
//l2 that are in l1 and only deletes the first occurrence of the element
const LinkedList<T>& LinkedList<T>::operator-(const LinkedList<T>& list) const
{
LinkedList<T> *templist = new LinkedList<T>;
*templist = *this;

ListEntry<T> *it = list.firstentry;

while(it)
	{const T ip = it->thisentry;

	 if( templist->FindElement(ip) )
		templist->RemoveCurrentEntry();

	 it = it->nextentry;
	}

return *templist;
}

template <class T>
// tells if two lists are equal. to be equal the lists must have exactly
// the same elements in exactly the same position in the list
int LinkedList<T>::operator==(const LinkedList<T>& list) const
{
ListEntry<T> *it1 = list.firstentry;
ListEntry<T> *it2 = firstentry;

int ok = (it1 && it2); //if both exist its ok


while(ok)
	{const T ip = it1->thisentry;
	if( !(it2->thisentry == ip) )
		return 0;

	it1 = it1->nextentry;
	it2 = it2->nextentry;
	ok = (it1 && it2);
	}

//if one of the lists has more nodes then its it will not be null
//and they are not equal
if(it1 || it2) return 0;
else return 1;
}


template <class T>
// clears a linked list
void LinkedList<T>::ClearList()
{
while (firstentry)
  RemoveEntry(firstentry);
iterator = 0;
firstentry = 0;
lastentry = 0;
}


template <class T>
// append an entry to the end of the linked list
void LinkedList<T>::AppendEntry(const T& entry)
{
ListEntry<T> *newentry = new ListEntry<T>(entry);

newentry->preventry = lastentry;
if (lastentry)
  lastentry->nextentry = newentry;
if (firstentry == 0)
  firstentry = newentry;
lastentry = newentry;
}

template <class T>
// remove an entry (lentry) from the linked list
void LinkedList<T>::RemoveEntry(ListEntry<T> *lentry)
{
if (lentry == 0)
  return;
if (lentry == iterator)
  iterator = lentry->preventry;
// repair any break made by this removal
if (lentry->nextentry)
  lentry->nextentry->preventry = lentry->preventry;
if (lentry->preventry)
  lentry->preventry->nextentry = lentry->nextentry;
// maintain listhead if this is last and/or first
if (lentry == lastentry)
		lastentry = lentry->preventry;
if (lentry == firstentry)
	firstentry = lentry->nextentry;
delete lentry;
}

template <class T>
// insert an entry into the linked list
void LinkedList<T>::InsertEntry(const T& entry, ListEntry<T> *lentry)
{
ListEntry<T> *newentry = new ListEntry<T>(entry);
newentry->nextentry = lentry;
if (lentry)    {
  newentry->preventry = lentry->preventry;
  lentry->preventry = newentry;
}
if (newentry->preventry)
  newentry->preventry->nextentry = newentry;
if (lentry == firstentry)
  firstentry = newentry;
}

template <class T>
// remove an entry from the linked list
// pos is the entry number that is to be removed
void LinkedList<T>::RemoveEntry(int pos)
{
FindEntry(pos);
RemoveEntry(iterator);
}

template <class T>
// insert an entry into the linked list
// entry is the data to be inserted into a new node at node number pos
void LinkedList<T>::InsertEntry(const T& entry, int pos)
{
FindEntry(pos);
InsertEntry(entry, iterator);
}

template <class T>
// return a specific linked list entry
// Note all lists start at pos = 1. ie) the first entry is entry 1
T *LinkedList<T>::FindEntry(int pos)
{
//if pos = -1 then no pos value was given so get out of function
if (pos != -1)    {
  iterator = firstentry; //start at the first entry
  if (iterator)    {
		while (--pos)  //decrement pos until you get to the node you eant
			 iterator = iterator->nextentry;
  }
}
return CurrentEntry();
}

template <class T>
// finds an entry of the tree
T *LinkedList<T>::FindEntry(const ListEntry<T> *lentry) const
{
ListEntry<T> *it = firstentry;

while(it)
	{if( it == lentry)
		return &(it->thisentry);
	 it = it->nextentry;
	}

return 0;
}

template <class T>
// return the first entry in the linked list
T *LinkedList<T>::FindElement(const T& entry)
{
iterator = firstentry;

while(iterator)
	{if( iterator->thisentry == entry)
		return &(iterator->thisentry);
	 iterator = iterator->nextentry;
	}

return 0;
}

template <class T>
// return the first entry in the linked list
T *LinkedList<T>::FirstEntry()
{
iterator = firstentry;
return CurrentEntry();
}

template <class T>
// return the last entry in the linked list
T *LinkedList<T>::LastEntry()
{
iterator = lastentry;
return CurrentEntry();
}

template <class T>
// return the next entry in the linked list
T *LinkedList<T>::NextEntry()
{
if (iterator == 0)
  iterator = firstentry;
else
  iterator = iterator->nextentry;
return CurrentEntry();
}

template <class T>
// return the previous entry in the linked list
T *LinkedList<T>::PrevEntry()
{
if (iterator == 0)
  iterator = lastentry;
else
  iterator = iterator->preventry;
return CurrentEntry();
}

template <class T>
// returns the next entry in the linked list starts at the head of the list
//if iterator is 0.  (postfix)
T *LinkedList<T>::operator++(int)
{
T *entry = CurrentEntry();
NextEntry();
return entry;
}

template <class T>
// returns the next entry in the linked list starts at the head of the list
//if iterator is 0.   (prefix)
T *LinkedList<T>::operator++()
{
return NextEntry();
}

template <class T>
// returns the prev entry in the linked list starts at the tail of the list
//if iterator is 0.  (postfix)
T *LinkedList<T>::operator--(int)
{
T *entry = CurrentEntry();
PrevEntry();
return entry;
}

template <class T>
// returns the prev entry in the linked list starts at the tail of the list
//if iterator is 0.   (prefix)
T *LinkedList<T>::operator--()
{
return PrevEntry();
}



template <class T>
// overloaded ostream operator <<
ostream& operator<<(ostream& os, LinkedList<T>& list)
{
T *ip = list.FirstEntry();

while ( (ip = list++) != 0 )
	 cout << *ip << '\n';
cout << '\n';
return os;
}

#endif
