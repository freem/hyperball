
Sprite_init macro ;VRAM ADRESS ,n' x,n'y,adress struct
		
	;Init Y + info
    move.w  #SCB3+(\1),LSPC_ADDR

    move.w  #$F8<<8|\3,\4+_y
    
	
	; Make
	if \2-1 != 0
	
		move.w  #\2-1,d2
		do
			move.w  #$40,LSPC_DATA
		while_dbra d2
	
	endif
	
	
	;init x
	move.w  #SCB4+(\1),LSPC_ADDR
    move.w  #$0400,LSPC_DATA
    move.w  #$0400,\4+_x
    

    
    ;send struct
    move.w  #\1,\4+_id
    move.w  #64*(\1),\4+_scb1    
    move.w  #SCB2+(\1),\4+_scb2
    move.w  #SCB3+(\1),\4+_scb3
    move.w  #SCB4+(\1),\4+_scb4
    
    move.w  #\2,\4+_w 
    move.w  #\3,\4+_h
    
    
   move.w  #(\2)*(\3)*2,\4+_pitch
    
    
endm

Sprite_init_ext macro ;VRAM ADRESS ,n' x
		
	;Init Y + info
    move.w  #SCB3+(\1)+(\2),LSPC_ADDR
    
	
	; Make
	if \2-1 != 0
	
		move.w  #\2-1,d2
		do
			move.w  #$40,LSPC_DATA
		while_dbra d2
	
	endif
	
	
	;init x
	move.w  #SCB4+(\1)+(\2),LSPC_ADDR
    move.w  #$0400,LSPC_DATA

    
    
endm

Sprite_id macro ;id,struct
		
    
    
    ;sent struct
    move.w  #\1,\2+_id
    move.w  #64*(\1),\2+_scb1      
    move.w  #SCB2+(\1),\2+_scb2
    move.w  #SCB3+(\1),\2+_scb3
    move.w  #SCB4+(\1),\2+_scb4
    

    
endm


Sprite_position_ram_init macro ;struct;x,y
	
	move.w  #$0400+(\2<<7),\1+_x
    
    move.w  \1+_y,d0
    andi.w	#$007F,d0
	addi.w  #($1F0-\3)<<7,d0
	move.w  d0,\1+_y

endm

Sprite_position_ram macro ;struct
	
	move.w  \1+_scb3,LSPC_ADDR
    move.w  \1+_y,LSPC_DATA
    
    move.w  \1+_scb4,LSPC_ADDR
    move.w  \1+_x,LSPC_DATA

endm

Sprite_position_ram_ext macro ;struct
	
	move.w  \1+_scb3,d0
	add.w	\1+_w,d0
	move.w  d0,LSPC_ADDR
    move.w  \1+_y,LSPC_DATA
    
    move.w  \1+_scb4,d0
    add.w	\1+_w,d0
	move.w  d0,LSPC_ADDR
    move.w  \1+_x,LSPC_DATA

endm


Sprite_Position_init macro ;...;x,y

    move.w  \1+_scb3,LSPC_ADDR
    move.w  \1+_y,d0
	addi.w  #($1F0-\3)<<7,d0
    move.w  d0,LSPC_DATA
    
    move.w  \1+_scb4,LSPC_ADDR
    move.w  #$0400+(\2<<7),LSPC_DATA
	
endm




Sprite_Draw macro ;struct,address sprite
	move.w  \1+_scb1,d0 
	lea     \2,a0
	
	clr.l d4
	move.w 	\1+_h,d4
	sub.b	#1,d4
	
	move.w	\1+_tileext,d1
		
	move.w  \1+_w,d3
	do
		move.w  d0,LSPC_ADDR
		move.w 	d4,d2
		do
			move.w  (a0)+,LSPC_DATA
			move.w  d1,LSPC_DATA 

		while_dbra d2
		
		addi.w  #64,d0
		
	while_dbra d3

endm

Sprite_Draw_ext macro ;struct

	move.w  \1+_w,d3
	lsl.w	#6,d3
	
	move.w  \1+_scb1,d0
	add.w	d3,d0
	lea     \2,a0
	
	clr.l d4
	move.w 	\1+_h,d4
	sub.b	#1,d4
	
	move.w	\1+_tileext,d1
	addi.w	#$100,d1
		
	move.w  \1+_w,d3
	do
		move.w  d0,LSPC_ADDR
		move.w 	d4,d2
		do
			move.w  (a0)+,LSPC_DATA
			move.w  d1,LSPC_DATA 

		while_dbra d2
		
		addi.w  #64,d0
		
	while_dbra d3

endm



Sprite_DrawBG macro ;n' sprite,h,address sprite
	move.w  \1+_scb1,d0 
	lea     \3,a0

	move.l 	#\3,\1+_address
	
	move.w 	#32,d1
	sub.w	\1+_h,d1
	lsl.w	#2,d1
	
	move.w 	\1+_h,d4
	sub.w	#1,d4
	
	move.w  \1+_w,d3
	do
		move.w  d0,LSPC_ADDR
		move.w 	#\2-1,d2
		do
			move.w  (a0)+,LSPC_DATA
			move.w  (a0)+,LSPC_DATA

		while_dbra d2
		
		addi.w  #64,d0
		
		add.w   d1,a0
		
	while_dbra d3

endm

Sprite_DrawBG_Scroll macro ;n' sprite,h,address sprite

	move.l  \1+_address,a0
	move.w  \1+_scb1,d0
	move.w	\1+_x,d1
	move.w	\1+_y,d2
	move.w	\1+_px,d3
	move.w	\1+_py,d4
	
	lsr.w	#7,d1
	lsr.w	#4,d1
	
	lsr.w	#7,d2
	lsr.w	#4,d2
	
	move.b	\1+_scrollaxe,d5
	andi.b	#$04,d5
	cmp.b #0,d5
	if_eq
		move.b	\1+_scrollaxe,d5
		andi.b	#$01,d5
		;jsr UpdateBGX
		
		move.w	d0,\1+_scrolld0
		move.l	a0,\1+_scrolla0
	endi
	
endm


