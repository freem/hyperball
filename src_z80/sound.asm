; codename HYPER BALL | sound driver (Z80)
;==============================================================================;
; Defines for RST usage, in case the locations change later.
rst_PortDelay1 = $08
rst_PortDelay2 = $10
rst_Write45    = $18
rst_Write67    = $20
rst_BusyWait   = $28
;==============================================================================;
	include "sounddef.inc"
	include "sysmacro.inc"
;==============================================================================;
	section start
; $0000: Disable interrupts and jump to the real entry point
Start:
	di ; Disable interrupts (Z80)
	jp EntryPoint

;==============================================================================;
	section delay1
; Port Delay Write for Addresses
portWriteDelayPart1:
	jp portWriteDelayPart2

;==============================================================================;
	section delay2
; Port Delay Write for Data
portWriteDelayPart3:
	jp portWriteDelayPart4

;==============================================================================;
	section write45
j_write45:
	jp write_45

;==============================================================================;
	section write67
j_write67:
	jp write_67

;==============================================================================;
	section ymwait
; Keep checking the busy flag in Status 0 until it's clear.

; Code from smkdan's example M1 driver (adpcma_demo2/sound_M1.asm), where he
; uses this instead of portWriteDelayPart2 and portWriteDelayPart4.
; It's noted that "MAME doesn't care". The hardware does, however.

CheckBusyFlag:
	in a,(YM_Status0) ; read Status 0 (busy flag in bit 7)
	add a
	jr C,CheckBusyFlag
	ret

;==============================================================================;
	;org $0030
;==============================================================================;
	section IRQ
; the IRQ belongs here.
j_IRQ:
	di
	jp IRQ

;==============================================================================;
	section idstr
; driver signature; subject to change.
driverSig:
	asc "freemlib "
	ifd TARGET_CD
		asc "NG-CDA"
	else
		asc "NG-ROM"
	endif

	asc " SoundDriver v000"

;==============================================================================;
	section NMI
; NMI
; Inter-processor communications.

; In this driver, the NMI gets the command from the 68K and interprets it.

NMI:
	; save registers
	push af
	push bc
	push de
	push hl

	in a,(0) ; Acknowledge NMI, get command from 68K via Port 0
	ld b,a ; save command into b for later

	; "Commands $01 and $03 are always expected to be implemented as they
	; are used by the BIOSes for initialization purposes." - NeoGeoDev Wiki
	cp 1 ; Command 1 (Slot Switch)
	jp Z,doCmd01
	cp 3 ; Command 3 (Soft Reset)
	jp Z,doCmd03
	or a ; check if Command is 0
	jp Z,endNMI ; exit if Command 0

	; do NMI crap/handle communication
	ld (curCommand),a ; update curCommand
	call HandleCommand

	; update previous command
	ld a,(curCommand)
	ld (prevCommand),a

	out (0xC),a ; Reply to 68K with something.
	out (0),a ; Write to port 0 (Clear sound code)
endNMI:
	; restore registers
	pop hl
	pop de
	pop bc
	pop af
	retn

;==============================================================================;
	section code
;==============================================================================;
; IRQ (called from $0038)
; Handle an interrupt request.

; In this driver, the IRQ is used for keeping the music playing.
; At least, that's the goal. Not sure how feasible it really is.

; Some other engines use the IRQ to poll the two status ports (6 and 4).

; IRQs in SNK drivers (e.g. Mr.Pac, MAKOTO v3.0) are pretty large.
; I want to avoid that, if at all possible. However, it might not be...

IRQ:
	; save registers
	push af
	push bc
	push de
	push hl
	push ix
	push iy

	; update internal Status 1 register
	in a,(YM_Status1)
	ld (intStatus1),a

	; check status of ADPCM channels
	;bit 7 - ADPCM-B
	;bit 5 - ADPCM-A 6
	;bit 4 - ADPCM-A 5
	;bit 3 - ADPCM-A 4
	;bit 2 - ADPCM-A 3
	;bit 1 - ADPCM-A 2
	;bit 0 - ADPCM-A 1

	; update internal Status 0 register
	in a,(YM_Status0)
	ld (intStatus0),a

	; Check Timer B
	; Check Timer A

	; keep the music and sound effects going.

	; FM Channel 1 (curPos_FM1)
	; FM Channel 2 (curPos_FM2)
	; FM Channel 3 (curPos_FM3)
	; FM Channel 4 (curPos_FM4)
	; SSG Channel A (curPos_SSG_A)
	; SSG Channel B (curPos_SSG_B)
	; SSG Channel C (curPos_SSG_C)

