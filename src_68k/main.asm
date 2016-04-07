; code name HYPER BALL | 68K code
;==============================================================================;
	include "include/neogeo.inc"   ; Neo-Geo Hardware and System ROM definitions
	include "include/ram_bios.inc" ; BIOS RAM locations
	include "include/input.inc"    ; Input defines

	include "ram_user.inc" ; user RAM
;==============================================================================;
	include "header_68k.inc" ; 68000 header
;==============================================================================;
	section code

	ifd TARGET_CD
		include "header_cd.inc"
	else
		include "header_cart.inc"
	endif

	include "softdips.inc"

;==============================================================================;
; todo: actual versions of the standard routines required by the bios
; (e.g. USER, PLAYER_START, DEMO_END, COIN_SOUND)

;==============================================================================;
USER:
	move.b d0,REG_DIPSW    ; kick watchdog
	lea    BIOS_WORKRAM,sp ; set stack pointer to BIOS_WORKRAM
	move.w #0,LSPC_MODE    ; Disable auto-animation, timer interrupts, set auto-anim speed to 0 frames
	move.w #7,LSPC_IRQ_ACK ; ack. all IRQs

	move.w #$2000,sr ; Enable VBlank interrupt, go Supervisor

	; todo: handle user request
.why:
	move.b d0,REG_DIPSW ; kick watchdog
	bra    .why

;==============================================================================;
; PLAYER_START
; Called by the BIOS if one of the Start buttons is pressed while the player
; has enough credits (or if the the time runs out on the title menu?).
; We're not using this in this demo.

PLAYER_START:
	move.b d0,REG_DIPSW ; kick the watchdog
	rts

;==============================================================================;
; DEMO_END
; Called by the BIOS when the Select button is pressed; ends the demo early.

DEMO_END:
	; if necessary, store any items in the (MVS) backup RAM.
	rts

;==============================================================================;
; COIN_SOUND
; Called by the BIOS when a coin is inserted; should play a coin drop sound.
; We don't actually do anything here since this isn't meant to take coins.

COIN_SOUND:
	; Send a sound code
	rts

;==============================================================================;
; VBlank
; VBlank interrupt, run things we want to do every frame.

VBlank:
	; check if the BIOS wants to run its vblank
	btst  #7,BIOS_SYSTEM_MODE
	bne   .gamevbl
	; run BIOS vblank
	jmp   SYSTEM_INT1

	;-----------------------;
.gamevbl:
	movem.l d0-d7/a0-a6,-(sp) ; save registers
	move.w  #4,LSPC_IRQ_ACK   ; acknowledge the vblank interrupt
	move.b  d0,REG_DIPSW      ; kick the watchdog

.endvbl
	jsr     SYSTEM_IO         ; "Call SYSTEM_IO every 1/60 second."
	move.b  #0,flag_VBlank    ; clear vblank flag so waitVBlank knows to stop
	movem.l (sp)+,d0-d7/a0-a6 ; restore registers
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

.waitLoop
	tst.b flag_VBlank
	bne.s .waitLoop 

	rts
