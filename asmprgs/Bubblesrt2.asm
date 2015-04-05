;Bubble sort routine Part 2
;********************
lxi h,2000
mvi c,16h

xra a
ora c
jz exit
dcr c
outerloop:	push b
		push h
innerloop: 	mov a,m
		inx h
		cmp m
		jc innerout
		mov b,m
		mov m,a
		dcx h
		mov m,b
		inx h
innerout:	dcr c
		jnz innerloop
	pop h	
	pop b
	dcr c
	jnz outerloop
exit:
	hlt
