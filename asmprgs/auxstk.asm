;Auxilarry stack Library
;Provides byte storing stack
;stack can be placed on any position in memory
;and of any length
;(c) Vaibhav Jain
;date: 15/4/04
;************************
lxi sp,ffffh    ;initialize processor stack
lxi h,Array1     ;load stack storage address
mvi c,09h        ;load byte count
call Stkinit    ;initialize the stack
xra a
mov c,a
loop:   inr a
        inr c
	call Stkpush; push the data in stack
        jnc loop    ;push data untill stack overflow

mvi c,00h
lxi h,Array2
dcx h

loop2: 	inx h
       	inr c
       	call Stkpop  ; get the data back from stack
	mov m,a
	jnc loop2	;pop untill stack underflow
hlt
;****************************************
;************Auxillary Stack Library*****
;Local Data
;relocate to suitable RAM Location
stkcount:       db 00   ;count of current data
stklimit:       db 00   ;max elements
stkaddress:     dw 0000 ;stack address
;
;*********Initialize Stack**********
;initializes the stack
;Input: c= no. of byte of stack
;       H-L=address of stack memory
;destroys: nothing
;***********************************
Stkinit:
        push psw
        xra a           ;set a to zero
        sta stkcount    ;store counter in count
        mov a,c
        sta stklimit
        shld stkaddress
        pop psw
        ret
;
;*********Pop Stack data**********
;pop a byte from stack to Accumulator
;Input: nothing
;modifies: Acc with poped data
;          CY is set if stack is empty
;***********************************
Stkpop:
        lda stkcount    ;load stack counter
        ora a           ;check if zero
        jnz Stkpop_c1
        stc             ;set CY to indicate error
        ret
Stkpop_c1:
        push h          ;save hl pair
        lhld stkaddress ;load address of stack
        dcx h           ;decrement stack top address
        dcr a           ;decrement stack counter
        sta stkcount    ;save new stack counter
        shld stkaddress ;save new stack top
        mov a,m         ;get data to pop
        pop h           ;restore h-l pair
        ret
;        
;*********Push data in Stack**********
;push a byte in stack from Accumulator
;Input: Acc with data
;modifies: CY is set if stack is full
;************************************
Stkpush: push b         ; save B-C pair
         mov b,a        ; save the push data
         lda stkcount   ; load stack counter
         mov c,a        ; copy it to C
         lda stklimit   ; get max limit
         cmp c          ; compair it to C i.e counter
         jnz Stkpush_c1 ; if count != maxlimit jump
         mov a,b        ; restore the data in Acc
         pop b          ; restore B-C pair
         stc            ; Signal Error
         ret            ; return
Stkpush_c1:
        inr c           ;increment counter
        mov a,c         ;copy it to acc
        sta stkcount    ;save new counter
        push h          ;save h-l pair
        mov a,b         ;get push data from B
        lhld stkaddress ;get stack address
        mov m,a         ;copy the data to stack
        inx h           ;increment to new stack location
        shld stkaddress ;save new stack top
        pop h           ;restore the h-l pair
        pop b           ;restore the b-c pair
        ret             ; job done OK bye
;**************************************************
;**************************************************
org 2000h
Array1:	db 00h	; Storage for stack
	db 00h
	db 00h
	db 00h
	db 00h
	db 00h
	db 00h
	db 00h
	db 00h

Array2:	db 00h	; Storage for Array
	db 00h
	db 00h
	db 00h
	db 00h
	db 00h
	db 00h
	db 00h
	db 00h

        
