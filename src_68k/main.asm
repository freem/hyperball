; code name HYPER BALL | 68K code

;==============================================================================;
	include "include/neogeo.inc"   ; Neo-Geo Hardware and System ROM definitions
	include "include/ram_bios.inc" ; BIOS RAM locations
	include "include/input.inc"    ; Input defines

	include "ram_user.inc" ; user RAM

	include "macro.asm" ; 
;==============================================================================;
	include "header_68k.inc" ; 68000 header
;==============================================================================;

	ifd ENABLE_SECTION
		
	else
		section code
	endif
	
	
	
	

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
Reset:
	move.b d0,REG_DIPSW    ; kick watchdog
	lea    BIOS_WORKRAM,sp ; set stack pointer to BIOS_WORKRAM
	move.w #0,LSPC_MODE    ; Disable auto-animation, timer interrupts, set auto-anim speed to 0 frames
	move.w #7,LSPC_IRQ_ACK ; ack. all IRQs
	
	
	jsr clear_fix
	
	move.w  #$8fff,PALETTE_BACKDROP

	move.w #$2000,sr ; Enable VBlank interrupt, go Supervisor

	; todo: handle user request
Gameloop:
	

	jsr WaitVBlank
	jmp Gameloop

clear_fix:
	
	move.w  #FIXMAP,LSPC_ADDR
    move.l  #$4F0,d0
	do
		move.w  #$00FF,LSPC_DATA
    while_dbra d0

	rts
	
	include "mvs.asm"
	include "VBlank.asm" ; VBlank and IRQ code
	
