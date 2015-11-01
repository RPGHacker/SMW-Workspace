RPG-Styled HP and MP Counter Version 1.2
by RPG Hacker


;;;;;;;;;;;;;;
;Introduction;
;;;;;;;;;;;;;;

This patch installs an RPG-styled HP and MP Counter to your Super Mario World ROM.
The counter was inspired by old SNES RPGs like Secret of Mana or Seiken Densetsu 3.
You can have up to 999 HP and 99 MP. Some actions (like shooting Fireballs,
Flying etc.) can be set up to cost MP. In that case you can't use them if your
MP are too low.

This patch rearranges the Status Bar. The Yoshi Coin Counter, the Star Counter,
the Lifes Counter and "Mario"/"Luigi" are removed from the Status Bar in order
to make room for the HP and MP Counter (they still work as normal, though). The Status Bar
Item is replaced with Mario's head as seen in Secret of Mana (I've also added a frame that
you can easily remove with the Status Bar Editor if you don't like it). To display the head
correctly the Item Fix patch is used. The head replaces the graphic of the Smiley Coin,
since that one is rarely used in SMW anyways, but it can pretty easy be set up to
replace any other graphic as well (just go to the ItemTable and edit the second value).

With this patch you won't lose your Powerup when you get hit, you only lose it when
you die (you always start as Super Mario, though). The items have also been changed.
A regular Mushroom restores XXX HP, a 1UP-Mushroom restores XX MP. If you get a
Feather as Cape Mario or a Flower as Fire Mario they recover half the MP a 1UP-Mushroom
recovers. So if your 1UP-Mushroom is set to recover 10 MP, Feahther and Flower recover
5 MP.

I've added SRAM capability to this patch. Your HP, Max HP, MP, Max MP, Powerup and
Item are saved to SRAM. Your Lifes are also saved to SRAM, but only if your current Lifes
are higher then the lifes you start with.

Keep in mind that this patch disables the second player, so you should think twice before
using it. On top of that small slowdowns may occur when there are many sprites on the screen
(not too bad, though).
In any case:

MAKE A BACKUP BEFORE APPLYING THIS PATCH TO YOUR ROM!

Use this patch on your own risk, I'm not responsible for any damage you take. I've just started
making ASM patches a while ago and this is one of my first patches ever.
The code may be written badly, it may contain bugs and even corrupt your ROM. I gave it my
best, though, to avoids errors like this.

This patch should be compatible with the 6 Digit Coin Counter Patch, but you have to
apply the Coin Counter Patch first and this patch second.

You don't have to give me credits when using this patch. Just do as you like.


;;;;;;;
;Usage;
;;;;;;;

First of all you should insert the ExGFX Files to your ROM, else you will get trash in your
Status Bar.

After that you have to open the ASM-file and specify the starting values under the
section "Value Defines" as well as a Freespace Adress.


!IntroLevel
This is the Intro Level + #$24, so setting it to $E9 will load C5 as Intro Level. Setting
it to $00 will disable the Intro Level, I don't recommend this, though, since it creates
a little bug on the overworld


!LifesatStart
These are the Lifes to start with minus one. If you want to start with 1 life, set it to 00.
Also if you want to keep your lifes from increasing you have to remove the semicolons at the
beginnings of those lines:

;org $028ACD
;        nop #8

If you want to disable Bonus Stars completely, you have to remove the semicolons at the
beginnings of those lines:

;org $05CF1B
;        nop #3
;
;
;org $009E4B
;        nop #3


!Damage
This is the damage a regular Sprite takes away. You can also set custom Sprite damage.
I've included a modified version of ICB's Poison Goomba as a demonstration. Unlike with his
patch you have to add the code ABOVE the Mario <-> Sprite Interaction Routine, that was the
only location where it worked for me. Don't ask me why. I don't have any experience
with Custom Sprites. Anyways, this is the code you have to use:

lda #$02
sta HurtFlag           ;by default $0670
lda #DamageHighByte
sta FreeramHighByte    ;by default $0061
lda #DamageLow
sta FreeramLow         ;by default $0060


!StartMaxHealth
These are the Max HP to start with in Hex. You can't go above 999 ($03E7).


!StartMaxMP
These are the Max MP to start with in Hex. You can't go above 99 ($63).


!RefillMPAfterDeath
Set this to $00 and your MP aren't refilled after death, otherwise set it to any other
number.


!LosePowerupAfterDeath
Set this to $00 to not lose your powerup afte death, otherwise set it to any other number.


!MushroomHeal
This is how much HP a regular Mushroom heals in Hex.


!MPHeal
This is how much MP a 1UP-Mushroom recovers in Hex.


!FireballMP
This is how much MP a Fireball takes away. Set to $00 to disable.


!CapeMP
This is how much MP Flying takes away. Set to $00 to disable.


!FloatRequiresMP
Set this to $00 and Floating doesn't require any MP, otherwise set it to any other number
and Floating requires the same MP as set under !CapeMP (but you still don't lose MP when
floating)


!SpinMP
This is how much MP Cape-Spinning takes away. Set to $00 to disable.


!FlyReduceSpeed
This is how fast your MP are reduced while Flying. The higher the number, the slower your
MP are reduced. $32 is about one second.


;;;;;;;;;;;;
;Known Bugs;
;;;;;;;;;;;;

-When you start a new game and skip the intro, Mario is shown as Game Over on the Overworld
 (this fixes itself once you enter a level)


;;;;;;;;;;;;;;
;Future Plans;
;;;;;;;;;;;;;;

There is quite some stuff that I didn't implement yet, that I still want to add in a future
version of this patch.

-Switching through your Powerups by pressing select if you've already gotten them
 This would be useful since the Status Bar Item is disabled and the Select Button is unused
 in this game anyways. Also it would make the game more like an RPG.
-Adding more stuff that takes away MP (probably Spin-Jumping, Invincibility or
 summoning Yoshi?)
-Adding an EXP System (After you've killed a certain amount of monsters your Max HP and
 Max MP will be raised slightly)
-Tolerance system (Damge you take varies in a range of +/-15%)


;;;;;;;;;
;Contact;
;;;;;;;;;

If you find any bugs, have a suggestion, criticism, praise or a question, then
go ahead and contact me!

E-Mail:      markus_wall@web.de
MSN:         rpg_hacker@hotmail.de
SMW Central: RPG Hacker
YouTube:     RPGHacker86


;;;;;;;;;;;;;;;;
;Special Thanks;
;;;;;;;;;;;;;;;;

-FPI for letting me use his TSRPR Status Bar GFX
-Mert for letting me use his custom Mario head
-People on SMWC, TMN, SMWH and YouTube who comment on my patch


;;;;;;;;;;;;;;;;;
;Version History;
;;;;;;;;;;;;;;;;;
Version 1.2 - 2015/11/1
i converted it to asar (medic)

Version 1.1 - 2009/07/21

-Fixed Bowser bug (glitched Mario head)
-Fixed Iggy/Larry bug (instant death when getting hit)
-Fixed some Wii and DS related problems
-Added "No MP refill when dead" option
-Added "No Powerup lose when dead" option
-Added "Floating doesn't require MP" option
-Added new GFX Files
-Introlevel now has to be set in the ASM-file
-Improved Flying Routine
-Improved SRAM Support


Version 1.0 - 2009/07/19

-Main Patch Release
