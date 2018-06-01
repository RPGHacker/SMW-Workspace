#RPG-Styled HP and MP Counter Version


##Introduction

This patch installs an RPG-styled HP and MP Counter to your Super Mario World ROM. The counter was inspired by old SNES RPGs like Secret of Mana or Seiken Densetsu 3. You can have up to 999 HP and 99 MP. Some actions (like shooting Fireballs, Flying etc.) can be set up to cost MP. In that case you can’t use them if your MP are too low.

This patch rearranges the status bar. The Yoshi Coin Counter, the star counter, the lifes counter and “Mario”/“Luigi” are removed from the status sar in order to make room for the HP and MP Counter (they still work as normal, though). The status bar item is replaced with Mario’s head as seen in Secret of Mana (I’ve also added a frame that you can easily remove with the Status Bar Editor if you don’t like it). To display the head correctly the Item Fix patch is used. The head replaces the graphic of the smiley coin, since that one is rarely used in SMW anyways, but it can pretty easy be set up to replace any other graphic as well (just go to the ItemTable and edit the second value).

With this patch you won’t lose your powerup when you get hit, you only lose it when you die (you always start as Super Mario, though). The items have also been changed. A regular mushroom restores XXX HP, a 1UP mushroom restores XX MP. If you get a feather as Cape Mario or a flower as Fire Mario, they recover half the MP a 1UP mushroom recovers. So if your 1UP mushroom is set to recover 10 MP, feahther and flower recover 5 MP.

I’ve added SRAM capability to this patch. Your HP, max HP, MP, max MP, powerup and item are saved to SRAM. Your lifes are also saved to SRAM, but only if your current lifes are higher than the lifes you start with.

Note that this patch disables the second player, so think twice before using it. On top of that, minor slowdowns may occur when there are many sprites on the screen. Please remember to always backup your ROM before applying patches to it.

Use this patch on your own risk, I’m not responsible for any damage caused. I’ve just started making ASM patches a while ago and this is one of my first patches ever. The code may be written badly, it may contain bugs and even corrupt your ROM. I gave it my best, though, to avoids errors like this.

This patch should be compatible with the 6 Digit Coin Counter Patch, but you have to apply the Coin Counter Patch first and this patch second.


##Usage

First of all you should insert the ExGFX files into your ROM, else you will get trash in your status bar.

After that you have to open the ASM file and specify the starting values under the section “Value Defines” as well as a freespace address.


!IntroLevel
This is the intro level + #$24, so setting it to $E9 will load C5 as intro level. Setting it to $00 will disable the intro level, I don’t recommend this, though, as it causes a bug on the overworld.


!LifesatStart
These are the lifes to start with minus one. If you want to start with 1 life, set it to 00. Also if you want to keep your lifes from increasing you have to remove the semicolons at the beginnings of those lines:

;org $028ACD
;        nop #8

If you want to disable bonus stars completely, you have to remove the semicolons at the beginnings of those lines:

;org $05CF1B
;        nop #3
;
;
;org $009E4B
;        nop #3


!Damage
This is the damage a regular sprite takes away. You can also set custom sprite damage. I’ve included a modified version of ICB’s Poison Goomba as a demonstration. Unlike with his patch, you have to add the code ABOVE the Mario <-> Sprite interaction routine, that was the only location where it worked for me. Don’t ask me why. I don’t have any experience with custom sprites. Anyways, this is the code you have to use:

lda #$02
sta HurtFlag           ;by default $0670
lda #DamageHighByte
sta FreeramHighByte    ;by default $0061
lda #DamageLow
sta FreeramLow         ;by default $0060


!StartMaxHealth
These are the max HP to start with in Hex. You can’t go above 999 ($03E7).


!StartMaxMP
These are the max MP to start with in Hex. You can’t go above 99 ($63).


!RefillMPAfterDeath
Set this to $00 and your MP aren’t refilled after death, otherwise set it to any other number.


!LosePowerupAfterDeath
Set this to $00 to not lose your powerup afte death, otherwise set it to any other number.


!MushroomHeal
This is how much HP a regular mushroom heals in Hex.


!MPHeal
This is how much MP a 1UP mushroom recovers in Hex.


!FireballMP
This is how much MP a fireball takes away. Set to $00 to disable.


!CapeMP
This is how much MP flying takes away. Set to $00 to disable.


!FloatRequiresMP
Set this to $00 and floating doesn’t require any MP, otherwise set it to any other number and floating requires the same MP as set under !CapeMP (but you still don’t lose MP when floating).


!SpinMP
This is how much MP cape-spinning takes away. Set to $00 to disable.


!FlyReduceSpeed
This is how fast your MP are reduced while flying. The higher the number, the slower your MP are reduced. $32 is about one second.


##Known Bugs

- When you start a new game and skip the intro, Mario is shown as Game Over on the overworld (this fixes itself once you enter a level).


##Future Plans

None for now, but feel free to contribute to this patch via [my GitHub](https://github.com/RPGHacker/SMW-Workspace/).


##Special Thanks

- FPI for letting me use his TSRPR Status Bar GFX
- Mert for letting me use his custom Mario head
- People on SMWC, TMN, SMWH and YouTube who comment on my patch


##Version History

###Version 1.3 - xx/xx/xx

Contributors:
- Exe Boss
- RPG Hacker

Changes:
- Converted to Asar format

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


###Version 1.2 - November 1, 2015

Contributors:
- Medic

Changes:
- Converted to Asar format


###Version 1.1 - July 21, 2009

Contributors:
- RPG Hacker

Changes:
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


###Version 1.0 - July 19, 2009

Contributors:
- RPG Hacker

Changes:
- Initial release
