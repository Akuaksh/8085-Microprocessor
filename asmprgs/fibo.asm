;Fibonacci Series program
;(c) Vaibhav Jain 2004
;*********Input*********
lxi h,2000
mvi c,ffh
;**************Program******
xra a
mvi b,1
loop:	mov m,a
	add b
	mov d,a
	mov a,b
	mov b,d
	inx h
	dcr c
	jnz loop
hlt
