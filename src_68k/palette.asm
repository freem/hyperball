; Palette Functions
;==============================================================================;
; todo: palette buffer stuff (palette RAM should be updated during vblank)

;==============================================================================;
; palmac_PalBufIndex
; Internal macro for calculating the palette buffer index.

; Trashes: d5, d4

; (Params)
; d7     Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)

; (Returns)
; a0     Location in palette buffer

palmac_PalBufIndex: macro
	; d5 = (d7 & $FF00)>>3) (palette set number)
	move.w d7,d5
	andi.w #$FF00,d5     ; d7 & $FF00
	lsr.w #3,d5 ; d7 >> 3

	; d4 = d7 & $0F (index inside of palette set)
	move.w d7,d4
	andi.w #$0F,d4
	add.w d4,d5 ; add palette set and palette index

	addi.l #PaletteBuffer,d5 ; add palette buffer location
	movea.l d5,a0 ; palette buffer location in a0

	endm

;==============================================================================;
; palmac_ColorRGBD
; A macro for placing an RGB (0-31) value (with dark bit) in the binary.

; (Params)
; \1     [byte] Red value   ($00-$1F; 0-31)
; \2     [byte] Green value ($00-$1F; 0-31)
; \3     [byte] Blue value  ($00-$1F; 0-31)
; \4     [byte] Dark bit    (0 or 1; subtracts RGB by 1 if enabled)

palmac_ColorRGBD: macro
	dc.w ((\4&1)<<15)|((\1&1)<<14)|((\2&1)<<13)|((\3&1)<<12)|(((\1&$1E)>>1)<<8)|(((\2&$1E)>>1)<<4)|((\3&$1E)>>1)
	endm

;==============================================================================;
; pal_LoadData
; Load raw color data into the palette RAM.

; (Params)
; d7     Number of color entries-1 (loop counter)
; a0     Address to load palette data from
; a1     Beginning palette address to load data into ($400000-$401FFE)

pal_LoadData:
	move.w (a0)+,(a1)+
	dbra d7,pal_LoadData
	rts

;------------------------------------------------------------------------------;
; palmac_LoadData
; For extremely lazy people. \1 through \3 are the same params as pal_LoadData.

palmac_LoadData: macro
	move.l #\1,d7
	lea \2,a0
	lea \3,a1
	jsr pal_LoadData
	endm
