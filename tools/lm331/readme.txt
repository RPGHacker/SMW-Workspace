______________________________________________________________________

 Lunar Magic : Super Mario World Level Editor
 Version 3.31
 September 24, 2021

 FuSoYa's Niche
 http://fusoya.eludevisibility.org
______________________________________________________________________

 CONTENTS
______________________________________________________________________

 1. Credits
 2. Introduction
 3. What's New
 4. Legal Notice
 5. Contact Information

______________________________________________________________________

 1. Credits
______________________________________________________________________


 PROGRAMMING:           FuSoYa (Defender of Relm)

 3RD PARTY ENHANCEMENTS: VRAM optimization patch - smkdan
                          (testing - Vic Rattlehead)
                         Dynamic Levels patch - Vitor Vilela
                         Memory Item 3 Index - BMF
                         FastROM Address List - Ersanio
                         LC_LZ3 patch - edit1754
                         LC_LZ2 patch - Ersanio, edit1754, 33953YoShI,
                                        Min, smkdan
                         LMSW DLL - Alcaro

 DEVELOPMENT TOOLS:     ZSNES debugger, Jeremy Gordon's 65816
                        assembler (custom build), SNES Professional
                        ASM kit (SPASM),SNES9X tracer feature, Naga,
                        Tile Layer Pro, UltraEdit 32, Borland's C++
                        IDE version 5.02, MSVC

______________________________________________________________________

 2. Introduction
______________________________________________________________________

 Lunar Magic is a level editor for the American and Japanese version
 1.00 Super Mario World SNES ROMs, and the SMW portion of the
 American version 1.00 Mario All Stars + World SNES ROM.  It's a
 Windows program with a fairly easy to use WYSIWYG interface that
 includes clipboard and drag/drop support, external level file saving
 and loading, graphics editing, palette editing, enemy support, world
 map editing, text editing, plus numerous 65816 ASM enhancements to
 expand the original game's capabilities.  

 The project was first started in February of 2000, and has been
 worked on and improved at various times over the past 20 years.
 Although the program took a substantial amount of time and effort to
 build along with figuring out how SMW worked, the result has been a
 rather powerful editor that should provide a fairly easy way for
 just about anyone to make their own customizations of this classic
 Mario game.

 Anyway, have fun making your own SMW levels!  ^^


______________________________________________________________________

 3. What's New
______________________________________________________________________


Version 3.31 September 24, 2021 (21 year Anniversary of Lunar Magic!)

-fixed a bug from 3.30 where Control + Shift + Page-Down would no
 longer work in the 8x8 Overworld Tile Selector, although viewing the
 tiles could still be enabled with the new option.  Thanks goes out
 to mariofreak4500 for reporting this.
-fixed a bug from 3.30 where the new custom sprite GFX information in
 the "Add Sprites" window would use the custom GFX information of
 regular sprites without any extra bit set for all extra bit
 settings.  Thanks goes out to Rykon-V73 for reporting this.
-fixed a bug from 3.03 where the "Tile Surface Outlines" view option
 was not immediately updating the outlines when the "POW" view option
 was changed and tile animation was turned off.  Thanks goes out to
 TheBiob for reporting this.
-fixed a bug from 3.00 with the sprite "Smart Spawn" option where if
 it was enabled and you went to the right edge of a 32 screen wide
 horizontal level there was a chance the game could try parsing
 random bytes for the sprite list, causing lag spikes and other
 strangeness.  Thanks goes out to yoshifanatic for reporting this.
-fixed a bug from 3.00 where the "Process While Offscreen" sprite
 flag was not being honored when doing vertical despawning checks in
 horizontal levels.  Thanks goes out to TheBiob for reporting this.
-fixed a bug from 2.41 where the custom user toolbar was not set up
 to correctly wrap on program startup or window maximize/restore. 
 It would only work on window stretching.  Thanks goes out to
 Imamelia for bringing this up.
-fixed a bug from 2.00 where the LM_NOTIFY_ON_NEW_LEVEL option for
 custom user toolbars did not send a notification when saving a
 level with a different level number.  Thanks goes out to Underway
 for reporting this.
-added LM_NOTIFY_ON_SAVE_LEVEL, LM_NOTIFY_ON_SAVE_MAP16, and
 LM_NOTIFY_ON_SAVE_OV to button options for custom user toolbars.
-made it possible to load/save edits to the bottom row of tiles for
 the title screen image, as the game shows the top pixel of this row.
-tweaked undo and delete in the event editor modes of the overworld
 editor so it's a bit nicer about maintaining the current event step
 progress shown.
-removed "Custom Sprites" from the level editor's view menu, as it's
 unlikely anyone needs to turn that off.
-added "Exit Enabled Tiles" to the level editor's view menu to allow
 seeing which tiles are exit enabled in the level editor.  You can
 also have the editor treat custom blocks that use screen exits as
 exit enabled (for undefined exit scans or for viewing) using the
 tooltip file.
-added largest free area within a 32KB bank that can be protected
 with a RAT to "Scan ROM" information, and converted it to a regular
 dialog window.  Also updated the help file on what the values mean.
-conflicting RATs detected using "Scan ROM" will now have their
 locations logged to the RATS.log file.
-added a new "VRAM Patch Options for this ROM" dialog in the options
 menu, which can disable the VRAM patch from being installed if it
 hasn't been already.  This is now a per-ROM setting.
-removed the "Install VRAM Patch on Save to ROM" option from general
 options, as this has now been replaced by the new dialog listed
 above.
-added support for unicode filenames/paths when running on a unicode
 OS.


Version 3.30 May 1, 2021

-added an "Auto-Enable custom palette on edit" option to the level and
 overworld palette editors.
-added edit buttons next to the graphics slots in the bypass dialogs
 that can open the GFX/ExGFX file in an external tile editor.  It can
 also optionally replace the yychr.pal file with the current palette,
 and offer to create the graphics file if it doesn't exist in the
 folder or ROM.  Also added a dialog to configure it in the "File",
 "Graphics" menu.
-added the ability to set separate appearances and tooltips for
 sprites in the editor based on the lower bits of a single extension
 byte (see "Technical Information" in the help file for more details).
-added the ability to display custom sprite GFX information in the
 "Add Sprites" window (see "Technical Information" in the help file
 for more details).
-made it so that original sprites that are set to have extra bytes
 will still display the sprite in the preview area for the original
 lists in the "Add Sprites" window.
-added a bit of ASM code to store the level number to $10B, as some
 people may find it useful.
-added an option to General Options that allows the 8x8/16x16 editors
 to show other tiles without having to press Control + Shift +
 Page-Down, which is disabled by default.
-added an option to DirectX windows for 100% zoom increments.  Note
 that with this enabled and the zoom filter option disabled, you can
 now get the same non-filtered zoom display and behavior of past
 versions without having to disable the DirectX option and restarting
 the program.
-removed the option in General Options for disabling the menu for the
 zoom button, as it probably isn't used much these days.
-added a new option to the "Extra Options" dialog of the overworld
 editor that controls if translucency (CGADSUB) is enabled for
 palettes C-F in sprites when the event path fade effect is off.  This
 will now be turned off by default when you disable the path fade
 effect, in case you want to use those palettes for regular
 non-translucent custom sprites.
-made it possible to type level and event numbers in the drop down
 list boxes for some of the overworld editor dialogs.
-changed the remap button in the 8x8 Overworld Tile Selector window so
 that it applies to all tiles by default in layer 3 editing modes
 unless you use F9.
-made it so that when you copy a tile to the windows clipboard in the
 8x8 tile selector of the Map16 editor or the 8x8 tile selector of the
 overworld editor, it will also copy the tile's hex value in text to
 the clipboard so you can paste it into edit fields in the ExAnimated
 Frames dialogs.
-fixed a bug from 3.20 where if you used any of the 8x8 Overworld Tile
 Selector Tools to make changes to a selected area in the overworld
 then attempted to resize it as a pattern of tiles, the tiles would
 first revert back to how they were before the changes were made. 
 Thanks goes out to BlueToad for reporting this.
-fixed a bug from 3.20 where if the DirectX option was on, animation
 was off and zoom was at a multiple of 100%, the level/layer
 2/overworld editor windows would sometimes appear to scroll 1 tile
 too far with a row/column of tiles repeated until the screen was
 refreshed.
-added a fix for sprite EF (scroll layer 2 sideways) so that it can
 now be used in tall horizontal levels and not just in vertical
 levels.
-adjusted palette used for a tile in sprite A2 (MechaKoopa) in LM so
 it will appear the same way in the editor as it will in the game. 
 Thanks goes out to WhiteYoshiEgg for reporting this.
-added a warning about palette usage to the Big Boo Boss tooltip. 
 Thanks goes out to Klug for bringing this up.
-the .msc, .dsc, .ssc, .sscov, .extmod, and usertoolbar.txt files
 must now use UTF-8.  Existing english text files are not affected,
 but other languages will need to change the encoding used for
 those files.


Version 3.21 October 24, 2020

-fixed a bug from 1.80 where the restore system would not correctly
 restore auxiliary files that were larger than 64KB although the
 files in the restore point were intact.  This was more noticeable in
 version 3.20 as the .s16 file for custom sprite Map16 went beyond
 64KB for the first time.  Thanks goes out to Imamelia for submitting
 his ROM folder to figure this out.
-made it so that saving the .s16 file in the Map16 editor for custom
 sprite Map16 only saves up to the last page of data that was
 actually used.


Version 3.20 September 24, 2020 (20 year Anniversary of Lunar Magic!)

-added an option to general options to use DirectX 9 in the main
 level editor window, background layer 2 editor window, and the
 overworld editor window, which allows using a zoom filter.  If
 DirectX is not available, it will automatically fall back to using
 GDI instead.
-added a zoom filter option to the zoom menu for windows that use
 DirectX, along with a few more zoom levels (125%, 150%, 175%).  Also
 made it so that using Zoom in/Zoom out (Ctrl+Scroll Wheel) in those
 windows will go in increments of +/-10% when DirectX is available.
-added a button to the main level editor that opens the overworld
 editor and loads layer 3 of the level into it.
-made it so that if layer 3 of the level is loaded in the overworld
 editor and tile animation is on, changes in the overworld editor are
 reflected immediately in the level editor.
-added the ability to display sprites in the editor using external
 graphics by making it possible to set the base graphics for
 individual sprite Map16 tiles in the sprite tooltip file (see the
 help file for more details).  The external graphics must be in the
 "ExternalGraphics" folder and be named "ExSpriteGFXxx.bin" where
 "xx" can be from 00-07 and the files can be up to 32KB in size
 (these files are currently loaded starting at page 0x20).
-added the ability to display sprites in the editor using external
 palettes using a setup similar to external graphics (see the help
 file for more details).  The external palettes must be in the
 "ExternalGraphics" folder and be named "ExSpritePalette00.mw3" (or
 "ExSpritePalette00.pal") and can hold up to 0x400 palettes of 0x10
 colors.
-added an extra 0x18 pages for custom sprite Map16 data.
-added an "Export Multiple Levels to Image Files" item to the "File",
 "Levels" menu which can export multiple levels to images at once.
-added an option to report on music tracks used in levels to the
 "Analyze Resources in Levels" menu command.
-added an option to use custom command line arguments for running the
 currently loaded ROM in an external emulator.
-added an option to "General Options" to show old/obsolete menu
 items, which are now hidden by default.
-added the ability to fill an area in the Background Editor with a
 pattern of tiles from either a selected area in the Background
 Editor (with Shift + Right Click) or from the Map16 Editor (with
 Control + Shift + Right Click).
-added the ability to resize an area in the Background Editor as a
 pattern of tiles by using the mouse on resize borders, similar to
 how you can resize Direct Map16 objects in the level editor.
-added the ability to resize an area in the Overworld Editor in Layer
 1 16x16 Editor Mode or Layer 2 8x8 Editor Mode as a pattern of tiles
 by using the mouse on resize borders, similar to how you can resize
 Direct Map16 objects in the level editor.  With 8x8 editing however,
 you must hold down the control key to get the mouse resizing cursor
 if zoom is below 200%.
-added an option to the overworld editor that forces using the
 control key to resize a group of tiles.
-added buttons to clear text and clear all text to the "Edit Boss
 Sequence Text", "Edit Message Box Text", and "Edit Level Names"
 dialogs of the overworld editor.
-added LM_NO_CONSOLE_WINDOW as a button option for user toolbars,
 which can be useful for running .bat files or other console programs
 without showing a console window if they never require user input.
-updated the sprite 19 fix (for displaying level message 1) so it
 will no longer cause the intro level to change from 0xC5/0x1C5
 depending on the starting submap, and made it now install
 automatically on level/overworld save.  However to avoid disruption
 for people with older hacks, it will not change the existing
 0xC5/0x1C5 behavior if the old fix is installed.  Also Shift+F8 will
 remain available to cause the 0xC5/0x1C5 behavior for those that
 still want it for porting older hacks.
-removed the warning option for when sprite 19 is used without the
 fix, as it's no longer needed.
-added a new option to the overworld editor that can save the game
 after the intro message with sprite 19 even if Mario's starting
 position on the overworld has been changed (normally that save gets
 disabled along with the intro march on the overworld if the position
 is changed).
-fixed a small issue from 3.00 where the "Scan Exits on Save to ROM"
 option didn't exclude exits to the overworld when checking the level
 destination.  Thanks goes out to Ninja Boy for reporting this.
-fixed a bug from 3.00 where if Mario did a cape spin while entering
 a pipe he would do zigzags when shot out of a diagonal pipe.  Thanks
 goes out to Aurel509 for reporting this.
-fixed a bug in the original game with sprites 0xC9 and 0xCA (Bullet
 Bill shooter and Torpedo Launcher) that can cause the game to keep
 reading right past the end of the level's sprite data which could
 cause lag, seemingly random sprites to appear, or a bunch of green
 Koopas without a shell to appear.  Thanks goes out to Tattletale for
 reporting and submitting the fix for this.


Version 3.11 February 9, 2020

-fixed a bug from 1.70 in smkdan's VRAM patch where pipes on layer 2
 in a horizontal level may be displayed with the wrong colors on
 level load, which changed to the right colors if the player left the
 initial screen and came back.
-fixed a bug from 2.20 for SA-1 ROMs where Conditional Direct Map16
 objects could not read their RAM table.  Thanks goes out to
 HammerBrother for bringing this up.
-fixed a display issue in the overworld editor where it was still
 showing how the original game handled destroying castle tiles placed
 at Y=0xF or 0x2F even though it was already fixed in-game for 3.10. 
 Thanks goes out to Thomas for reporting this.
-made it possible for 3rd party sprite programs to notify LM that the
 sprite count limit per level has been increased to 255 to avoid the
 sprite count warning message appearing.
-added an option to disable all the hardcoded default layer 1 paths
 to the overworld's "Extra Options" dialog.
-added a new "Fast" layer 3 scroll setting that uses a 1.2:1 scroll
 rate, which goes faster than layer 1.  This is intended for the type
 of foregrounds you can see in SMW2:Yoshi's Island.


Version 3.10 September 24, 2019 (19 year Anniversary of Lunar Magic!)

-added support for tides in horizontal levels that are taller than in
 the original game.
-added support for having vertical scroll in tide levels when you use
 the "Constant" vertical scroll option for layer 3.
-made the layer 3 auto-vertical scroll options detect tides to
 support vertical scroll of the level.
-added support for negative Y scroll offsets for layer 3 and greatly
 expanded the possible range of values (-400 to 3FF) to better allow
 for adjusting the tide height.  The layer 3 scroll offsets are also
 now displayed in units of 16x16 tiles instead of pixels.
-made it possible to have tides in horizontal levels that are 1-2
 screens wide if you enable the advanced bypass settings in LM.
-added support for tides in vertical levels if you enable the
 advanced bypass settings in LM (minimum level height of 2 screens
 required).
-added a new setting for layer 3 that lets you make the tides act as
 water, 3 types of lava, solid, or tiles 0x200-0x20A.
-added a new setting that makes sprites beyond level boundaries
 interact with air instead of water, which should usually be turned
 on for tides.
-added ExportSharedPalette, ImportSharedPalette, ExportAllMap16,
 ImportAllMap16, ExportMultLevels, ImportMultLevels,
 TransferLevelGlobalExAnim, TransferOverworld, TransferTitleScreen,
 TransferCredits, ExportTitleMoves, ImportTitleMoves to command line
 functions.
-added a separate "Auto-Set Number of Screens" option to the "Import
 Multiple Levels from File" dialog.
-added an extra 0x10 pages for custom sprite Map16 data.
-added a new ASM hack to make it so that revealing/destroying
 overworld layer 1 tiles will show tiles from the same page instead
 of temporarily showing tiles from page 0.
-fixed an issue in the original game where castle tiles placed at
 Y=0xF or 0x2F on the overworld would not collapse correctly when
 destroyed.
-fixed a crash bug from 3.00 that happened if you tried to right
 click to paste objects/sprites in a boss battle level that can't be
 rendered.  Thanks goes out to TheBiob for reporting this.
-fixed a bug from 2.30 where using the %5 placeholder in custom user
 toolbars would cut off the rest of the string.  Thanks goes out to
 SmokedSeaBass for reporting this.


Version 3.04 June 1, 2019

-fixed a crash bug from 3.03 that could happen if the "Select All"
 command was used on objects in the level editor that were then moved
 or deleted.
-fixed a crash bug from 3.02 that would occur if you tried to do a
 remap in the Map16 editor on pages A3+.  Thanks goes out to Koopster
 for reporting this.
-fixed a bug from 3.00 where if you went beyond the top of the level
 with Yoshi, he could eat berries that were on the previous screen. 
 Thanks goes out to Thomas for reporting this.
