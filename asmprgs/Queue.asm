;Queue Library
;Implements a Queue storage a user
;define area and of selected size
;(c) Vaibhav Jain
;date: 15/4/04
;*******************************
lxi sp,ffffh    ;init stack
lxi h ,2000h    ;storage area
mvi c,0Ah       ;the storage size will provide only 9
call Queinit    ;Init the queue
xra a           ;set acc to 0
mov c,a
loop:
        inr a
        inr a
        inr c
        call Quepush; push Acc in queue
        jnc loop; loop until error is signalled

        xra a;
	mov c,a;
        lxi h,array2; load address of array2
loop2:  call Quepop     ; fetch data in Acc
        jc  exit        ;if error signalled then exit
        mov m,a         ;save it in array2
        inx h
        inr c
        jmp loop2

exit:   hlt             ;exit
;*************Queue Library********
;**********************************
;*******Queue Local Variables******
quelimit:       db 00h  ;max length of queue
quetop:         db 00h  ;top of the queue
quebottom:      db 00h  ;bottom of the queue
queaddress:     dw 00h  ;address of queue
;**********************************
;**********Queue Init*************
;Initializes the Queue with give data
;Input : H-L : Storage Address
;        C   : No. of elements        
;!!!Caution!!! Actual storage available is 1byte less
;Modifies: Nothing
;*********************************
Queinit:
        push psw        ;save Acc and Flags
        mov a,c         ;copy count to Acc
        sta quelimit    ;copy to memory variable
        shld queaddress ;copy stack address to variable
        xra a           ;set Acc to zero
        sta quetop      ;set top=0
        sta quebottom   ;set bottom=0;
        pop psw         ;restore acc and flags
        ret             ;stack is now intialized
;*******************************
;**********Queue Pop*************
;Pop an element from the Queue 
;Input : nothing
;Modifies: Acc: containts poped element
;           Cy: in case of Queue Underflow
;*********************************
Quepop:
        push b          ;save B-C pair
        mov c,a         ;save contents of A in C
        lda quebottom   ;get the Queue Bottom Index
        mov b,a         ;copy it to B
        lda quetop      ;get the Queue Top index
        cmp b           ;compare Top to Bottom
        jnz Quepopc2    ;Are they Equal?
        mov a,c         ;restore previous contents of A
        pop b           ;this is the underflow error
        stc             ;set Cy to indicate Error
        ret             ;Bye-Bye Sweet Heart!!!
Quepopc2:
        mov b,a         ;save top-count in B
        push h          ;save h-l pair
        lhld queaddress ;get the storage address in H-L
        add l           ;add this index to Lower Queue Address
        mov l,a         ;save this back to L
        jnc Quepopnc3   ;if nocarry skip these steps
        inr h           ;add this carry bit to H
Quepopnc3:
        lda quelimit    ;get the queue length
        inr b           ;increment value of top
        cmp b           ;Is top=Queue Length
        mov a,b         ;NFC==> new top copied to Acc
        jnz Quepopne3   ;if not skip following steps
        xra a           ;set new top to zero
Quepopne3:
        sta quetop      ;copy new queue top to mem-var
        mov a,m         ;get the poped data from memory
        pop h           ;restore h-l pair
        pop b           ;restore b-c pair
        ret             ;job is done Have a nice execution
;*******************************
;**********Queue Push*************
;Pushes an element into the Queue 
;Input : Acc: data to push
;Modifies: Cy: in case of Queue Overflow
;*********************************
Quepush:
        push b          ;save B-C pair
        push h          ;save H-L pair
        mov c,a         ;save push data in C
        lda quebottom   ;get the Queue Bottom Index
        mov b,a         ;copy bottom to B saved
        lhld queaddress ;load the Queue Address
        add l           ;add Bottom index to L
        mov l,a         ;NFC==>copy this address to L
        jnc  Quepushnc1  ;if no carry from addition SKIP
        inr h           ;add this carry bit to H
Quepushnc1:              ;address of bottom is in H-L
        inr b           ;to new value of bottom
        lda quelimit    ;get the queue size
        cmp b           ;if botttom=queuesize
        jnz Quepushne2 ;SKIP if bottom!=size
        mvi b,0         ;set new bottom to 0
Quepushne2:
        lda quetop      ;get the queue top
        cmp b           ;if new bottom=top
        jnz Quepushne3  ;SKIP if equal
        ;//The Queue has Over Flown RUN!!!!!
        mov a,c         ;restore push data back
        pop h           ;restore H-L pair
        pop b           ;restore B-C pair
        stc             ;signal Queue Overflow
        ret             ;What a bad day- to Home
Quepushne3:
        mov a,b         ;copy new bottom to Acc
        sta quebottom   ;store it to mem-var
        mov a,c         ;restore push data to acc
        mov m,a         ;save Quity-Quity to memory 
        pop h           ;restore H-L pair
        pop b           ;restore B-C pair
        ora a           ;reset the CY flag
        ret             ;job is done Return home
;*******************************
;*******************************
org 2000h
array: dw 0000h;  Array of 10 bytes for queue  
      dw 0000h;  
      dw 0000h;	 
       dw 0000h;     
   dw 0000h;
org 2010h
array2: dw 0000;  Array of 9 bytes for data       
	dw 00; 
       dw 00; 
       dw 00; 
       db 00;  