lxi h,2000
mvi c,0
xra a
ora c
jz exit

outerloop:	mov d,h
		mov e,l
		mov a,m
		push b
		push h

innerloop:	cmp m
		jc innerout
		mov d,h
		mov e,l
		mov a,m
		
innerout: 	inx h
		dcr c
		jnz innerloop

		pop h
		pop b
		mov b,m
		mov m,a
		mov a,b
		stax d
		inx h
		dcr c
		jnz outerloop

exit:		hlt
