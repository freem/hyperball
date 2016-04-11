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

CH1_id 		= 100
CH1_w   	= 04
CH1_h   	= 04

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
	
	Load_Palette palette_scoreboard,$30,2
	
	
	
	;Background
	Sprite_init					BG1_id,BG1_w,BG1_h,BG1_struct
	Sprite_position_ram_init 	BG1_struct,-8,0
	
	Sprite_DrawBG 				BG1_struct,BG1_h,Map1
	
	;Score
	Sprite_Draw_sp SCORE_id,#$0407,#$3000
	Sprite_init_sp SCORE_id,$40,$40
	
	
	;Ch1
	Sprite_init					CH1_id,CH1_w,CH1_h,CH1_struct
	move.w	#$40,CH1_struct+_px
	move.w	#-$40,CH1_struct+_py
	
	
	
	move.w #$0000,CH1_struct+_animact
	move.w #$3100,CH1_struct+_tileext
	move.w #$0004,CH1_struct+_animv
	move.w #$0008,CH1_struct+_animn
	move.b #$00,CH1_struct+_direction
	
	;Sprite_Draw_sp 66,#$05E9,#$3000
	;Sprite_init_sp 66,$80,$40

	move.w #$2000,sr ; Enable VBlank interrupt, go Supervisor

	; todo: handle user request
Gameloop:

	Animation CH1_struct
	jsr Buffer_ch1
	
	move.b #$00,CH1_struct+_animact
	
	cmpi.b 	#$02,MEM_STDCTRL+_UP
	if_ne
		move.b #$01,CH1_struct+_animact
		move.b #$00,CH1_struct+_direction
		
		addi.w #$0001,CH1_struct+_py
	endi
	
	cmpi.b 	#$02,MEM_STDCTRL+_DOWN
	if_ne
		move.b #$02,CH1_struct+_animact
		subi.w #$0001,CH1_struct+_py
		move.b #$01,CH1_struct+_direction
	endi
	
	cmpi.b 	#$02,MEM_STDCTRL+_RIGHT
	if_ne
		move.b #$04,CH1_struct+_animact
		move.b #$02,CH1_struct+_direction
		addi.w #$0001,CH1_struct+_px
	endi
	
	cmpi.b 	#$02,MEM_STDCTRL+_LEFT
	if_ne
		move.b #$03,CH1_struct+_animact	
		move.b #$03,CH1_struct+_direction
		subi.w #$0001,CH1_struct+_px
	endi
	
	
	
	move.w	CH1_struct+_px,d1
	move.w	CH1_struct+_py,d2
		
	Position_Sprite_update CH1_struct,d1,d2

	jsr WaitVBlank
	jmp Gameloop
	
Buffer_ch1:
	move.w #$0000,d2
	
	cmpi.b 	#$01,CH1_struct+_direction
	if_ne
		move.w #$0120,d2
	endi
	
	cmpi.b 	#$02,CH1_struct+_direction
	if_ne
		move.w #$1B0,d2
	endi
	
	cmpi.b 	#$03,CH1_struct+_direction
	if_ne
		move.w #$90,d2
	endi
	
	

	cmpi.b 	#$00,CH1_struct+_animact
	if_ne
		move.w #0,CH1_struct+_animi
		move.w #0,CH1_struct+_animl
		
		move.w #$0000,CH1_struct+_animv
		move.w #$0000,CH1_struct+_animn
	endi
	
	cmpi.b 	#$01,CH1_struct+_animact
	if_ne
		move.w #$0004,d2
		move.w #$0004,CH1_struct+_animv
		move.w #$0008,CH1_struct+_animn
	endi
	
	cmpi.b 	#$02,CH1_struct+_animact
	if_ne
		move.w #$0124,d2
		move.w #$0004,CH1_struct+_animv
		move.w #$0008,CH1_struct+_animn
	endi
	
	cmpi.b 	#$03,CH1_struct+_animact
	if_ne
		move.w #$0094,d2
		move.w #$0004,CH1_struct+_animv
		move.w #$0008,CH1_struct+_animn
	endi
	
	cmpi.b 	#$04,CH1_struct+_animact
	if_ne
		move.w #$01B4,d2
		move.w #$0004,CH1_struct+_animv
		move.w #$0008,CH1_struct+_animn
	endi
	
	

	move.w CH1_struct+_animi,d1
	lsl #2,d1
	add.w d2,d1
	
	move.l #BufferMap,a1
	
	move.w #$05e8+0,d0
	add.w d1,d0
	move.w d0,(a1)+
	move.w #$060C+0,d0
	add.w d1,d0
	move.w d0,(a1)+
	move.w #$0630+0,d0
	add.w d1,d0
	move.w d0,(a1)+
	move.w #$0654+0,d0
	add.w d1,d0
	move.w d0,(a1)+
	
	move.w #$05e8+1,d0
	add.w d1,d0
	move.w d0,(a1)+
	move.w #$060C+1,d0
	add.w d1,d0
	move.w d0,(a1)+
	move.w #$0630+1,d0
	add.w d1,d0
	move.w d0,(a1)+
	move.w #$0654+1,d0
	add.w d1,d0
	move.w d0,(a1)+
	
	move.w #$05e8+2,d0
	add.w d1,d0
	move.w d0,(a1)+
	move.w #$060C+2,d0
	add.w d1,d0
	move.w d0,(a1)+
	move.w #$0630+2,d0
	add.w d1,d0
	move.w d0,(a1)+
	move.w #$0654+2,d0
	add.w d1,d0
	move.w d0,(a1)+
	
	
	move.w #$05e8+3,d0
	add.w d1,d0
	move.w d0,(a1)+
	move.w #$060C+3,d0
	add.w d1,d0
	move.w d0,(a1)+
	move.w #$0630+3,d0
	add.w d1,d0
	move.w d0,(a1)+
	move.w #$0654+3,d0
	add.w d1,d0
	move.w d0,(a1)+
	

	rts
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
	
Animation:

	cmp.w d4,d5
	if_eq
		clr.w	(a0)
		clr.w	(a1)
		move.w	d4,(a2)
		
		clr.w	d2
		clr.w	d3
	endi

	addi.w #1,(a0)
	cmp.w d0,d2
	if_ne
		clr.w (a0)
		addi.w #1,(a1)
		addi.w #1,d3
	endi
	
	clr.w (a3)
	cmp.w d1,d3
	if_ne
		clr.w (a0)
		clr.w (a1)
		move.w	#1,(a3)
	endi

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

palette_ch1:
    dc.w $5f0f,$0a55,$2fa5,$7ffa,$0555,$2aa5,$0500,$0550,$7aaa,$7fff,$75af,$75aa,$0055,$0000,$0000,$0000


;==============================================================================;

	include "mvs.asm"
	include "VBlank.asm"  ; VBlank and IRQ code
	include "palette.asm" ; palette related code

;==============================================================================;
	include "paldata.inc" ; game palette data
	
	
Map1:
	include "Map/map1.sng"

	;org $80000
