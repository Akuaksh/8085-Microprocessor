;Implement the following variant of the strncpy function: 
;void strncpy(char * src, char * dest, unsigned char n)
;Assume all strings to be already allocated, and that the 
;strings do not overlap. In strncpy not more than 
;n bytes are copied.If there is no null (0) byte among 
;the first n bytes of src, the result will not be null-terminated. 
;Further, in the case where the length of src is less than n, the
;remainder of dest will be padded with nulls
;(c) Vaibhav Jain
;Date: 9/4/2004

lxi h,2000	;source ascii-z string
lxi d,3000	;destination ascii-z string
;*****************
inr c		;protection from zero count
loop:	dcr c
	jz exit
	mov a,m	; read src char
	stax d	; store it in destnation
	inx d		;incr to next dest pos
	inx h		;incr to next src pos
	ora a		;check if A was zero
	jnz loop	;continue if not zero

exit:	hlt	;program exit


	
