;*******32 bit Shifting*********
;(c) Vaibhav Jain
;Date: 16/4/04
;******************************
lxi sp,ffffh
lxi h,2000
call Shr32
call Shl32
call Shl32
hlt
;******Shift Left 32-bit*************
;Shift Left a 32 bit number pointed by H-L 
;through Cary Fill
;operands: H-L address of number
;modifies CY flag 
;*******************************
Shl32:
	push h
	push d
	push b
	push psw
	mvi b,0h	; set B to zero
	mvi c,4h	; set c to count
	mov d,b	; set D to zero

Shlloop:
	mov a,m
	ral
	jnc Shlnc1	; if no cary then SKIP
	inr d		; Save present CY in D
Shlnc1:
	add b		;add previous CY to num.
	mov m,a	;save it back
	mov b,d	;save Cy of current Op to b 
	mvi d,0	;NFC==> set D to zero
	inx h
	dcr c
	jnz Shlloop
	
	mov a,b	; save last carry to Acc
	pop b		; pop Acc & psw to B-C
	mov b,a	; set flags for bit have CY
	push b	; push the Acc & new Flags
	pop psw	; pop new data to flgs & acc
	pop b		; pop old b-c
	pop d		; pop old d-e
	pop h		; pop old h-l
	ret
;******************************
;******Shift Right 32-bit*************
;Shift Right a 32 bit number pointed by H-L 
;through Cary Fill
;operands: H-L address of number
;modifies CY flag 
;*******************************
Shr32:
	push h
	push b
	push psw
	push psw 	;save flg+CY for operations
	mvi c,4h	;load count in C
	mvi b,0	;set b-c pair to count
	dad b		;add to h-l pair to get
	dcx h		;bottom of integer
Shr32loop1:
	pop psw	;get the previous flags
	mov a,m	;get the data chuck
	rar		;rotate right through CY
	push psw	;save any CY generated
	mov m,a	;save data chuck back to mem
	dcx h		;to new data chuck
	dcr c		;decrement counter
	jnz Shr32loop1
pop psw	;restore previous flag
mvi a,0	;set acc to zero
aci 0		;trap the Cy in Acc
pop b		;pop original psw in b
mov b,a	;copy the CY to stacked PSW
push b	;push new PSW
pop psw	;pop original PSW
pop b		;pop original B
pop h		;pop original h
ret
;******************************