-fixed a bug in the original game where if Mario flew beyond the top
 of the level, he might interact with block numbers formed by the
 lower 8 bits of a block number that another sprite was interacting
 with.  This was particularly noticeable if the resulting block
 number was for an invisible question block or jumping note block. 
 Thanks goes out to Thomas for reporting the issue that led to
 figuring this out.
-fixed an issue from 2.20 for SA-1 ROMs where if you re-enabled the
 path fade effect and saved the overworld, a warning message about a
 failed pointer remap would appear (although the ROM would be fine). 
 Thanks goes out to DPBOX for submitting the hack that revealed this.
-made the "Block Contents" view option show the contents somewhat
 translucent.
-added a few extra options for the "Analyze Resources in Levels" menu
 command.


Version 3.03 April 1, 2019

-fixed an issue with some code in the original game where if Mario was
 above screen 0 in a horizontal water level, there was a chance it
 could cause the game to freeze (with LM 1.30+) or crash (depending on
 code inserted by block tool programs).  Thanks goes out to
 GreenHammerBro for reporting this.
-fixed a bug from 2.43 where using F3 to copy then paste a color in
 the palette editors would temporarily display the original PC color
 instead of the converted SNES color, and the converted SNES color
 could be slightly off from what it should have been.  Thanks goes out
 to DPBOX for reporting this.
-added "Block Contents" to the level editor's view menu to allow
 seeing the contents of question blocks, etc in the level editor.  You
 can also specify contents to show for custom blocks using the tooltip
 file.
-combined viewing the main, midway, and secondary entrances into a
 single menu item to simplify the view menu a bit and reclaim a couple
 keyboard shortcuts.
-added "Analyze Resources in Levels" to the level editor's "File",
 "Levels" menu that can check which Map16 tiles, GFX/ExGFX files, and
 sprites are used in which levels then generate a text file report.
-added "Select All" to the level editor's "Edit" menu for selecting
 all sprites or objects of the layer you're editing, depending on
 which mode you're in.
-made the extension field in Add Object/Sprite Manual dialogs wider. 
 You can also now put optional spaces between the values.
-coordinates in the status bar of the level editor are now in hex
 instead of decimal.


Version 3.02 February 9, 2019

-fixed a bug from 3.00 where ROMs upgraded from version 2.43 or
 earlier of LM (meaning you had never used 2.5x on it) didn't convert
 secondary entrances that used method 2 for horizontal levels,
 resulting in their positions being reset to the top subscreen.  If
 you've already used 3.00/3.01 on such a ROM, you can fix it for all
 levels by using Alt+Shift+F11 in this version then saving the current
 level.
-fixed a crash bug from 2.50 that would occur if you imported a Map16
 file in the Map16 editor while the remap dialog in the BG Editor was
 open at the same time.  Thanks goes out to MarioFanGamer for
 reporting this.
-fixed a limitation in the original game with tileset specific object
 33 (forest tree top) so that it will now work correctly at any Y
 offset instead of just Y=10 to 15.  This also fixes it to work in
 horizontal levels that have different heights than the default. 
 Thanks goes out to Shiny Ninetales for reporting this.
-added "Line Guide Outlines" as an option in the view menu, for cases
 where you want to use line guided tiles yet don't have the right
 graphics loaded to see them.
-added the ability to set a rectangle of Map16 tiles to use a
 rectangle of "Act as" settings with the specified base (such as
 R200-211,S25) in the Map16 editor's remap dialog.


Version 3.01 January 1, 2019

-fixed a bug from 3.00 where vertical levels with a "No Yoshi" intro
 would have tiles missing in the intro.  Thanks goes out to Shiny
 Ninetales for reporting this.
-fixed a bug from 3.00 where if there was only a horizontal scroll
 bar you couldn't use the scroll wheel to move objects
 backwards/forwards by one.  Thanks goes out to Daizo Dee Von for
 reporting this.
-fixed a bug from 2.41 where the warning for sprite 19 (display level
 message 1) could be triggered in level 0xC5 when using the "Import
 Multiple Levels from File" function.  Thanks goes out to
 WhiteYoshiEgg for reporting this.
-fixed a bug in the original game where if you placed Mario's starting
 position near the far right side of a horizontal level, the game
 would not set the initial X scroll position correctly.


Version 3.00 December 25, 2018

-integrated an ASM hack submitted by Vitor into LM that allows
 changing the height of horizontal levels, effectively making it
 possible to change the level dimensions.  You can find the new
 setting controlling this in the "Change Properties in Header" dialog,
 along with a new option that lets you view the full bottom row of
 tiles in horizontal levels.
-the sprite loader now has a cache added by Vitor to reduce the
 performance impact from parsing most of the sprite list to access
 sprites on later screens.
-added a setting to the "Change Properties in Sprite Header" dialog to
 control the sprite vertical spawning range for horizontal levels and
 an option for smart spawning.
-levels can now have up to 128 sprites instead of 84 for non-SA1 ROMs.
-a limitation of the original game where sprites could not start with
 an FF byte has been removed (previously LM would silently move the
 sprite on save when it encountered this to avoid premature
 termination of the sprite list for the level).
-in vertical levels most objects will no longer break up on horizontal
 subscreen boundaries (but they still will on vertical ones).
-added an option for entrances to use a new FG/BG init system which
 can set the FG relative to the player, and calculates the BG position
 relative to the FG position, scroll settings, level height, and BG
 height.  The BG height is a new setting in the "Change Other
 Properties" dialog, along with an option to just set the BG relative
 only to the FG which is meant mainly for layer 2 levels.
-added 4 new vertical scroll settings for layer 2 (Variable 2,
 Variable 3, Variable 4, and Slow 2).  Note that these take up slots
 that were previously blank (H/V Scroll of None), so you may want to
 double check your scroll settings in older levels.  To have H/V
 scroll set to None, you should be using the 4th entry in the list
 rather than one of the later ones.
-added a new option for entrances to have Mario face the left
 direction.
-made it so that using the "Shoot From Slanted Pipe Right" entrance
 action combined with the "Face left" option will make Mario shoot
 left instead of right.
-added a new option for midway entrances to redirect a midway
 entrance to another level.  This allows you to have the midway
 entrance for an overworld level be in another level entirely.
-added a new option for secondary entrances to make the level a water
 level.  Note that the older option for the same thing in screen exits
 can also still be used.
-added a new option for secondary entrances to exit to the overworld. 
 You can also optionally set an exit to the overworld to pass the
 level with the normal/secret exit of your choice or just switch
 players, use a different base event when passing the level, and
 teleport to a different location.
-added a new toolbar button to the overworld editor that can set
 secondary exit teleport locations, which uses the same table as the
 Star/Pipe tiles.
-made it possible for the overworld Star/Pipe index table to hold
 twice as many entries (0x100), to accommodate secondary exit
 teleport locations.
-made it possible to use Secret Exit 2 and Secret Exit 3 in the game. 
 This means the overworld editor now has direction to enable settings
 on level tiles for both of these, and the Secret Exit 2 and Secret
 Exit 3 goal point tape sprites have been added to the sprite list.
-made it possible to change level tile settings for tiles 0x82-0x86 in
 the overworld editor.  While they can't be entered as levels, they
 are valid stopping points so this allows you to assign them a level
 number in case you want them to display a name or give them initial
 enabled directions.
-moved the music and time limit settings from the "Change Properties
 in Header" dialog to the "Bypass Music and Time Limit Setting"
 dialog, then renamed the latter to "Change Music and Time Limit
 Settings".
-made it so that when you copy a color to the windows clipboard in the
 palette editors, it will also copy the SNES RGB hex value in text to
 the clipboard so you can paste it into edit fields in the ExAnimated
 Frames dialogs.
-added a new toolbar button to the level editor and overworld editor
 that will insert all GFX and ExGFX then reload the graphics.
-added a new view menu option that allows viewing tile surfaces.  This
 is mainly meant for showing the shape of slopes and for revealing if
 a tile is solid or not.
-added a few basic command line functions for some common operations. 
 See the technical section in the help file for more info.
-added a new option to the overworld editor that allows disabling the
 Forest of Illusion ghost from being hidden until an event has been
 passed.  Also made it so you can change the events that it gets shown
 on.
-when linking star/pipe tiles, the program no longer requires that the
 second tile be a star/pipe tile.  This makes it easier to create
 warps from a star/pipe tile to tiles that you can't warp from.
-changed the Modify Screen Exits dialog to allow typing full values
 directly into the index combo box for faster selection.
-changed how the "Insert Manual" dialog works for objects and sprites
 in the level editor.  Instead of specifying X/Y and the screen
 number, LM will now simply insert the object or sprite near the upper
 left corner of the level editor window.
-made it so that the sprite size table is loaded on level load, not
 just on ROM load.
-added "Delete All" to the level editor's "Edit" menu, which was
 previously only available through the Ctrl+Del keyboard shortcut.
-moved Shift+Scroll Wheel for Bring to Front/Send to Back to
 Ctrl+Alt+Scroll Wheel, added Ctrl+Shift+Scroll Wheel for vertical
 scroll, and made Shift+Scroll Wheel and Ctrl+Shift+Scroll Wheel
 unaffected by objects/sprites selected.
-tweaked some code so that scroll bar thumbs are now sized
 proportionally more like the way you'd expect.  Thanks goes out to
 Vitor for pointing this out.
-fixed a bug from 2.43 where the undo/redo/F3 keys in the palette
 editors would not function while any other modal dialog window in the
 program was open at the same time.
-fixed a crash bug from 2.30 that could occur under certain
 circumstances when selecting tiles in the Layer 1 Event Editor Mode
 of the overworld editor.  Thanks goes out to Wiimeiser for reporting
 this.
-fixed a bug from 2.30 where if you saved a level then used undo to
 revert a change to a secondary entrance then saved again without
 making any other changes to secondary entrances, LM would not save
 the reverted change for the secondary exit.  Thanks goes out to Ramon
 for reporting this.
-fixed a bug from 1.70 in smkdan's VRAM patch where if you rapidly
 scrolled past the top of the BG image (such as by setting layer 2's
 vertical scrolling to constant), there was a chance you could get a
 brief 1 frame glimpse of a couple rows of pixels at the top or bottom
 of the screen showing the wrong tiles.  Thanks goes out to Vitor and
 Super Maks 64 for reporting this.
-fixed a bug from 1.10 where the program would not
 load/save/export/import the last color of the Special World shared
 palettes for when Special World had been passed.  Thanks goes out to
 yoshifanatic for reporting this.
-corrected the description for Mario Action 7 of midway entrances to
 "Do Nothing or Pipe Exit Down (Water Level)" and changed how it's
 displayed in LM.  Normally midway entrances that use this setting
 skip the pipe exit part.  It never came up in the original SMW
 levels, though it seems to have been used in SMA2.  However it still
 acts as a pipe entrance if accessed via a screen exit.  To avoid
 confusion, it may be better to instead use the "Vertical Pipe Exit
 Down" action with the separate "Make this a Water Level" setting.
-renamed Layer 1 vertical scroll setting 2 to "No Vertical Scroll at
 Bottom unless Flying/etc" to more accurately describe what it's for. 
 Also adjusted the code for this setting to work for horizontal levels
 that have different heights and vertical levels.
-fixed an issue in the original game where when switching between
 levels if you entered a level with layer 2 horizontal scrolling set
 to None, the layer 2 X position was carried over from the last level
 instead of being reset to 0 like it does when entering from the
 overworld.
-fixed an issue in the original game where if a "No Yoshi" entrance
 intro is activated for a vertical level, the layer 2 Y position in
 the intro could be wrong and even possibly display garbage tiles.
-fixed an issue in the original game where using a pipe exit at the
 very top of a vertical level could malfunction if Mario's Y
 coordinate ended up being beyond the top of the level.
-added a fix for the original game where the sprite load status for
 indexes 64-127 were not cleared between sublevels, leading to some
 sprites not appearing if a sprite at that index was killed in
 another sublevel.
-adjusted tile used for sprite 99 (Volcano Lotus) in LM so it will
 appear the same way in the editor as it will in the game.  Thanks
 goes out to WhiteYoshiEgg for reporting this.
-added a bit of info for sprite 70 (Pokey), as it can't detect if
 Mario is riding Yoshi if it's within spawning distance of Mario
 entering the level.  Thanks goes out to Wiimeiser for pointing out
 that something was up with this.


Version 2.53 February 9, 2018

-fixed a bug from 2.40 with ExAnimation on the overworld where if you
 tried to use multiple slots for the same destination tile to do
 faster animations, the frames would not always appear in the order
 you'd expect.  Thanks goes out to Noivern for reporting this.
-if overworld ExAnimation is installed, it will also now fix a small
 issue present in the original game where the bottom waterfall tile
 animation would not consistently match up with the main waterfall
 tile.
-fixed a glitch in the original game where sprite 52 (moving ledge
 hole) would appear in the wrong position if placed at the top of a
 sub-screen.  Thanks goes out to Thomas for discovering this, and
 zacmario for reporting it.
-fixed a minor issue from 1.70 where the timing of the victory pose
 at the end of the level didn't really match up to the music in
 non-SA1 ROMs.
-corrected info on sprite 45 (directional coin) as it does in fact
 have a time/coin limit.  Thanks goes out to Katerpie for reporting
 this.
-replaced some non-standard apostrophe chars in some tooltips in the
 General Options dialog that could get displayed oddly on non-english
 systems.  Thanks goes out to Akaginite for reporting this.
-fixed a small issue that's been around forever where using a mouse
 gesture on a screen exit that goes to a vertical level did not
 scroll the screen for the corresponding entrance of that level into
 view.
-made it possible to use Ctrl+Alt+F7 in level editor for advanced
 users to edit more local ExAnimation slots by sacrificing global
 slots (when global animations have been disabled for level/submap).
-made it possible to use Ctrl+Alt+Shift+F8 in overworld editor for
 advanced users to enable editing more levels and events (the game
 does not currently support this at the moment, so don't enable it
 unless you're adding your own ASM for it).
-added the ability to drag and drop a ROM, mwl, map16, or palette
 file into the main level editor window to open the file.
-made it possible to use Alt-Middle click to edit screen exits.
-added LM_MOUSE_EDIT_SCREEN_EXIT to function names for user toolbars.
-added an option to open levels at the main level entrance.
-added an option to pause animations when the program loses focus.
-added an option to display the ROM file name and path in the main
 window title bar.


Version 2.52 September 30, 2017

-fixed a bug from 2.50 where SA-1/SFX ROMs upgraded from a previous
 version of LM could use the wrong "Act as" settings during gameplay
 after the Map16 was saved. Resaving the Map16 in this version will
 correct the issue.  Thanks goes out to Christian07 for reporting
 this.


Version 2.51 September 25, 2017

-fixed a crash issue from 2.50 with the 8x8 tile selector in the Map16
 editor.  Thanks goes out to yoshifanatic for reporting this.


Version 2.50 September 24, 2017 (17 year Anniversary of Lunar Magic!)

-made it possible to resize objects from top/left and related
 corners, for most objects that support it.  Note that a few objects
 that resize in increments larger than 1 or in opposite directions
 may seem to resize a bit oddly.
-Map16 space has been expanded to 2x the previous limit.  There are
 now 0x80 pages for FG Map16, and 0x80 pages for BG Map16.  Note that
 if you use a third party block tool type program, you shouldn't use
 the new FG tiles (0x4000-0x7FFF) in LM until your program has been
 updated to deal with the new max.
-expanded the number of secondary exits in the game to 0x2000, up
 from 0x200.
-changed the Modify Secondary Entrances dialog to allow typing full
 values directly into the index combo box for faster selection.
-added tooltips to sprites in the overworld editor.
-added the ability to add custom sprites in the overworld editor with
 the insert key.  Note that these require an external third party
 patch to show up in the game.
-made it possible to use alt-right click in the overworld editor to
 modify custom sprites.
-made it possible to use right click in the overworld editor to copy
 custom sprites.
-made it possible to customize sprite appearances and tooltips for
 sprites in the overworld editor (editor display only).
-added LM_FILE_RELOAD_ROM and LM_MOUSE_SCREEN_EXIT to function names
 for user toolbars.
-added VK_MBUTTON, VK_XBUTTON1, VK_XBUTTON2 (for middle mouse button,
 mouse button 4, mouse button 5) to keyboard definitions for user
 toolbars.
-fixed a bug from 1.70 where the ExAnimation dialog would limit the
 max number of frames to 0x80 based on the slot's type when it was
 supposed to be based on the trigger.  Thanks goes out to Skewer
 for reporting this.
-fixed a bug from 2.43 that allowed saving with an invalid level
 number.  Thanks goes out to KDeee for reporting this.
-fixed a bug from 2.30 where if you used LM's layer 3 auto-scroll
 on tide levels with buoyancy enabled that were 3-8 screens long,
 sprites would tend to act like they were in water periodically even
 if they weren't (note that this still happens for levels 1-2
 screens long, but the original game also does this).  Thanks goes
 out to Thomas for reporting this.
-adjusted some code so that closing the overworld editor while
 minimized would no longer cause a few odd things on reopening. 
 Thanks goes out to Erik557 for reporting this.


Version 2.43 December 25, 2016

-added a new keyboard shortcut of F3 to the palette editors to allow
 copying the color of any pixel on the computer screen to the windows
 clipboard.  Note however that the palette editor must have the
 window focus, and it may not work on all windows or protected media.
-enabled undo/redo keyboard shortcuts in palette editors.
-updated filter in Add Objects window for extended object 7F (skull
 and crossbones) for ghost houses.  Thanks goes out to imamelia for
 reporting this.
