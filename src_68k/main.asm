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

	
	Init_NeoGeo
	
	jsr clear_fix
	Text_Draw 2,3,Hello_text
	
	
=======
	move.b d0,REG_DIPSW    ; kick watchdog
	lea    BIOS_WORKRAM,sp ; set stack pointer to BIOS_WORKRAM
	move.w #0,LSPC_MODE    ; Disable auto-animation, timer interrupts, set auto-anim speed to 0 frames
	move.w #7,LSPC_IRQ_ACK ; ack. all IRQs

	jsr clear_fix


	move.w  #$8fff,PALETTE_BACKDROP
	
	
	;Load Palettes
	Load_Palette palette_ng,$00,1
	
	

	move.w #$2000,sr ; Enable VBlank interrupt, go Supervisor

	; todo: handle user request
Gameloop:

	jsr WaitVBlank
	jmp Gameloop

;==============================================================================;
; clear_fix
; Clears the Fix layer.

clear_fix:

	move.w  #FIXMAP,LSPC_ADDR
	move.l  #$4F0,d0
	do
		move.w  #$00FF,LSPC_DATA
	while_dbra d0

	rts
	
Joypad:
	
	;J1
	joypad_event $10,$00,REG_P1CNT
	joypad_event $20,$01,REG_P1CNT
	joypad_event $40,$02,REG_P1CNT
	joypad_event $80,$03,REG_P1CNT
	
	joypad_event $01,$04,REG_P1CNT
	joypad_event $02,$05,REG_P1CNT
	joypad_event $04,$06,REG_P1CNT
	joypad_event $08,$07,REG_P1CNT
	
	;J2
	joypad_event $10,$10,REG_P2CNT
	joypad_event $20,$11,REG_P2CNT
	joypad_event $40,$12,REG_P2CNT
	joypad_event $80,$13,REG_P2CNT
	
	joypad_event $01,$14,REG_P2CNT
	joypad_event $02,$15,REG_P2CNT
	joypad_event $04,$16,REG_P2CNT
	joypad_event $08,$17,REG_P2CNT



	rts

	
Hello_text:
	dc.b "Hello",0
	
palette_ng:
    dc.w $0f0f,$0eee,$0ddd,$0ccc,$0bbb,$0aaa,$0999,$0888,$010f,$0f00,$00ff,$0f0f,$0f0f,$0f0f,$0f0f,$0000
	
=======

;==============================================================================;

	include "mvs.asm"
	include "VBlank.asm"  ; VBlank and IRQ code
	include "palette.asm" ; palette related code

;==============================================================================;
	include "paldata.inc" ; game palette data
