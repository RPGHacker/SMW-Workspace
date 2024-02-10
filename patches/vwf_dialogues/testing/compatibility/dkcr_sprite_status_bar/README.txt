
                ###########################################
                #                                         #
                #      DKCR STYLED SPRITE STATUS BAR      #
                #                                         #
                #    made in 2012-19 by WhiteYoshiEgg,    #
                #  with lots of help from various people  #
                #                                         #
                ###########################################

This patch replaces SMW's status bar with a system similar to that of the
DKC/DKCR series. Counters are implemented as sprites that slide in and out
independently, and shup up only when needed (i.e. the number changes).

                USAGE INSTRUCTIONS BELOW (SEE "HOW TO USE")


MAIN FEATURES
    - Counters that slide in and out independently
    - Shows lives, coins, Yoshi/Dragon coins and the reserve item
    - No fixed Y position for counters; each finds the best spot on its own
    - Lack of layer 3 status bar allows for full-screen layer 3 backgrounds

DRAWBACKS AND LIMITATIONS
    - No timer, no score, no bonus stars
    - Needs lots of graphics space in GFX00
      (the Mario GFX DMA will be installed automatically if you haven't yet)
    - Will overwrite the coin game cloud tile
    - Counters will look glitched in mode 7 boss battles, so I disabled them
      (except for the reserve item, which only looks slightly wonky and is
      the only one that's really needed anyway) - the gameplay's fine though
    - If you're using the Custom Powerups patch, every shelless koopa shares
      the same graphics and the flopping fish graphics are overwritten.

CHANGELOG
    - Version 2.2 (April 23, 2019):
        - Fixed some crashes when applying the patch again to your ROM after
          changing !ShowAtMidwayPoint, !ShowAtGoal or !ShowWhenPaused from 
          1 to 0. (lx5)
        - Implemented a better Custom Powerups patch support. (lx5)
        - Fixed miscelaneous sprites not being executed on SA-1 CPU on SA-1
          enhanced ROMs. (lx5)
    - Version 2.1 (January 22, 2019):
        - Added Custom Powerups patch support (lx5)
        - Added hex edits to remap the shelless koopas graphics to make room
          in SP2 (lx5)
        - .palmask file for paletteF.pal is now included
    - Version 2.0 (January 21, 2018):
        - Actually named the thing DKC*R* Styled Sprite Status Bar like I
          intended all along
        - Tidied up the ASM file visually
        - Moved defines and options to a separate file
        - Added a .palmask file for the palette
        - Made it easier to disable the status bar on the title screen and
          in the intro level (via defines; both are disabled by default)
        - Fixed a bug where a Game Over would send you to the overworld
          with 99 lives and no "continue/end" menu
          (thanks to imamelia and Gamma V for reporting this!)
        - Fixed a bug where a couple of sprite tiles would disappear when a
          message box was on screen (thanks to LX5 for reporting this!)
        - Fixed a typo that made all counters except the reserve item ignore
          the !CounterSpeed define (it had been useless all that time!)
        - Fixed a bug that would glitch mode 7 boss battles (thanks to
          Gamma V for reporting this, and to Ladida for helping me fix it!)
        - Added compatibility with the VWF Dialogues patch
        - Added SA-1 compatibility (thanks to MaxodeX for converting the
          previous version!)
        - Minor technicality: Changed the timer code so it only counts down
          when a counter is fully visible
        - Added options for independent sliding-in and sliding-out speeds
        - Added options to make the counters appear and/or disappear
          instantly instead of sliding in/out
        - Added options to show all counters on getting a midway point
          and/or goal point
        - Added an option to show all counters when the player is idle
          for a while
        - Added an option to show all counters when the game is paused
          (finally got this working! thanks to p4 and Ladida for the help!)
    - May 27, 2015: Updated the Mario GFX DMA patch to the newest version;
      all status bar graphics now fit into GFX00
    - January 31, 2015: Fixed the lives counter overflowing after 99

HOW TO USE
    1. Change the options in status_bar_config.asm if you want
    2. Patch status_bar.asm to your ROM with Asar
    3. Insert GFX00.bin with Lunar Magic
       (if you've already edited it, just copy the relevant tiles over)
    4. Insert PaletteF.pal (affects only the very last palette row)
    5. That's it!

HOW TO USE FOR CUSTOM POWERUP PATCH USERS
    1. Change the options in status_bar_config.asm and
       status_bar_powerup_config.asm if you want
    2. Patch status_bar.asm to your ROM with Asar after you have applied
       the Custom Powerups patch
    3. Insert GFX00.bin and GFX01.bin in the folder with Lunar Magic
       (if you've already edited it, just copy the relevant tiles over)
    4. Insert PaletteF.pal (affects only the very last palette row)
    5. That's it!


NOTES FOR ASM DEVELOPERS
    - This patch gives you 53 bytes of RAM - previously used
      by SMW's status bar, but now free to use however you want!
      ($0F0B-$0F5D, cleared on level load)
    - If you disable the "show when idle" feature in the config file,
      !IdleTimer ($0F0A by default) is also free to use
    - You can disable the status bar on the fly by storing non-zero
      to !DisableStatusBar ($0F09 by default)

CREDIT?
    - It'd be awesome, but I can't force you, so whatever.
    - Additional code contributions:
        - Ladida (Mario GFX DMA patch)
        - p4plus2 (Disabling SMW's status bar, pause handling)
        - edit1754 (Disabling IRQ)
        - Aiko and imamelia (Disabling bonus stars)
        - MaxodeX (initial SA-1 conversion)
        - lx5 (Custom Powerups patch support)

THANKS FOR HELP, BUG REPORTS AND SUGGESTIONS
    - lx5
    - Ladida
    - p4plus2
    - Gamma V
    - imamelia

DISCLAIMER
    - I cannot guarantee that no other bugs are present,
      and much less that I will fix them.
