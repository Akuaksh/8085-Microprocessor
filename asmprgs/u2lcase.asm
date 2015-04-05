;Uppercase To Lowercase and vice-versa
; of an ascii-z string
;(c) Vaibhav Jain 
;date: 15/4/04
;*************************
lxi h,2000h
call L2Ucase	;convert to lowercase
lxi h,2070h		;address second string
call U2Lcase	;convert it to lowercase
hlt
;***********************
;Uppercase to Lowecase
;Input : H-L= Address of ASCII-Z string
;**********************
U2Lcase:
	push h	;save h-l pair
	push psw	;save acc and flags
U2Lcase1:	mov  a,m 	;get the char
		ora a		;check if zero
		jz U2Lcase2	;exit if zero
		cpi 41h	;if >='A'(65)
		jc U2Lcase3
		cpi 5Bh	;if >='['(91)
		jnc U2Lcase3
		adi 20h	;convert to lcase
		mov m,a	;save char to memory	
U2Lcase3:	inx h		;move to next pos
		jmp U2Lcase1;continue loop
U2Lcase2: 	pop psw	;restore acc and flags		
		pop h		;restore h-l pair
		ret
;***********************
;
;***********************
;Lowecase to Uppercase 
;Input : H-L= Address of ASCII-Z string
;**********************
L2Ucase:
	push h	;save h-l pair
	push psw	;save acc and flags
L2Ucase1:	mov  a,m 	;get the char
		ora a		;check if zero
		jz L2Ucase2	;exit if zero
		cpi 61h	;if >='a'(97)
		jc L2Ucase3
		cpi 7Bh	;if >='{'(123)
		jnc L2Ucase3
		sui 20h	;convert to Ucase
		mov m,a	;save char to memory	
L2Ucase3:	inx h		;move to next pos
		jmp L2Ucase1;continue loop
L2Ucase2: 	pop psw	;restore acc and flags		
		pop h		;restore h-l pair
		ret
;**************************
