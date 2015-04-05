;program to reverse a given array
;input h-l address of array
;c: count of no. of elements
;******************************
lxi h,2000
mvi c,8

mov d,h
mov e,l
mov b,c

loop1: mov a,m
	 push psw
	 inx h
	 dcr c
	 jnz loop1


loop2: pop psw
	 stax d
	 inx d
	 dcr b
	 jnz loop2

hlt
	 


