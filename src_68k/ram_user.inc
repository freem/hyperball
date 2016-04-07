; FM Studio 68K RAM
;==============================================================================;
	ifd ENABLE_SECTION
		
	else
		section bss
	endif
;==============================================================================;
USER_RAM equ $100000 ; USER RAM (begins at $100000)
;==============================================================================;

	ifd ENABLE_SECTION
		
RAMSTART        = $100000 
flag_VBlank		= RAMSTART+$00
flag_HBlank		= RAMSTART+$01
		
	else
	
flag_VBlank: ds.b 1 ; (byte) vblank flag
flag_HBlank: ds.b 1 ; (byte) hblank flag

	endif

