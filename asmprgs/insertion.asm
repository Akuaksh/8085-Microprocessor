;Insertion sort routine
;vaibhav jain 05/04/2004
lxi h,2000	;load adress of array
mvi c,Ah	;load no. of elements

xra a		; set acc to 0
inr c		
outerloop:	inr a		;generate next counter
		cmp c		; compare with max counter
		jnc exit	; exit if equal
		push b	;save max counter info
		push psw	; save current counter
		push h	;save current base
		mov c,a	;copy new counter to c
		mov d,h	;
		mov e,l	;copy h-l to d-e
		mov a,m	;get cmp element
		dcx h		;set h-l cmp base
		
innerloop: 	dcr c		; dcr counter
		jz outerout	; exit loop if zero
		cmp m		; cmp cur element to acc
	     	jnc outerout; exit loop if less than
		mov b,a	;save acc to b
		mov a,m	;copy cur ele to acc
		stax d	; store it at prebase
		mov a,b	;copy cmpele back to acc
		dcx d		;dcr d-l
		dcx h		;dcr h-l	
		jmp innerloop; jmp back to loop

outerout:  	stax d	; store acc to curbase
		pop h		;retrive saved base
		pop psw	;retrive pre counter
		pop b		;retrive max counter
		inx h		; inr h-l to next base
		jmp outerloop; jmp to next iteration
exit:	hlt
	
