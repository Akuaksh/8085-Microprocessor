;program to create a table of given number
;from 1 to the given index on a selected
;memory location
;(c) Vaibhav Jain 2004
;date: 9/4/2004

mvi b,3h	;table of 3
mvi c,15h	;from 0 to 21
lxi h,2000	;address to store table

;***********************************

xra a	;set a to zero
inr c	;safety from zero count

loop:
	mov m,a
	dcr c
	jz exit
	add b	;add b to accumulator
	inx h
	jmp loop

exit: hlt
