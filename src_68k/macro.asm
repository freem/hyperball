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

Init_NeoGeo	macro	

	move.b d0,REG_DIPSW    ; kick watchdog
	lea    BIOS_WORKRAM,sp ; set stack pointer to BIOS_WORKRAM
	move.w #0,LSPC_MODE    ; Disable auto-animation, timer interrupts, set auto-anim speed to 0 frames
	move.w #7,LSPC_IRQ_ACK ; ack. all IRQs
	
	move.w #1,LSPC_INCR 
	

endm


joypad_event macro
	move.b \3,d0
	and.b #\1,d0
	cmp.b #\1,d0
	if_ne
		clr.b MEM_STDCTRL+\2
	endi
	
	
	if_eq
		move.b MEM_STDCTRL+\2,d0
		cmp.b #$00,d0
		if_eq
			move.b #2,MEM_STDCTRL+\2
		else_
			move.b #1,MEM_STDCTRL+\2
		endie
	endi
endm

Text_Draw macro ;

    move.w  #FIXMAP+$22+(\1*$20)+\2,d1
    
   	move.l	#\3,a0

	do
		move.w  d1,LSPC_ADDR
		
		clr.w 	d0
		move.b 	(a0)+,d0
		move.w 	d0,d2
		add.w	#$0321,d0
		sub.w	#'!',d0
		move.w  d0,LSPC_DATA
		
		add.w	#$20,d1
		
		
		cmp.w  #$00,d2
	while_ne
	
endm

Load_Palette macro ;adresse rom,adresse palette,nbr palette
	lea     \1,a0       
    lea     PALETTES+(32*\2),a1
    
    move    #(16*\3),d7
	do
		move.w  (a0)+,(a1)+
	while_dbra d7

endm

Clear_Ram macro ; structure

	move.l    #RAMSTART,a0 
	move.l    #$8000,d7
	do
		move.b  #$00,(a0)+
	while_dbra d7
	
endm
