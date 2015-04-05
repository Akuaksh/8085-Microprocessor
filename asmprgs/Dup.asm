;******************************
;removal of duplicates from a sorted array
; stores no. of unique elements in c
;(c) Vaibhav Jain
;date: 15/4/04
;******************************

lxi h,2000	;address of array
mvi c,16h	; count of no. of elements
	
	push h
	mov d,h
	mov e,l
loop:	ldax d
	cmp m
	jz lout ; if equal skip following steps
	inx d
lout:	mov a,m
	stax d
	inx h
	dcr c
	jnz loop
exit:	pop h
	xchg
	mov a,h
	cma
	mov h,a
	mov a,l
	cma
	mov l,a
	dad d
	mov a,l
	cma
	mov c,a
	inr c
hlt
