; Neo-Geo freemlib Sound Driver RAM
;==============================================================================;
; Usable RAM exists from 0xF800 to 0xFFFF.
	section bss
;==============================================================================;
; <Sound Driver Section>
;==============================================================================;
dummyByte   ds 1  ; dummy byte used for RAM clearing, etc.
;------------------------------------------------------------------------------;
; [Commands]
curCommand   ds 1  ; Current command to handle
prevCommand   ds 1  ; Previous command handled
commandBuffer  ds 64  ; 64 byte command buffer (todo: is this enough? too much?)

; unsure if I'm keeping this idea...
dataMode   ds 1  ; (0=normal, 1=send to 68k, 2=receive from 68k)
dataBuffer   ds 64  ; buffer for data transfer

;------------------------------------------------------------------------------;
; [Channel Playback]
musicToggle   ds 1  ; Master Toggle for Music (0=off, nonzero=on)
soundToggle   ds 1  ; Master Toggle for Sound Effects (0=off, nonzero=on)

typeToggle   ds 1  ; Overall toggle for SSG, FM, and PCM (1 bit each)
ssgToggle   ds 1  ; Specific SSG channel toggles ($07 p4/5)
fmToggle   ds 1  ; Specific FM channel toggles (matches FM register $28 - Key On/Off)
pcmToggle   ds 1  ; Specific ADPCM channel toggles (matches ADPCM-B register $1C - Flag Control)

;==============================================================================;
; <YM2610 Section>
;==============================================================================;
; [System variables]
intStatus0   ds 1  ; Status 0 (Timer flags and Busy)
intStatus1   ds 1  ; Status 1 (ADPCM A and B status)

;==============================================================================;
; [Timer variables]
intTimerControl  ds 1  ; ($27) Timer Control and Mode
intTimerA_Hi  ds 1  ; ($24) Timer A value, upper 8 bits
intTimerA_Lo  ds 1  ; ($25) Timer A value, lower 2 bits
intTimerB   ds 1  ; ($26) Timer B value