endIRQ:
	; restore registers
	pop iy
	pop ix
	pop hl
	pop de
	pop bc
	pop af

	; enable interrupts and return
	ei
	ret

;==============================================================================;
; EntryPoint
; The entry point for the sound driver.

EntryPoint:
	ld sp,0xFFFC ; Set stack pointer ($FFFD-$FFFE is used for other purposes)
	im 1 ; Set Interrupt Mode 1 (IRQ at $38)

	; Clear RAM at $F800-$FFFF
	xor a ; make value in A = 0
	ld (0xF800),a ; set $F800 = 0
	ld hl,0xF800 ; 00 value is at $F800
	ld de,0xF801 ; write sequence begins at $F801
	ld bc,0x7FF ; end at $FFFF
	ldir ; clear out memory

	;-------------------------------------------;
	; Initialize variables (todo)

	;-------------------------------------------;
	; Silence SSG, FM(, and ADPCM?)
	call ssg_Silence
	call fm_Silence
	; "various writes to ports 4/5 and 6/7"

	;-------------------------------------------;
	; write 1 to port $C0 (what is the purpose?)
	ld a,1
	out (0xC0),a

	;-------------------------------------------;
	; continue setting up the hardware, etc.

	ld de,FM_TimerMode<<8|0x30 ; Reset Timer flags, Disable Timer IRQs
	write45 ; write to ports 4 and 5
	ld de,PCMB_Control<<8|1 ; Reset ADPCM-B
	write45 ; write to ports 4 and 5
	ld de,PCMB_Flags<<8|0 ; Unmask ADPCM-A and B flag controls
	write45 ; write to ports 4 and 5

	;-------------------------------------------;
	; Initialize more variables

	call SetDefaultBanks ; Set default program banks

; this section subject to further review
;{
	; set timer values??

	; Start Timers ($27,$3F to ports 4 and 5)
	ld de,FM_TimerMode<<8|0x3F ; Reset Timer flags, Enable Timer IRQs, Load Timers
	write45 ; write to ports 4 and 5

	; (ADPCM-A shared volume)
	ld de,PCMA_MasterVol<<8|0x3F ; Set ADPCM-A volume to Maximum
	write67 ; write to ports 6 and 7
;}

	; (Enable interrupts)
	ei ; Enable interrupts (Z80)

	; execution continues into the main loop.
;------------------------------------------------------------------------------;
; MainLoop
; The code that handles the command buffer. I have no idea how it's gonna work yet.

MainLoop:
	; handle the buffer...
	jp MainLoop

;==============================================================================;
; write_45
; Writes data (from registers de) to ports 4 and 5. (YM2610 A1 line=0)

write_45:
	push af
	ld a,d
	out (4),a ; write to port 4 (address 1)
	rst rst_PortDelay1 ; Write delay 1 (17 cycles)
	ld a,e
	out (5),a ; write to port 5 (data 1)
	rst rst_PortDelay2 ; Write delay 2 (83 cycles)
	pop af
	ret

;------------------------------------------------------------------------------;
; write_67
; Writes data (from registers de) to ports 6 and 7. (YM2610 A1 line=1)

write_67:
	push af
	ld a,d
	out (6),a ; write to port 6 (address 2)
	rst rst_PortDelay1 ; Write delay 1 (17 cycles)
	ld a,e
	out (7),a ; write to port 7 (data 2)
	rst rst_PortDelay2 ; Write delay 2 (83 cycles)
	pop af
	ret

;------------------------------------------------------------------------------;
; portWriteDelayPart2
; Part 2 of the write delay for ports (address port 2/2).
; (burns 17 cycles on YM2610)

portWriteDelayPart2:
	ret

;------------------------------------------------------------------------------;
; portWriteDelayPart4
; Part 4 of the write delay for ports (data port 2/2).
; (burns 83 cycles on YM2610)

portWriteDelayPart4:
	push bc
	push de
	push hl
	pop hl
	pop de
	pop bc
	ret

