; Palette Data
;==============================================================================;
; default Fix layer font palette
pal_DefaultFix:
	dc.w $8000 ; reference black
	palmac_ColorRGBD $1F,$1F,$1F,0 ; white (main text)
	palmac_ColorRGBD $00,$00,$00,0 ; black (shadow)
	; unused
	dc.w $0000
	dc.w $0000
	dc.w $0000
	dc.w $0000
	dc.w $0000
	dc.w $0000
	dc.w $0000
	dc.w $0000
	dc.w $0000
	dc.w $0000
	dc.w $0000
	dc.w $0000
	dc.w $0000

;------------------------------------------------------------------------------;
; Test court palette data
pal_TestCourt:
	dc.w $0000 ; transparent
	palmac_ColorRGBD $06,$02,$00,0 ; 06 02 00
	palmac_ColorRGBD $06,$06,$06,0 ; 06 06 06
	palmac_ColorRGBD $05,$08,$0D,0 ; 05 08 0D
	palmac_ColorRGBD $0C,$04,$00,0 ; 0C 04 00
	palmac_ColorRGBD $0A,$0A,$0A,0 ; 0A 0A 0A
	palmac_ColorRGBD $09,$0E,$13,0 ; 09 0E 13
	palmac_ColorRGBD $0C,$13,$19,0 ; 0C 13 19
	palmac_ColorRGBD $10,$06,$00,0 ; 10 06 00
	palmac_ColorRGBD $13,$07,$00,0 ; 13 07 00
	palmac_ColorRGBD $1F,$13,$0C,0 ; 1F 13 0C
	palmac_ColorRGBD $10,$10,$10,0 ; 10 10 10
	palmac_ColorRGBD $1F,$19,$15,0 ; 1F 19 15
	palmac_ColorRGBD $18,$18,$18,0 ; 18 18 18
	palmac_ColorRGBD $1F,$1F,$1F,0 ; 1F 1F 1F
	palmac_ColorRGBD $00,$00,$00,0 ; 00 00 00
