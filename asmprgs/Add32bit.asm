;32-bit addition
;take address of operand1 in h-l &
;& address of operand2 in d-e 
;stores result at operand1
;operands are stored in BIG-Edian format
lxi h,2000
lxi d,2004

;***************************
mvi c,4
xra a; set carry flag to zero
push psw; save flags
loop:
	pop psw ; restore flags
	mvi a,0
	ldax d
	adc m
	mov m,a
	inx d
	inx h
	push psw; save flags
	dcr c
	jnz loop
pop psw
hlt
