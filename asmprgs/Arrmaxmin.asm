;get max & min elements of the given array
lxi h,2000 	; address of array
mvi c,5	; no. of elements

xra a
ora c
jz exit
mov a,m
mov b,m
loop: 	inx h
		dcr c
		jz exit
		cmp m
		jnc jmp2
		mov a,m

jmp2:		mov d,a
		mov a,b
		cmp m
		jc loopout
		mov b,m 				

loopout:	mov a,d
		jmp loop

exit:		hlt
	
	
