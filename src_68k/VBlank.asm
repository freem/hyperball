
;==============================================================================;
; VBlank
; VBlank interrupt, run things we want to do every frame.

VBlank:



	jsr Joypad
	
	endVBlank
	rte

;==============================================================================;
; IRQ2
; Level 2/timer interrupt, unused here. You could use it for effects, though.

IRQ2:
	move.w #2,LSPC_IRQ_ACK ; ack. interrupt #2 (HBlank)
	move.b d0,REG_DIPSW    ; kick watchdog
	rte

;==============================================================================;
; IRQ3
; Level 3 IRQ, unused here. Might be used for something else on CD, though.
; (More research needed)

IRQ3:
	move.w #1,LSPC_IRQ_ACK ; acknowledge interrupt 3
	move.b d0,REG_DIPSW    ; kick watchdog
	rte

;==============================================================================;
; WaitVBlank
; Waits for VBlank to finish (via a flag cleared at the end).

WaitVBlank:

	move.b #1,flag_VBlank

	do
		tst.b	flag_VBlank
	while_ne

	rts
