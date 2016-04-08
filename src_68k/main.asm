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
	
	
;ID & Info
BG1_id  = 1
BG1_w   = 32
BG1_h   = 32

BG2_id  = 33
BG2_w   = 32
BG2_h   = 32

SCORE_id  = 65
SCORE_w   = 02
SCORE_h   = 02

;==============================================================================;
; todo: actual versions of the standard routines required by the bios
; (e.g. USER, PLAYER_START, DEMO_END, COIN_SOUND)

;==============================================================================;
Reset:

	
	Init_NeoGeo
	
	jsr clear_fix
	Text_Draw 2,3,Hello_text

	move.w  #$8fff,PALETTE_BACKDROP

	;Load Palettes
	Load_Palette pal_DefaultFix,$00,1
	Load_Palette pal_TestCourt,$01,1
	
	Load_Palette palette_tile1,$10,2
	
	Load_Palette palette_scoreboard,$30,1
	
	
	
	;Background
	Sprite_init					BG1_id,BG1_w,BG1_h,BG1_struct
	Sprite_position_ram_init 	BG1_struct,0,0
	
	Sprite_DrawBG 				BG1_struct,BG1_h,Map1
	
	;Score
	Sprite_Draw_sp SCORE_id,#$0407,#$3000
	Sprite_init_sp SCORE_id,$40,$40

	move.w #$2000,sr ; Enable VBlank interrupt, go Supervisor

	; todo: handle user request
Gameloop:


	cmpi.b 	#$02,MEM_STDCTRL+_RIGHT
	if_ne
		addi.w #$0080,BG1_struct+_x	
	endi
	
	cmpi.b 	#$02,MEM_STDCTRL+_LEFT
	if_ne
		subi.w #$0080,BG1_struct+_x	
	endi

	jsr WaitVBlank
	jmp Gameloop

;==============================================================================;
; clear_fix
; Clears the Fix layer.

clear_fix:

	move.w  #FIXMAP,LSPC_ADDR
	move.l  #$500,d0
	do
		move.w  #$00FF,LSPC_DATA
	while_dbra d0

	rts

;==============================================================================;
; Joypad
; Joypad control routine

Joypad:
	
	;J1
	joypad_event INPUT_A,$00,REG_P1CNT
	joypad_event INPUT_B,$01,REG_P1CNT
	joypad_event INPUT_C,$02,REG_P1CNT
	joypad_event INPUT_D,$03,REG_P1CNT

	joypad_event INPUT_UP,$04,REG_P1CNT
	joypad_event INPUT_DOWN,$05,REG_P1CNT
	joypad_event INPUT_LEFT,$06,REG_P1CNT
	joypad_event INPUT_RIGHT,$07,REG_P1CNT

	;J2
	joypad_event INPUT_A,$10,REG_P2CNT
	joypad_event INPUT_B,$11,REG_P2CNT
	joypad_event INPUT_C,$12,REG_P2CNT
	joypad_event INPUT_D,$13,REG_P2CNT
	
	joypad_event INPUT_UP,$14,REG_P2CNT
	joypad_event INPUT_DOWN,$15,REG_P2CNT
	joypad_event INPUT_LEFT,$16,REG_P2CNT
	joypad_event INPUT_RIGHT,$17,REG_P2CNT



	rts

	
Hello_text:
	dc.b "Hellod 2",0,0
	
palette_ng:
    dc.w $0f0f,$0eee,$0ddd,$0ccc,$0bbb,$0aaa,$0999,$0888,$010f,$0f00,$00ff,$0f0f,$0f0f,$0f0f,$0f0f,$0000
	
palette_tile1:
    dc.w $5f0f,$2930,$0333,$0310,$7fff,$0ccc,$0888,$0555,$5246,$5479,$769c,$0620,$0830,$2f96,$7fca,$0000
    
palette_tile2:
    dc.w $5f0f,$2930,$0333,$0310,$7fff,$0ccc,$0888,$0555,$5246,$5479,$769c,$7fca,$0830,$2f96,$0620,$0000

palette_scoreboard:
    dc.w $5f0f,$0333,$0555,$0888,$2f96,$7fca,$0ccc,$7fff,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000



;==============================================================================;

	include "mvs.asm"
	include "VBlank.asm"  ; VBlank and IRQ code
	include "palette.asm" ; palette related code

;==============================================================================;
	include "paldata.inc" ; game palette data
	
	
Map1:
	include "Map/map1.sng"

	org $80000