-adjusted the appearance of sprite 0x7A (fireworks) in the editor to
 match the game.  Thanks goes out to Footsteps_of_Coins for reporting
 this.
-made it so that if you attempt to go past the min/max level in the
 level editor, it won't bother with bringing up the save dialog. 
 Thanks goes out to Erik557 for noticing this.
-saving level 0 or 100 to a different level number will no longer
 mark half the available secondary entrances as used if the "transfer
 secondary entrances" option was on.
-tweaked some code to workaround coordinate rounding issues in
 Microsoft's DPI virtualization code that can occasionally violate
 ClipCursor functionality.
-added "System DPI Aware" option to general options, to avoid DPI
 virtualization done by Windows Vista and later when possible.


Version 2.42 February 9, 2016

-fixed a crash bug from 2.40 that could occur under certain
 circumstances with the Background Layer 2 Editor.  Thanks goes out
 to Luks for reporting this.
-added tooltips for the preview icons in the Add Objects/Sprites
 windows.
-added 2 forest tileset specific ledge edge subobjects to the "Add
 Objects" list that had been overlooked.  Thanks goes out to
 yoshifanatic for reporting this.
-increased the tile tracking limit per object to account for largest
 possible DM16 size.  Thanks goes out to yoshifanatic for reporting
 this.
-enabled rest of SuperFX RAM remap from 2.41.


Version 2.41 December 25, 2015

-fixed sprites not triggering custom block ASM when touched from the
 side in layer 2 levels on layer 2.  Apparently it's been this way
 for as long as custom blocks have existed (version 1.30).  The fix
 will be installed when the Map16 is saved.
-added proper medium auto-scroll sprite F3 with extra bit of 1 to the
 sprite list and updated the tooltip about using other Y positions. 
 Thanks goes out to imamelia for reporting this.
-added the ability to make custom Map16 tiles in the level editor
 appear translucent using the custom tooltips for Direct Map16 file. 
 Check the help file for more info.
-added an option that will display a warning when using sprite 19
 (display level message 1) in a level other than level 0xC5 when the
 fix for it has not yet been installed.
-added an option that allows toolbar buttons in the main level editor
 and overworld editor windows to wrap if there isn't enough room to
 display them on one row.
-added "All Objects" list and "All Sprites" list to the Add Objects
 and Add Sprites windows.
-added another area for SuperFX RAM remap.


Version 2.40 September 24, 2015 (15 year Anniversary of Lunar Magic!)

-added a new ASM hack to implement ExAnimation for the overworld,
 which is based on the same system as the one for levels.  Check the
 help file for more details and a small list of differences from
 level ExAnimation.
-added a new ASM hack that expands the number of overworld exit path
 indexes to 0x80.
-made the previously unofficial support for the Super FX ROM map
 official, along with support for a future Super FX RAM remap patch.
-added a dialog to the overworld options menu that allows you to
 change the rate of animation the editor uses.
-made the bowser sign sprite in the overworld editor animated.
-made it possible for the overworld editor to display the lightning
 palette animation.
-added an option to make the overworld palette lightning animation
 use colors from the ROM instead of the working copy of the palette
 in the overworld's "Extra Options" dialog (frees up colors 9-F of
 palette 2 for maps that use lightning).
-added an option to disable player life exchange in the overworld's
 "Extra Options" dialog.
-added an option to disable player life exchange using L/R only in
 the overworld's "Extra Options" dialog.
-moved the keyboard shortcuts for loading/saving the credits in the
 overworld editor from Ctrl+F11/F12 to Shift+Alt+F11/F12 so that the
 same shortcuts used in the level editor for ExAnimation triggers
 can also be used in the overworld editor.
-added "Bring to Front" and "Send to Back" menu commands for
 objects/sprites in the level editor.  You can also activate these
 with the mouse scroll wheel by holding shift while objects/sprites
 are selected.
-added "Bring Forward" and "Send Backward" menu commands for
 objects/sprites in the level editor as replacements for
 Increase/Decrease Z Order.  These act much like the latter, but
 will skip past non-overlapping objects on the same screen so that
 you don't have to use the command as much.
-assigned keyboard shortcuts for the older "Increase Z Order" and
 "Decrease Z Order" to Ctrl+Alt+Shift+Plus/Minus, and removed them
 from the edit menu as they likely won't be used much anymore.
-added support for .palmask files.  These provide a method for
 palette files to specify which colors in the palette should be
 imported into your level.  Also added a couple new buttons to the
 palette editor to work with this.  Check the palette editor section
 in the help file for more details.
-changed the Super GFX Bypass and Layer 3 Bypass dialogs to allow
 typing full values directly into the combo boxes for faster
 selection.
-added an option to the "Restore Point Options" dialog that scans
 the user area of the ROM for nested RATs on Full Restore Point
 creation.  This can sometimes help detect data loss and corruption
 caused by third party tools and patches.  Previously a user had to
 initiate a scan themselves if they wanted to check on this, which
 meant issues could go unnoticed for long periods of time.
-added an option to the "General Options" dialog to notify the user
 when RATS.log is written to.  Also adjusted the information
 reported in the log file a bit.
-added a "Scan ROM" item to the file menu, which reports some
 information about the ROM user area.  This has actually been around
 for a very long time via a keyboard shortcut, but not everyone was
 aware of it.
-made it possible to display a custom image in the black
 non-editable areas of the level editor, background editor and
 overworld editor for cosmetic purposes.  Check the help file for
 more info.
-added several more levels of zoom to all editors that have a zoom
 button.
-added an option to the "General Options" dialog that allows zoom
 buttons to either bring up the zoom menu or to act as a toggle
 between default zoom and the last used zoom setting (2x by default).
-made it possible to zoom in/out with the mouse wheel while holding
 down the control key.  Also added an option to turn this off in the
 "General Options" dialog.
-moved the "Conditional Direct Map16 On" keyboard shortcut in the
 level editor from Ctrl+0 to Ctrl+5 so the former can be used as a
 zoom shortcut.
-added DPI scaling for the toolbar button images for when the
 minimum height adjusted for the screen's DPI is more than 25%
 larger than the image provided.
-added basic DPI scaling to the 8x8 editor, in 50% increments.
-improved mouse scroll wheel support.  You can also now scroll
 horizontally with the wheel when there is no vertical scroll bar or
 by holding down the shift key.
-added the ability to fill an area of the overworld with a pattern
 of tiles in Layer 2 8x8 Editor Mode from either the selected area
 in the overworld (with Shift + Right Click) or from the 8x8
 Overworld Tile Selector window (with Control + Shift + Right Click).
-made it so that left clicking a tile in Layer 1 Event Editor Mode
 in the overworld editor also selects the tile in the Layer 1 16x16
 Tile Selector.
-made it so that left/right clicking in Layer 1 Event Editor Mode in
 the overworld editor will update the submap palette selected in the
 palette editor and the submap palette/graphics used in the Layer 1
 16x16 Tile Selector.
-made it so that left/right clicking in Layer 2 Event Editor Mode in
 the overworld editor will update the submap palette selected in the
 palette editor and the submap palette/graphics used in the Layer 2
 Event Tile Selector.
-made the Layer 2 Event Tile Selector window for the overworld
 editor twice as high to show more tiles at once.
-moved the older Star/Pipe/Exit dialogs to a submenu.
-gave pitchin' chuck slightly different poses when displayed in the
 editor depending on how many balls he throws.
-added LM_NOTIFY_ON_CLOSE, LM_NOTIFY_ON_CLOSE_FORCE_ALL,
 LM_AUTORUN_ON_NEW_ROM, and LM_NO_AUTORUN options plus a %8
 placeholder to get the current version of LM for user toolbars.
-removed window visibility checks on notification messages sent by
 LM to programs started from the user toolbar.  Thanks goes out to
 HyperHacker for reporting this.
-fixed a display bug from 1.70 where ExAnimations that used the
 "Precision Timer Palette Rotate" trigger would be displayed by the
 editor at a wrong or uneven speed.  The editor also now emulates
 the side effects of incorrect usage of this trigger.
-fixed a display bug from 2.30 where performing an undo in the
 overworld editor while in one of the event editor modes would not
 show undone changes in the layer 1 Map16 data or Layer 2 source
 event tiles until after you had switched out of that mode.
-fixed a bug from 2.30 where editing screen exits did not add an
 undo, yet could still be undone by a prior undo even though the
 editor would not update the display of screen exits right away. 
 Thanks goes out to Hinalyte for reporting this.
-fixed a bug from 2.30 where double clicks in the new BG editor
 didn't take into account scrolling.  Thanks goes out to
 yoshifanatic for reporting this.
-changed the appearance of overworld path tiles 0xC and 0x13 (which
 are unused in the original game) to match land versions of path
 tiles 0x30 and 0x3A.  Functionally they act the same way, but the
 8x8 tiles Nintendo used suggests they were intended to be used as a
 visual guide for this.  Also added an option to the view menu to
 display them the old way.  Thanks goes out to Wiimeiser for
 pointing this out.
-made it so that the preview icons in the Add Objects and Add
 Sprites windows will update when certain view options are changed. 
 Thanks goes out to Thomas for reporting this.
-slightly tweaked tile movement on right click pasting in the
 overworld editor for layer 1 event editor mode.  Thanks goes out to
 Wiimeiser for bringing this up.
-added alternate GFX file info for sprites 33 (vertical fireball)
 and B6 (reflecting fireball).  Thanks goes out to Footsteps_of_Coins
 for reporting this.
-added alternate GFX file info for sprite 1B (bouncing football). 
 Thanks goes out to Katerpie for reporting this.
-corrected info and appearance for sprite D4 (bubble generator with
 goombas and bob-ombs), as it will also generate fish in bubbles
 after some time has passed.  Thanks goes out to Thomas for
 reporting this.
-moved sprite 8E (warp hole) from "Tileset Specific" list to
 "Special Commands and Generators".


Version 2.32 January 1, 2015

-fixed a bug from 2.30 where ROM locking wasn't working correctly. 
 Thanks goes out to S.R.H. for reporting this.
-fixed a minor issue that's been around forever with other windows
 being activated when closing windows from the toolbar.  Thanks goes
 out to Ruberjig for pointing this out.


Version 2.31 October 31, 2014

-fixed a bug from 2.30 where the flying switch blocks on the
 overworld that appear when you pass a switch palace would
 temporarily corrupt part of the overworld's animated tile GFX in the
 game as the RAM they use overlapped with the extra space that the
 new 4bpp tiles take up.  The fix will be installed when the
 GFX/ExGFX are inserted.  Thanks goes out to 33953YoShI for reporting
 this.
-fixed a bug from 2.30 with the M16-7k dialog, where it wouldn't
 draw/behave correctly.
-fixed a minor issue from 2.30 where the layer 3 CGADSUB checkbox
 would not always be disabled when it should be.  Thanks goes out to
 Hinalyte for reporting this.
-fixed a minor issue from 2.30 where if x2 zoom was already enabled
 in the Add Object/Sprite windows when the program was started, the
 list height was shorter than it should be.  Thanks goes out to
 Underway for reporting this.
-fixed a minor issue from 2.30 where closing the Add Objects/Sprites
 windows would not let you use the level history mouse gestures
 without having to hold down the Shift key.  Thanks goes out to
 Wiimeiser for reporting this.
-added the ability to set custom sprite appearances and tooltips in
 the editor based on the last 1, 2, 3, or 4 bits of the sprite's X
 and/or Y position.  Check the help file for more info.
-expanded the Map16 space for custom sprites in the editor from 8 to
 0x10 pages.
-tweaked the "Insert all Slots" button of the "Edit ExAnimated
 Frames" dialogs so that it will insert starting at the currently
 selected slot instead of always from the start.


Version 2.30 September 24, 2014 (14 year Anniversary of Lunar Magic!)

-made it possible for the level editor to display layer 3.
-made it possible for the overworld editor to edit layer 3 tilemaps
 for levels and submaps and store them in an ExGFX file (check the
 file menu).
-added a new ASM hack to allow layer 3 GFX and tilemap bypassing on
 a per level and per submap basis.  Note that if you have already
 used a third party ASM hack for bypassing layer 3 GFX, it should
 be removed prior to using this version to avoid compatibility
 issues.
-added a new "Change Layer 3 Settings" dialog, which can modify
 layer 3 scrolling and some other advanced options.  Also moved the
 Layer 3 Priority option from the "Change Properties in header"
 dialog and the Layer 3 Options setting from the "Change Other
 Properties" dialog into this new one.
-for anyone using only 3bpp tiles (which is probably nobody, but
 anyway): the ExGFX file range of E00-FFF has now been set aside for
 files to be inserted/extracted "as is" so they can be excluded from
 3bpp/4bpp conversions.  This range should be used only for layer 3
 GFX and tilemap files, and for files intended for slot AN2 in the
 level editor.  If you already have other files in that range, you
 should move them prior to using this version.  But those that are
 using 4bpp tiles (likely everyone) can disregard this and continue
 using any file as they wish.
-added a new ASM hack for the overworld to allow setting the sprite
 GFX slots and the animated AN2 slot on a per submap basis.  You can
 also now access all the ExGFX files for use on the overworld, not
 just the ones from 80-FF.
-added a new ASM hack for the overworld to reload the overworld
 (which includes the GFX) when swapping players that aren't on the
 same submap.
-added a new ASM hack for the overworld to reload all the GFX when
 using an exit tile.  You must insert the GFX as 4bpp using this
 version then save the overworld for the hack to be enabled.
-added a new ASM hack for the overworld that allows merging GFX
 slots FG1 and FG2 into SP3 and SP4 to create room for 2 more FG
 slots.  This option is off by default, but can be turned on in the
 "Extra Options" dialog of the overworld menu.
-added a new ASM hack for the overworld to remove the 3bpp limit on
 the overworld animated tiles, so they can now be 4bpp.
-added a new ASM hack for the overworld so that silent layer 2 event
 steps can appear below regular steps of higher event numbers. 
 While Lunar Magic had always displayed it this way, apparently the
 original game couldn't quite do it as it would place layer 2 silent
 steps above all regular steps once the overworld map had been
 refreshed.  Thanks goes out to Falconpunch for drawing attention
 to this.
-made a couple minor optimizations to smkdan's VRAM patch.
-made a couple minor optimizations to LM's block gameplay ASM, which
 will be installed when you save the Map16.
-added undo and redo buttons to the level editor and overworld
 editor windows.  Since this can affect the amount of RAM the
 program uses, you can change the max number of undo operations in
 the "General Options" dialog.
-replaced the "Add Objects" and "Add Sprites" windows with new ones
 that include a separate find text field and options for x2 zoom,
 displaying preview icons beside each item, hiding objects/sprites
 based on tileset/GFX files loaded, turning the preview area on/off,
 and horizontal/vertical layouts.  The window can also now be
 resized both vertically and horizontally.
-made it possible to delete entries from the "Custom Collections of
 Sprites" list in the "Add Sprites" window, and to move entries by
 holding down shift and using the arrow keys.
-replaced the "Background Tile Map Editor" window with a new one
 that includes x2 zoom, undo/redo, and uses a regular window instead
 of the tool window in previous versions so it can be
 maximized/minimized as well as resized.
-moved the "Change Background Map16 Bank", "Remap Background Tiles",
 and "Copy Background Image" menu items from the level menu of the
 level editor to buttons in the new Background Editor window.
