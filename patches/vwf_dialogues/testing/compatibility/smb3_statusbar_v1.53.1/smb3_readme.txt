SMB3 Status Bar Patch for SMW
by Ladida

replaces SMW's default status bar with one that looks like All-Star SMB3's

easily customizable in terms of function and appearance

includes adapted/optimized version of Ersanio's P-Meter patch


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; PRECAUTIONS ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

note that you should enable the layer 3 exgfx hack in LM before (or after) applying this patch.
you dont have to actually use it; the hack just needs to be installed

additionally, you should enable the VRAM modification in LM before (or after) applying this patch.
unlike the above, the hack needs to be used

this patch will warn you if either of the above is not installed

on v1.53 generators and special commands sprites WILL NOT work if placed at the top of the screen.
please don't report bugs on this, just move your sprites to the bottom subscreen if needed.

;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; FILE LIST ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

patch these with asar:

  smb3_status.asm is the main patch.
  levelheight.asm applies a level height "fixer". it essentially offsets the initial layer 1/2
	positions up 32 pixels. optional but useful, as it means you don't need to have 2 rows
	of wasted space under each level due to the status bar taking up that region.

smb3_status.asm incsrc's these. you can edit them if you want:

  smb3_status_defines.asm holds numerous defines that can be changed in order
  	to easily alter the appearance and/or function of the status bar.
  	please check it out for more info!
  smb3_status_gfx.bin holds the status bar graphics (2bpp)
  	it's 64 tiles by default (1kb), but you can make the file larger if you want
  	more tiles. one tile in 2bpp is 16 bytes. you can use a hex editor to extend/
  	shrink the gfx file, and then edit it with yychr. i recommend you stay within 3kb
  	or so (xC00 bytes, or 192 tiles)
  smb3_status_map.bin holds the status bar tilemap (256x32)
  	unlike with the gfx, this cannot be extended. it should remain 256 bytes.
  	each row is 64 bytes. even bytes are tiles, odd bytes are properties.
  	for easier editing, use an external tilemap editor
  smb3_status_pal.bin holds the status bar palette (8 palettes, 4 colors each)
  	note: color 0 will become the backdrop color
  smb3_status_worlds.asm holds world numbers for each level. defaults configured for SMW's levels
  smb3_status_counters.asm is where you put custom counter code

the different folders you see are alternate status bars. they have been included as examples
of what you can do with this patch. to check them out, go into smb3_status.asm, scroll down
to STATUS BAR DEFINES (near the top somewhat), and prepend the incsrc with the folder name

for example, if you want to check out the SMW status bar:

incsrc smb3_status_defines.asm -> incsrc SMW/smb3_status_defines.asm

you can also just replace smb3_status_defines.asm with the one inside the folder

NES - SMB3 NES-style status bar (basically the default with different GFX/palette)
SMW - basically a bottom version of SMW's status bar, with the SMB3 status bar's benefits
TALL - a status bar that makes use of tall numbers for all of the counters
KIRBY - Kirby's Adventure-style status bar, though text/digits are taken from Kirby Super Star
SHIN - Shin Onigashima-style status bar, though text/digits are taken from Bonni's Quest
TOKI - Tokimeki Memorial-style status bar. example of how elaborate a status bar can be


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; EXPLANATION ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

the gfx are uploaded to the first half of GFX28 on level load.
therefore that region is unusable for layer 3 GFX during levels

the tilemap is uploaded dynamically to the offscreen portion of layers 1 and 2.
since the tilemap is separate from the regular layer 3 tilemap, you are able to
have full 512x512 layer 3 backgrounds!

the palette is uploaded to palette 0/1 dynamically; you can use all colors in palettes 0 and 1 for
whatever you want!

smb3_status_worlds.asm holds a table that contains a value for each overworld level. this value is the
"world number" (top left of status bar) but directly corresponds to a tile in GFX28/29

smb3_status_counters.asm is basically the same as uberasm's new statusbar_drawn hijack. use
this over uberasm's because uberasm's hijack will be ignored by the patch

