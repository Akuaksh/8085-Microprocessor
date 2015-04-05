;16 bit arithmetic shifting to right
;shifts register h-l right by 1 bit a time
;(c) Vaibhav Jain
;date:9/4/04s
lxi h,1234h; load data in H-L pair
mvi c,2h; load count in c

loop: stc	; set the carry flag
	cmc	; this sets carry it to zero
	mov a,h; copy lower 8 bits of data
	rar	; rotate accumulator left trough carry
	mov h,a; copy back the contents to l
	mov a,l;copy upper 8 bits 
	rar	; rotate it through carry
	mov l,a; copy back the contents
	;****Shift is complete perform loop
	dcr c
	jnz loop
hlt
;*** result is 18h in H-L pair
	

	
	
	
