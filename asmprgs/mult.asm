;Binary Multiplication Algorithm for 8085
;takes the operands in H & L registers
;stores 16-bit multiplication result
;in H-L pair
;(c) Vaibhav Jain
;date 09/4/2004

mvi h,efh;	operand1 in H
mvi l,f0h;	operand2 in L

;*******Initialization*******
mov a,h; copy operand 1 to acc
mov e,l; copy operand 2 to e
mvi d,0; set register d to 0
lxi h,0; set multiplication result to zero

loop:
	ora a		;check if a if now zero
	jz exit	;exit loop if true
	stc		;set carry flag
	cmc		;complement cary flag
	rar		;rotate acc right through carry
	jnc cond1	;skip nxt step if no carry
	dad d		;double add d-e to h-l
cond1:
	xchg		;xchange D-E  & H-L
	call LSHL	;left shift H-L one bit
	xchg		;re-xchange D-E  & H-L
	ani 7Fh	;mask out leftmost bit of acc
	jmp loop	;return in loop

exit:	hlt	; the job is now complete
;*********************************
;****Procedure: Left Shift HL*****
;left shifts contents of HL left one bit
;H-L: Data to be shifted
;Flags Effected: CY
;*********************************
LSHL:
mov b,a	;copy acc to b
	stc	; set the carry flag
	cmc	; this sets carry it to zero
	mov a,l; copy lower 8 bits of data
	ral	; rotate accumulator left trough carry
	mov l,a; copy back the contents to l
	mov a,h;copy upper 8 bits 
	ral	; rotate it through carry
	mov h,a; copy back the contents
mov a,b	;copy previous contents of acc
ret		;job is one and now return
