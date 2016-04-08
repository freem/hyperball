# makefile for code name "hyper ball"
################################################################################
# tool executables #
####################
VASM_68K = vasm68k
VASM_Z80 = vasmz80
VLINK = vlink

TOOL_ROMWAK = romwak
TOOL_MKISOFS = mkisofs
TOOL_CHDMAN = chdman
TOOL_NEOGEOCONVERT = neogeoconvert

################################################################################
# input files #
###############

DIR_SRC68K = src_68k
DIR_SRCZ80 = src_z80

DIR_ADPCMA = pcm/pcma
DIR_ADPCMB = pcm/pcmb
DIR_GRAPHICS = graphics

# [prog]
PROG_LINKSCRIPT = $(DIR_SRC68K)/linkscript.ld
PROG_MAINFILE = $(DIR_SRC68K)/main.asm
PROG_VOBJ = out-68k.vobj
PROG_INTERMED = hyperball.p

# [z80]
Z80_LINKSCRIPT = $(DIR_SRCZ80)/sounddrv.ld
Z80_MAINFILE = $(DIR_SRCZ80)/sound.asm
Z80_VOBJ = out-z80.vobj

# [Sprites]
SPRITES_C1 = hyprball-c1.c1
SPRITES_C2 = hyprball-c2.c2

# [Fix tiles]
FIX_SOURCE = $(DIR_GRAPHICS)/hyprball-s1.s1

# [ADPCM-A samples]

# [ADPCM-B samples] (cart only)

################################################################################
# output files #
################
# [Shared]
OUTPUTDIR_CART = roms
OUTPUTDIR_CD = disc

# [prog]
PROG_OUTFILE = hyprball-p1.p1

# [cdprog]
CDPROG_OUTFILE = HYPRBALL.PRG

# [z80]
Z80_OUTFILE = hyprball-m1.m1

# [cdz80]
CDZ80_OUTFILE = HYPRBALL.Z80

# [fix]
FIX_OUTFILE = hyprball-s1.s1
CDFIX_OUTFILE = HYPRBALL.FIX

# [pcm]

# [cdpcm]

################################################################################
# Neo-Geo CD disc image #
#########################
FLAGS_MKISOFS = -iso-level 1 -pad -N

# eight character limit based on disc label
NGCD_IMAGENAME = hyprball
NGCD_DISCLABEL = HYPRBALL

################################################################################
# various flags #
#################
FLAGS_VASM68K = -m68000 -devpac -Fvobj -nosym -I$(DIR_SRC68K)
FLAGS_VLINK68K = -brawbin1 -T $(PROG_LINKSCRIPT) -o $(PROG_INTERMED)
FLAGS_VLINK68K_CD = -brawbin1 -T $(PROG_LINKSCRIPT) -o $(OUTPUTDIR_CD)/$(CDPROG_OUTFILE)

FLAGS_VASMZ80 = -Fvobj -nosym -I$(DIR_SRCZ80)
FLAGS_VLINKZ80 = -brawbin1 -T $(Z80_LINKSCRIPT) -o $(OUTPUTDIR_CART)/$(Z80_OUTFILE)
FLAGS_VLINKZ80_CD = -brawbin1 -T $(Z80_LINKSCRIPT) -o $(OUTPUTDIR_CD)/$(CDZ80_OUTFILE)

FLAGS_CART = TARGET_CART
FLAGS_CD = TARGET_CD

# FLAGS_ROMWAK_PROG - Flags for ROMWak to use when operating on cart .p# output
FLAGS_ROMWAK_PROG = /f $(PROG_INTERMED) $(OUTPUTDIR_CART)/$(PROG_OUTFILE)
# FLAGS_ROMWAK_PRG2 - Flags for ROMWak to use when padding cart .p# output
FLAGS_ROMWAK_PROG2 = /p $(OUTPUTDIR_CART)/$(PROG_OUTFILE) $(OUTPUTDIR_CART)/$(PROG_OUTFILE) 512 0

# FLAGS_ROMWAK_Z80 - Pad output .m1 file
FLAGS_ROMWAK_Z80 = /p

################################################################################
.phony: all clean cart cd chd prog z80 pcm cdprog cdz80 cdpcm

################################################################################
all: cart chd

clean:
	$(RM) $(PROG_INTERMED) $(PROG_VOBJ) $(Z80_VOBJ)
	$(RM) $(OUTPUTDIR_CART)/$(PROG_OUTFILE) $(OUTPUTDIR_CART)/$(Z80_OUTFILE) $(OUTPUTDIR_CART)/$(FIX_OUTFILE)
	$(RM) $(OUTPUTDIR_CD)/$(CDPROG_OUTFILE) $(OUTPUTDIR_CD)/$(CDZ80_OUTFILE) $(OUTPUTDIR_CD)/$(CDFIX_OUTFILE)

################################################################################
# Cart target
################################################################################
cart: prog z80
	cp $(FIX_SOURCE) $(OUTPUTDIR_CART)/$(FIX_OUTFILE)
	cp $(DIR_GRAPHICS)/$(SPRITES_C1) $(OUTPUTDIR_CART)/$(SPRITES_C1)
	cp $(DIR_GRAPHICS)/$(SPRITES_C2) $(OUTPUTDIR_CART)/$(SPRITES_C2)

prog:
	$(VASM_68K) $(FLAGS_VASM68K) -D$(FLAGS_CART) -o $(PROG_VOBJ) $(PROG_MAINFILE)
	$(VLINK) $(FLAGS_VLINK68K) $(PROG_VOBJ)
	$(TOOL_ROMWAK) $(FLAGS_ROMWAK_PROG)
	$(TOOL_ROMWAK) $(FLAGS_ROMWAK_PROG2)
	$(RM) $(PROG_INTERMED)

z80:
	$(VASM_Z80) $(FLAGS_VASMZ80) -D$(FLAGS_CART) -o $(Z80_VOBJ) $(Z80_MAINFILE)
	$(VLINK) $(FLAGS_VLINKZ80) $(Z80_VOBJ)
	$(TOOL_ROMWAK) $(FLAGS_ROMWAK_Z80) $(OUTPUTDIR_CART)/$(Z80_OUTFILE) $(OUTPUTDIR_CART)/$(Z80_OUTFILE) 64 255

pcm:
	@echo "adpcm step not done yet"

################################################################################
# CD target
# todo: implement linker script and vlink
################################################################################
cd: cdprog cdz80
	cp $(FIX_SOURCE) $(OUTPUTDIR_CD)/$(CDFIX_OUTFILE)
	@echo "CD image generation still needs work."

cdprog:
	$(VASM_68K) $(FLAGS_VASM68K) -D$(FLAGS_CD) -o $(PROG_VOBJ) $(PROG_MAINFILE)
	$(VLINK) $(FLAGS_VLINK68K_CD) $(PROG_VOBJ)

cdz80:
	$(VASM_Z80) $(FLAGS_VASMZ80) -D$(FLAGS_CD) -o $(Z80_VOBJ) $(Z80_MAINFILE)
	$(VLINK) $(FLAGS_VLINKZ80_CD) $(Z80_VOBJ)

cdpcm:
	@echo "CD adpcm step not done yet"

################################################################################
# CHD target
################################################################################
chd: cd
	@echo "CHD output still needs work"
