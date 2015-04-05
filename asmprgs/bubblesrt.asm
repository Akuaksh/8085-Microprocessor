;bubble sort Program
;without using stack
;(c) Vaibhav Jain 2003
;*****Input************
lxi h,2000	;address of array
mvi c,16h	; no. of elements
;********Program********
mov d,h
mov e,l
outerlop:
mov b,m
dcr c
loop:	mov a,b
	inx h
	mov b,m
	cmp b
	jc loop2
	dcx h
	mov m,b
	inx h
	mov m,a
	mov b,a
loop2:dcr c
	jnz loop
mov a,h
cma 
mov h,a
mov a,l
cma
mov l,a
dad d
mov a,l
cma
mov c,a
mov h,d
mov l,e
cpi 1
jnz outerlop
hlt
