;32 bit rotation

lxi h,2000
call ROR32
call ROL32
call ROL32
hlt
;******ROtate Left 32-bit*************
;Rotates Left a 32 bit number pointed by H-L 
;operands: H-L address of number
;modifies CY flag , Acc
;*******************************
ROL32:
push h
ana a	;reset CY flag
mvi c,4
push psw
loop:
	pop psw
	mov a,m
	ral
	mov m,a
	inx h
	push psw
	dcr c
	jnz loop
pop psw
pop h
mov a,m
aci 0	; copy the cary bit to LSB
mov m,a
rrc
rlc
ret
;******************************
;******ROtate Right 32-bit*************
;Rotates right a 32 bit number pointed by H-L 
;operands: H-L address of number
;modifies CY flag,Acc
;*******************************
ROR32:
push h
ana a	;reset CY flag
mvi c,4
inx h;
inx h;
inx h;
push h;save this address for later refrence
push psw
ROR32loop:
	pop psw
	mov a,m
	rar
	mov m,a
	dcx h
	push psw
	dcr c
	jnz ROR32loop
pop psw
pop h ; get address of last byte
mov a,m
ral
rrc
mov m,a
pop h
ret
;******************************
