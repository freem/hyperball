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
		
	else
	
flag_VBlank: ds.b 1 ; (byte) vblank flag
flag_HBlank: ds.b 1 ; (byte) hblank flag
_else_     : ds.b 1 ; (byte) temp var for else macro
MEM_STDCTRL: ds.b $20 ; (byte) joypad 1&2 (1 down , 2 down stop, 3 up)

	endif

