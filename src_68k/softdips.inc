; Software Dipswitch Settings (view as UTF8)
;==============================================================================;
; setting up the soft dip (Japan)
softDips_Japan:
	; Game Name (16 chars)
	dc.b	"HANDBALL CHAMP. "
	dc.w	$FFFF				; Special Option 1 (time 1)
	dc.w	$FFFF				; Special Option 2 (time 2)
	dc.b	$FF					; Special Option 3 (01-99)
	dc.b	$FF					; Special Option 4 (00-99, without, infinite)
	; Options
	dc.b	$38	; Option 1: Difficulty (8 choices, default #3)
	dc.b	$03	; Option 2: Round Time (3 choices, default #0)
	dc.b	$28	; Option 3: Match Points (8 choices, default #2)
	dc.b	$28	; Option 4: VS Points (8 choices, default #2)
	dc.b	$02	; Option 5: Continue (2 choices, default #0)
	dc.b	$02	; Option 6: Show Level (2 choices, default #0)
	dc.b	$02	; Option 7: Show Credits (2 choices, default #0)
	dc.b	$02	; Option 8: Demo Sound (2 choices, default #0)
	dc.b	$00	; Option 9: unused in USA and Japan configurations
	dc.b	$00	; Option 10: unused in all configurations
	;---------------------------;
			;------------;
	dc.b	"DIFFICULTY  "		; Option 1 description
	dc.b	"LEVEL 1     "		; Option choices
	dc.b	"LEVEL 2     "
	dc.b	"LEVEL 3     "
	dc.b	"LEVEL 4     "
	dc.b	"LEVEL 5     "
	dc.b	"LEVEL 6     "
	dc.b	"LEVEL 7     "
	dc.b	"LEVEL 8     "
			;------------;
	dc.b	"ROUND TIME  "		; Option 2 description
	dc.b	"30 SECONDS  "		; Option 2 choices
	dc.b	"45 SECONDS  "
	dc.b	"60 SECONDS  "
			;------------;
	dc.b	"MATCH POINTS"		; Option 3 description
	dc.b	"8 POINTS    "		; Option 3 choices
	dc.b	"9 POINTS    "
	dc.b	"10 POINTS   "
	dc.b	"11 POINTS   "
	dc.b	"12 POINTS   "
	dc.b	"13 POINTS   "
	dc.b	"14 POINTS   "
	dc.b	"15 POINTS   "
			;------------;
	dc.b	"VS POINTS   "		; Option 4 description
	dc.b	"8 POINTS    "		; Option 4 choices
	dc.b	"9 POINTS    "
	dc.b	"10 POINTS   "
	dc.b	"11 POINTS   "
	dc.b	"12 POINTS   "
	dc.b	"13 POINTS   "
	dc.b	"14 POINTS   "
	dc.b	"15 POINTS   "
			;------------;
	dc.b	"CONTINUE    "		; Option 5 description
	dc.b	"YES         "		; Option 5 choices
	dc.b	"NO          "
			;------------;
	dc.b	"SHOW LEVEL  "		; Option 6 description
	dc.b	"YES         "		; Option 6 choices
	dc.b	"NO          "
			;------------;
	dc.b	"SHOW CREDITS"		; Option 7 description
	dc.b	"YES         "		; Option 7 choices
	dc.b	"NO          "
			;------------;
	dc.b	"DEMO SOUND  "		; Option 8 description
	dc.b	"YES         "		; Option 8 choices
	dc.b	"NO          "
			;------------;
	;---------------------------;

;==============================================================================;
; setting up the soft dip (USA)
softDips_USA:
	dc.b	"Handball Champ. "	; Game Name
	dc.w	$FFFF				; Special Option 1 (time 1)
	dc.w	$FFFF				; Special Option 2 (time 2)
	dc.b	$FF					; Special Option 3 (01-99)
	dc.b	$FF					; Special Option 4 (00-99, without, infinite)
	; Options
	dc.b	$38	; Option 1: Difficulty (8 choices, default #3)
	dc.b	$03	; Option 2: Round Time (3 choices, default #0)
	dc.b	$28	; Option 3: Match Points (8 choices, default #2)
	dc.b	$28	; Option 4: VS Points (8 choices, default #2)
	dc.b	$02	; Option 5: Continue (2 choices, default #0)
	dc.b	$02	; Option 6: Show Level (2 choices, default #0)
	dc.b	$02	; Option 7: Show Credits (2 choices, default #0)
	dc.b	$02	; Option 8: Demo Sound (2 choices, default #0)
	dc.b	$00	; Option 9: unused in USA and Japan configurations
	dc.b	$00	; Option 10: unused in all configurations
	;---------------------------;
			;------------;
	dc.b	"Difficulty  "		; Option 1 description
	dc.b	"Level 1     "		; Option choices
	dc.b	"Level 2     "
	dc.b	"Level 3     "
	dc.b	"Level 4     "
	dc.b	"Level 5     "
	dc.b	"Level 6     "
	dc.b	"Level 7     "
	dc.b	"Level 8     "
			;------------;
	dc.b	"Round Time  "		; Option 2 description
	dc.b	"30 Seconds  "		; Option 2 choices
	dc.b	"45 Seconds  "
	dc.b	"60 Seconds  "
			;------------;
	dc.b	"Match Points"		; Option 3 description
	dc.b	"8 Points    "		; Option 3 choices
	dc.b	"9 Points    "
	dc.b	"10 Points   "
	dc.b	"11 Points   "
	dc.b	"12 Points   "
	dc.b	"13 Points   "
	dc.b	"14 Points   "
	dc.b	"15 Points   "
			;------------;
	dc.b	"VS Points   "		; Option 4 description
	dc.b	"8 Points    "		; Option 4 choices
	dc.b	"9 Points    "
	dc.b	"10 Points   "
	dc.b	"11 Points   "
	dc.b	"12 Points   "
	dc.b	"13 Points   "
	dc.b	"14 Points   "
	dc.b	"15 Points   "
			;------------;
	dc.b	"Continue    "		; Option 5 description
	dc.b	"Yes         "		; Option 5 choices
	dc.b	"No          "
			;------------;
	dc.b	"Show Level  "		; Option 6 description
	dc.b	"Yes         "		; Option 6 choices
	dc.b	"No          "
			;------------;
	dc.b	"Show Credits"		; Option 7 description
	dc.b	"Yes         "		; Option 7 choices
	dc.b	"No          "
			;------------;
	dc.b	"Demo Sound  "		; Option 8 description
	dc.b	"Yes         "		; Option 8 choices
	dc.b	"No          "
			;------------;
	;---------------------------;

;==============================================================================;
; setting up the soft dip (Europe)
softDips_Europe:
	dc.b	"Handball Champ. "	; Game Name
	dc.w	$FFFF				; Special Option 1 (time 1)
	dc.w	$FFFF				; Special Option 2 (time 2)
	dc.b	$FF					; Special Option 3 (01-99)
	dc.b	$FF					; Special Option 4 (00-99, without, infinite)
	; Options
	dc.b	$38	; Option 1: Difficulty (8 choices, default #3)
	dc.b	$03	; Option 2: Round Time (3 choices, default #0)
	dc.b	$28	; Option 3: Match Points (8 choices, default #2)
	dc.b	$28	; Option 4: VS Points (8 choices, default #2)
	dc.b	$02	; Option 5: Continue (2 choices, default #0)
	dc.b	$02	; Option 6: Show Level (2 choices, default #0)
	dc.b	$02	; Option 7: Show Credits (2 choices, default #0)
	dc.b	$02	; Option 8: Demo Sound (2 choices, default #0)
	dc.b	$05	; Option 9: Language (5 choices, default #0)
	dc.b	$00	; Option 10: unused in all configurations
	;---------------------------;
			;------------;
	dc.b	"Difficulty  "		; Option 1 description
	dc.b	"Level 1     "		; Option choices
	dc.b	"Level 2     "
	dc.b	"Level 3     "
	dc.b	"Level 4     "
	dc.b	"Level 5     "
	dc.b	"Level 6     "
	dc.b	"Level 7     "
	dc.b	"Level 8     "
			;------------;
	dc.b	"Round Time  "		; Option 2 description
	dc.b	"30 Seconds  "		; Option 2 choices
	dc.b	"45 Seconds  "
	dc.b	"60 Seconds  "
			;------------;
	dc.b	"Match Points"		; Option 3 description
	dc.b	"8 Points    "		; Option 3 choices
	dc.b	"9 Points    "
	dc.b	"10 Points   "
	dc.b	"11 Points   "
	dc.b	"12 Points   "
	dc.b	"13 Points   "
	dc.b	"14 Points   "
	dc.b	"15 Points   "
			;------------;
	dc.b	"VS Points   "		; Option 4 description
	dc.b	"8 Points    "		; Option 4 choices
	dc.b	"9 Points    "
	dc.b	"10 Points   "
	dc.b	"11 Points   "
	dc.b	"12 Points   "
	dc.b	"13 Points   "
	dc.b	"14 Points   "
	dc.b	"15 Points   "
			;------------;
	dc.b	"Continue    "		; Option 5 description
	dc.b	"Yes         "		; Option 5 choices
	dc.b	"No          "
			;------------;
	dc.b	"Show Level  "		; Option 6 description
	dc.b	"Yes         "		; Option 6 choices
	dc.b	"No          "
			;------------;
	dc.b	"Show Credits"		; Option 7 description
	dc.b	"Yes         "		; Option 7 choices
	dc.b	"No          "
			;------------;
	dc.b	"Demo Sound  "		; Option 8 description
	dc.b	"Yes         "		; Option 8 choices
	dc.b	"No          "
			;------------;
	dc.b	"LANGUAGE    "		; Option 9 description
	dc.b	"English     "		; Option 9 choices
	dc.b	"French      "
	dc.b	"Spanish     "
	dc.b	"German      "
	dc.b	"Italian     "
	;---------------------------;
