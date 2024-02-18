Sprite Status Bar v1.1.1
coded by edit1754

MAKE A BACKUP OF YOUR ROM FIRST!
Patch this to your ROM with asar through command prompt or with a .bat file.
If you patch by instead renaming to romname.asm, the graphics file might not insert properly under some circumstances

Please report any glitches you encounter besides the ones listed here (unless they're more severe)

NOTE: Much of this status bar is hardcoded, so it may be difficult to make it match a heavily edited layer 3 status bar.

The main purpose of this patch is to allow fullscreen layer 3 BGs, and also allow all 16 colors in palettes 0 and 1 to be used.

NEW in v1.1.1
	- Now integrates the IRQ size-change patch.
	- Separated values in tables for efficiency

NEW in v1.1.0
	- Now comes with Sprite Course Clear text, so goalpoints can be used!
	  (see bottom for notes on this)
	- Now uses colors A-F in palette F by default, due to the custom fade patch not being able to fade those anyway

NEW in v1.0.2
	- fixed game over and time-up fadeout glitch, and pipe fadeout glitch
	- Yoshi's tongue no longer glitches up the item box (I don't know how I overlooked this)
	- there is no more glitched score sprite from kicking a shell through 8 enemies
	- hitting more than 2 coin blocks in about a second no longer glitches the statusbar, but the # of coin animations is limited
	- various other glitches

NEW in v1.0.1
	- now allows you to use the 1st page of SP ExGFX and not just the second
	- doesn't screw up OW events

This patch works on a per-level basis. Each level has its own entry in tables
LevelEnabled is 00 for disabled, 01 for enabled
LevelGraphicsLoc is the initial sprite tile (on 2nd page by default) to overwrite. 36 tiles will be overwritten, which is 2 lines plus 4 more tiles. (default $80, 2nd page)
LevelSBProp is the properties of the status bar tiles in the OAM (default %00001100)
LevelIEQ is the IRQ scanline start when Sprite Status Bar is DISABLED
	don't touch Y, X, or PP because they are hardcoded. All you need to modify is CCC the palette, and T the GFX page.
	to figure out what bytes to put into CCC, open windows calculator...
		1) go to View>Scientific and click "hex"
		2) type in the palette #, and then subtract 8
		3) click "bin", and there's your CCC.
			If, for example, you get something like "11", consider that to be "011"
			default is E-8 -> 6 -> 110
		4) by default, T is set to 1 for the second GFX page. Set it to 0 to use the first (new in v1.0.1)

Since this overwrites certain slots in the beginning of the OAM, it limits the amount of points/1-up sprites, glitter effects, etc. that can be shown, but this is rarely noticable.
	- DO NOT USE GOAL POINTS! create an exit to another level with a goalpoint and without Sprite Status Bar (à la level 1FF)
	  (as of v1.1.0, this has changed)
	- Don't put too many enemies in a row that can be killed with a shell or star because of score sprites (fixed in v1.0.2)
	- Don't use Lotus Plants, because there aren't enough available extended sprite slots
	- Don't use more than two fire-spitting Jumping Piranha Plants on the same screen
	- Wigglers work, but the flower doesn't show up
	- Don't put too many coin blocks in a row- if you have a cape and you spinjump-fly or fly w/ Yoshi & hit >2 really quickly, not all the coins animations show up

Very seldom can a bounce block sprite can appear above the status bar, but it will only show up for a split second.

Do not use layer 3 rain/snow if you plan to have it appear above the FG because it will also show up above the status bar. Instead, put your BG on layer 3 and the rain/snow on layer 2, or put the FG on layer 2 and rain/snow on layer 1.


Sprite Course Clear Text:
This requires No More Sprite Tile Limits to be patched to your rom, although it does not have to be enabled in your level. (it will get auto-enabled when the goal point is hit, but at that time sprites turn into coins anyway)
(if you don't patch it, goalpoints will crash the game)
The layer 3 "COURSE CLEAR!" text is shown using sprites, just like the status bar. This makes goalpoints compatible with layer 3 BGs, 8BPP BGs, and ExGFX Revolution #2 BGs.

You will likely want to patch the Fade Disable patch to your ROM, because 8BPP BGs that use status bar + sprite palettes, or layer 3 BGs that use status bar palettes will not fade completely.
I am working on a patch that will allow you to choose which colors you want to fade on a per-level basis, but as of now it's not complete.

Limitations:
- Mario and other sprites will show up above the text, so make sure the goal point is placed in such a way that Mario does not touch the course clear text, and so that no sprites show up there.
- No sprites incompatible with the No More Sprite Tile Limits patch can be placed in such a way that they will show up while the bonus star sprites or the course clear text are onscreen (most sprites turn into coins anyway)
- In addition to that, no sprites that use GFX within 3 rows after the Sprite Status Bar GFX can show up (feel free to use them elsewhere in the level though)