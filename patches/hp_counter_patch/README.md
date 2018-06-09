# RPG-Styled HP and MP Counter Version



## Introduction

This patch adds an RPG-styled HP and MP counter to your Super Mario World ROM. The counter was inspired by old SNES RPGs like Secret of Mana or Seiken Densetsu 3. Up to 999 HP and 99 MP are supported. Some actions (like shooting fireballs, flying etc.) can be set up to cost MP. In that case you can’t use them if your MP are too low.

The patch rearranges the status bar. The Yoshi Coin counter, the bonus star counter, the lives counter and the “Mario”/“Luigi” text are removed to make room for the HP and MP counter (they still function normally and just aren't displayed anymore). The status bar item is replaced with Mario’s head as seen in Secret of Mana (I’ve also added a frame that you can easily remove with the Status Bar Editor if you don’t like it). To display the head correctly the Item Fix patch is used (a customized version of it is embedded directly into this patch). The head replaces the graphic of the smiley coin since that one is rarely used in SMW, but this can be customized via the config file.

With this patch, Mario won’t lose his power-up from taking damage - he only loses it when dying and always starts as Super Mario. Pick-ups have also been edited. A regular mushroom restores XXX HP now, a 1UP mushroom restores XX MP. If you collect a feather as Cape Mario or a flower as Fire Mario, they recover half the MP a 1UP mushroom recovers, so if your 1UP mushroom is set to recover 10 MP, feahther and flower recover 5 MP each.

I’ve added SRAM capability to this patch. Your HP, max HP, MP, max MP, power-up and item are saved to SRAM. Your lives are also saved to SRAM, but only if your current lives are higher than the default amount (otherwise the default is saved to SRAM).

Note that this patch disables the second player, so think twice before using it. On top of that, minor slowdown may occur when there are many sprites on the screen. Please remember to always backup your ROM before applying patches to it.

Use this patch on your own risk, I’m not responsible for any damage caused. This was the very first SMW patch I ever wrote and while it was slighty updated over the years, it should still be considered written by a beginner.

This patch should be compatible with the 6 Digit Coin Counter patch, but you have to apply the Coin Counter Patch first and this patch second.



## Usage

First of all you should insert GFX00.bin and GFX28.bin into your ROM, otherwise you will get garbage in the status bar. A few alternative GFX files using different graphical styles are included. Feel free to use whichever one you prefer.

After that you have to open hpconfig.cfg in a text editor and take a look at all the settings in there. The comments give detailed explanations on what each setting means. Tweak these settings as you like, save the file and apply hp_counter_patch.asm to your ROM via Asar.

The amount of damage a sprite deals by default is specified by the !Damage define. You can also set custom sprite damage. I’ve included a modified version of ICB’s Poison Goomba as a demonstration. Unlike with his HP patch, you have to add the code ABOVE the Mario <-> Sprite interaction routine, that was the only location where it worked for me. Don’t ask me why. I don’t have any experience with custom sprites. Anyways, this is the code you have to use:

```asm
lda #$02
sta HurtFlag           ;by default $0670
lda #DamageHighByte
sta FreeramHighByte    ;by default $0061
lda #DamageLow
sta FreeramLow         ;by default $0060
```

The !EnableBowserBattleStatusBar define enables or disables the HP counter for SMW's Bowser battle. When enabled, sprite_sb.bin is automatically inserted into the ROM. You can overwrite this with sprite_sb_TSRPR.bin if you're using the TSRPR-styled GFX files.



## Contribute

Encountered a bug, have a suggestion or want to contribute to this patch? Feel free to create an issue or a pull request on [my GitHub](https://github.com/RPGHacker/SMW-Workspace/).



## Special Thanks

- FPI for letting me use his TSRPR Status Bar GFX
- Mert for letting me use his custom Mario head
- People on SMWC, TMN, SMWH and YouTube who comment on my patch
- Everyone else who contributed to this patch in any way



## Version History


### Version 1.3 - xx/xx/xx

#### Contributors:
- ExE Boss
- RPG Hacker

#### Changes:
- Optimised a lot of code
- Added SA-1 support
- Added Sprite Status Bar to the Bowser battle, can be turned off if another patch already handles this
- Added support for VWF Dialogues and Free $7F4000
- Made it so that spin-jumping doesn’t auto-shoot fireballs everywhere
- Fireballs can now only be shot using the X button if they cost MP, this is to prevent wasteful usage of MP
- Knockback is now customisable
- Added support for more than 2 fireballs (requires the [Shoot More Fireballs patch](https://www.smwcentral.net/?p=section&a=details&id=4469))
- The Player head can now be moved around or removed altogether
- The status bar can now display MP values of up to 255, but the rest of the code still only supports values up to 99


### Version 1.2 - November 1, 2015

#### Contributors:
- Medic

#### Changes:
- Converted to Asar format


### Version 1.1 - July 21, 2009

#### Contributors:
- RPG Hacker

#### Changes:
- Fixed Bowser bug (glitched Mario head)
- Fixed Iggy/Larry bug (instant death when getting hit)
- Fixed some Wii and DS related problems
- Added “No MP refill when dead” option
- Added “No Powerup lose when dead” option
- Added “Floating doesn’t require MP” option
- Added new GFX Files
- Introlevel now has to be set in the ASM-file
- Improved Flying Routine
- Improved SRAM Support


### Version 1.0 - July 19, 2009

#### Contributors:
- RPG Hacker

#### Changes:
- Initial release