-added a new fill operation that can be used with control+shift
 right click to fill an enclosed area of the level with Direct Map16
 tiles from the Add Objects window.  This can be useful for quickly
 filling in non-rectangular areas within ledges built with Direct
 Map16.  You can also add the alt key to do it from the Map16 editor
 instead (which can be skipped if the Add Objects window is closed
 or isn't in the Direct Map16 Access list).
-made it possible to use control+alt right click in the level editor
 to copy FG tiles from the Map16 editor.  You can also just use a
 right click if the Map16 editor is open and the Add Objects window
 is closed.
-made it possible to copy FG tiles from the Map16 editor into the
 level editor through the windows clipboard.
-made it possible to copy tiles from the Background Editor into the
 Map16 editor through the windows clipboard.
-made it possible to copy tiles between the Background Editor and
 the overworld editor through the windows clipboard when the latter
 is in a compatible mode that supports it.
-made it possible to copy tiles between the Map16 editor and the
 overworld editor through the windows clipboard when both are in
 compatible modes that support it.  This was already possible if the
 Map16 editor was in 8x8 mode, but it has now been expanded to
 include 16x16 mode.
-added windows clipboard support to the layer 1 editing mode of the
 overworld editor.
-added "Auto-Deselect on Editor Select" options to the main level
 editor, Background Editor, and Map16 Editor.
-made it so that double clicking a tile in the Background Editor to
 select it in the Map16 editor will also open the Map16 editor if it
 isn't already open.
-added a new "Edit Reveal Tile List" menu item to the overworld
 editor, which allows changing which layer 1 tiles are revealed into
 another tile when you pass an event.  This was used in DW:TLC for
 creating red star levels.
-marked a few "Mario Path" tiles in the overworld editor with a
 black X, to indicate that Mario cannot enter them as levels even
 though he can stop there.
-fixed a display issue in the overworld editor that's been around
 forever where all sprites would always be shown with the palette of
 the main map without special world passed.
-made it so that loading the title screen in the overworld editor
 will use the layer 3 GFX files of the title screen level.
-modified the overworld editor's "Edit Level Names" dialog to use x2
 zoomed tiles, DPI scaling, and added a new control for selecting
 which submap Layer 3 GFX and colors to use to display the preview.
-modified the overworld editor's "Edit Message Box Text" dialog to
 use x2 zoomed tiles, DPI scaling, and added a new option for using
 the Layer 3 GFX and colors of the currently loaded level in the
 level editor to display the preview.
-modified the overworld editor's "Edit Boss Sequence Text" dialog to
 use x2 zoomed tiles, DPI scaling, and to use the correct colors.
-added the ability to export a level to a PNG image file.
-made it possible to use Snes9x savestates for recording title
 screen moves.
-changed the "Export Title Moves Playback Data" menu command to
 create a fake ZSNES savestate rather than having it require an
 existing savestate to save into.
-added the ability for programs launched from LM to make requests to
 LM to reload the current level or ROM.  Check the help file for
 more info.
-fixed an issue from 2.20 where saving to a different level number
 would not update the displayed secondary entrance sprites in the
 currently loaded level to reflect possible changes.  Thanks goes
 out to Hinalyte for reporting this.
-adjusted the auto-set number of screens feature so it ignores
 entrances, as it did before 2.20.
-adjusted the exit scan option so that for "clear the original level
 data area" and "import multiple levels from file" operations, it
 will no longer give a warning for screen exits that are explicitly
 set to level 0/100.  Thanks goes out to Wiimeiser for bringing this
 up.
-made it possible to change the Mario sprite tile arrangement
 displayed in LM for level entrances, using the same method as with
 custom sprites.  Check the help file for more info.
-added the mouse gestures for back/forward to the list of function
 commands for custom user toolbars.
-fixed a couple issues that have been around forever with trying to
 use the "Copy BG" function with the TEST levels.  Thanks goes out
 to Sokobansolver for bringing this up.
-fixed a bug that's probably been around since 1.70, where if LM
 ever tried to save a BG to a particular address the save would be
 aborted and a warning message saying "Could not save BG data in a
 bank-appropriate area" would be displayed.  Thanks goes out to
 Mini-Tech for helping to identify this issue.


Version 2.22 February 9, 2014

-fixed a bug from 1.70 in smkdan's VRAM patch where sprite 49
 (growing/shrinking pipe end) could cause a few pixels of some tiles
 to be corrupted if the sprite was near enough to the entrance to be
 processed during fade in.  Thanks goes out to WhiteYoshiEgg for
 reporting this.
-fixed a potential bug that's been around forever where if your
 overworld had no silent events at all and was not yet using the new
 format, LM would create a single entry for the table as required by
 the game's original ASM, but the contents weren't specified so it
 could end up holding something invalid/harmful.  Note that while LM
 now sets it to "no event" and recognizes that as valid, the entry
 created by previous versions still has a chance to trigger the new
 "silent event corruption" warning added in 2.21.  In that case
 simply resaving the overworld in this version will remove the
 offending entry.  Thanks goes out to Wiimeiser for reporting about
 this.
-fixed an issue from 2.20 where opening a level from the "Open Level
 Address" menu would result in the main and midway entrance not being
 displayed although the labels still were.
-corrected the "Mario Path" displayed for overworld layer 1 tile
 0x36, which is actually a water version of tile 0x1C.  Thanks goes
 out to Wiimeiser and mariofreak4500 for drawing attention to this.
-increased the allowed number of sprites for the sprite count warning
 to 255 if Vitor Vilela's RAM remap for SA-1 ROMs has been used.
-added some code to prevent attempts at opening a second overworld
 window under certain conditions.  Thanks goes out to Hinalyte for
 reporting this.
-made a minor tweak to the optimized LZ2 and LZ3 ASM code to not
 attempt decompression if the GFX file has not been inserted, to aid
 with ASM debugging.  Will only take effect once you switch
 compression formats with this version.
-moved most of the options in the options menu to their own "General
 Options" dialog.
-removed the "Highlight Mouse Cursor in BG Editor" option, as it
 doesn't seem likely that many people turn it off anyway.
-added a new "Check if Vertical Fireball has Buoyancy" option to the
 general options dialog, at Alcaro's suggestion.


Version 2.21 December 25, 2013

-fixed a bug from 2.20 where the new "view sprite data" menu item in
 the overworld editor would display black squares for the sprite data
 text if the editor had not yet loaded an overworld that wasn't using
 a custom palette.  Thanks goes out to Wiimeiser for helping to figure
 this out.
-fixed a bug from 1.40 (which became more noticeable in 2.10) where
 changes to the last 8 entries in LM's "Destroy Level Tile Settings"
 dialog could cause Ghost House/Castle/etc tiles to no longer give
 the player a save prompt when the event had already been cleared. 
 This is partly due to a mistake in Nintendo's code, as it treats the
 list as 0x18 bytes long when it's really only 0x10 bytes.  This
 version of LM relocates the table so it can safely have all 0x18
 entries, and repairs the other 8 bytes that may have been changed in
 previous versions.  Thanks goes out to Wiimeiser for helping to
 figure this out.
-fixed a minor entrance label display positioning issue from 2.20
 when switching between vertical/horizontal level layouts.  Thanks
 goes out to Koopster for pointing this out.
-fixed a small bug that's been around forever, where if the save
 prompt for castle/ghost house/etc tiles was disabled and the player
 passed a level using one of those tiles, the player would move off
 the level even if the event had already been passed.
-added a new ASM hack to fix a timing issue in Nintendo's code, where
 there was a chance that the game could turn the screen on a frame
 too early during black screen transitions, resulting in a brief full
 screen flash of color.
-disabled some Nintendo ASM that apparently served no purpose, which
 was preventing ExGFX from being used in tiles 4A-4F and 5A-5F of
 SP1.  This also now makes these tiles 4bpp.
-added some filtering and warning messages to detect and remove bad
 event data in the overworld in case people corrupt it with external
 tools/patching.
-made it so that pressing Page-Up in the overworld editor in event
 editor mode while on event 0x77 will cause the event to be shown as
 passed, so you don't have to advance through each step with Home/End
 for that event.  Thanks goes out to Everest for bringing this up.
-added a small bypass warning in the old GFX bypass dialogs and the
 tileset change dialog when Super GFX Bypass is enabled, at Alcaro's
 suggestion.


Version 2.20 September 24, 2013 (13 year Anniversary of Lunar Magic!)

-made the previously unofficial support for the SA-1 ROM map official,
 and added 6 & 8 MB expansion menu items for SA-1 ROMs (see the help
 file on emulator compatibility with large SA-1 ROMs).
-added support for Vitor Vilela's RAM remap for SA-1 ROMs.
-made it possible to drag/copy/delete/alt-right click level entrances
 as part of sprite editing mode.  Dragging an entrance automatically
 updates its FG/BG init position (except for the BG init position in
 vertical levels), copying an entrance creates a new secondary
 entrance in a free slot, deleting a secondary entrance clears the
 slot, and alt-right click lets you modify the entrance properties and
 change which slot a secondary entrance should use.
-changed the "Add/Modify/Delete Screen Exits" dialog so that changes
 to the current entry aren't lost when you switch which screen you
 want to edit, and renamed it to "Modify Screen Exits".
-added a "Clear All Screens" button to the "Modify Screen Exits"
 dialog and renamed the "Delete" button to "Clear Screen".
-the "Modify Screen Exits" dialog now displays information about exits
 that have been set for each screen.
-changed the definition of a "free" secondary exit slot to be more
 than just an exit that points to level 0 or 100.  If you have
 secondary entrance slots that you manually cleared in the past by
 only changing the level destination, you will need to use the "Clear
 Slot" button or delete them so they'll show up as unused again.
-level entrances are now displayed using the player graphics from the
 game.
-replaced the mostly redundant "Screen Boundaries" item in the view
 menu with a new "Game View Screen" option.  This creates a draggable
 SNES-sized screen that you can use when designing levels to figure
 out what will be visible on the screen.  It also optionally has
 highlighted areas for locations Mario will be during scrolling in
 different directions, to aid in determining where the screen will be
 during gameplay.
-made it possible to have Lunar Magic load external files in place of
 GFX32.bin and GFX33.bin for display purposes in the editor.  Just
 place files called ExternalGFX32.bin and ExternalGFX33.bin in the
 Graphics folder for your ROM.
-added a new ASM hack where you can set the midway level entrance to
 coordinates separate from the main level entrance.
-added a new ASM hack where a screen exit can go to a level's midway
 entrance if it's using the new separate coordinates option.
-fixed an issue in Nintendo's original code, where if the midway
 entrance was set to screen 0 the game would not record obtaining the
 midway point for that level.
-adjusted the control+delete keyboard shortcut to also delete all
 secondary entrances in the current level.
-added the ability to set the Koopa Kid teleport locations in the
 overworld editor, and a menu item to view them (check the help file
 for more info on the Koopa Kid sprites).  Thanks goes out to Wiimeiser
 for providing the test patch to examine these.
-added the ability to view sprite data to the overworld's view menu, as
 it helps in showing which slot and subslot a sprite on the overworld
 belongs to.
-set LM to pause the internal emulator if viewing animations is turned
 off.  Thanks goes out to MarioFanGamer659 for reporting on this.
-added tile/page jump in place of text search for the Direct Map16
 list in the Add Objects window.  Thanks goes out to telinc1 for
 bringing this up.
-made conditional Direct Map16 objects appear translucent in the
 editor if the "Other Invisible Objects" view menu option is on and
 "Conditional Direct Map16 On" option is off.  Translucency will not
 be applied to objects using the +100 option.
-adjusted tiles used for sprite 4D (Monty Mole) in LM so it will
 appear the same way in the editor as it will in the game.  Thanks
 goes out to Wiimeiser for pointing this out.
-changed the name of the "Cloud Ledge" for ghost houses to remove the
 "Ledge" bit as you can't stand on it.  Thanks goes out to Wiimeiser
 for pointing this out.


Version 2.12 February 16, 2013

-fixed a bug from 2.11 where using the "Edit Boss Sequence Text",
 "Edit Message Box Text", or "Edit Level Names" dialogs in the
 overworld editor then saving the overworld would change the list of
 GFX files to load for the main overworld map.  Thanks goes out to
 Wiimeiser for reporting on this.
-added a save prompt for Windows logoff/shutdown events.  Thanks goes
 out to Vitor Vilela for bringing this up.
-removed the "Allow Fragmentation" option from the options menu, as
 it's a very advanced option that's been sitting there since version
 1.00 but no one is really going to want to turn it off anyway.
-removed the "Level Insertion Complete!" message box that pops up
 after using the "Save level to ROM as..." command, as it's another
 holdover from version 1.00 and not really necessary.


Version 2.11 February 9, 2013

-fixed an issue in the new overworld 8x8 tile selector, where it
 wouldn't show the correct colors for title screen or credits editing.
 Thanks goes out to Zeldara109 for pointing this out.
-fixed an issue in the new overworld 8x8 tile selector, where the
 overworld controls did not enable the save button when used.  Thanks
 goes out to Zeldara109 for pointing this out.
-made an adjustment to the new overworld 8x8 tile selector, where it
 will paste tiles with priority enabled by default for title screen
 and credits editing, at Zeldara109's suggestion.
-changed the "Modify Secondary Entrances" dialog, so that changes to
 the current entry aren't lost when you switch which entrance you
 want to edit.
-added a "Clear Slot" button and a "Clear All Slots" button to the
 "Modify Secondary Entrances" dialog.
-added a new option when importing multiple levels from files, to
 clear all existing secondary entrances in the ROM before importing.


Version 2.10 December 25, 2012

-added x2 zoom to both the level editor and the overworld editor.
-added a new 8x8 tile selector to the overworld window.  The new
 selector allows multiple tile selecting, is x2 zoomed by default,
 and has controls similar to the level editor's new map 16 editor
 for manipulating the current selection in the main overworld window
 (including a remap button).
-added a new "Auto-Deselect on Editor Select" option to the
 overworld's option menu, which causes tiles in the main overworld
 editor to be deselected automatically if you make a selection in one
 of the selector windows.
-removed the "Modify Selected 8x8 Tiles" menu item from the overworld
 menu, as the new 8x8 tile selector makes it redundant.
-removed the "Exit Path Tile Settings" and the "Star and Pipe Tile
 Settings" buttons from the toolbar, to discourage their use in
 linking tiles in favour of the alt-left click or link button
 methods.  They can however still be found in the overworld menu.
-added the ability to create one-way links when using alt-left clicks
 to link 2 star/pipe/exit tiles together.
-added "Show Star/Pipe Numbers" and "Show Exit Path Numbers" to the
 overworld's view menu.
-added a warning message when trying to link Star and Pipe tiles
 placed at X=0 with Y>=0x20, as they don't function correctly from
 there due to a limitation with one of SMW's tables.
-fixed a bug in the overworld editor that's been around forever,
 where if you placed an exit tile that goes left/right at X=0 with
 Y>=0x20 then moved it, the tile would partially unlink from its
 destination tile and would have to be relinked.
-fixed a bug in the overworld editor that's been around forever,
 where if you changed certain settings of a selected tile then moved
 that tile without first deselecting it, the tile would either revert
 to its previous setting or not move the setting to the new location.
 The settings affected by this were the Star/Pipe/Exit tile settings,
 the "Reveal this level tile on any of these events" setting, and the
 "Destroy Castle/Fortress/Switch Palace tile" setting.
-fixed a bug in the overworld editor that's been around forever,
 where if Star/Pipe/Exit tiles were selected then you copied or
 inserted new Star/Pipe/Exit tiles without first deselecting the old
 ones, the settings of the previously selected Star/Pipe/Exit tiles
 were vulnerable to getting attached to the new Star/Pipe/Exit tiles
 if they happened to get dragged over the old ones.
-fixed a bug in the overworld editor that's been around forever,
 where if a level tile was placed in the main map at the same layer 1
 VRAM location as another tile placed in the submap area, the "Reveal
 this level tile on any of these events" setting would be changed for
 both tiles whenever you tried to change one of them.  Thanks goes
 out to Gamma V for discovering this.
-fixed a display bug in the overworld editor that's been around
 forever, where the overworld animation tiles in the second half of
 GFX file 0x14 were supposed to be shown using only the first 8
 colors in a palette but LM wasn't enforcing it.  Thanks goes out to
 Shurik Kid for reporting this.
-fixed a bug from 1.80 where if someone who was keeping all their GFX
 at 3bpp inserted the GFX, the overworld 4bpp modifications for FG3/4
 might still be applied, causing overworld layer 1 tiles to use the
 wrong colors.
-you can now clear the entry for a Star/Pipe/Exit location by
 deleting the tile at the location it's currently assigned to (for
 exit locations, there must be an actual exit tile there). 
-increased the animation rate in the overworld editor to 15 fps, to
 better match the game.
-added support for LMSW's SwitchFlags function, to allow viewing
 state changes to the switch palace blocks in the emulator.
-upgraded the level editor's "Add offset to Background Tiles" dialog
 to a full remap dialog.
-made some adjustments so that the restore system can deal with ROM
 files marked as read-only/hidden on its own when possible during a
 restore operation.


Version 2.01 May 20, 2012

-fixed a bug from 2.00 where if the LMSW DLL requested a level switch
 there was a chance LM could crash.  Thanks goes out to TRS for
 discovering this.
-set LM to automatically leave sprite editing mode when starting the
 internal emulator.
-fixed a bug from 2.00 where the LM_NEWIMAGE directive for user
 toolbars wouldn't reset the base index right away like it should. 
 Thanks goes out to jimbo1qaz for discovering this.
-fixed an odd bug from 1.00 in the "Add Sprites" window where if a
 sprite's tiles in that window were placed at certain locations and
 in a certain order, LM would refuse to paste the sprite into the
 level.  While in LM's sprite lists this was only evident in
 version 2.00 with sprite 66 (upside down chainsaw), user supplied
 sprites in the "Custom Collections" list could trigger it in
 previous versions as well.  Thanks goes out to Wiimeiser for
 reporting this.
-fixed a small display issue from 1.00 where the back area color was
 dimmed in certain level modes.  Thanks goes out to Epsilon for
 reporting this.
-corrected the descriptions for sprites 41 and 42 (jumping dolphins),
 as they were switched around.  Also changed the direction they
 face.  Thanks goes out to Zeldara109 for reporting this.


Version 2.00 May 5, 2012

-added the ability to load the LMSW DLL from Alcaro, which allows
 using an emulator to play levels within LM itself (downloaded
 separately).
-added an optional user defined second toolbar to the main window,
 which can be used to launch external applications or activate
 internal Lunar Magic functions.  It also allows for assigning
 keyboard shortcuts which can replace Lunar Magic's existing
 keyboard shortcuts.  Check the technical info section of the help
 file for more details.
-fixed a bug from 1.00 where LM didn't preserve the Z order of
 sprites when possible and only cared about following the sorting
 rules imposed by the game.  Thanks goes out to King Dedede for
 noticing this.
-fixed a bug from 1.00 where changing a level from having objects
 on layer 2 to an image would cause LM to draw all objects that
 were on layer 2 on layer 1 instead until the level was reloaded.
-fixed a small bug from 1.91 where if you opened the Add
 Objects/Sprites windows then closed and reopened them again, the
 last used currently selected item could not be pasted (and would
 not be displayed in the preview area for sprites) until the
 selection was changed.  Thanks goes out to Dakress for reporting
 this.
-fixed a bug from 1.90 in the new Map16 editor's Remap button
 dialog and the new Remap DM16 dialog where if you just entered a
 space for the list, LM would freeze.  Thanks goes out to DiscoMan
 for reporting this.
-fixed a bug from 1.70, where a check for JW's old animated tile
 editor had a very rare chance of being triggered by LM's own
 ExAnimation ASM, causing junk to be displayed in LM for the game's
 original animations.  Support for this tool has been disabled, as
 it hijacks the same addresses as LM anyway.
-fixed a minor issue from 1.70 where if you forgot to enter the
 number of colors for a new palette animation when editing
 ExAnimation frames and left it blank, LM would use a value of 1 but
 would interpret the entered frame values as RAM offsets instead of
 SNES RGB values.  Thanks goes out to supernova38 for discovering
 this.
