;merging of two sorted arrays into an
;sorted array
;(c) Vaibhav Jain 2004
;date: 7/4/2004
lxi h,2000	;source bounded array1
lxi d,3000	;source bounded array2
lxi b,4000	;destination bounded array

;*************************************
ldax d	;load count of arr2
add m		;add count of arr1 to that of arr1
stax b	;store length in dest. bounded array

push h	;save address of arr1
mov h,d	;
mov l,e	;load address of arr2 in h-l

mov d,b	;
mov e,c	;load address of dest.arr in d-e

mov c,m	;load count of arr2 in b
inx h		;incr p->arr2 to storage area
xthl		;get p->arr1
mov b,m	;load count of arr1 in b
inx h		;incr p->arr1 to storage area

inx d		;incr p->dest.arr to storage area
;*************************************
loop: 			;m->arr1
		xra a		;set a to zero
		ora b		;check if b is zero
		jz lout
		xthl		
				;m->arr2
		xra a		;set a to zero
		ora c		;check if c is zero
		jz lout	
		
				;m->arr2
		mov a,m	;m points to arr2
		dcr c		;assuming that element 
		inx h		;in arr2 i.e acc is least
		xthl		;m->arr1
		cmp m		;m points to arr1
		jc cond2	;jmp if assumption is true
;*************************************
		mov a,m	;rectify the mistake
		inx h		;incr p->arr1 to new pos
		dcr b		;set new count of elems in arr1 
		
		xthl		;m->arr2
		dcx h		;decr p->arr2 back		
		inr c		;incr c back
		
		xthl		;reenforce the previous situation
				;i.e m->arr1
;*************************************
cond2:	stax d	;a contains min element
				;store it to new dest.
		inx d		;set new dest pointer
		jmp loop
;************************************
lout:		pop h		;get pointer to remaing 
				;elements
		xra a		;set a to 0
		ora b		;get count in b
		ora c		;get count in c
		inr a		;increment a for zero safety
		mov c,a	;set generated count in c
;***loop to copy remaining elements*******
loop2:	dcr c
		jz exit
		mov a,m
		stax d 
		inx d
		inx h
		jmp loop2
;****************************************
exit: 	hlt
