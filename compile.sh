#!/bin/bash
path68k="/home/kannagi/Documents/SDK/NeoDev/m68k/vasmm68k_mot"
pathromk="/home/kannagi/Documents/SDK/NeoDev/Tools/RomK/bin/romk"

$path68k -DENABLE_SECTION -Fbin -m68000 src_68k/main.asm -o 052-p1.bin
$pathromk -invert 052-p1.bin

mkdir ssideki
cp 052-p1.bin ssideki
rm 052-p1.bin

cp graphics/hyprball-s1.s1 ssideki/052-s1.bin 

cp graphics/hyprball-c1.c1 ssideki/052-c1.bin 
cp graphics/hyprball-c2.c2 ssideki/052-c2.bin 

cd ssideki
zip -1 ssideki *.*
cp ssideki.zip ..
rm ssideki.zip

cd ..
#gngeo --rompath=/home/kannagi/Documents/SDK/GitFreem/hyperball ssideki