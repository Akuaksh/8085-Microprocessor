;16-bit rotation to left for H-L register
;(c) Vaibhav Jain 2004
;date:9/4/2004
lxi h,1234h	;load data in HL
mvi c,1h	;rotate to left 34 times
;***************************
inr c
loop:	dcr c
	jz exit	; exit if count is zero
	mov a,l	; copy l to acc
	stc		;
	cmc		;set carry flag to zero
	ral		;rotate acc left 1-bit
	mov l,a	;copy back to l
	mov a,h	;now work on contents of h
	ral		;rotate through cary
	mov h,a	;copy contents back to h
	mvi a,0
	adc l		;add l with cary in acc
	mov l,a	;mov this to l
	jmp loop	;cary on the loop

exit: hlt
;********return is 4 in H-L********

