;program to copy ascii-z strings from 
;source to destination
;(c) Vaibhav Jain
;Date: 9/4/2004

lxi h,2000	;source ascii-z string
lxi d,3000	;destination ascii-z string

;*****************
loop:
	mov a,m	; read src char
	stax d	; store it in destnation
	inx d		;incr to next dest pos
	inx h		;incr to next src pos
	ora a		;check if A was zero
	jnz loop	;continue if not zero
	hlt	;program exit


	
