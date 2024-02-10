10 files main directory

Super Status Bar readme

Patch written by Kaijyuu, Updated by GHB.

WHAT THE CRAP IS THIS EXACTLY?
	This is a status bar hack. It's designed for two main purposes:
	- Make it possible for non-ASM hackers to add additional tiles to their status bar
	- Make it easier for ASM hackers to dynamically modify the entire status bar for
	  health bars, boss health bars, timers, ect

WHAT'S THE DIFFERENCE BETWEEN THE ADVANCED AND COMPATIBILITY VERSIONS?

	The compatibility one is simply more compatible with (some) status bar hacks. 
	This version does NOT guarentee compatibility with ANYTHING that touches the
	status bar or it's routines.
	- Slow.
	- Uses old RAM addresses for tiles ($0EF9-$0F2F)
	- Smaller insert size


	The advanced version is MUCH faster, but pretty much guarantees 0 compatibility
	with any pre-existing status bar hack (except Smallhacker's status bar editor).
	It also has a larger insert size. 
	- Faster
	- Uses entirely new RAM addresses ($0EF9-$0F2F are completely unused)
	- Larger insert size

	^Note: if you are using UberASM from the patch section, make sure you disable the
	"status bar hijack" or it will cause the game to crash. To do that, open the main
	asm file (the file used to patch other asm file codes into the ROM), and in the
	label "!statusbar", change it to equal to "!false" so it doesn't conflict with it.
	If you have codes in the status bar asm file, move them into a different asm file
	(mainly in gamemode_code in "gamemode_14:" or global).

WHICH SHOULD I USE FOR MY HACK?

	Depends, really. Do you have any patches or bosses that change the status bar?
	If so, the compatibility one might be right for you. If you don't, and all you
	really want is some extra tiles on the status bar, the advanced one would be good. 


HOW DO I USE IT?
	First and foremost, make a backup of your ROM. Always do this before applying any
	patch whatsoever. Next, open up the .ASM file. Change the freeram if necessary.
	Do note that the freeram is not automatically converted to sa-1 address, (in case
	you wanted to use freeram that sa-1 has created).

	Scroll down a bit until you see DATA_TILES. These tables hold new values for
	previously uneditable status bar tiles. The first number is the tile number. The
	second is the properties. I suggest opening up the status bar editor by Smallhacker
	at the same time so you can easily see which tile number is which. The properties
	byte is explained in the asm file comments. Changing these means you can change
	each and every tile from the top of the screen to the bottom of the status bar,
	except those editable with Smallhacker's Status Bar editor tool.  

Advanced hackers:
	This patch rearranges the tiles in RAM. All the tiles (and their properties bytes!)
	are placed into RAM at $7FA000 by default. You can change the free RAM address pointer
	at the top if you wish. However, if you do this, you'll have to change the DMA table too
	(- GHB edit, made a bit-shifting converter to make changing the table and freeram
	convenient). This table is right below the tile numbers/properties tables at the top of
	the file. What you should change is explained in the comments. You do not need to
	change anything else if you do this. 

	The big thing for you though is you can change any tile on the status bar at will now. 
	Want your boss health bar to change palette?  Want your mario health patch to exist
	ABOVE the default SMW tiles? You can do all that here. More stuff will be explained later.


I APPLIED THE COMPATIBILITY VERSION AND IT SCREWED UP MY METRIOD HEALTH PATCH/WHATEVER!

	Hope you have a backup. Just because it has "compatible" in it's name doesn't mean it's
	compatible with everything.

WHAT EXACTLY IS THIS COMPATIBLE WITH?

	Hard to say. Anything that hijacks the status bar routine directly will be overwritten.
	Most patches could be "grafted" to the compatibility version and work fine, though.
	Grafting to the Advanced version might require some relatively advanced knowledge (changing
	the patch to the new RAM addresses). Or it might be really easy (deleting some NOPs at the top
	and JSRing to your patch).

	One thing for certain is compatible with both versions of Super Status Bar, though: Smallhacker's
	Status Bar Editor I built this patch with compatibility with that in mind. Any change you make
	with that tool will work after applying this patch.


	You ASM hackers that might be concerned my patch bypasses one of the patches you have applied... 

	The compatibility patch bypasses the following routines:
	DrawStatusBar ($008DA6) (Well, it only bypasses everything after $008DC6, so it should be
	compatible with sprite status bar for example)

	The advanced patch bypasses these routines:
	DrawStatusBar (same as above)
	$008E1A (controls coins/lives/ect)
	$009012 (subroutine of $008E1A)
	$009051 (subroutine of $008E1A)

	Read GHB's_notes.txt (advance only) to find out why it doesn't work and how to convert them.


I PUT A TILE ON THE BOTTOM ROW AND IT'S CUT OFF HALFWAY DOWN!

	That's a IRQ line quirk of SMW. Sorry, but any tile you put on the very bottom row will be cut
	off like that. It's still all there on the tilemap and everything,  but for some reason Nintendo
	thought it'd be funny if they set the layer 3 tilemap's default Y to 140 past that line.

	GHB edits:
	-Nintendo did this because the layer 3 smasher shakes up and down along with layer 1 except the
	 HUD (stands for heads-up display), when this occurs, some parts of pixels of the HUD duplicates
	 will appear between the HUD and smasher (can be any X position, but Y position is in between
	 these two layer 3 things). Its fixed now, no need to worry about it, but if you are using the
	 layer 3 smasher, make sure you design the level's "ceiling" to a lower position to hide it,
	 else its visible.

	 ^However its not fixed on mode 7 bosses (iggy, larry, morton etc, until the "COURSE CLEAR!"
	 layer 3 text appears), as they, themselves move the cutoff line. (I couldn't find any
	 spots on smwDisC that controls the IRQ, sorry) but don't worry; you'll unlikely gunna use
	 smw's mode 7 bosses. If you have found a fix for mode 7 bosses, send me (GreenHammerBro) a
	 PM to fix it.


(ASM HACKERS) WHAT SHOULD I BE AWARE OF TO TAKE ADVANTAGE OF THIS PATCH'S FEATURES?

	The big thing you have to remember is that the table is now interleaved.  This means that each
	8x8 space seen in-game takes up two bytes in RAM: Tile number, tile properties. Even numbered
	RAM addresses are tile numbers. Odd are properties. (using default RAM) Ex: $7FA000 holds the
	tile number for the very top-left tile $7FA001 holds the tile *properties* for that same tile

	The benefit of this is you can change the tile's palette, priority, X/Y flip, and page number
	at will in-game. Also, of course, you can use tiles outside of the dynamic ones set up by SMW,
	instead of just those two rows.

	Big thing of note concerning each version!

	The compatibility patch still uses the old RAM addresses for tile numbers ($0EF9-$0F2F).
	If you use that patch, and you wish to modify those tiles, you will have to use the old RAM
	addresses. However, if you use the advanced version, you can easily modify every tile without
	switching between 3 tables.

	Read GHB's_notes.txt on how to make other codes work with this patch!!


(ASM HACKERS) $140 BYTES?! THAT'S A LOT TO KEEP TRACK OF!

	I included a .xls spreadsheet that shows the hex and decimal offset for each tile and it's
	properties. 320 (decimal) bytes is a lot more to keep track of than 55, I know :P
	But believe me, having so few tiles to work with (and being unable to change properties) 
	can be a huge pain if you want to do anything dynamic with the status bar.


DO I HAVE TO CREDIT YOU?

	No. Give this out to anyone, host it anywhere, claim it as your own if you want. 
	I won't mind :)

	However, If you use the ASSB (Advanced super status bar patch), Please (also) credit GreenHammerBro,
	Working on the defines, adding comments on the table, and working on the tedious diagram for where are
	the bytes of ram corrosponding to the tile spaces on the status bar, it took me 4-5 days to complete.


I HAVE A QUESTION!11

	Advanced SMW Hacking forum at SMWCentral.net. Feel free to post your question in the
	"Official Hex/ASM/Ect. Help Thread" at the top. Please do not PM me simple questions. If you
	post them publicly others in your situation can learn from you. If you have some super advanced
	question that somehow relates to this patch, make a thread.


I HAVE A SUGGESTION AND/OR BUG REPORT!

	A PM would be appropriate here. Just understand that "bug report" does not equate "Your patch does not work with x
	other patch. Please fix." If you want help combining this patch with another status bar hack, post in the forum/topic
	mentioned above.

	GHB edit: PM GreenHammerBro or talk on the forums so I can fix it.

	See GHB's_notes.asm on chapter 4 for more info.
----------------------------------------------------------------------------------------------------------------------------
version history: (M/D/Y, from oldest to newest)

01/17/2015:
	-made them asar patches. (no need to add ;@xkas and setting up the freespace.) Just type in the name of the patch
	 and the name of your rom in asar and there you go.
	-added defines, comments, and a diagram so its easy to use and modify. However, the compatibilty is converted to
	 asar
	 only (its messy).
02/28/2015:
	-Fix the cutoff on the bottom line of the status bar, now the bottom row of 8x8 tiles aren't cut.
	-Added more info (on GHB's_notes) about another thing that can also store to multiple bytes of RAM, using 16-bit
	 value.
	-Added a list of files in this readme just in case if some files are missing.
	-added comments and added the DMA define for the compatibility version.
02/8/2015-3/13/2015:
	-fix the patch because vitor vilela remove it for reasons below:
		-If disabling the counters, there will be some useless routines/codes left that makes the game run slow due
		 to the waste of cycles.
		-Bitshifting (if you shift in amounts multiple/divisible by 8, I call it "byteshifting") conversion for the
		 DMA is better than re-typing the "digit" pairs of freeram.
		-This readme mentions about changing the freespace, which I'm supposed to remove that since its a asar patch.
	-Realized that the timer frame counter ($7E:0F30) includes #$00 as 1 frame, so its actually how many extra (1-extra)
	 frames before one smw second is subtracted (put $3B instead of $3C for real seconds), thus if the frame counter is
	 "-1" will subtract 1 second (its #$00-#$28 within a second, not #$01-#$28 by default).
	-Added a SM3DL/SM3DW/NSMB2 timer gimmick that warns the player is running low in time (as an option) for the ASSB.
3/14/2015:
	-Fix the SM3DL timer bug that if there is a level with no time limit, it will continue to keep playing the warning
	 sounds and stays red.
3/22/2015:
	-Realized that the timer did not use #$00 as an extra +1 frame. At the same frame, the timer frame counter hits
	 zero, and one second is subtracted (I was wrong, within a second is #$01-#$28; 40 different frame values in between
	 whole "smw seconds", so it excludes #$00's frame (unlike the real timer "sprite", in the sprite section (that shows
	 minutes seconds and frames (that are 00-59; 60 different values))).
	-Found a glitch (but not fix it) and added a notice that the IRQ cutoff line still $24 pixels down if the gamemode is
	 mode 7 for smw's bosses.
	-Made the paragraphs and line breaks on this readme better.
	-Move the uberasm's statusbar hijack warning to this readme, since its more appropriate and important.
3/23/2015:
	-Realized that the ASSB map image (that I made) made the excel file obsolete since its is way better.
4/9/2015:
	-Improved the not equal sign for the option(s) rather than if !define > or define <.
6/21/2015
	-Found a potential top of the screen flickering and HDMA garbage when adding custom codes in SSB.
12/3/2015
	-Converted the patches to detect sa-1 mode (thank god that almost all ram address just need +!Base2 after each ram
	 addresses and that DMA and other snes registers don't need to be converted).
8/18/2016
	-Because uberasm tool has been released, address $008E1A is hijacked by both the tool itself and the super status
	 bar advance patch, therefore if you use both, the game will crash. Here is the status bar hijack from uberasm tool:
		;----code----;
			ORG $008E1A
				autoclean JML statusbar_main
				NOP
		;----end_code----;
	 So I simply move the hijack to address $008E1F. Also, give credit to DiscoTheBat for fixing the luigi name.
	 before:
		;----code----;
			DATA_008DF5:		      db $40,$41,$42,$43	;>luigi's name?
		;----end_code----;
	 After:
		;----code----;
			DATA_008DF5:		      db $40,$41,$42,$43,$44	;>luigi's name?
		;----end_code----;
8/13/2017 2.0
	-Made it easy to convert to SA-1 RAM address. This also enables easy access for things on the sa-1 side
	 to use the status bar code.
2/8/2019 2.1
	-Merged the sa-1 RAM address version into the same file as the non-SA-1 file.
	-Added a html javascript RAM address locater, so that the user don't have to keep manually entering a number
	 in a calculator to find what RAM address he should write.
2/9/2019 2.1 slight improvement to the javascript html file.
	-Added subrange just before the big table noting the ranges for each row.
2/11/2019 2.1 More improvement on how to use.
	-[GHB's_notes.txt]'s code now instructs to use a more optimized code (no longer instructs to use scratch RAM).
	-The javascript HTML file [RAM_BAR_MemoryLocater.html] now have an advanced and easier tutorial to edit tiles
	 on the status bar.
	-Removed the item list in this readme, due to its redundancy.
3/2/2019 2.2 small updates
	-Fixed the "()" in the GHB notes.
	-Improved the relative address in the GHB notes.
	-ASM files now display the memory range usage upon patching.