;hexa decimal to binary conversion
;converts a given byte in an ascii-z 
;binary charactor string

mvi a,34h	;convert it into binary equivalant
lxi h,2000h	;store the string at this location

;********************
mov b,a	; save param in B
mvi c,8h	;load counter in C
loop: mov a,b 	;get rotated number
	rlc		;rotate Acc left
	mov b,a 	;save num in B
	mvi a,0 	;set Acc to zero
	aci 30h	; Ascii '0'=30h & '1'=31h
	mov m,a 	;save the Bit in memory
	inx h		;To next memory location
	dcr c		;decrement count
	jnz loop	;continue loop
exit: mvi m,0	;end string with NULL char
	hlt
