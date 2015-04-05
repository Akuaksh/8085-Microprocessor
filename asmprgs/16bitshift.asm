;16 bit arithmetic shifting to left
;shifts register h-l left by 1 bit a time
;(c) Vaibhav Jain
;date:9/4/04
lxi h,1234H; load data in H-L pair
mvi c,2h; load count in c

loop: stc	; set the carry flag
	cmc	; this sets carry it to zero
	mov a,l; copy lower 8 bits of data
	ral	; rotate accumulator left trough carry
	mov l,a; copy back the contents to l
	mov a,h;copy upper 8 bits 
	ral	; rotate it through carry
	mov h,a; copy back the contents
	;****Shift is complete perform loop
	dcr c
	jnz loop
hlt
;*** result is 18h in H-L pair
	

	
	
	