-further tweaked some code so that the new double clicks introduced
 in LM 1.90 also count as regular clicks for the middle mouse
 button.  Thanks goes out to Alcaro for reminding me of this.
-renamed the "Save level to ROM" menu item to "Save Level to ROM
 as...", then added a new "Save level to ROM" menu item that works
 the same way as the save button on the toolbar and assigned it the
 Control+S shortcut.  "Save Level to File" has been moved to
 Control+W instead of Control+S.
-reduced the maximum number of screens LM displays in levels that
 use layer 3 tides to reflect what's safe to use.
-adjusted tiles used for sprite 99 (Volcano Lotus) in LM so it
 will appear the same way in the editor as it will in the game. 
 Thanks goes out to MSA/Gamma_V for discovering this.
-adjusted the position of the light switch block, message block,
 and Banzai Bill sprites slightly in LM to match the game.  Thanks
 goes out to Alcaro for noticing this.
-changed the palette used in the white blocks in the bonus game in
 LM to match the game.  Thanks goes out to Alcaro for reporting this.
-adjusted the positions of sprites 65-68 (line guided chain saw,
 upside down chain saw, grinder, fuzz ball) in LM to more closely
 match the game.  Also greatly corrected their "set to go right"
 positions and updated their descriptions.
-changed the appearance of sprite 30 (dry bones that throws bones)
 to actually show it with a bone ready to throw, to better
 distinguish it from sprite 32.
-horizontally flipped the koopa shells in LM so they'll appear the
 same way in the editor as they do in the game.
-corrected the tooltip for sprite 3C (wall following Urchin) as the
 directions were reversed.  Thanks goes out to King Dedede for
 pointing this out.
-tweaked several other tooltips and sprites here and there.
-added some menu items to the view menu for custom ExAnimation
 triggers, to allow previewing them in LM.
-added displaying the size of a level in bytes within the status
 bar when a level is saved.
-added displaying the size of GFX/ExGFX in bytes within the status
 bar when GFX/ExGFX are inserted.
-added the ability to customize button images for the new Map16
 editor (using a bitmap file named "Lunar Magic.ff5"), and the
 palette editors ("Lunar Magic.ff3" for the level palette editor
 and "Lunar Magic.ff6" for the overworld palette editor).
-adjusted M16-7k a bit, as it's been difficult to get into since
 1.70 and became mostly unusable in 1.90.  Thanks goes out to
 MaZ18 for reporting this.
-did a few minor tweaks to the object/sprite window searching at
 Zeldara109 and Alcaro's suggestions.


Version 1.91 December 25, 2011

-fixed a bug from 1.70 in smkdan's VRAM patch where dynamic changes
 (such as coin collection) on layer 2 were not always displayed if
 layer 1 and 2 scrolling were not in sync, and another bug where a
 column of garbage tiles could appear under rare circumstances. 
 Thanks goes out to smkdan for submitting the fixes for his patch,
 and Zeldara109 for reporting the coin issue.
-added a new "Prefer Saving in 2MB+ ROM area" option to the options
 menu, which is on by default.  This will cause Lunar Magic to
 first try saving data and code past the 2MB mark in the ROM before
 using earlier space, but only if the ROM is already larger than
 2MB.  This will help save space below bank 40 for less versatile
 3rd party ASM patches/tools to use, as many of them unfortunately
 do not take bank 40+ into account and will malfunction without
 warning when installed there.
-added a new "Check Object Placement on Save to ROM" option to the
 options menu, which will warn if an object is placing tiles beyond
 the viewable level area into unsafe SNES RAM locations which could
 cause various issues during gameplay.
-added a new "Export Title Moves Playback Data" menu command to the
 overworld editor, to allow exporting existing title screen playback
 data from a ROM back into a Zsnes savestate, so it can be
 transferred to a different ROM.
-added a new "Edit Manual" command to the edit menu, which allows
 manually modifying existing objects/sprites.  You can also
 Alt-Right click on an object or sprite to use this.
-added the ability to remap 16x16 gameplay "act as" settings in the
 new Map16 editor using the remap button.
-added a warning message to be displayed when attempting to use
 Lunar Magic on a ROM that has already been edited by a newer
 version of the program.
-saved the new Map16 editor's zoom setting to the registry.
-enabled the new Map16 editor to use the "translucent text and
 outlines" option from the main editor, but set the translucency
 level a bit lower than what's used in the main editor.
-enabled using Ctrl+Z/Ctrl+Y keyboard shortcuts in the new Map16
 editor for undo/redo.
-tweaked some code so that the new double clicks introduced in LM
 1.90 also count as regular clicks.
-added text search to the Add Sprite/Object windows, which you can
 activate just by typing.
-added support for non-256 color bitmaps when using custom toolbar
 images, and support for using images larger than 16x16 for the
 toolbar buttons.
-added sprites A0, A1 and A9 (Bowser Scene, Bowser's Bowling Ball,
 Reznor) to sprite list.
-added a few alternate sprite GFX file suggestions to tileset
 specific sprites in Add Sprites window.
-adjusted sprite 33 (Vertical Fireball) in LM to include some bits
 of fire dropping off it, at Zeldara109's suggestion.
-horizontally flipped sprite 2C (Yoshi Egg) in LM so it will appear
 the same way in the editor as it will in the game.  Thanks goes
 out to Wiimeiser for discovering this.
-adjusted palette used for sprite 45 (Directional Coin) in LM so it
 will appear the same way in the editor as it will in the game. 
 Thanks goes out to andy_k_250 for reporting this.


Version 1.90 September 24, 2011 (11 year Anniversary of Lunar Magic!)

-replaced the Map16 editor with a new one that features multiple tile
 selection, reload/save and undo/redo buttons, 2x zoom, 8x8 and
 palette remapping capabilities, an 8x8 mode with an 8x8 tile
 selector, etc.  This release also introduces a new .map16 file
 format intended to replace the old generic .bin files that were
 used in previous versions for exporting/importing single pages of
 Map16 data.  The new files can hold variable amounts of tiles, can
 optionally be imported to the same location they were exported from,
 and multiple files can be imported at once.  There are also 2 new
 buttons allowing you to export/import all the Map16 data for all
 tilesets from/to a single file.  LM remains backward compatible
 with both loading and saving the older raw .bin Map16 data files.
-added a feature to double left click on a tile in the level or
 background editors to select it in the Map16 editor, and you can
 also double left click on a tile in the Map16 editor to select it
 in the 8x8 editor.
-removed being able to paste the current page from the Map16 editor
 into the background editor with Ctrl+Shift+Insert, as the new Map16
 editor makes it unnecessary.
-added a new "Add Offset to Background Tiles" menu item to the level
 menu, which allows adding or subtracting an offset from all tiles in
 the background, much like F9 does to selected tiles in the
 background editor.  Also made this function able to change the BG
 Map16 bank setting automatically when needed.
-added a new "Remap Direct Map16" menu item to the edit menu, which
 can remap specified Direct Map16 objects in a level to others in
 case you've moved the original Map16 tiles to a different location.
-made it possible to set Luigi's starting position on the overworld
 to a different location than Mario's.
-added an option to the overworld editor that allows disabling the
 original game's path fade effect, which frees up colors 1-7 of
 palettes 0-3 and C-F, and GFX slots SP3 + SP4.  Also added a setting
 to control the path revealing speed when this option is used.
-expanded the overworld's layer 1 Map16 data to 2 full pages.  Tiles
 on the second page will generally act like tiles on the first page.
-included an ASM hack from DW:TLC that expands the number of
 overworld pipe and star indexes to 0x80.
-updated the overworld editor so that if the tile that replaces the
 top of a castle when destroyed is edited, the game will correctly
 display the edited tile in the destruction sequence.
-added an entry to the options menu to allow using an alternate GFX
 Bypass dialog that lets you type in the GFX files to use instead
 of selecting from a list.  Previously this option could only be
 changed by pressing Shift-F4.
-added using Control-Alt-Left/Right click in the palette editor for
 copy/pasting an entire row.
-added a "Paste all Slots" button to the Exanimated Frames dialog
 which pastes all copied slots to the same slots they came from,
 and moved the "Insert all Slots" button to the side.
-made it possible to use text labels for custom sprite tile
 arrangements, which appear the same way that LM shows certain
 sprite commands.  Check the help file for more details.
-added a prompt to create an IPS patch after locking a hack.
-changed some code so that applying an IPS patch of a locked hack to
 a ROM will cause LM to close the ROM after patching instead of
 closing the program.  But for convenience you can still use F4 to
 run the previously open ROM in your emulator.  Thanks goes out to
 GlitchMr for bringing this up.
-made a slight adjustment to sprite 61 in LM so it will appear the
 same way in the editor as it will in the game.  Thanks goes out to
 GlitchMr for pointing this out.
-made the edit controls in the Exanimated Frames dialog slightly
 larger to allow entering all digits for direct offsets.  Thanks
 goes out to imamelia for reporting this.
-fixed a bug from 1.80 where having auxiliary .msc .dsc etc files
 with a size of 0 bytes would cause LM to crash if creating a full
 restore point.  Thanks goes out to iRhyiku for submitting the data
 that helped figure this out.
-fixed a bug from 1.80 where the restore point created by locking a
 hack was invalid.
-fixed a bug from 1.70 where opening an mwl file with an unmodified
 background could sometimes cause LM to display the background using
 the wrong BG Map16 bank (although if saved to the ROM, the correct
 setting would still be preserved and used when the level was
 reloaded).  Thanks goes out to Ultimaximus for reporting this.
-fixed a bug from 1.64 where locking a hack prevented LM from opening
 any other ROMs and had to be closed.
-fixed a bug from 1.50, where if the gameplay table in the ROM was
 corrupted for any reason (like the user overwriting it with a
 patch), Lunar Magic could crash while moving the mouse cursor over
 a block that referenced the invalid data.  Also fixed a similar
 bug from 1.30 in the old Map16 editor where it could crash while
 right-clicking to copy a tile with the invalid data.
-fixed a minor display issue from 1.20, where edits to the Map16
 tiles that make up a pipe would not be displayed in the main level
 editor until you either saved the changes to the ROM or changed
 the pipe view index.
-changed window border style setting for main and overworld editor
 as apparently Win7 doesn't handle that border type on application
 windows when Aero is enabled.  This had resulted in weirdness from
 Aero like the caption/title bar of the window being partially
 offscreen when maximized, and the inner window border occasionally
 appearing as unerased pixels.


Version 1.82 October 31, 2010

-fixed a bug from 1.81 that causes the game to glitch/crash midway
 through the enemy list at the end of the game.
-fixed a bug from 1.81 for SMAS+W involving the Direct Map16 Access
 ASM.
-fixed an issue from 1.80 for SMAS+W, where the restore feature was
 using the wrong CRC value to check for an original unmodified ROM. 
 Thanks goes out to GlitchMr for reporting this.
-the above made me realize that I've apparently been using an
 overdumped SMAS+W ROM this whole time (3MB instead of 2.5MB).  This
 means Lunar Magic hadn't been coded to recognize the extra 500KB as
 free space.  But it was installing some fixed location ASM hacks and
 tables there, so to avoid compatibility issues this version of LM
 will only recognize that area as free space when starting a new hack.
-fixed a bug that's been around forever where turning off the "Correct
 Fatal Errors" option and inserting an object that would normally be
 interpreted as an error would cause object resizing with the mouse to
 use single-pixel increments, making it rather difficult to control. 
 Thanks goes out to Clown Dentist for discovering this.
-included a palette fix for the "S" in "Mario/Luigi Starts", as it was
 wrong in the original game.
-made it possible to resize the Add Objects/Sprites windows vertically,
 at Zeldara109's suggestion.
-added compression options to the options menu, which allows switching
 to either the optimized for speed version of LC_LZ2, or to LC_LZ3 for
 better compression using a patch submitted by edit1754.
-added an option to the options menu to disable converting the sprite
 berry GFX tile.  Technically this option has been around since
 version 1.60, but the only way to change it until now has been
 through the registry since it was never added to the GUI.


Version 1.81 September 24, 2010

-fixed an issue from the 1.80 release where it wasn't actually
 installing the required ASM for the Direct Map16 Access upgrade
 (errr... oops.  Always ends up being one of those last minute/week
 changes that trip you up.)


Version 1.80 September 24, 2010 (10 year Anniversary of Lunar Magic!!)

-fixed a bug from 1.70 where the Iggy/Larry battles could glitch
 depending on certain conditions.  Thanks goes out to Markus for
 reporting this.
-added a new restore feature to the program that can optionally track
 changes to the ROM and allow the user to revert the ROM to any
 previous restore point.  Note that this requires the program have
 access to a copy of the original ROM, so you may have to browse to a
 copy the first time you save in the new version.  Also added
 create/apply IPS to the restore menu.
-the Direct Map16 Access feature has been upgraded so you can select
 an area with multiple tiles in the "Add Objects" window and paste
 them as a single object.  Resizing the object will repeat the pattern
 of the original tiles pasted.  It can also now be resized to larger
 areas than before, and has been made vertical level compatible so it
 won't break up like regular objects do.  All of which can help
 reduce level data size.
-added a Conditional Direct Map16 Access feature to the edit menu,
 which allows you to set any DM16 object to only be rendered if a
 certain flag is enabled within a table of values in RAM.  Check the
 help file for more information.
-added Ersanio's FastROM modifications as an option in the options
 menu.
-made several adjustments to the palette editor (moved it to the
 editors menu, moved the "enable custom palettes" option into it,
 added undo and redo buttons, etc).
-made the same adjustments to the overworld palette editor that were
 made to the level palette editor.
-added an option to the overworld palette editor to allow custom
 palettes for the overworld.
-cleaned up the shared palettes for the overworld and levels by
 removing the bits left over after transitioning between the two as
 they generally can't be relied upon to always be the same due to the
 use of custom palettes.
-adjusted overworld to use full 4bpp graphics for FG3 and FG4.  To
 fully enable, you must extract then insert the original GFX.  Note:
 before you start playing with overworld custom palettes and graphics,
 be sure to read the warnings about path revealing in the help file
 sections for the palette editor and the submap FG graphics dialog.
-enabled the "extension" field in the "Add Sprites Manual" dialog to
 allow multibyte sprites with 3rd party utilities.  Check the help
 file for more information.
-added an "extension" field in the "Add Objects Manual" dialog to
 allow entering more information for multibyte objects.  More
 specifically, it's for object 2D which has now been set aside as a 5
 byte object for user defined purposes (do not use this object unless
 you've inserted code into the game for it, or in-game level parsing
 errors will occur).
-added viewing tile grid in level and overworld editors with F8 (use
 control+alt+F8 to switch grid color).
-moved existing F8 functionality (disable title screen color hack) to
 control+shift+F8.
-added a option to display a warning when an ips with the same name
 as the ROM is detected in the same directory.
-reorganized the toolbar buttons a bit.
-updated sprite A5 so it displays in LM the way it does in the game
 when used in sprite tilesets it was not originally intended for. 
 Thanks goes out to Alcaro for reporting this.
-corrected sprite 7F to use the correct palette in LM.  Thanks goes
 out to imamelia for pointing this out.
-corrected part of sprite 9B to use the correct palette in LM.  Thanks
 goes out to EL santo for finding this.
-mostly fixed the delay that would occur when bringing up the Super
 GFX dialog on Win7/Vista.
-added code to automatically remove the block that IE7+ puts on the
 help file when you use that browser to download the program.  Also
 added a warning to be displayed when the help file cannot be found.
-updated the program to stop always using the Win95 default font. 
 Should improve readability on LCDs with ClearType.


Version 1.71 April 17, 2010

-fixed a bug from 1.70 where attempting to initialize any of Manual
 Frame Triggers 1-F would crash the game.  Thanks goes out to Davros
 for noticing this.
-corrected a display glitch from 1.70 where the secret goal tape
 sprite was being displayed in LM as though it were a custom sprite.
-fixed a display issue from 1.70 where tile 0x25 was not highlighted
 when selected.  Thanks goes out to Dotsarecool for reporting this.
-corrected an issue where attempting to save more sprites than a
 LoROM bank could hold would not display an error message like it was
 supposed to and LM would only save the sprite header.  Thanks goes
 out to Glitch for reporting this.
-re-added setting 3 for the "Item Memory Index", along with an ASM
 hack that changes the setting so it doesn't record any items
 obtained.  Thanks goes out to BMF for submitting the ASM for this.
-added a few ROM expansion menu commands to the file menu, in case
 someone wants to expand the ROM for data or code they intend to
 insert themselves.
-updated object 3B and extended objects 49,80,84, and 85 to break
 up when near or on screen boundaries like the game does.  Also
 removed some junk subobjects from the list for object 3A.  Thanks
 goes out to Alcaro for reporting this.


Version 1.70 April 1, 2010

-smkdan's VRAM modification patch has been integrated into LM.  This
 means levels can now use 50% more 8x8 FG/BG tiles (0x100 tiles),
 which can be accessed using 2 extra GFX slots (BG2 and BG3).  A big
 thanks goes out to smkdan for developing and submitting this
 improvement, and to Vic Rattlehead for testing it for him.
-Map16 space has been expanded to 4x the previous limit.  There are
 now 0x40 pages for FG Map16, and 0x40 pages for BG Map16.
-Map16 page 2 can now be set to be either tileset specific or not,
 with Control + F1 in 16x16 editor window.  New hacks will have this
 set to off by default.
-the page limit for backgrounds has been replaced with a bank limit. 
 A single background can now access up to a bank's worth of Map16
 tiles (0x10 pages).
