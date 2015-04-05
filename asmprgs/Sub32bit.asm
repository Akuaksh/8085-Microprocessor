;32-bit subtraction
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
xchg	;xchange addresses of operands
loop:
	pop psw 	; restore flags
	ldax d	;get operand1 byte
	sbb m		;subtract with borrow
	stax d
	mvi a,0
	push psw	;save flags and acc
	inx d
	inx h
	dcr c
	jnz loop
pop psw
hlt
