			INT	PLACE
			LONG	HOLDER
			LXID	#d123 ;SET DE TO 8005
			LXIB	0002	;SET BC TO 0200
			MVIH	#o38	;SET H TO A
LOOP1:	LDAXB			;A = (BC)
			STAXD			;(DE) = A
			INXD			;DE++
			INXB			;BC++
			DCRH			;H--
			JNZ	LOOP1

			MVIA	B4
			OUT	03		;LOAD PORT C WITH B4
			MVIA	05
			OUT	03		;LOAD PORT C WITH 05

			LONG	JOHN
LOOP2:	IN		02		;READ STATUS OF INTERFACE
			CPI	27		;IF IT IS NOT 27 THEN STAY IN LOOP2
			JNZ	LOOP2

			LHLD	JOHN
			IN		00		;READ COMPUTER INPUT INTO A
			LXID	3602	;LOAD DE WITH ADDRESS OF THE FUNCTION TABLE
			STA	HOLDER
			MVIH	00		;LOAD H WITH 00
			ADDA			;A = A*2
			MOVLA			;L = A
			LDA	PLACE
			DADD			;HL = HL + DE
			XCHG			;DE = HL
			LHL			;HL = (DE)
			PCHL			;JUMP TO (HL)