-backgrounds have been upgraded to use a height of 512 pixels instead
 of the 432 that Nintendo went with, which translates to 5 extra rows
 of 16x16 tiles.  While this doesn't make much difference in
 horizontal levels, it means vertical levels can now have backgrounds
 that will seamlessly wrap vertically.  It also effectively means the
 end of the "animated tile garbage" that used to appear when the
 background was vertically scrolled past the viewable range.
-an option was added to the view menu for viewing backgrounds that
 are 512 pixels high.
-the ExAnimation feature has been completely rewritten.  The changes
 include: addition of several new 8x8 line types and new palette
 types (such as Palette Rotate), palettes can have multiple colors
 per entry by using ExGFX files for the source data, multiple new
 triggers for use in custom blocks (such as custom/manual/one-shot),
 the ability to use a few non-compressed ExGFX files for source
 tiles, the number of frames can now be set up to a limit of 0x100
 frames per animation, the addition of a global animation list for
 animations to be run in all levels, and settings that can disable
 both the original game's tile animation and color 64 palette
 animation as well as Lunar Magic's own level and global animations
 on a per-level basis.  ExAnimation now also spreads entries across
 multiple frames instead of doing them all at once every 8th frame,
 to improve the amount of vblank time available for animations. 
 *Note that this may have implications for custom blocks programmed
 to change behavior based on LM's ExAnimated frame counter at
 $7FC004.  While the counter is being maintained for backwards
 compatibility, it's only truly accurate now for slots 0,8,10 and 18
 (although if you have a block that hurts mario, it seems the next 2
 slots after those are still close enough).  If you find this is an
 issue you can either move your animations to the mentioned slots, or
 recode the blocks to use the new animation per-slot counters
 starting at $7FC080 (add 0x20 for global entries).
-the 2 8x8s stacked ExAnimation type has been changed slightly, so
 that the source tiles must now be one after the other (previously
 the two tiles had to be separated by a single tile, which was
 inconsistent with all other line types).
-added a dialog to the options menu that allows you to change the
 rate of animation Lunar Magic uses.  I've also bumped up the default
 rate to 15 fps.  The faster settings are only really useful if
 you're using the ExAnimation speed tricks.
-added an option that makes LM use FastROM addressing for its own
 data and ASM hacks, in case you want to convert your ROM to use
 FastROM.
-added an ASM fix for fading colors above color 7 in each FG/BG
 palette at the end of a level.  Nintendo didn't bother with this as
 they didn't use those colors much.  Colors related to the status
 bar (colors 9,A,B of palette 0 and colors 9,A,B,D,E,F of palette 1)
 will not be affected.  If BMF's version of the fix is already
 installed, LM's won't be inserted.
-modified the original graphics insertion code to disallow saving
 within the unexpanded ROM area unless it's within the original GFX
 area.
-added a "Clear Original Level Data Area" menu command to the file
 menu, which will resave all non-modified levels except the test
 level then clear most of the data in the original level data area
 to free it up for 3rd party ASM hacks.
-added a dialog that lets you add a specified value to all selected
 16x16 background tiles with F9.
-added a way to paste the current page in the Map16 editor into the
 background editor with Ctrl+Shift+Insert.
-the "custom sprites" and "translucent text and outlines" options
 were moved from the "options" menu to the "view" menu.
-improved "translucent text and outlines" drawing performance.
-stopped drawing the unused secondary entrances in levels 0 and 100,
 as there were a couple hundred of them overlapped and drawing them
 tended to slow down older computers.
-made it possible to customize sprite appearances and tooltips for
 sprites that have the extra bits set to 1.
-made it possible to select sprite indexes B-FF in the overworld
 editor, at Roy's request.
-fixed the overworld editor where if animation was turned off and
 event or level number labels were turned on and you moved around
 level tiles, it would leave a trail of unerased labels behind. 
 Thanks goes out to LobsterIan for reminding me of this.
-fixed a bug that's been around since version 1.50, where just moving
 tiles around in one of the unmodified original backgrounds in the
 background editor was not enough to cause the changes to be saved... 
 you had to first paste/insert/delete a tile in the background for
 that.
-updated extended objects 8A-8D (switch palace switches) to break up
 when near or on screen boundaries like the game does.  Thanks goes
 out to era64 for reporting this.
-updated some info for noteblock tiles 24 and 115 which are
 apparently unused.  Thanks goes out to Kaijyuu for discovering this.
-corrected info on swooper bat, as its behavior apparently isn't
 related to its X position after all.  Thanks goes out to Kaijyuu
 for reporting this.
-adjusted the "open level" button on the toolbar so it gets repainted
 as soon as you've saved to a different level number.  Thanks goes
 out to TRS for noticing this.
-corrected info on Level Mode F, which reported that you could
 interact with layer 2, except you can't.  Thanks goes out to smkdan
 for reporting this.
-removed setting 3 for the "Item Memory Index", as the game
 reportedly didn't implement this which meant it wouldn't function
 correctly.  Thanks goes out to smkdan for reporting this.


Version 1.65 October 1, 2009

-fixed "export multiple levels to mwl files" feature, where LM was
 trying to open the ROM twice when it shouldn't have.  This fails in
 1.64, due to certain file operations having been tightened up to
 detect this kind of thing in old code.
-fixed saving to mwl files, where if the level had ExAnimations it
 wouldn't save them correctly and would then disrupt the level's
 Super GFX bypass settings.  While this shows up in 1.64, the code
 was wrong in all 1.6x versions yet apparently still worked due to a
 strange coincidence.
-updated extended object 46 (midway point bar) to break up on screen
 boundaries like the game does.  Thanks goes out to TRS for noticing
 this.


Version 1.64 September 24, 2009 (9 year Anniversary of Lunar Magic!)

-fixed a memory leak with sprites that exists in all prior versions
 of LM.
-fixed an issue where if you used entry 0x1F in the Extended
 Animation Frames list and saved to the ROM or a mwl file, LM would
 save the data but upon reopening the level it would not read anything
 from the list at all.  Thanks goes out to Jimmy52905 for discovering
 this.
-fixed a problem with mouse gestures where holding down the right
 mouse button inside the editor window and then left clicking outside
 it would cause LM to crash.  Thanks goes out to crushawake for
 finding this.
-adjusted a slope object in LM to emulate a game bug that causes the
 slope to break up on screen boundaries in some cases.  Thanks goes
 out to Alex99 for noticing this.
-fixed the "view screen exits" toolbar button so it doesn't stay
 pressed if you switch to view screen or sub-screen boundaries, as
 reported by Maxx.
-corrected tileset info for Thwomp and Thwimp, reported by Noobish
 Noobsicle.
-fixed the animation of the wave tile in the overworld editor so it
 moves in the correct direction.  Thanks goes out to Sukasa for
 finding this.
-fixed loading an unmodified title screen in the overworld editor
 when it's from an 8 MB ExLoROM game.
-fixed an issue in the overworld editor where if LM ever had to
 report an error while reloading the overworld and tile animation
 was turned on, LM would start spawning multiple message boxes. 
 Thanks goes out to Obsidian for reporting this.
-updated the overworld palette editor so that alt-right click does a
 gradient instead of ctrl-right click, as in the level palette
 editor.  Should have been done in version 1.63.
-fixed overworld exit tile 0x4D so it can connect directly to a
 level tile without malfunctioning, which the original game doesn't
 allow...  I think Nintendo originally set it up as a corner path
 tile and didn't completely convert it when they decided to use it as
 an exit tile.
-added a new method to the overworld editor for linking
 star/pipe/exit tiles together with fewer steps using alt-left click.
-added an option to the overworld editor that allows turning off level
 24's redirection of exits based on coins and time.
-added a setting to the overworld editor that can change the one level
 used to activate a secret exit when beating a boss, which was used by
 the Big Boo Boss.
-fixed sprite interaction with custom block ASM in vertical levels.  I
 actually fixed this years ago and temporarily released the fix as a
 patch, intending to later integrate it into LM for version 1.62.  But
 mysteriously the fix never made it into the program...  I suspect I
 was waiting till I had time to check/adjust the fix for the Japanese
 ROM as well, and forgot about it.
-implemented the "Mario touched top corner of block", "Mario within
 block (body)", and "Mario within block (head)" custom block ASM
 hooks.  Two of these were used in a few of DW:TLC's blocks.  Should
 of been done before, but likely wasn't for the same reason as the
 sprite fix.
-adjusted the 16x16 program icon for WinXP, since apparently XP has
 something against using 16 color icons at times.
-fixed mwl file association for Windows Vista, which should also fix
 it for non-administrator accounts on Win2k and up.
-file types mw0, mw1, mw2, and mw3 are no longer associated with
 Lunar Magic, as the program hasn't used those for saving levels
 since 2003.  Note that this does not affect LM's ability to open
 levels saved in the older format.
-added a feature that allows LM to add a copier header to the ROM for
 you if it's missing, plus an option to do it silently.
-added exporting/importing palettes in YY-CHR .pal format.
-added a feature that allows LM to display custom tooltips and sprite
 tile arrangements for custom sprites based on the extra info bits
 (as done by a 3rd party ASM hack).  Also added an option to turn
 this off.  Check the help file for more info.
-added an extra category to the "Add Sprites" window called "Custom
 Collections of Sprites", which uses external files to allow custom
 sprites to be added a little more easily than using the "insert
 manual" command.  See the help file for more information.
-enlarged the area used for LM's internal sprite Map16 data, and split
 it up into 2 separate files so custom sprites can use their own file.
 Check the help file for more information.
-replaced Lunar Magic's old code for handling RATs with a modified
 version of the code in Lunar Compress.  This removes the limitation
 LM had about not honoring RATs that existed in a different LoROM bank
 than the data being protected, and also lets LM use the full size
 allowed by the RAT format.
-The FG Map16 data will now be protected by a RAT when saved, to make
 it easier for third party programs to avoid this data.
-converted LM's help file into a compiled HTML help file, as Microsoft
 is phasing out the old WinHelp system.
-thanks goes out to Smallhacker for gathering suggestions and bug
 info.


Version 1.63 September 24, 2005 (5 year Anniversary of Lunar Magic!)

-Adjusted some code so that importing a palette would enable the save
 level button.  Thanks goes out to Juggling Joker for bringing it up.
-Fixed a bug in one of LM's ASM hacks which could cause the game to
 crash if a user inserted custom block ASM that tried to dynamically
 change a tile into a tile that is at or above 0x400.  The fix will
 be installed when you save the Map16 data.  Thanks goes out to
 Darkflight for submitting the hack that revealed the problem.
-Fixed a bug where the 3 8x8s line animation type was copying 4 tiles
 instead of 3 (in the editor).  Thanks goes out to Smallhacker for
 discovering this.
-Fixed some code to prevent a rare case where pasting
 objects/sprites/tiles on the left side of the screen while moving
 left could, if timed correctly, paste the items on the other side
 of the editable area.  Thanks goes out to Smallhacker for pointing
 this out.
-Fixed a couple bugs in the BG editor that involved dragging a tile
 pasted from the 16x16 editor.
-Lowered the max file size allowed for the ExAnimated file to reflect
 the true safe limit for that file (0x1B00, or 0x1A00 for All Stars
 + World, down from 0x2000).
-Fixed the tile arrangements of several platform sprites (5F, 62, A3,
 C4, and E0) in the editor to emulate how the game does it.  Thanks
 goes out to Glyph Phoenix for pointing this out.
-Fixed the tile arrangement of Reznor (A9) in the editor.  Thanks
 goes out to Bio for pointing this out.
-Updated info on the climbing net door sprite (54), to include a
 warning for not putting it on a sub-screen boundary.  Thanks goes
 out to HyperHacker for discovering this.
-Updated info on sprite 88, which is apparently a winged cage that
 Nintendo didn't use.  Thanks goes out to mikeyk & Smallhacker for
 discovering this.
-Moved the control-right click functionality in the palette editor
 for gradients to alt-right click.  This way, when using
 control-left click to copy a color, you don't have to release the
 control key when you right click to paste (making it less annoying
 and more consistent with the other editors).
-Moved the control-right click functionality in the 16x16 editor to
 alt-right click, to make room for the new clipboard shortcuts.
-Added windows clipboard copy/paste using control left and right
 clicks in the 16x16 and 8x8 editor windows.
-The previously hidden credits and title screen editor modes of the
 overworld editor are now standard features.
-Added a new feature that allows overriding the sprite tile
 arrangements that LM uses by including new tile arrangement
 instructions in the sprite tool tip file.  Read the help file
 for more details.


Version 1.62 April 11, 2004

-Fixed a bug that was introduced by the "Count Sprites" option in
 version 1.60.  If the maximum sprites exceeded message box was ever
 actually displayed, it could cause various problems.  Symptoms
 included strange values showing up in the GFX, ExGFX, Insert Level
 and Insert Directory address fields, as well as areas filled with
 garbage tiles showing up in unused portions of the BG Map16 data. 
 The latter is caused by RAT tags getting embedded in the data (1.60
 only), leading to your ROM slowly filling up with useless copies of
 it each time you save the Map16 data.  This version of LM scans the
 BG Map16 data for the tags caused by the bug, and removes them
 before saving to prevent further space from being wasted.  You may
 also need to set the address to insert GFX back to 40200, the
 address for ExGFX back to 100200, and erase garbage tiles left over
 in your BG Map16 data.  Thanks goes out to TheClaw for submitting
 the hack that revealed the problem.
-Fixed a crash bug that would occur if you tried to insert a GFX or
 ExGFX file of size 0.
-Changed some code so that failure to extract a single GFX or ExGFX
 file from the ROM will not abort the rest of the extraction process.
-Fixed a bug introduced in 1.61 where if you have a sprite/object
 selected in the editor and try to use the clipboard keyboard
 shortcuts in the background editor window, the keys would be passed
 to the main editor window and replace the contents of the clipboard
 with the object/sprite selected.
-Updated sprite 5C,5E for info about floating on water with sprite
 buoyancy enabled.  Thanks goes out to Kenny for bringing this up.
-Updated objects 82 and 83 to emulate garbage tiles effect when other
 tiles are placed behind the empty tiles of the bush object.  Thanks
 goes out to thesubrosian for noticing this.
-Added an option in the options menu for turning off the sprite/object
 ID and object size info in the Add Object/Sprite windows, at Jesper's
 request.


Version 1.61 December 25, 2003

-Fixed a bug where if you set a level to use palette animation for
 color 0, Lunar Magic would shut down whenever it tried to read more
 data from the ROM.  Thanks goes out to SomeGuy for pointing this out.
-Fixed a bug where the "Run in Emulator" function wasn't putting quotes
 around the file name and path, causing problems for snes9x when the
 path or file name contained a space.  Thanks goes out to Excel for
 bringing this up.
-Fixed a bug where Lunar Magic would freeze if the user canceled
 expanding in the 8 MB dialog warning, but only if it was done after a
 "not enough room" message.  Thanks goes out to Sendy for discovering
 this.
-Fixed the palette numbers being used by the editor to display the
 bob-omb, para bob-omb, bubble bob-omb, bullet bill, the torpedo
 launcher hand, puff of smoke, and fishin' Boo.  Thanks goes out to
 KT15X and BMF for bringing this up.
-Updated the overworld editor to change the "Nothing?" sprite to "Koopa
 Kid x3", and added display support for it.  Thanks goes out to BMF for
 discovering this!
-Updated sprite 64 (rope mechanism), since it will be long or short
 depending on X&1, and will always be short if the sprite memory index
 is not set to 1.  Also, only 2 long ropes can be on the screen at once
 during gameplay.  Thanks goes out to Sendy for bringing this up.
-Updated tool tips for sprites 4D and 4E (Monty Moles), since they will
 follow Mario or walk with a hop depending on X&1.  Thanks goes out to
 MetaRidley for noticing this.
-Adjusted some code so that using features like the Super GFX dialog
 will no longer cause tileset-specific Map16 data to be unnecessarily
 reloaded from the ROM.  Thanks goes out to Jeffrey for bringing this up.
-Added keyboard shortcuts for the object and sprite editor windows and
 the "Open Level Number" dialog, highlighted the level number in the
 dialog, and added a feature to delete all sprites, objects and exits
 in a level with Ctrl+Delete at HyperHacker's suggestion.
-Added short tileset descriptions to the entries in the "Change Graphics
 in header" dialog, at HyperHacker's suggestion.
-Added buttons to copy and paste the extended animated tile data in the
 appropriate dialog, at Sendy's suggestion.
-Added Opera-style mouse gestures to the right mouse button.  Left and
 right go back and forth in level history (you can hold shift to force
 this if the Sprite or Object editor window is open).  Shift + Alt with
 left and right goes down/up by one level, and alt right goes to the
 level of the exit on the screen you clicked on.  This feature can be
 disabled in the options menu if you don't want to use it.


Version 1.60 September 24, 2003 (3rd year Anniversary of Lunar Magic!)

-Included 64 Mbit ExLoROM support (8 meg ROM files).  However, since it
 involves physically moving the ROM banks around which will make the
 ROM incompatible with other SMW utilities, usage is not recommended
 except for those that need an insanely large amount of space.  You
 can use Shift + Page Down to force the conversion.  You will need
 Snes9x 1.39a (or 1.39mk3) or higher to play the ROM (zsnes doesn't
 yet support it).
-The mwl file format has been changed so that levels can be in a
 single, self-contained file instead of the split files used in the
 old format.  Lunar Magic will still be able to open files in the old
 format to maintain backward compatibility.
-Added a new ASM hack that allows you to create new animated tiles and
 do simple palette animation, on a per-level basis.
