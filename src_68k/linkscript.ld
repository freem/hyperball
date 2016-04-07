/* quick dumb m68k linker script */

MEMORY
{
	/*rom : ORIGIN = 0x00000000, LENGTH = 0x00080000*/
	header68k: ORIGIN = 0x00000000, LENGTH = 0x00000100
	rom : ORIGIN = 0x00000100, LENGTH = 0x0007FF00
	ram : ORIGIN = 0x00100000, LENGTH = 0x0000F300 /* $100000-$10F2FF (62208 bytes) */
}

SECTIONS
{
	.header68k : { *(header68k) } > header68k
	.code : { *(code) } > rom
	.bss (NOLOAD) : { *(bss) } > ram
	.data : { *(data) } > ram AT> rom
}
