;8085 implementation of strlen() function
;of C standard library
;date: 15/4/04
;**************
lxi h,2000h	;load address of string
call Strlen ;
hlt		;
;
;************************
; Strlen:Calculates length of an Ascii-Z string
;Input: H-L: Adress of string
;Modifies: C: length of array, Flags
;************************
Strlen: 	push psw	;save acc and flags
		push h	;save h-l pair
		mvi c,0h	;set c to zero
Strlenloop:	mov a,m	;get the char
		ora a		; check if zero
		jz Strlenout; exit if zero
		inr c		;incr counter
		inx h		;to next char pos
		jmp Strlenloop; do the loop
Strlenout:	pop h		;restore H-L pair
		pop psw	;restore Acc and Flags
		ret		;Job done Bye-Bye
;**********************
		


