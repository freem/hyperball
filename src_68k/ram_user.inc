; FM Studio 68K RAM
;==============================================================================;
	ifd ENABLE_SECTION
		
	else
		section bss
	endif
;==============================================================================;
USER_RAM equ $100000 ; USER RAM (begins at $100000)
;==============================================================================;

RAMSTART        = $100000 
	ifd ENABLE_SECTION
		

flag_VBlank		= RAMSTART+$00
flag_HBlank		= RAMSTART+$01
_else_			= RAMSTART+$02

MEM_STDCTRL		= RAMSTART+$10
BG1_struct 		= RAMSTART+$30
BG2_struct 		= RAMSTART+$60
CH1_struct 		= RAMSTART+$90
CH2_struct 		= RAMSTART+$C0

BufferMap 		= RAMSTART+$100
		
	else
	
flag_VBlank: ds.b 1 ; (byte) vblank flag
flag_HBlank: ds.b 1 ; (byte) hblank flag
_else_     : ds.b 1 ; (byte) temp var for else macro
ram0004:     ds.b 1 ; (byte) currently unused; here for alignment

MEM_STDCTRL: ds.b $20 ; (32 byte) joypad 1&2 (1 down , 2 down stop, 3 up)


BG1_struct : ds.b $30 ; struct for BG1
BG2_struct : ds.b $30 ; struct for BG2
CH1_struct : ds.b $40 ; struct for CH1
BufferMap  : ds.b $80 ; Buffer for CH1

	endif

;struct :
_id			=	$00	;2 bytes
_scb1		=	$02	;2 bytes
_scb2		=	$04	;2 bytes
_scb3		=	$06	;2 bytes
_scb4		=	$08	;2 bytes
_x 			= 	$0A ;2 bytes
_y 			= 	$0C ;2 bytes
_w 			= 	$0E ;2 bytes
_h 			= 	$10 ;2 bytes

;for BG
_scrolld0	=	$20	;2 bytes
_scrolla0	=	$22	;4 bytes
_scrolld1	=	$24	;2 bytes
_scrolla1	=	$26	;4 bytes
_scrollaxe	=	$28	;1 bytes

;for Sprite
_anim 		= 	$20	;2 bytes
_animi 		= 	$20	;2 bytes
_animl 		= 	$22 ;2 bytes
_animact	=	$24	;2 bytes
_animactold	=	$26	;2 bytes
_animn		=	$28	;2 bytes
_animv		=	$2A	;2 bytes
_animout	=	$2C	;2 bytes
_animend	=	$2E	;2 bytes


_direction	=	$30	;1 bytes

_px			=	$12	;2 bytes
_py			=	$14	;2 bytes
_tileext	=	$16	;2 bytes
_pitch		=	$18	;2 bytes
_address	=	$1C	;4 bytes

