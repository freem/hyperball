; Software Dipswitch Settings (view as UTF8)
;==============================================================================;
; setting up the soft dip (Japan)
softDips_Japan:
	; Game Name (16 chars)
	dc.b	"HYPER BALL      "
	dc.w	$FFFF				; Special Option 1 (time 1)
	dc.w	$FFFF				; Special Option 2 (time 2)
	dc.b	$FF					; Special Option 3 (01-99)
	dc.b	$FF					; Special Option 4 (00-99, without, infinite)
	; Options
	dc.b	$01					; Option 1: 1 choice, default #0
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00	; filler
	;---------------------------;
			;------------;
	dc.b	"Options Todo"		; Option 1 description
	dc.b	"Default     "		; Option choices
			;------------;
	;---------------------------;

;==============================================================================;
; setting up the soft dip (USA)
softDips_USA:
	dc.b	"HYPER BALL      "	; Game Name
	dc.w	$FFFF				; Special Option 1 (time 1)
	dc.w	$FFFF				; Special Option 2 (time 2)
	dc.b	$FF					; Special Option 3 (01-99)
	dc.b	$FF					; Special Option 4 (00-99, without, infinite)
	; Options
	dc.b	$01					; Option 1: 1 choice, default #0
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00	; filler
	;---------------------------;
			;------------;
	dc.b	"Options Todo"		; Option 1 description
	dc.b	"Default     "		; Option choices
			;------------;
	;---------------------------;

;==============================================================================;
; setting up the soft dip (Europe)
softDips_Europe:
	dc.b	"HYPER BALL      "	; Game Name
	dc.w	$FFFF				; Special Option 1 (time 1)
	dc.w	$FFFF				; Special Option 2 (time 2)
	dc.b	$FF					; Special Option 3 (01-99)
	dc.b	$FF					; Special Option 4 (00-99, without, infinite)
	; Options
	dc.b	$01					; Option 1: 1 choice, default #0
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00	; filler
	;---------------------------;
			;------------;
	dc.b	"Options Todo"		; Option 1 description
	dc.b	"Default     "		; Option choices
			;------------;
	;---------------------------;