NOTE: WHETHER YOU USE LEVELHEIGHT.ASM OR NOT, DESIGN YOUR LEVELS WITH THE SHORTER SCREEN IN MIND.
	SMW USUALLY HAS 2 BLOCKS OF VISIBLE GROUND AT THE BOTTOM, BUT SMB3 USUALLY ONLY HAS 1, PLUS
	THE 2 BLOCKS THAT ARE THE STATUS BAR.
	AS A PRECAUTION, LEVELHEIGHT.ASM HAS BEEN DESIGNED WITH THIS IN MIND, SO MANY SMW LEVELS
	MAY APPEAR BORKED OR UNDESIRABLE


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; IMPORTANT RAM ADDRESSES ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[2019/11/30] GHB's note: the new RAM addresses info are outdated, marked with
"*" means it no longer works (they're outdated). RAM addresses are displayed
on the asar console window during patching, use that instead when designing
custom info display (such as counters, graphical bars, etc.)

$0C00-$0C7F holds the status bar tiles*
	$0C00-$0C1F = 1st row
	$0C20-$0C3F = 2nd row
	$0C40-$0C5F = 3rd row
	$0C60-$0C7F = 4th row
$0C80-$0CFF holds the status bar tile properties (YXPCCCTT)*
	$0C80-$0C9F = 1st row
	$0CA0-$0CBF = 2nd row
	$0CC0-$0CDF = 3rd row
	$0CE0-$0CFF = 4th row
	not only can you dynamically write to the entire status bar rather than a few select
	tiles, but you can write the tile properties as well!
$0EF9-$0EFB is free RAM
$0EFC-$0F2F holds the status bar OAM
	$0EFC-$0EFF is the item box item (or extra sprite 0)
	$0F00-$0F03 is extra sprite 1
	$0F04-$0F07 is extra sprite 2
	$0F08-$0F0B is extra sprite 3
	$0F0C-$0F0F is extra sprite 4
	$0F10-$0F2F is the high table. dont touch it (except the last 8 bits, which handle
	the above 4 extra sprites, and the 2 high bits of $0F2E handling the item box.
	by default, the size bit is set (16x16) and the high X position is clear)
$0D00-$0D3F holds the status bar palette*
	$0D00-$0D07 = palette 0
	$0D08-$0D0F = palette 1
	$0D10-$0D17 = palette 2
	$0D18-$0D1F = palette 3
	$0D20-$0D27 = palette 4
	$0D28-$0D2F = palette 5
	$0D30-$0D37 = palette 6
	$0D38-$0D3F = palette 7


;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; CREDITS ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;

have fun! give credit if used pls, this took forever to debug
credits to Ersanio for the original P-meter patch
also thanks to DiscoTheBat for helping test the v1.2-1.4 updates
also thanks to byuu for technically indirectly testing v1.5
also thanks to GreenHammerBro for miscellaneous testing and feedback
also thanks to imamelia for bugtesting


;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; CHANGELOG ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

v1.0	initial release
v1.1	optimizations. now uses 1 IRQ and HDMA hax instead of 3 IRQs
	(does not look good in zsnes though)
v1.2b	the item box now requires 0 tiles in the standard OAM mirror, which
	gives 2 free OAM slots. the previous HDMA window + masking sprite
	method was scrapped in favor of an OAM high table upload during IRQ.
	this method allows for other optional sprites to appear in the status
	bar without issue (Mario animation, minimap, item roulette, etc)
v1.3b	the entire status bar tilemap is now uploaded to $6000, freeing up
	space in the layer 3 GFX VRAM. consequently, the entire status bar
	tilemap is now in RAM @ $0AF9, allowing for dynamic changes to the
	tile properties as well as the tiles themselves. the status bar
	palette now occupies the old status bar tilemap ram @ $0EF9, allowing
	for dynamic changes to that as well. as a result of these changes,
	the patch is now incompatible with ZSNES
v1.4	first official release since v1.1. SA-1 support has been implemented!
	the status bar now has its own OAM table (a short one) @ $0EFC. the
	status bar palette has been relocated to $1BA3. you can now choose
	to have 4 extra status bar palettes OR 4 extra sprites on the status
	bar, or a mix of the two. basic custom counter support has been added
	via a counters.asm file that runs after the main status bar update code.
	several defines have been added to the main patch to aid customization.
	the patch remains incompatible with ZSNES
v1.5	switched from $0AF6 to $0C00 as freeram, since the former gave problems
	when ExAnimation was used. additionally, like with the minimalist
	status bars, the tilemap was moved to the offscreen portion of layers
	1 and 2, as overwriting Mario's GFX is just too risky and also takes up
	too much time. as a result, the F-blank that precedes the status bar
	is shorter, but in return NMI is a bit longer (so i threw in my $2132-
	store-shortening patch). NUMEROUS user-friendly changes were also made,
	and defines were moved to an external file, in order to further aid in
	customization. additionally, palettes and sprites have been maximized
	to 8 and 5 respectively; you no longer need to choose between more
	sprites or more palettes. the patch has regained some compatibility
	with zsnes, and is now FastROM-compatible
v1.51	same as above, i just want to emphasize how much more user-friendly
	the patch has become :). also, i replaced my lame-o level end hex
	edits with Lui37's Minimalist Course Clear patch. less complaints
	about the level end looking glitched that way
v1.52	removed Lui37's Minimalist Course Clear patch, because it broke too
	many things... level end behavior has been changed to something akin
	to earlier versions of the patch, except without scorecard info
v1.53	(lx5) added LM300+, latest SA-1 pack and Custom Powerups support. also
	added 24-bit addresses support because $0BF6 is used by EXLEVEL.
	and i believe IRQ now lasts for 3px instead of 2px.