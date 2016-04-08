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
		
	else
	
flag_VBlank: ds.b 1 ; (byte) vblank flag
flag_HBlank: ds.b 1 ; (byte) hblank flag
_else_     : ds.b 1 ; (byte) temp var for else macro
ram0004:     ds.b 1 ; (byte) currently unused; here for alignment

MEM_STDCTRL: ds.b $20 ; (32 byte) joypad 1&2 (1 down , 2 down stop, 3 up)


BG1_struct : ds.b $30 ; struct for BG1
BG2_struct : ds.b $30 ; struct for BG2

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
_scrolld0	=	$12	;2 bytes
_scrolla0	=	$14	;4 bytes
_scrolld1	=	$18	;2 bytes
_scrolla1	=	$1A	;4 bytes
_scrollaxe	=	$1E	;1 bytes

;for Sprite
_anim 		= 	$12	;2 bytes
_animi 		= 	$12	;2 bytes
_animl 		= 	$14 ;2 bytes
_animact	=	$16	;2 bytes
_animactold	=	$18	;2 bytes
_animn		=	$1A	;2 bytes
_animv		=	$1C	;2 bytes
_animout	=	$1E	;2 bytes
_animend	=	$20	;2 bytes

_px			=	$22	;2 bytes
_py			=	$24	;2 bytes
_tileext	=	$26	;2 bytes
_pitch		=	$28	;2 bytes
_address	=	$2C	;4 bytes
