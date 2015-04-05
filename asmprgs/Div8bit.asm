;Division of 8085
;Divides Value of Reg.B with Value of Reg.C
;stores Quotient in B and Remainder in C
mvi b,feh
mvi c,10h
;**************************
mov a,c
mvi c,8h
loop:
		rlc		;
		jc loopout 	;if end reached exit
		dcr c		;decrement counter
		jnz loop	;do the shift loop
		;****there is an overflow******
		pop d		;Restore D-E
		stc		;set CY to show error
		mvi b,ffh	;set highest quiotient
		hlt
loopout:
		rrc		;move 1bit back to MSB
		cmc		;set CY to zero
		mvi e,0	;set Quotient to zero
		mov d,a	;save Divisor in D
		mvi a,8h	;load a with 8h
		sub c		;Minus remaing count
		inr a		;incr count by 1
		mov c,a	;save this count in c
		mov a,b	;restore dividend
	
;NFE==>No Flags Effected
loopdiv:
		cmp d		;cmp Divident with 
				;divisor
		mov b,a	;NFE:save dividend ->B
		mov a,e	;NFE:load quotient
		cmc		;complement CY	
		;quotient<<1 if Divisor<divident
		;<<0 if Divisor>divident
		ral		;insert Cary bit in 
		rrc		;restore state of CY
		rlc		;
		mov e,a	;save quitoent in E
	jnc skipdivsub   ;Divisor>Divident=>Skip
		mov a,b	;load the dividend
		sub d		;minus the divisor 
		mov b,a	;save new divident
skipdivsub:
		mov a,d	;restore divisor<== D
		rrc		;rotate divisor right
		mov d,a	;save divisor in D
		mov a,b	;load A with dividend
		dcr c
		jnz loopdiv
	mov c,b	;save remainder in C
	mov b,e	;save quotient in B
hlt

