This README will be broken into a how to patch and a hot to use section.  I will
also add instructions on importing old levelcode.asm files at the end of the 
README.

There should be 7 items in the main folder in case if something is missing.

Patching:

asar instructions:
1) Open asar_patch.asm.
2) Find the section labeled "Hijack list".
3) Set any hijacks you don't need to "!false". (Do NOT do this with an old ROM)
4) Save and patch the patch with "asar.exe asar_patch.asm smw.smc".
5) Enjoy.
Note) Disabling global hijacks will also disable sprite hijacks.

Using the patch:
As a user of the patch you only need to edit files in the code directory.  Find
the file with the name of the hijack you need, open it, find the appropriate 
label, and place your code there.  All code starts with A and XY set to 8 bits
and must end with them being reset to 8 bits.  No other restrictions exist.

Importing old levelASM code:
Importing old code is easy, just replace level_code.asm with your old 
levelCode.asm. and do the same for init. Be sure to run xkasanti to
remove your old levelASM if you are using the same ROM.

Thats all there is to it!  Enjoy the power of uberASM.

GHB's Note: the freeram that this patch uses is defined at the hub patch
(asar_patch.asm), and they are not automatically converted to sa-1 address, in
case if you want to manually convert them to use new freeram address that the sa-1
patch has created.

DiscoTheBat's Note: there are some game modes that won't run constantly such as game mode 00
or game mode 03, this is because the game mode is changed, so the state isn't maintened.
In game mode 00, the INIT is skipped, the rest works just as desired.
Also, fixed GHB's mistake for new game modes, where it pointed to the wrong location
causing the game to break.

Change log:
V1.2
Added: A "Status Bar Drawn" hijack, allowing the user to execute code at the end of the
       status bar routine rather than at the beginning, making it possible to overwrite
       values written by SMW's status bar code before.

V1.1
Bugfix: Fixed init/main gamemode code
Bugfix: Fixed sprite execution code

GHB's updates: (format: M/D/Y)
12/4/2015
	-Added sa-1 support, give thanks to Vitor Vilela for
	 helping me.
12/25/2015
	-Fix a serious glitch that I have made on the gamemode hijack, I forgot to
	 remove this line:

		STA !previous_mode ;?

	 Which causes the gamemode (that runs every frame during a specific value in $7E0100)
	 to not run at all and the init runs every frame, give thanks to Medic for having the old
	 version: https://dl.dropboxusercontent.com/u/77068552/uberASM.zip. It allows me to compare
	 of how the previous version worked.
	-Added a freeram map image that shows the sprite tables and other things.
	-Fix an out-of-place freeram that !previous_mode should be +66, not +88 (I did the math
	 wrong, using the image helps a lot).
	-Added a comment about !sprite_RAM on how much bytes it uses, for both normal and sa-1.