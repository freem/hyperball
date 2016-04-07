; sound engine command handlers
;==============================================================================;
; HandleCommand
; Handles any command that isn't already dealt with separately (e.g. $01, $03).

HandleCommand:
	ld a,(curCommand) ; get current command
	ld b,a ; save in b

	; check what the command falls under
	; in SNK drivers, this is done using a table of values that map between 0-5:
	; 0=unused, 1=system, 2=music, 3=pcm?, 4=pcm?, 5=SSG

	; in the freemlib driver, this might be handled differently, since games
	; might want to have different configurations.

	; However, commands $00-$1F are always reserved for system use.
	cp 0x20
	jp C,HandleSystemCommand

	; commands $20-$FF are up to you, for now...

HandleCommand_end:
	ret

;------------------------------------------------------------------------------;
; HandleSystemCommand
; Handles a system command (IDs $00-$1F).

HandleSystemCommand:
	; use command as index into tbl_SysCmdPointers
	ld e,a
	ld d,0
	ld hl,tbl_SysCmdPointers
	add hl,de
	add hl,de

	; get routine location and jump to it
	ld e,(hl)
	inc hl
	ld d,(hl)
	push de
	pop hl
	jp (hl)

;------------------------------------------------------------------------------;
; Table of system command routine pointers
; Commands marked with a * are required by the BIOS

tbl_SysCmdPointers:
	word command_00   ; $00 - nop/do nothing
	word command_01   ; $01* - Slot switch
	word command_02   ; $02* - Play eyecatch music
	word command_03   ; $03* - Soft Reset
	word command_00   ; $04 - Disable All (Music & Sounds)
	word command_00   ; $05 - Disable Music
	word command_00   ; $06 - Disable Sounds
	word command_00   ; $07 - Enable All (Music & Sounds)
	word command_00   ; $08 - Enable Music
	word command_00   ; $09 - Enable Sounds
	word command_00   ; $0A - Silence SSG channels
	word fm_Silence   ; $0B - Silence FM channels
	word command_00   ; $0C - Stop all ADPCM-A samples
	word pcmb_Silence ; $0D - Stop current ADPCM-B sample
	word command_00   ; $0E - (tempo-related)
	word command_00   ; $0F - (tempo-related)
	word command_00   ; $10 - Fade Out (1 argument; fade speed)
	word command_00   ; $11 - Stop Fade In/Out
	word command_00   ; $12 - Fade In (1 argument; fade speed)
	word command_00   ; $13 - (currently unassigned)
	word command_00   ; $14 - (currently unassigned)
	word command_00   ; $15 - (currently unassigned)
	word command_00   ; $16 - (currently unassigned)
	word command_00   ; $17 - (currently unassigned)
	word command_00   ; $18 - (currently unassigned)
	word command_00   ; $19 - (currently unassigned)
	word command_00   ; $1A - (currently unassigned)
	word command_00   ; $1B - (currently unassigned)
	word command_00   ; $1C - (currently unassigned)
	word command_00   ; $1D - (currently unassigned)
	word command_00   ; $1E - (currently unassigned)
	word command_00   ; $1F - (currently unassigned)

;==============================================================================;
; command_00
; Dudley do-nothing.

command_00:
	ret

;------------------------------------------------------------------------------;
; command_01
; Handles a slot switch.

command_01:
	di
	xor a
	out (0xC),a ; Write 0 to port 0xC (Reply to 68K)
	out (0),a ; Reset sound code

	call SetDefaultBanks ; initialize banks to default config

	; (FM) turn off Left/Right, AM Sense and PM Sense
	ld de,FM1_LeftRightAMPM<<8|0 ; $B500: turn off for channels 1/3
	write45
	write67
	ld de,FM2_LeftRightAMPM<<8|0 ; $B600: turn off for channels 2/4
	write45
	write67

	; (ADPCM-A, ADPCM-B) Reset ADPCM channels
	ld de,PCMA_Control<<8|0xBF ; $00BF: ADPCM-A Dump=1, all channels=1
	write67
	ld de,PCMB_Control<<8|1 ; $1001: ADPCM-B Reset=1
	write45

	; (ADPCM-A, ADPCM-B) Poke ADPCM channel flags (write 1, then 0)
	ld de,PCMB_Flags<<8|0xBF ; $1CBF: Reset flags for ADPCM-A 1-6 and ADPCM-B
	write45
	ld de,PCMB_Flags<<8|0 ; $1C00: Enable flags for ADPCM-A 1-6 and ADPCM-B
	write45

	; silence FM channels
	ld de,FM_KeyOnOff<<8|1 ; FM channel 1 (1/4)
	write45
	ld de,FM_KeyOnOff<<8|2 ; FM channel 2 (2/4)
	write45
	ld de,FM_KeyOnOff<<8|5 ; FM channel 5 (3/4)
	write45
	ld de,FM_KeyOnOff<<8|6 ; FM channel 6 (4/4)
	write45

	; silence SSG channels
	ld de,SSG_VolumeA<<8|0 ;SSG Channel A
	write45
	ld de,SSG_VolumeB<<8|0 ;SSG Channel B
	write45
	ld de,SSG_VolumeC<<8|0 ;SSG Channel C
	write45

	; set up infinite loop in RAM
	ld hl,0xFFFD
	ld (hl),0xC3 ; Set 0xFFFD = 0xC3 ($C3 is opcode for "jp")
	ld (0xFFFE),hl ; Set 0xFFFE = 0xFFFD (making "jp $FFFD")
	ld a,1
	out (0xC),a ; Write 1 to port 0xC (Reply to 68K)
	jp 0xFFFD ; jump to infinite loop in RAM

;------------------------------------------------------------------------------;
; command_02
; Plays the eyecatch music. (Typically music code $5F)

command_02:
	ret


;------------------------------------------------------------------------------;
; command_03
; Handles a soft reset.

command_03:
	di
	xor a
	out (0xC),a ; Write to port 0xC (Reply to 68K)
	out (0),a ; Reset sound code
	ld sp,0xFFFF ; Set stack pointer location

	; disable FM channels
	ld d, 0xB5
	ld e, 0 ; $B500: Clear L/R output, AM Sense, PM Sense
	call write_45 ; (for channel 1)
	call write_67 ; (for channel 3)
	ld d, 0xB6 ; $B600: Clear L/R output, AM Sense, PM Sense
	call write_45 ; (for channel 2)
	call write_67 ; (for channel 4)

	jp Start ; Go back to the top.
