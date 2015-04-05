;16-bit rotation to right for H-L register
;(c) Vaibhav Jain 2004
;date:9/4/2004
lxi h,1234h	;load data in HL
mvi c,1h	;rotate to right 34 times
;***************************
inr c
loop:	dcr c
	jz exit	; exit if count is zero
	mov a,h	; copy l to acc
	stc		;
	cmc		;set carry flag to zero
	rar		;rotate acc left 1-bit
	mov h,a	;copy back to l
	mov a,l	;now work on contents of h
	rar		;rotate through cary
	mov l,a	;copy contents back to h
	mvi a,0
	rar		;rotate acc and send cary bit
			;to the MSB
	ora h		;or l with cary in acc
	mov h,a	;mov this to l
	jmp loop	;cary on the loop

exit: hlt
;********result is 4000 in H-L********