-Updated the ExGFX ASM hack to allow using up to 0xF00 additional
 ExGFX files, for a total of 0xF80 files.  Also added a new dialog to
 allow Super GFX bypassing, which lets you access the new files and
 setup the FG/BG/SP/ExAn GFX from one dialog.  The settings in it are
 level specific, meaning you don't need to use a global list of GFX
 files to load as with the older bypass code.  The old list method is
 still supported, but it cannot access the new files.
-Added a feature to allow importing a custom palette directly from a
 ZSNES save state.
-Added an option in the options menu for highlighting the tile under
 the mouse cursor in the BG editor.
-Added an option in the options menu to count the number of sprites in
 the level when saving to the ROM, in case you exceed the maximum that
 the game can usually handle.
-Made a couple minor changes to LM's toolbar (added a "Scan for
 Undefined Exits" button, a "Super GFX Bypass" button, and a "Edit
 Extended Animated Frames" button).
-Fixed a bug in how Lunar Magic displays extended object 0x90 (the Boss
 Door).  Due to strange coding on Nintendo's part, the door tiles break
 up when the door is on or beside a screen boundary.  LM has been
 updated to do the same.
-Fixed a special case involving Lunar Magic displaying certain layer 2
 level tiles (on levels using FG/BG tileset 3) with the wrong palette.
-Fixed a bug where hitting Ctrl-6 to advance to the next animated frame
 would have no effect on Yoshi coin palette animation when using a
 custom palette.  Thanks goes out to BMF for pointing this out.
-Added a feature that lets you test the currently loaded ROM in the
 emulator of your choice by hitting F4 in the level or overworld editor.
-Using F5 & F6 in the Map16 editor will also now save and load the
 gameplay settings for the FG Map16 tiles.
-Added a feature that lets you use your own custom map16 data for
 displaying sprites in the editor (does not affect the actual game).
-Adjusted the palette editors so that ctrl-left clicking puts the color
 on the windows clipboard, so you can copy and paste between multiple
 instances of Lunar Magic.
-Added a new mode to the overworld editor to allow moving around the
 sprites.  You can also set Mario's starting position in this mode by
 moving the Mario sprite around.
-Added a tool bar to the overworld editor.
-Added a dialog to the overworld editor to allow changing/deleting the
 overworld sprites for each slot.  Thanks goes out to JW for initial
 research on this.
-Added a dialog to the overworld editor to allow changing the No-Auto
 -Move levels, which is usually used for the switch palace levels.
-Added Windows Clipboard support to the overworld editor's layer 2 8x8
 editing mode for standard cut, copy, and paste operations.
-Added a new ASM hack for the overworld that allows up to 0x4000 silent
 event steps for layer 1 and 2 combined.  The previous limit in the
 editor was 0x100 steps, which turned out to be a mistake since the
 actual limit used by the game was only 0x80 and exceeding it caused
 all silent event steps to not show up during gameplay.
-Included a new setting in the "Extra Options" of the overworld editor
 for toggling the ability to use the start button for scrolling on the
 main overworld map.
-Added a setting to the Boss Sequence dialog of the overworld editor
 for changing which level the earthquake sequence is activated on.
-The OV editor window was not redrawing itself to reflect changes made
 in the "Modify Level Tile Settings" dialog if it was activated using
 an alt-right-click, which has been fixed.
-The OV editor now has an option for viewing tile animation.
-A few of the keyboard shortcuts in the OV editor have been changed to
 be more consistent with the level editor.  Keys 3-6 have been moved
 to 7-0.  Sorry if that causes any confusion, I should have thought
 ahead...
-Added a new menu command to the OV editor to allow setting the FG GFX
 of each individual submap.  You can even specify ExGFX files. 
 However, you must use a star or pipe exit to make the game load the
 different graphics... a normal exit tile won't do it.
-Updated sprites 0x22, 0x23, 0x24, and 0x25 (the net koopas) to
 indicate whether they're below or above the net, which is apparently
 based on their X position.
-Added the ability to shift/wrap the currently selected 8x8 tile in
 the 8x8 tile editor left/right/up/down by one line of pixels using
 the shift and arrow keys.
-Fixed a few places where changing something wouldn't enable the quick
 save button in the main editor (background editor, palette editor). 
 Thanks goes out to Sendy and Someguy for bringing this up.
-If the midway entrance of a level is at the same location as the main
 entrance, the main entrance label will now simply display a leading
 ">" character.  It just looks less messy this way when translucent
 text is enabled.
-Inserted some code to stop Windows from setting the window focus to
 external programs when closing LM's tool windows under certain
 circumstances.  Thanks to the Juggling Joker for mentioning this.
-Fixed the palette number that the Ninji was using when displayed
 by the editor.  Thanks goes out to BMF for pointing this out.
-Fixed an issue where the "Auto-Set Number of Screens" option should
 have really been internally turned off for level (omitted).  Thanks
 goes out to BMF for bringing this up.
-Fixed an issue in the overworld editor where if you modified the
 Map16 data of a layer 1 level tile that can be "revealed" or
 "destroyed" through an event, in the game the revealed or destroyed
 tile still looked like the old unedited tile until the screen was
 refreshed.
-Fixed a bug where one of the extra events in the overworld that were
 removed by Nintendo (event 0x77) was not being enabled for use like
 the others, causing certain problems for any level that tried to use
 it.
-Fixed an issue where using other dialogs while the overworld palette
 editor was open at the same time could cause it to behave strangely.
-Fixed a bug where if you loaded the (omitted) screen in the overworld
 editor, then went back to the level editor and saved the currently
 loaded level, it would corrupt the level's custom palette (if it had
 one).
-Allowed editing the (omitted) screen palette from the overworld
 editor.
-Fixed a bug with the scan for undefined exits, where it wasn't
 checking for horizontal exit pipe tiles.  Thanks goes out to Gandalf
 for pointing this out.
-Removed all except one of the Boss Door tiles from the exit scan,
 since they don't act as a door.
-Fixed a bug in ExGFX support for the Japanese ROM.  Apparently the
 FG/BG GFX tracking code wasn't disabled like it should have been,
 which would cause bypassed FG/BG GFX to not load if you exited to a
 level that used the same GFX file in the standard list as the level
 you came from.  Simply insert your ExGFX with the new version of LM
 to install the fix for this.
-Updated the tool tip for sprite AD (wooden spike moving up/down). 
 It will move up or down first depending on its X position.  Thanks
 goes out to Sendy for pointing this out.
-Updated the tool tip for sprite 19 (instantly displays level message
 #1).  Apparently this sprite also causes Mario's current and last
 saved at overworld map number to be set back to the starting map of
 the game.  Also included an optional fix for the sprite to remove
 this limitation (read the tool tip for more info).
-Updated the tool tip for sprite 9.  The green koopa will jump high
 or low based on (Y&1), not on its height from the ground.  Thanks
 goes out to Lord Allan for bringing this up.
-With the overworld editor completed, this will likely be the last
 major release of Lunar Magic.  Future versions will probably just be
 for fixing any bugs that appear.  A big thank you goes out to the
 whole SMW hacking scene, for helping to make Lunar Magic the program
 it is today.  The last 3 years have been very memorable.  And who
 knows, maybe I'll make another editor some day...  -_^
-Set a new record for time between new releases (1 year).


Version 1.51 September 24, 2002 (...)

-Fixed a bug that caused the program to crash on startup in Win NT/XP
 based systems.
-Set a new record for time between new releases (4 hours).  


Version 1.50 September 24, 2002 (2nd year Anniversary of Lunar Magic!)

-Added a tool bar to the main Lunar Magic level editing window. 
 Buttons that are described as "quick" in the tool tips will skip the
 dialogs that normally appear when using the standard menu items for
 those functions.
-Added a menu item to scan for exit-enabled objects that lead to the
 bonus game levels, and included an option to do the scan automatically
 whenever you save a level to the ROM.  This may help people who
 accidentally use exit-enabled objects without setting them up to go
 anywhere.
-Added the ability to create gradients in the palette editor using
 control right-clicking, as suggested by Sendy.
-Updated creating/eating sprite block information, thanks to Iggy.
-Corrected Dry Bones SP GFX info, thanks to Iggy.
-Updated information for a few sprites that can be made to go away
 using Sprite Command 0xD2, thanks to Iggy.
-Fixed various spelling errors and names, thanks to KJAZZ.
-Apparently there are far more sprites that turn into silver coins
 when a silver POW is hit than I had realized.  Lunar Magic has been
 updated to reflect this.  Thanks goes out to KJAZZ and Dejiko.
-Added extra information on sprite DF, thanks to EYE.
-Corrected the door tool tip, since apparently if Mario is small, he
 CAN enter it while riding Yoshi.  Thanks goes out to EYE for pointing
 this out.
-Corrected a problem where Lunar Magic was not looking for the optional
 *.dsc file when opening a ROM using the command line.  Thanks goes out
 to EYE for pointing this out.
-Lunar Magic would not reload GFX structures 32 and 33 for rendering of
 animated tiles unless you reopened the ROM.  This has been changed so
 that they'll be reloaded whenever you reinsert the GFX.
-Fixed a small bug where hitting cancel in the palette editor would not
 reverse the changes if you had a custom palette.
-Fixed a nasty bug where if Lunar Magic tried to save a table of size 0
 in the ROM, the RAT system would save it with a size of 0x10000.  This
 could later cause large sections of data to get erased since SMW is a
 LoROM game and LM didn't expect data tables to be larger than 0x8000
 bytes.  Thanks goes out to EYE for supplying the hack that revealed
 this problem.
-Added a warning dialog to notify the user when one of the FG/BG/SP GFX
 or ExGFX files loaded by the level is larger then it should be, since
 some tile editors will modify the size of smaller files (which can
 cause glitches in the game).
-Fixed a bug where if you take a level that has a modified background
 image and changed the SNES Registers and Level Settings mode to have a
 level on layer 2, the custom BG flag would not be cleared when saving
 the level.  This could cause several problems.  One, SMW would try to
 decode the data as both a level and a background, though it would only
 display the level data.  In some cases this could cause the game to
 freeze/crash.  Two, Lunar Magic would decode the level data as a
 background but then discard it and display a blank level on layer 2,
 creating the illusion that LM was not saving layer 2.  LM would also
 allow you to use the level number as the source for a background to
 copy in the "Switch BG" menu.  And three, LM would attempt to erase
 the layer 2 level data as background data when saving over the level. 
 Which means that if the level being erased was last saved in LM version
 1.10 to 1.31, it could potentially cause other data in the same bank
 that was last saved in LM version 1.31 or lower to be erased!  (Data
 protected by RATS is unaffected in versions of LM that support it, ie.
 LM 1.40+.)  Thus this version of Lunar Magic correctly clears the
 custom BG flag when saving levels for layer 2, and also has extended
 checking to make erasing old levels with this problem safe for older
 non-RAT protected data.  Thanks goes out to several people on the SMW
 forum for pointing out symptoms of this bug, which has apparently been
 in Lunar Magic for over a year and a half...  O_O
-Cleaned up how Lunar Magic handles changing modes for levels on layer
 2 to images, and vice versa.  When switching to level modes that have
 fewer screens available than the current level mode, Lunar Magic will
 now simply delete the objects and sprites beyond the new maximum number
 of screens.  Also added a warning dialog for this.
-Objects and sprites that are on screens beyond the maximum number of
 screens allowed for the current level mode will no longer be displayed
 on the last screen in Lunar Magic.  The sprites will simply not be
 shown at all, and the objects may overwrite portions of the other level
 layer.  This is to more accurately emulate how SMW displays it.  If you
 have levels created in older versions of LM where the maximum number of
 screens were reduced due to a level mode change, you can hit CTRL-F8 to
 delete any extra objects and sprites.
-Changing the level mode setting will now cause Lunar Magic to
 automatically update the "Use Vertical Entrance Positioning" flag to
 reflect the level layout.
-Added some directional information to the tool tips of certain sprites.
-Added support for ROM_File_Name.ssc files to override the sprite tool
 tips.
-Tool tips will now show up in the Add Objects and Add Sprites windows.
-Tool tips for objects on layer 2 will now show up regardless of which
 editing mode you're in.
-Added a new option for making the text labels and outlines for
 entrances and exits translucent.
-Added support for exporting and importing Tile Layer Pro SNES palette
 files for levels.
-Added an item to the level menu for changing the Map16 page the BG is
 using.
-The background editor has received a long overdue update, and now
 includes multiple tile selection and drag/drop support, plus windows
 clipboard support.
-Attempting to insert non-existent GFX files will no longer mess up
 the ROM.
-Lunar Magic now saves the view animation option in the view menu to
 the registry, so that those with faster computers can start the program
 with this on all the time if they like.
-Lunar Magic will no longer switch to layer 1 editing mode when opening
 a different level.  It will stay in the editing mode you're currently
 in, if possible.
-Lunar Magic now specifies the current directory when opening a file
 dialog to avoid the "My Documents" default folder that Windows 98
 likes to use.
-Updated the dialog for the sprite header properties to explain the
 effects of sprite buoyancy on the game's speed and on interaction
 with layer 2.


Version 1.43 June 13, 2002

-Sprite 66 is apparently an upside down chainsaw, not just a duplicate
 of sprite 65.  Lunar Magic has been updated to reflect this.  A thank
 you goes out to Dwario for pointing this out.
-The OV editor window was not redrawing itself to reflect changes made
 in the "Modify Level Tile Settings" dialog, which has been fixed. 
 Thanks goes out to Sendy for noticing this.
-Added a menu command to allow exporting the level as a 24-bit bitmap
 file.
-Added a "Recent Files" section to the file menu.  
-Fixed a minor bug that caused the editor to refuse to open a MWL file
 if any of the file names within it were longer than 100 characters.
-Added a warning dialog to prevent people from inserting ExGFX as 4bpp
 when the ROM's GFX are still 3bpp or vice versa, as that will appear
 to scramble the graphics of one or the other.  The help file already
 warns against doing this, but apparently not everyone reads it.
-Added a more informative dialog for those that try to write to a
 read-only ROM file.
-The Easter egg for support of SMW in the Mario All Stars + World ROM
 has been turned into a standard feature.


Version 1.42 February 9, 2002

-Fixed a bug from version 1.40 which could occasionally cause the
 bonus game entrance to use secondary entrance 0 or 100, and the Yoshi
 wings to use secondary entrance C8 or 1C8.  The fix will be
 automatically inserted the first time you save a level to the ROM
 using the new version.
-Fixed a bug from version 1.40 where the X value in the main/midway
 entrance dialog for method 2 was sometimes being initialized to the
 wrong setting.
-Fixed a bug in the overworld editor where copying over *all* the
 tiles of the Layer 2 event path tile area in the Layer 2 8x8 editor
 mode with the blank "X" tile could cause rather nasty things to
 happen if saved to the ROM.
-Fixed what appears to be some sort of flaw or oversight on
 Nintendo's part, where the midway point entrance ASM code does not
 check the "Use Vertical Level Positioning for all entrances" flag. 
 The fix will be inserted the first time you save a level to the ROM
 with the new version.  Thanks goes out to Dwario for pointing out
 that there was a problem.
-Added level name editing to the overworld editor (not supported for
 the Japanese version).
-Added level message box text editing to the overworld editor (not
 supported for the Japanese version).
-Added boss sequence text editing to the overworld editor (not
 supported for the Japanese version).
-Added viewing options to show a text label with the level number
 and/or event number beside levels on the overworld in the overworld
 editor.  Thanks to Pikachu14 for the suggestion.
-Added a view option to display all Mario Paths as translucent tiles.
-Added a save prompt for when you try to open a different
 level/ROM/etc without saving the current level/overworld first.  You
 can turn it off in the options menu if you want.
-Added an option that allows LM to remember its window size for the
 next time you run the program.
-Added a dialog to the overworld editor that allows changing the level
 numbers the game checks for when determining if a defeated boss
 sequence or the end game sequence should be displayed.
-Added a dialog to the overworld editor that allows changing the level
 numbers the game checks for to display special messages like the
 switch palaces and Yoshi's house (not supported for the Japanese
 version).
-Added a dialog to the overworld editor that allows altering the level
 numbers the game checks for to enable the changes that occur when
 special world is passed.
-You can now use the "Modify Level Tile Settings" dialog in the
 overworld editor for certain non-level tiles that can be revealed by
 events, such as the translucent bridge and door tiles.
-Sprites 83 and 84 can give a flower or feather, but LM was only
 displaying a mushroom for both, so the program has been updated to
 display the correct images.  Thanks goes out to Sendy for pointing
 this out.
-Added support for ROM_File_Name.dsc files to override LM's tool tips
 for tiles.
-You can now use the middle mouse button to switch between sprite
 editing mode and the last used layer editing mode.


Version 1.41 January 1, 2002

-Fixed a bug from version 1.40 where there was a possibility of part
 of the overworld's layer 2 data being accidentally stored in a
 separate bank from the rest, making it inaccessible to the game and
 Lunar Magic.  Thanks goes out to SomeGuy for submitting his hack
 which revealed the problem.
-Fixed a bug from version 1.40 where one of the sections of data
 saved by the overworld editor was not being erased prior to saving
 a new copy of it.  This means repeatedly saving the overworld would
 result in the gradual build up of undeleted segments of data in
 the ROM.
-Fixed a compatibility bug in the new exit ASM code of version 1.40
 which was causing old style secondary exits to use mangled "Mario
 Action" values during gameplay.  The fix will be automatically
 inserted the first time you save a level to the ROM.  Thanks goes
 out to VinnyMack for pointing this out.
-Corrected a minor flaw in the OV editor's simulation of passing
 events.  Apparently only one tile can be "destroyed" per event...
 in cases where there are multiple entries for the same event, the
 one nearest to the bottom of the list is used.
-The "Future Layer 1 Tiles" option in the View menu of the overworld
 editor will now also make future path tiles translucent.