;==============================================================================;
; SetDefaultBanks
; Sets the default program banks.
; This setup treats the M1 ROM as linear space. (no bankswitching needed)

SetDefaultBanks:
	SetBank 0x1E,8 ; Set $F000-$F7FF bank to bank $1E (30 *  2K)
	SetBank 0xE,9  ; Set $E000-$EFFF bank to bank $0E (14 *  4K)
	SetBank 6,0xA  ; Set $C000-$DFFF bank to bank $06 ( 6 *  8K)
	SetBank 2,0xB  ; Set $8000-$BFFF bank to bank $02 ( 2 * 16K)
	ret

;==============================================================================;
; fm_Silence
; Silences all FM channels.

; "If you're accessing the same address multiple times, you may write the
; address first and procceed to write the data register multiple times."
; - translated from YM2610 Application Manual, Section 9

; todo: switch out the ld commands on 0x02 and 0x06 for "inc a" instead?
; 7->4 cycles for each switch.

fm_Silence:
	push af

	ld a,FM_KeyOnOff ; Slot and Key On/Off
	out (4),a        ; write to port 4 (address 1)
	rst 8            ; Write delay 1 (17 cycles)
	;---------------------------------------------------;
	ld a,FM_Chan1 ; FM Channel 1
	out (5),a     ; write to port 5 (data 1)
	rst 0x10      ; Write delay 2 (83 cycles)
	;---------------------------------------------------;
	ld a,FM_Chan2 ; FM Channel 2
	out (5),a     ; write to port 5 (data 1)
	rst 0x10      ; Write delay 2 (83 cycles)
	;---------------------------------------------------;
	ld a,FM_Chan3 ; FM Channel 3
	out (5),a     ; write to port 5 (data 1)
	rst 0x10      ; Write delay 2 (83 cycles)
	;---------------------------------------------------;
	ld a,FM_Chan4 ; FM Channel 4
	out (5),a     ; write to port 5 (data 1)
	rst 0x10      ; Write delay 2 (83 cycles)

	pop af
	ret

;==============================================================================;
; ssg_Silence
; Silences all SSG channels.

ssg_Silence:
	ld de,SSG_VolumeA<<8|0
	write45

	ld de,SSG_VolumeB<<8|0
	write45

	ld de,SSG_VolumeC<<8|0
	write45
	ret

;==============================================================================;
; pcma_Silence
; Silences all ADPCM-A channels.

pcma_Silence:
	ret

;==============================================================================;
; pcmb_Silence
; Silences the ADPCM-B channel.

pcmb_Silence:
	; Force ADPCM-B to stop synthesizing with a $1001 write (set Reset bit)
	ld de,PCMB_Control<<8|1 ; $1001: ADPCM-B Control 1: Reset bit = 1
	write45

	; Stop ADPCM-B output by clearing the Reset bit ($1000 write)
	dec e ; $1000: ADPCM-B Control 1: All bits = 0
	write45

	ret

;==============================================================================;
; doCmd01
; Performs setup work for Command $01 (Slot Change).

doCmd01:
	ld a,0
	out (0xC),a ; write 0 to port 0xC (Respond to 68K)
	out (0),a ; write to port 0 (Clear sound code)
	ld sp,0xFFFC ; set stack pointer

	; call Command 01
	ld hl,command_01
	push hl
	retn

;==============================================================================;
; doCmd03
; Performs setup work for Command $03 (Soft Reset).

doCmd03:
	ld a,0
	out (0xC),a ; write 0 to port 0xC (Respond to 68K)
	out (0),a ; write to port 0 (Clear sound code)
	ld sp,0xFFFC ; set stack pointer

	; call Command 03
	ld hl,command_03
	push hl
	retn

;==============================================================================;
; Command handlers
	include "commandhandlers.asm"

;==============================================================================;
; ADPCM-A Channel masks
tbl_ChanMasksPCMA:
	byte ADPCMA_CH1
	byte ADPCMA_CH2
	byte ADPCMA_CH3
	byte ADPCMA_CH4
	byte ADPCMA_CH5
	byte ADPCMA_CH6

;==============================================================================;
; Driver tables
	include "freqtables.inc" ; FM and SSG frequency tables

;==============================================================================;
; RAM defines at $F800-$FFFF
	include "soundram.inc"
