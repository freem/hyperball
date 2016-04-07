if_eq	macro		
	beq	L1\@!
endm

if_ne	macro		
	bne	L1\@!
endm

if_pl	macro		
	bpl	L1\@!
endm

if_mi	macro		
	bmi	L1\@!
endm

if_le	macro		
	ble	L1\@!
endm

if_ge	macro		
	bge	L1\@!
endm
	
endi	macro		
	L1\@@:
endm

endie	macro		
	L1\@@:
	clr.b _else_
endm


else_	macro
	
	move.b #1,_else_
	L1\@@:
	
	
	cmp.b #0,_else_
	bne	L1\@!
endm



while	macro		
	jmp	L1\@@
endm
	
do	macro		
	L1\@!:
endm

while_eq	macro		
	beq	L1\@@
endm

while_ne	macro		
	bne	L1\@@
endm

while_pl	macro		
	bpl	L1\@@
endm

while_mi	macro		
	bmi	L1\@@
endm

while_ge	macro		
	bge	L1\@@
endm

while_le	macro		
	ble	L1\@@
endm



while_dbra	macro		
	dbra.w \1,L1\@@
endm


_A	= 0
_B 	= 1
_C 	= 2
_D 	= 3
_UP	= 4
_DOWN	= 5
_LEFT	= 6
_RIGHT	= 7

endVBlank	macro	


	; check if the BIOS wants to run its vblank
	btst  #7,BIOS_SYSTEM_MODE
	if_ne
		; run BIOS vblank
		jmp   SYSTEM_INT1
	endi

	;-----------------------;

	movem.l d0-d7/a0-a6,-(sp) ; save registers
	move.w  #4,LSPC_IRQ_ACK   ; acknowledge the vblank interrupt
	move.b  d0,REG_DIPSW      ; kick the watchdog


	jsr     SYSTEM_IO         ; "Call SYSTEM_IO every 1/60 second."
	clr.b  flag_VBlank    ; clear vblank flag so waitVBlank knows to stop
	movem.l (sp)+,d0-d7/a0-a6 ; restore registers	
    
endm

waitVBlank	macro	

	move.b #1,flag_VBlank

	do
		tst.b	flag_VBlank
	while_ne

endm
