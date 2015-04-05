;adding two arrays element by element into an
;another array
;(c) Vaibhav Jain
;date: 7/4/2004
lxi h,2000	;source bounded array1
lxi d,3000	;source bounded array2
lxi b,4000	;destination bounded array

;*************************
push h	;save address of arr1
mov h,d	;
mov l,e	;load address of arr2 in h-l
mov d,b	;
mov e,c	;load address of dest. arr in d-e

mov a,m	;load count of arr2
xthl		;m->arr1
mov b,m	;load count of arr1
cmp m		;
jc condition1
mov a,b
condition1:	mov c,a	;load the counter
		stax d	;store count in dest.arr

		inx d		;increment to storage area
		inx h		;increment to storage area
		xthl		;m->arr2
		inx h		;increment to storage area

		inr c		; incr c for zero safety

loop: 	dcr c
		jz exit
		mov a,m	; m points to arr2
		inx h		; incr pointer to arr2
		xthl	  	; m now points to arr1
		add m		; add its element to arr2
		inx h		; ince pointer to arr1
		stax d	;store the sum in d.b array
		inx d		;set new p->dest.array
		xthl		;m->arr2
		jmp loop

exit: 	pop h		;clean the stack
		hlt