-You can now use the mouse scroll wheel in Win98 or above to
 increase/decrease the Z order of selected objects/sprites in Lunar
 Magic (I don't have a mouse with a scroll wheel though, so this
 feature hasn't been tested).


Version 1.40 December 25, 2001

-Added two new editing modes and several dialogs to the overworld
 editor for editing layer 1.  It's now possible to move around the
 levels, pipes, star roads, the paths Mario walks on, the event
 activated by passing a level, the direction enabled by passing an
 event, etc.
-A far better method of keeping track of used areas in the expanded
 portion of the ROM has been implemented.  This should prevent any
 future problems like the one in version 1.30.  However, only data
 saved with the new version of LM will use it.
-Added unofficial support for JW's tile set specific animated tile
 modification.
-A new option in the view menu can enable tile animation in the
 editor to mimic the animation you would see in the game for coins,
 question blocks, backgrounds, etc.
-Added two new viewing options to simulate hitting POWs and Silver
 POWs.
-Using a control right click to paste an object/sprite/tile/etc from
 an editor window regardless of what you already have selected has
 been implemented in all editing modes of LM that didn't already have
 it.  The previous function handled by control right clicking in the
 Layer 2 Event Editor Mode of the overworld editor has been moved to
 the shift key.
-Several ASM modifications have been done to SMW's level screen exit
 code.  One such modification has resulted in the removal of the old
 limitation of levels from 0XX not being able to exit to levels in
 1XX and vice versa; any level can now exit to any of the 0x200
 levels, and any level can access any of the 0x200 Secondary
 Entrances.  Note however that this is dependent upon Lunar Magic
 converting the exits in a level from the old style to the new
 style; the old style exits in unmodified levels will still follow
 the old rule.  For example, if you use a new exit to go from one
 level block to another, and then use an old style exit in that level,
 the old style exit will unexpectedly divert you back to the original
 level block.  But this can easily be solved simply by resaving the
 level that contains the old style exit so LM can automatically
 convert all the old style exits in the level to use the new
 enhancement.
-Secondary Entrances can now be set for individual screens, allowing
 you to use both standard and secondary entrances within the same
 level.  Thus the "Enable Secondary Entrances" option in the level
 menu has been moved to the "Add/Modify/Delete Screen Exits" dialog.
-Both the standard and secondary entrance dialogs now have a second
 method for setting the X/Y and Sub-Screen position which allows for
 any X/Y coordinate, with an option for using either the original
 method or the new method for setting Mario's position.
-The standard and secondary entrances can now directly specify if
 the level should be a water level or slippery (or both!), rather
 than using one of the Mario Action settings (which was previously
 the only way one could enable either of these).
-The "Sub-Screen Boundaries" option in the "View" menu has been
 updated to display the screen number and sub-screen label for each
 section, which may make placing entrances a bit easier.
-A few minor modifications have been made to the MWL format to
 accommodate the new exit information that has to be stored.  Older
 versions of LM can still read the newer MWL files, but they will
 import the main and secondary entrances incorrectly.  LM continues
 to remain backwards compatible with MWL files created with older
 versions of the program.
-It's now possible to resize objects using the mouse.  Just move
 the mouse cursor along the right and/or bottom edge of an object's
 tiles until the cursor changes.
-You can now export and import custom level palette files (MW3)
 directly through the file menu.
-An "Export Multiple Levels to Files" command has been added to the
 file menu.
-The "Insert at the original address of the level" option of the
 "Save Level to ROM" dialog has been removed.  It's an old function
 that should have been taken out long ago.
-The "Enhanced Level Management" option in the save level dialog was
 removed, as recent changes have made turning that off inadvisable
 under any circumstances.


Version 1.31 October 1, 2001

-Fixed a nasty bug from 1.30 that could potentially erase non-level
 data such as BG Map16 data, overworld data, etc when saving a level. 
 Thanks goes out to SomeGuy for submitting the patch that revealed
 this problem.
-Fixed a crash bug (!) that would occur in 1.30 if you left-clicked
 on the currently selected 8x8 tile in the 16x16 tile editor window
 without opening the 8x8 editor at least once beforehand.
-In the 16x16 properties dialog of the 16x16 editor window, the
 upper right and bottom left 8x8 tile numbers were switched around. 
 Thanks to Sendy for pointing this out.
-Fixed a bug where FG tiles >= 0x400 in the 16x16 properties dialog
 of the 16x16 editor window incorrectly reported tile gameplay
 settings of 0x130 in the 16x16 editor window, even when they had
 been changed.
-Sprite 18 (a surface jumping fish) is not "unused" as a tool tip
 in 1.30 indicated.  It has now been added to the sprite list, and
 the tool tip has been updated.  A thank you goes out to Iggy for
 pointing this out.
-Sprite A4 (a spike ball that floats on water) is slow or fast
 based on (X&1), so Lunar Magic's description of it has been
 updated.


Version 1.30 September 24, 2001 (1st year Anniversary of Lunar Magic!)

-Lunar Magic now supports the Japanese version of SMW!
-The overworld editor is no longer hidden, as just about everyone
 knows how to get into it by now anyway.  Only minor updates have been
 done to it since the last version.
-Added a dialog to the overworld editor that can switch the music
 selection of the submaps around.  Thanks goes out to ßouché for
 finding the data to support this.
-Added tool tips for objects and sprites in the main editor window. 
 If you have a really old version of comctl32.dll though (earlier than
 4.70), this feature will be automatically disabled.
-The palette editor is now a modeless dialog, meaning you can now keep
 it open while you edit the level.  The main editor window is updated
 immediately whenever changes to the palette are made.
-You can now use a control-left click to copy an existing color in the
 palette editor, and a right click to paste it back in. 
-Reversed the byte order of the SNES color values reported by the
 palette editor, since it was inconsistent with the order of the PC
 color values.
-Fixed a bug that appeared in version 1.20 of Lunar Magic where saving
 a level without a custom palette overtop of a level with a custom
 palette resulted in the level using a custom palette of "random"
 colors.
-Fixed another bug from version 1.20 where the "File", "Exit" command
 was closing the MDI child window instead of the parent window.
-Fixed a bug that caused a Yoshi egg placed at (X&3)==3 to appear
 yellow instead of blue.
-Fixed a couple bugs in rendering Extended Objects 91-96 at certain
 screen coordinates.  A thank you goes out to Iggy for sending me the
 level that allowed me to track this one down.
-Updated the BG ASM hack to support up to 16 pages (0x100 tiles/page)
 of Map16 data, a significant increase over Nintendo's limit of 2
 pages.  You can change the active page used by the background by
 using the Page Up/Down keys in the Background editor window.  Any
 ROM with the old BG ASM enhancement will be automatically detected
 and updated when a modified background is saved.
-Included a new ASM hack to support 16 pages of FG Map16 data, up
 from Nintendo's limit of 2 pages.  The first extended page has been
 made tile set specific, while the rest will remain fixed for all
 levels.  The new tiles can be accessed through the "Direct Map16
 Access" menu of the "Add Objects" window.
-Added the ability to set a FG Map16 tile to "mimic" the gameplay
 properties of another tile.  For example, if you copy a coin tile
 into one of the new FG pages, the tile will not only look like a
 coin, it'll actually act like one too!  To only copy a tile's
 appearance as in previous versions of Lunar Magic, just hold down
 the control key while pasting.
-Added the ability to export/import the currently loaded FG and BG
 Map16 data in the 16x16 Tile Map Editor Window using keyboard
 shortcuts (F2,F3,F5,F6,F7,F8).  Also added confirmation dialogs for
 those keys plus F9.
-Corrected a minor bug in the Background Editor Window, where it was
 using the temporary data of the currently selected tile in the 16x16
 Tile Map Editor Window when placing a tile into the Background Editor
 Window...it _should_ have only been using the tile number.  This
 created the illusion of being able to take a 16x16 tile, modifying
 it and then pasting it directly into the background without actually
 saving it somewhere in the Map16 data first.
-Added several minor enhancements and buttons to the 8x8 editor window.
-Added a music and time limit bypass dialog to override the settings
 in the level header. 
-Improved Drag/Drop logic.  The program isn't as strict regarding
 valid mouse positions when moving things near the edge of the screen
 or an invalid area.
-Repaired a bug where decreasing the Z-order of an object on layer 2
 beyond zero would result in the object jumping to layer 1 (I'm
 surprised this has never been noticed before...)
-Added 32 Mbit (4 meg) ROM expansion support.


Version 1.20 May 20, 2001

-Added a Windows Help file to the program.  The online documentation
 on the website will be taken down, since the help file is more easily
 maintained and generally more helpful.
-Added Cut/Copy/Paste commands for objects/sprites to the "Edit" menu. 
 This allows copying compatible objects or sprites between levels.  In
 fact, since it was implemented using the standard Windows Clipboard,
 you can even copy between multiple instances of Lunar Magic!
-Implemented basic SNES layering and color addition support, so that
 level modes 1E and 1F will now show up in the editor as they would in
 the game.  Although technically none of Nintendo's levels appear to
 have used those modes in the first place, it's still rather interesting
 to be able to make a translucent level. ^^
-Rewrote the animated tile support; Lunar Magic will now read the data
 from the ROM rather than having it hard coded.  Additionally, the
 "On/Off" block and the "always-turning" turn block will now show up
 as they'd appear in the game.
-Included a minor ROM modification that will enable support for the
 animated water surface tile in tile sets 4,5,7,9 & D (in other words,
 all the tile sets where the water surface would show up as a blue
 question block).  The modification will be inserted automatically the
 first time you save a level to the ROM.
-Added an ASM hack to allow appending a selectable ExGFX or GFX file 
 to the end of the animated tile area, for use in animated tiles.
-Added Flip X/Y buttons to the 16x16 editor window.
-Made a few minor modifications to the placement of certain window
 elements.  Probably the most noticeable change is that the status
 bar is now anchored to the bottom of the main window, which is really
 where I should have put it in the first place.
-Fixed a minor bug in the 8x8 tile editor, where it wouldn't update the 
 colors of the current palette it was using if the window was open while 
 a different level was loaded.  There was also an annoying screen flicker
 when that happened, which has also been fixed.
-The "Add Sprites" window will now display a small line of text at the
 top left of the preview screen to suggest which GFX files could be
 loaded into SP3/SP4 to view the sprite properly.
-Sprite 8C, the smoke and fire generator for Yoshi's house that also
 allows Mario to walk off the edge of the screen without passing the
 level, will apparently not display any smoke or fire when (x&1) is
 true.  Lunar Magic has been updated to do the same.
-Added a third category list to the "Add Sprites" window.  The new
 category will contain the special sprite commands (like layer 2
 scrolling, for example) and the sprite generators.
-Object 12 apparently does not detect and adjust for the tiles it is
 overwriting for the 4 upside-down slopes.  This has been corrected in
 Lunar Magic.  A thank you goes out to Jonathan for noticing this one.
-Lunar Magic will now identify and display in the status bar the contents
 of a block tile that has been placed using the Direct Map16 Access
 feature.
-Put in a warning message to notify the user when the exe file has
 been modified/corrupted by something (like a virus, for example). 
 Previously the program would just silently terminate itself on
 startup when that happened, which wasn't exactly informative.
-Various other minor updates.
-omitted.


Version 1.11 February 9, 2001

-fixed a bug in the "Bypass Standard SP GFX List" menu that affected
 vertical levels.  It caused Lunar Magic to incorrectly save the list
 index number to the ROM/MWL file and consequently made the game load
 the wrong sprite graphics.
-sprite 63 apparently depends on the value of (x&1), so I fixed it.
-included the "Open Level from Address" file menu command from the
 debug version.  It's useful for viewing some things that aren't in the
 main level pointer table.  Try address 0x30338 for the boss monster
 test room. ^^
-implemented a dialog to manually enter the four 8x8 tiles used to make
 up a 16x16 tile in the 16x16 Tile Map Editor, which is accessible
 through the previously unused "Edit 16x16 Attributes" button.  Although
 standard mouse clicks for copy/paste already do this when the 8x8 Tile 
 Editor Window is open, the former is more intuitive for beginners.
-invalid areas of the main screen are now painted black, rather than
 tiling the background image behind everything.  This is to make it
 easier to see the valid workspace area of the level.
-layer 2 levels are now painted with the default back area color
 rather than a blue gradient, for the sake of correctness.
-omitted. ^^


Version 1.10 December 25, 2000

-added an ASM hack to allow up to 0x80 additional GFX files to be
 stored in the ROM for level use, called ExGFX files.  Also added a 
 FG/BG/SP GFX tileset list bypass hack so a level can access these files.
 Basically, this creates a new table of 0xFF list entries that you have
 direct control over, allowing you to select exactly which 8 GFX files
 are loaded by a level.  Check the documentation for details.
-added an optional ASM hack to allow the use of 4bpp tiles in SMW 
 instead of 3bpp tiles.  In other words, most 8x8 tiles will have 
 access to all 16 colors of a palette instead of only 8. This
 increases the amount of raw GFX data to compress by ~25% though.
-modified the GFX insertion code so that if you run out of room
 inserting at 0x40200-0x60200, it will insert the rest of the GFX
 to the expanded portion of the ROM instead of just giving an error.
-modified the GFX insertion code to use the level manager whenever
 graphics are stored in the expanded ROM space (meaning it will 
 erase the old GFX and scan to ensure it doesn't overwrite things).
-added the "Classic Piranha Plant" and "Death Bat Ceiling" to the
 sprite list, since they can be safely implemented now with ExGFX.
-determined that "Sprite Display 1" in the sprite header selects 
 the sprite memory and the maximum number of sprites per screen.
-added a couple menu items that allow you to extract and insert the
 shared SMW palettes, useful for backing up and restoring colors.
-located and implemented the last missing level palette colors!
-editing the colors of the palette loaded by a level is now supported.
-added another ASM hack to give any level the option of having its
 own custom palette instead of using the standard shared palettes.
-registered another file type (MW3) for storing custom Mario World
 level palettes.
-the title screen colors are now loaded into the main level palette
 when viewing intro level 0xC7, unless it has a custom palette.
-Lunar Magic now inserts a minor hack into the ROM when saving level 
 0xC7 (the intro level) to prevent the game menu from changing the
 back area color to other hard-coded values.  If you don't want the 
 hack inserted for some reason, hit F8 before saving this level.
-a basic background tilemap editor is finally in place, as well as a 
 new ASM hack to support storing BG tilemaps in the extended ROM area.
-a new view menu item called "Special World Passed" was added, to allow 
 viewing level differences caused by completing Special World.
-I've removed the "Custom Collections of Objects" category from the 
 "Add Objects" window...this is only usable in the debug version
 anyway.  Consequently, the "custom.bin" and "custom.txt" files are no
 longer included in the zip file distribution.
-the options in the "Options" menu will now be saved to the Windows
 registry.
-fixed a potential bug in the level manager that could cause Lunar Magic
 to crash when trying to erase a corrupt level in the ROM.
-fixed a bug where the level manager wasn't correctly scanning some 
 sprite pointers.  This means that when it was removing a level there
 was a small chance that some data would only be partially erased.
-various other minor changes.


Version 1.03 October 28, 2000

-fixed a bug that was caused by an accidental change I made in version
 1.01.  It seems the "Sprite Display 1" value in the "Level/Change
 Sprite Header" menu was no longer being saved, making it impossible
 to change the value in the GUI.  Thanks goes out to DarKnight13 for
 pointing this out.
 
 
Version 1.02 October 10, 2000

-fixed a bug that I suspect was causing an overlapping level problem
 for many people.  Apparently when saving a level to the ROM, Lunar
 Magic wasn't storing the last address used to the ROM until after
 you did another ROM operation.  Which means if you went and saved a
 level, immediately exited LM (or reloaded the ROM), then later came
 back and saved a different level without changing the address that
 showed up, you'd often end up over-writing the first level.
 I can't believe I never noticed this bug until now... O_O
-implemented Enhanced Level Management.  Enabling this option will
 cause Lunar Magic to erase the level being replaced (if it's in the
 expanded ROM area), then scan and adjust the destination address to
 avoid overwriting any other data.  For best results, don't use this
 on old test ROM's that will likely have multiple undeleted and
 unreferenced levels from older versions of Lunar Magic.


Version 1.01 October 2, 2000

-fixed a minor display bug involving sprites in vertical levels.
-included an option for using joined GFX files instead of split ones.
-included Layer 3 options in the "Change Other Properties" Menu.
-documented the unknown bit in the "Change Properties in Header" Menu,
 which controlled Layer 3 layering.
 (thanks goes out to Mr. 207 for noticing what this bit was doing)
-documented and replaced the second value of the "Change Properties in
 Sprite Header" with options for sprite buoyancy.


Version 1.00 September 24, 2000

-First Release.


______________________________________________________________________

 4. Legal Notice
______________________________________________________________________

 The Lunar Magic Mario World Level Editor program (hereafter referred
 to as the "Software") is not official or supported by Nintendo or any
 other commercial entity.

 The Software is freeware thus it can be distributed freely provided
 the following conditions hold:(1) The Software is only distributed as
 the stand-alone original zip file provided by the author, with no
 files added, removed, or modified (2) The Software is not distributed
 with or as part of any ROM image in any format, and (3) No goods,
 services, or money can be charged for the Software in any form, nor
 may it be included in conjunction with any other offer or monetary
 exchange.

 The Software is provided AS IS, and its use is at your own risk.
 Anyone mentioned in this document will not be held liable for any
 damages, direct or otherwise, arising from its use or presence.
 

______________________________________________________________________

 5. Contact Information
______________________________________________________________________

 FuSoYa
   www:   http://fusoya.eludevisibility.org
   ???:   06942508

______________________________________________________________________
