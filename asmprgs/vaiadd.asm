;Addtion Without Add Instruction
;******************************
;implements a new Addition Algorithm
;discovered by Vaibhav Jain
;(c) Vaibhav Jain
;**************************	
mvi b,10h	;add operand1
mvi c,eeh	;add operand2

call AddBC ;addtion result is in B
hlt		; result is B=8B

AddBC:
	mov a,c	;copy c to acc
	ora a		;is c=zero
	rz		;is zero than return
	
	ana b		;bit wise And to b
	rlc		;rotate it to left
	mov d,a	;save result in d
	mov a,c	;copy C to a
	xra b		;bitwise Xor it to B
	mov b,a	;save result in B
	mov c,d	;copy And+Rot result to c
	call AddBC	;call it recursively
	ret
