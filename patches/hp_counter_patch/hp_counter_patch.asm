@asar 1.50

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;RPG-Styled HP and MP Counter Patch by RPG Hacker;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


incsrc ../free_7F4000/freeconfig.cfg
incsrc hpconfig.cfg
incsrc ../shared/shared.asm


print "HP/MP Counter Patch - (c) RPG Hacker"


math pri on
math round off

pushtable
cleartable


namespace hp_counter_patch_



;;;;;;;;
;Values;
;;;;;;;;



if !use_sa1_mapping
	!HP	= !HP_SA1
	!MP	= !MP_SA1
	!MaxHP	= !MaxHP_SA1
	!MaxMP	= !MaxMP_SA1

	!FreeRAM	= !FreeRAM_SA1
	!CheckRAM	= !CheckRAM_SA1
	!PowerupRAM	= !PowerupRAM_SA1
	!HurtFlag	= !HurtFlag_SA1
	!FlyTimer	= !FlyTimer_SA1
	!BowserRAM	= !BowserRAM_SA1
	
	!SRAM_HP	= !BWRAM_HP
	!SRAM_MaxHP	= !BWRAM_MaxHP
	!SRAM_MP	= !BWRAM_MP
	!SRAM_MaxMP	= !BWRAM_MaxMP
	!SRAM_Item	= !BWRAM_Item
	!SRAM_Powerup	= !BWRAM_Powerup
	!SRAM_Lives	= !BWRAM_Lives
endif

!IntroLevel #= select(equal(!IntroLevel,0),0,(!IntroLevel+$24))

!false	= 0
!true	= 1

;;;;;;;;;
;Hijacks;
;;;;;;;;;



org	remap_rom($05CF1B)	;\
	nop #3	; |
		; | Disable Bonus Game
		; |
org	remap_rom($009E4B)	; |
	nop #3	;/


org	remap_rom($028ACD)	;\ Disable 1UP Increasing and Sound
	nop #8	;/


org	remap_rom($008F9D)	;\
	jml $008FC5	; |
	nop	; |
		; |
		; |
org	remap_rom($009053)	; | Remove Bonus Stars from Status Bar
	nop #3	; |
		; |
		; |
org	remap_rom($009068)	; |
	nop #3	;/


if read2(remap_rom($008FF0)) == get_status_ram(8,2)
org	remap_rom($008FEF)	;\ Remove Yoshi Coin Counter from Status Bar
	nop #3	;/
endif


if read1(remap_rom($008FCB)) == $F0
org	remap_rom($008FCB)	;\ Remove Mario/Luigi from Status Bar
	db $80	;/
endif


org	remap_rom($008F49)	;\ Jump to new Status Bar Routine
	autoclean jml StatusBar	;/


org	remap_rom($00F5F8)	;\ Disable Item Box getting used when hurt
	nop #$4	;/


org	remap_rom($00C570)	;\ Disable Item Box getting used when pressing Select
	db $80	;/


org	remap_rom($009E48)	;\ Disable Item Box Reset at Game Start
	nop #3	;/


org	remap_rom($00F600)	;\ Disable Powerup Taking when hurt
	nop #$2	;/


org	remap_rom($00D129)	;\ Eliminate Powerdown Animation and jump to Flash Routine
	db $EA,$EA,$EA,$80	;/


org	remap_rom($009E2C)	;\
	autoclean jml NewGame	; | Loading/starting a game from title screen
	nop #2	;/


org	remap_rom($00F5D5)	;\ Custom Damage Routine
	autoclean jml DamageHP	;/


org	remap_rom($00F5B2)	;\ When falling into a hole or lava
	autoclean jsl CustomPitDeath	;/


org	remap_rom($00F606)	;\ Jump to Custom Death Routine
	autoclean jml CustomDeath	;/


org	remap_rom($00A0E6)	;\ Refill Health when you die
	autoclean jsl RefillHealth	;/


org	remap_rom($009BCC)	;\
	autoclean jsl SaveSRAMRoutine	; | Jump to new SRAM Saving Routine
	nop #2	;/


org	remap_rom($009D24)	;\
	autoclean jsl OnePlayer	; | Jump to 2-Player-Disable Code
	nop	;/

org	remap_rom($01C510)	;\
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; | Disable Items giving Status Bar Items
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;/


org	remap_rom($01C524)	;\ Mushroom always gives Mushroom Power
	db $00,$00,$00,$00	;/


org	remap_rom($01C528)	;\ Flower always gives Flower Power
	db $04,$04,$04,$04	;/


org	remap_rom($01C52C)	;\ Star always gives Star Power
	db $02,$02,$02,$02	;/


org	remap_rom($01C530)	;\ Feather always gives Feather Power
	db $03,$03,$03,$03	;/


org	remap_rom($01C534)	;\ 1UP-Mushroom always gives 1UP-Mushroom Power
	db $05,$05,$05,$05	;/


org	remap_rom($01C561)	;\
	autoclean jml Mushroom	; |
		; |
org	remap_rom($01C592)	; |
	autoclean jml Star	; |
		; |
org	remap_rom($01C598)	; |
	autoclean jml Feather	; | Powerup Hijacks
		; |
org	remap_rom($01C5EC)	; |
	autoclean jml Flower	; |
		; |
org	remap_rom($01C5FE)	; |
	autoclean jml Oneup	;/

org	remap_rom($009095)	;\ Fix Status Bar Item
	autoclean jml ItemFix	;/


org	remap_rom($00D081)	;\ Hijack Fireball Routine
	autoclean jml Fireball	;/


org	remap_rom($00D676)	;\
	autoclean jml Flyroutine1	; |
	nop	; |
		; |
org	remap_rom($00D802)	; |
	autoclean jml Flyroutine2	; |
		; |
org	remap_rom($00D8E7)	; |
	autoclean jml Flyroutine3	; |
		; | Hijack Flying Routines
org	remap_rom($00D062)	; |
	autoclean jml Flyroutine4	; |
		; |
org	remap_rom($00D07B)	; |
	autoclean jml Flyroutine5	; |
		; |
org	remap_rom($00D832)	; |
	autoclean jml Flyroutine6	; |
	nop #2	;/

org	remap_rom($009CB0)	;\
	autoclean jml InitialSetup	; | Load Intro Level
	nop	;/

org	remap_rom($00971A)	;\ Load Initial Data
	autoclean jml IntroLevelSet	;/

org	remap_rom($009CF8)	;\
	autoclean jml IntroDone	; | If Intro already played through
	nop	;/

org	remap_rom($008C81)	;\
	db $FC,$38,$FC,$38,$FC,$38,$FC,$38,$FC,$38	; |
		; |
org	remap_rom($008C8B)	; |
	db $40,$3C,$41,$3C,$FC,$38,$11,$38,$19,$38,$FC,$38	; |
	db $FC,$38,$FC,$38,$00,$38,$44,$38,$FC,$38,$FC,$38	; |
	db $00,$38,$FC,$38,$FC,$38	; |
		; |
org	remap_rom($008CC1)	; | Status Bar Rearrangement
	db $42,$3C,$43,$3C,$FC,$38,$16,$38,$19,$38,$FC,$38	; |
	db $FC,$38,$FC,$38,$00,$38,$44,$38,$FC,$38,$FC,$38	; |
	db $00,$38,$FC,$38,$FC,$38	; |
		; |
org	remap_rom($008CF7)	; |
	db $FC,$38,$FC,$38,$FC,$38,$FC,$38	;/

if !EnableBowserBattleStatusBar
	org remap_rom($0082E2)
		jml BowserBattle_DMA

	org remap_rom($01836E)
		jsl BowserBattle_InitBowserScene

	org	remap_rom($03B44F)
		jsl BowserBattle_BowserItemBoxGfx
		rts
endif

;;;;;;;;
;Macros;
;;;;;;;;


; A macro to write a value to the Status Bar
macro WriteStatusBar16(x,y,addr)
	rep #$20
	lda remap_ram(<addr>)
	jsl Conversion16
	sep #$20
	sta get_status_ram(<x>+2,<y>)
	cpy #$00
	bne ?ThreeDigit
	ldy #$FC
?ThreeDigit:
	sty get_status_ram(<x>,<y>)
	txa
	bne ?TwoDigit
	ora get_status_ram(<x>,<y>)
	bpl ?TwoDigit
	ldx #$FC
?TwoDigit:
	stx get_status_ram(<x>+1,<y>)
endmacro

; Same as above, but 8 bit
macro WriteStatusBar8(x,y,addr)
	lda remap_ram(<addr>)
	jsl Conversion8
	sta get_status_ram(<x>+2,<y>)
	cpy #$00
	bne ?ThreeDigit
	ldy #$FC
?ThreeDigit:
	sty get_status_ram(<x>,<y>)
	txa
	bne ?TwoDigit
	ora get_status_ram(<x>,<y>)
	bpl ?TwoDigit
	ldx #$FC
?TwoDigit:
	stx get_status_ram(<x>+1,<y>)
endmacro


; Used for the sprite status bar
macro BowserBattle_SBTile(dest,x,y,tile,size)
	lda.b #<size>
	sta.w remap_ram($0420+<dest>)
	lda.b #<x>
	sta.w remap_ram($0200+(<dest><<2))
	lda.b #<y>
	sta.w remap_ram($0201+(<dest><<2))
	lda.b #<tile>+$C0	;\
	sta.w remap_ram($0202+(<dest><<2))	; | Enforce that bowser’s battle mode always uses lines 4-5 of SP2 (underwater BG),
	lda.b #$30	; | Which are the only unused tiles in this battle mode.
	sta.w remap_ram($0203+(<dest><<2))	;/
endmacro

macro BowserBattle_SBDigit(addr,dest,offset)
	if !use_sa1_mapping
		ldy.b #%11000100
		sty $2230
	else
		stz.w $4300
		ldy.b #$80
		sty.w $4301
	endif
	sep #%00100000	; 8-bit A
	lda.w <addr>
	cmp.b #$FC
	rep #%00100000	; 16-bit A
	bne ?NoTrans
	lda.w #($000F<<5)
	bra ?Proceed
?NoTrans:
	and.w #$00FF
	if <offset> : clc : adc.w #(<offset><<5)
	asl #5
?Proceed:
	clc : adc.w #BowserBattle_SBGFX
	sta select(!use_sa1_mapping,$2232,$4302)
	ldy.b #get_bank_byte(BowserBattle_SBGFX)
	sty select(!use_sa1_mapping,$2234,$4304)

	lda.w #$0020
	sta select(!use_sa1_mapping,$2238,$4305)

	lda.w #remap_ram(!BowserRAM+(<dest><<5))
	sta select(!use_sa1_mapping,$2235,$2181)
	ldy.b #get_bank_byte(remap_ram(!BowserRAM))
	sty select(!use_sa1_mapping,$2237,$2183)

	if !use_sa1_mapping
	-	ldx $318C
		beq -
		ldx #$00
		stx $318C
		stx $2230
	else
		ldy.b #%00000001
		sty $420B
	endif
endmacro


;;;;;;;;;;;;;;;;;
;MAIN CODE START;
;;;;;;;;;;;;;;;;;


freedata

struct SaveData remap_ram(!SRAM_HP)
	.HP:
		.hp_low:	skip 1
		.hp_high:	skip (remap_ram(!SRAM_MaxHP)-remap_ram(!SRAM_HP)-1)

	.MaxHP:
		.MaxHP_low:	skip 1
		.MaxHP_high:	skip (remap_ram(!SRAM_MP)-remap_ram(!SRAM_MaxHP)-1)

	.MP:	skip (remap_ram(!SRAM_MaxMP)-remap_ram(!SRAM_MP))
	.MaxMP:	skip (remap_ram(!SRAM_Item)-remap_ram(!SRAM_MaxMP))
	.Item:	skip (remap_ram(!SRAM_Powerup)-remap_ram(!SRAM_Item))
	.Powerup:	skip (remap_ram(!SRAM_Lives)-remap_ram(!SRAM_Powerup))
	.Lives:	skip (remap_ram(!SRAM_HP)-remap_ram(!SRAM_Lives)+1)
endstruct

FreecodeStart:





;;;;;;;;;;;;;;;;;;;;;;;;;;
;Status Bar Rearrangement;
;;;;;;;;;;;;;;;;;;;;;;;;;;


StatusBar:
	%WriteStatusBar16($09,$02,!HP)
	%WriteStatusBar16($0D,$02,!MaxHP)

	%WriteStatusBar8($09,$03,!MP)
	%WriteStatusBar8($0D,$03,!MaxMP)

	lda remap_ram($0D9B)
	cmp #$C1
	bne .bowserSkip

	lda remap_ram($190D)
	bne .bowserSkip
	stz remap_ram($190D)

.bowserSkip:
	jml remap_rom($008F5B)	; Return to Main Code, skip lives and Bonus Stars to save cycles


if !EnableBowserBattleStatusBar
	BowserBattle:
	.InitBowserScene:
		jsl remap_rom($03A0F1)
		jsl .init
		rtl

	.returnSepXY:
		sep #%00010000	; 8-bit X/Y
		rtl

	.init:
		rep #%00100000	; 16-bit A
		if !use_sa1_mapping
			ldy.b #%11000100
			sty $2230
		else
			stz.w $4300
			ldy.b #$80
			sty.w $4301
		endif
		lda.w #BowserBattle_SBGFX+$200
		sta select(!use_sa1_mapping,$2232,$4302)
		ldy.b #get_bank_byte(BowserBattle_SBGFX)
		sty select(!use_sa1_mapping,$2234,$4304)

		lda.w #$0360
		sta select(!use_sa1_mapping,$2238,$4305)

		lda.w #remap_ram(!BowserRAM)
		sta select(!use_sa1_mapping,$2235,$2181)
		ldy.b #get_bank_byte(remap_ram(!BowserRAM))
		sty select(!use_sa1_mapping,$2237,$2183)

		if !use_sa1_mapping
		-	ldx $318C
			beq -
			ldx #$00
			stx $318C
			stx $2230
		else
			ldy.b #%00000001
			sty $420B
		endif
		sep #%00100000	; 8-bit A

	.BowserItemBoxGfx:
		lda remap_ram($0D9B)	;\ If we’re done fighting Bowser, hide the status bar.
		cmp #$C1	;|
		bne .returnSepXY	;|
		lda remap_ram($190D)	;|
		beq +	;|
		stz remap_ram($0DC2)	;|
		bra .returnSepXY	;/

	+	lda #$00 : xba
		phx
		rep #%00010000	;> 16-bit X/Y

		if !PlayerHead_Sprite
			%BowserBattle_SBTile($00,!PlayerHead_X,!PlayerHead_Y,$00,%10)
		endif
		%BowserBattle_SBTile(select(!PlayerHead_Sprite,$02,$00),$30,$0F,$02,%10)
		%BowserBattle_SBTile(select(!PlayerHead_Sprite,$03,$01),$48,$0F,$04,%10)
		%BowserBattle_SBTile(select(!PlayerHead_Sprite,$04,$02),$50,$0F,$05,%10)
		%BowserBattle_SBTile(select(!PlayerHead_Sprite,$2A,$03),$60,$0F,$07,%10)
		%BowserBattle_SBTile(select(!PlayerHead_Sprite,$2B,$04),$70,$0F,$09,%10)

		sep #%00010000	; 8-bit X/Y
		rep #%00100000	; 16-bit A
		
		%BowserBattle_SBDigit(get_status_ram($09,$02),$04,$00)	;\ HP
		%BowserBattle_SBDigit(get_status_ram($0A,$02),$05,$00)	;|
		%BowserBattle_SBDigit(get_status_ram($0B,$02),$06,$00)	;/
		%BowserBattle_SBDigit(get_status_ram($0D,$02),$08,$00)	;\ Max HP
		%BowserBattle_SBDigit(get_status_ram($0E,$02),$09,$00)	;|
		%BowserBattle_SBDigit(get_status_ram($0F,$02),$0A,$00)	;/

		%BowserBattle_SBDigit(get_status_ram($09,$03),$14,$00)	;\ MP
		%BowserBattle_SBDigit(get_status_ram($0A,$03),$15,$00)	;|
		%BowserBattle_SBDigit(get_status_ram($0B,$03),$16,$00)	;/
		%BowserBattle_SBDigit(get_status_ram($0D,$03),$18,$00)	;\ Max MP
		%BowserBattle_SBDigit(get_status_ram($0E,$03),$19,$00)	;|
		%BowserBattle_SBDigit(get_status_ram($0F,$03),$1A,$00)	;/

		sep #%00100000	; 8-bit A
		if !BowserRAM >= $7F4000 && !BowserRAM < $7F8000 && read1($00A0B9) == 22 && !use_dirty_flag_for_ow_reload
			%sta_one_or_inc(remap_ram(!ow_dirty_flag))
		endif
		plx
		rtl

	.DMA:
		lda remap_ram($0D9B)
		cmp #$C1
		beq ..bowserBattle
		lsr
		jml remap_rom($0082E6)

	..bowserBattle:
		rep #%00100000	; 16-bit A
		ldy #%10000000	;\ increment when high
		sty $2115	;/ byte is accessed
		lda.w #($0C0<<4)+$6000	; Start at Sprite GFX index 0C0
		sta $2116	; set as VRAM destination
		ldy #$01	;\
		sty $4300	; | rest of
		ldy #$18	; | GFX buffer
		sty $4301	; | transfer
		lda.w #remap_ram(!BowserRAM)	; | to VRAM
		sta $4302	; |
		ldy.b #get_bank_byte(remap_ram(!BowserRAM))	; |
		sty $4304	; |
		lda #$0360	; |
		sta $4305	; |
		ldy #%00000001	; |
		sty $420B	;/
		sep #%00100000	;> 8-bit A
		jml remap_rom($0082EB)	;> Return
endif


;;;;;;;;;;;;;;;;;
;One Player Only;
;;;;;;;;;;;;;;;;;


OnePlayer:
	inc remap_ram($0100)	;\
	lda remap_ram($0100)	; |
	cmp #$0A	; |
	bne .return	; |
	inc remap_ram($0100)	; | Disable second Player
	pea $8074	; |
	pea $9E64	; |
	pea $9E12	; |
	jml remap_rom($00A195)	;/

.return:
	ldy #$12
	rtl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Starting a new game/Loading a Game;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


InitialSetup:
	lda.b #!IntroLevel	;\
	sta remap_ram($0109)	; |
	beq .skippedIntro	; | Load Intro Level at Start Up
	%sta_zero_or_stz(remap_ram(!CheckRAM))	; |
	jml remap_rom($009CB5)	;/

.skippedIntro:
	%sta_one_or_inc(remap_ram(!CheckRAM))
	jml remap_rom($009CB5)


IntroDone:
	stz remap_ram($0109)	;\
	%sta_zero_or_stz(remap_ram(!CheckRAM))	; | Don't load Intro if Save File exists
	lda #$8F	; |
	jml remap_rom($009CFD)	;/


IntroLevelSet:
	lda remap_ram(!CheckRAM)	;\
	bne .introWasSkipped	; |
	lda remap_ram($0109)	; | Check, if Intro Level was loaded
	cmp #$00	; |
	beq .skipIntroLevel	; |
	cmp.b #!IntroLevel	; |
	bne .noInitialLoad	;/

.introWasSkipped:
	rep #$20	;\
	lda remap_ram($010A)	; |
	asl	; |
	tax	; |
	lda.w #!StartMaxHP	; |
	jsl Inputcheck16	; |
	sta remap_ram(!FreeRAM)	; |
	lda remap_ram(!FreeRAM)	; |
	sta remap_ram(!MaxHP)	; |
	sta SaveData.MaxHP,x	; |
	sta remap_ram(!HP)	; |
	sta SaveData.HP,x	; |
	ldx remap_ram($010A)	; |
	sep #$20	; |
		; |
	lda.b #!StartMaxMP	; |
	jsl Inputcheck8	; | Reset SRAM Data at New Game
	sta remap_ram(!FreeRAM)	; |
	sta remap_ram(!MaxMP)	; |
	sta SaveData.MaxMP,x	; |
	sta remap_ram(!MP)	; |
	sta SaveData.MP,x	; |
		; |
	lda #$01	; |
	sta remap_ram($0DC2)	; |
	sta remap_ram($0DBC)	; |
	sta SaveData.Item,x	; |
	sta $19	; |
	sta remap_ram($0DB8)	; |
	sta SaveData.Powerup,x	; |
		; |
	lda.b #!LivesAtStart	; |
	sta remap_ram($0DBE)	; |
	sta remap_ram($0DB4)	; |
	sta SaveData.Lives,x	;/

	lda remap_ram(!CheckRAM)	;\ If Intro was Skipped
	bne .skipIntroLevel	;/

.noInitialLoad:
	lda remap_ram($0109)	;\
	cmp #$E9	; | Return to Main Code
	bne ..ChangedIntroLevel	; |
	jml remap_rom($009723)	;/

..ChangedIntroLevel:
	jml remap_rom($009740)

.skipIntroLevel:
	%sta_zero_or_stz(remap_ram(!CheckRAM))
	jml remap_rom($009728)



NewGame:
	stz remap_ram($0DBF)	;\
	ldx remap_ram($0DB2)	; | Set Coins at Game Start
	phx	;/

	rep #$20	;\
	lda remap_ram($010A)	; |
	asl	; |
	tax	; |
	lda remap_ram(!SRAM_MaxHP),x	; |
	sta remap_ram(!MaxHP)	; |
	lda remap_ram(!SRAM_HP),x	; |
	sta remap_ram(!HP)	; |
	ldx remap_ram($010A)	; |
	sep #$20	; |
		; |
	lda remap_ram(!SRAM_MaxMP),x	; | Load SRAM Data
	sta remap_ram(!MaxMP)	; |
	lda remap_ram(!SRAM_MP),x	; |
	sta remap_ram(!MP)	; |
		; |
	lda remap_ram(!SRAM_Item),x	; |
	sta remap_ram($0DC2)	; |
	sta remap_ram($0DBC)	; |
		; |
	lda remap_ram(!SRAM_Powerup),x	; |
	sta $19	; |
		; |
	lda remap_ram(!SRAM_Lives),x	; |
	sta remap_ram($0DBE)	;/

	plx	;\
	stz remap_ram($0DC1)	; | Return to Main Code
	jml remap_rom($009E3A)	;/


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Custom Damage Handling and HP Setting;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DamageHP:
	lda $19
	sta remap_ram(!PowerupRAM)
	lda remap_ram(!HurtFlag)
	cmp #$02
	beq .calculation
	rep #$20	;\
	lda.w #!Damage	; | Load regular Damage
	sta remap_ram(!FreeRAM)	;/

.calculation:
	rep #$20	;\
	lda remap_ram(!FreeRAM)	; | Check, if Damage is a valid Input
	jsl Inputcheck16	; |
	sta remap_ram(!FreeRAM)	;/

	lda remap_ram(!HP)	;\
	cmp remap_ram(!FreeRAM)	; |
	bcs +	; |
	jmp CustomDeath	; |
+	sec	; | Damage Calculation
	sbc remap_ram(!FreeRAM)	; |
	sta remap_ram(!HP)	; |
	lda remap_ram(!HP)	; |
	cmp #$0000	; |
	beq CustomDeath	; |
	sep #$20	; |
	stz remap_ram(!HurtFlag)	;/

	lda #$38	;\ Play Hurt Sound
	sta remap_ram($1DFC)	;/

	lda remap_ram($0D9B)	;\
	cmp #$80	; | Disable Knockback in Iggy/Larry Battles
	beq .return	;/

	lda.b #($100-(!Knockback*sin(deg_to_rad(!Knockback_angle))))	;\
	sta $7D	; |
	lda.b #!Knockback*cos(deg_to_rad(!Knockback_angle))	; |
	ldy $76	; | Knockback Code
	beq +	; |
	lda.b #($100-(!Knockback*cos(deg_to_rad(!Knockback_angle))))	; |
+	sta $7B	;/

.return:
	jml remap_rom($00F5DD)

CustomPitDeath:
	lda $19	;\ Save Powerup when you fall into a hole
	sta remap_ram(!PowerupRAM)	;/


CustomDeath:
	rep #$20	;\
	lda #$0000	; |
	sta remap_ram(!HP)	; |
	sep #$20	; |
	stz remap_ram(!HurtFlag)	; |
	lda #$90	; |
	sta $7D	; |
	lda #$09	; |
	sta remap_ram($1DFB)	; | Custom Death Routine
	lda #$FF	; |
	sta remap_ram($0DDA)	; |
	lda #$09	; |
	sta $71	; |
	stz remap_ram($140D)	; |
	lda #$30	; |
	sta remap_ram($1496)	; |
	sta $9D	; |
	stz remap_ram($1407)	; |
	stz remap_ram($188A)	; |
	rtl	;/

RefillHealth:
	rep #$20	;\
	lda remap_ram(!HP)	; |
	cmp #$0000	; |
	bne .noRefill	; | Reset HP and MP when you die
	lda remap_ram(!MaxHP)	; |
	sta remap_ram(!HP)	; |
	sep #$20	;/

	if !RefillMPAfterDeath
		lda remap_ram(!MaxMP)
		sta remap_ram(!MP)
	endif
	if !LosePowerupAfterDeath
		lda #$01
		sta $19
		sta remap_ram($0DB8)
	else
		lda remap_ram(!PowerupRAM)
		sta $19
		sta remap_ram($0DB8)
	endif

.noRefill:
	sep #$20
	lda #$03
	sta $44
	rtl



;;;;;;;;;;;;;;;;;;;;;;
;Item Hijack Routines;
;;;;;;;;;;;;;;;;;;;;;;


Mushroom:
	lda #$0A	;\
	sta remap_ram($1DF9)	; |
	rep #$20	; |
	lda.w #!MushroomHeal	; |
	jsl Inputcheck16	; |
	sta remap_ram(!FreeRAM)	; |
	lda remap_ram(!HP)	; | Mushroom recovers HP
	clc	; |
	adc remap_ram(!FreeRAM)	; |
	sta remap_ram(!HP)	; |
	bcs ReduceHP	; |
	cmp remap_ram(!MaxHP)	; |
	bcs ReduceHP	; |
	sep #$20	; |
	jmp ItemReturn	;/

ReduceHP:
	lda remap_ram(!MaxHP)	;\
	sta remap_ram(!HP)	; | If HP is higher then Max HP, reduce them
	sep #$20	; |
	jmp ItemReturn	;/


Star:
	lda #$0A	;\
	sta remap_ram($1DF9)	; |
	lda #$FF	; |
	sta remap_ram($1490)	; |
	lda #$0D	; | Star Powerup
	sta remap_ram($1DFB)	; |
	asl remap_ram($0DDA)	; |
	sec	; |
	ror remap_ram($0DDA)	; |
	jmp ItemReturn	;/


Feather:
	lda $19	;\
	cmp #$02	; |
	beq PowerupMPHeal	; |
	lda #$02	; |
	sta $19	; |
	lda #$0D	; | Feather Powerup
	sta remap_ram($1DF9)	; |
	lda #$04	; |
	jsl remap_rom($02ACE5)	; |
	jsl remap_rom($01C5AE)	; |
	inc $9D	; |
	jmp ItemReturn	;/
	bra PowerupMPHeal


Flower:
	lda $19	;\
	cmp #$03	; |
	beq PowerupMPHeal	; |
	lda #$20	; |
	sta remap_ram($149B)	; |
	sta $9D	; |
	lda #$04	; |
	sta $71	; | Flower Powerup
	lda #$03	; |
	sta $19	; |
	jml remap_rom($01C56F)	; |
	lda #$08	; |
	clc	; |
	adc remap_ram($1594),x	; |
	jsl remap_rom($02ACE5)	; |
	jmp ItemReturn	;/
	bra PowerupMPHeal

Oneup:
	lda #$0A	;\
	sta remap_ram($1DF9)	; |
	lda.b #!MPHeal	; | 1UP-Mushroom recovers MP
	sta remap_ram(!FreeRAM)	; |
	bra AddMP	;/


PowerupMPHeal:
	lda #$0A	;\
	sta remap_ram($1DF9)	; |
	lda.b #!MPHeal	; | Recover MP if you get the same Powerup twice
	lsr	; |
	sta remap_ram(!FreeRAM)	; |
	bra AddMP	;/


ItemReturn:
	jml remap_rom($01C608)	;> Jump back to Main Code


AddMP:
	lda remap_ram(!MP)	;\
	clc	; |
	adc remap_ram(!FreeRAM)	; |
	sta remap_ram(!FreeRAM)	; | MP Caculation
	bcs .ReduceMP	; |
	cmp remap_ram(!MaxMP)	; |
	bcs .ReduceMP	; |
	sta remap_ram(!MP)	; |
	jmp ItemReturn	;/

.ReduceMP:
	lda remap_ram(!MaxMP)	;\
	sta remap_ram(!MP)	; | If MP higher then Maximum MP, reduce them
	jmp ItemReturn	;/



;;;;;;;;;;;;;;;;;;;;;;;;;
;Fireball Hijack Routine;
;;;;;;;;;;;;;;;;;;;;;;;;;


Fireball:
	cmp #$03	;\
	bne .return	; |
	lda $73	; |
	ora remap_ram($187A)	; | Original Fireball Routine, minus the spin jump auto-shooting,
	bne .return	; | because that chews through MP like there’s no tomorrow.
	bit select(or(!FireballsOnlyOnX,!FireballMP),$18,$16)	; |
	bvc .return	; |
	jsl ShootFireball	;/
.return:
	jml remap_rom($00D0AD)


ShootFireball:
	ldx #$09	;\
-	lda remap_ram($170B),x	; | Original ShootFireball subroutine
	beq .subroutine	; |
	dex	;/
	if !MaxFireballCount < 10
		cpx.b #($09-clamp(!MaxFireballCount,0,10))
		bne -
	else
		bpl -	;> SMW only supports 10 extended sprites
	endif
	rtl


.subroutine:
	lda remap_ram(!MP)	;\
	cmp.b #!FireballMP	; |
	bcc ..noFireball	; | Check and use MP
	sec	; |
	sbc.b #!FireballMP	; |
	sta remap_ram(!MP)	;/

	lda #$06	;\
	sta remap_ram($1DFC)	; |
	lda #$0A	; |
	sta remap_ram($149C)	; |
	lda #$05	; |
	sta remap_ram($170B),x	; |
	lda #$30	; |
	sta remap_ram($173D),x	; |
	ldy $76	; |
	lda $FE94,y	; |
	sta remap_ram($1747),x	; |
	lda remap_ram($187A)	; |
	beq +	; |
	iny	; |
	iny	; |
	lda remap_ram($18DC)	; |
	beq +	; |
	iny	; | Original ShootFireball sub-subroutine
	iny	; |
+	lda $94	; |
	clc	; |
	adc $FE96,y	; |
	sta remap_ram($171F),x	; |
	lda $95	; |
	adc $FE9C,y	; |
	sta remap_ram($1733),x	; |
	lda $96	; |
	clc	; |
	adc $FEA2,y	; |
	sta remap_ram($1715),x	; |
	lda $97	; |
	adc #$00	; |
	sta remap_ram($1729),x	; |
	lda remap_ram($13F9)	; |
	sta remap_ram($1779),x	;/
..return:
if !NoFireballSound
	rtl

..noFireball:
	lda remap_ram($140D)	;\
	cmp #$00	; | Remove Semicolons if you want Mario to make a Sound Effect
	bne ...return	; | when he doesn't have enough MP for a Fireball
	lda #$54	; |
	sta remap_ram($1DFC)	;/
...return:
	bra ..return
else
..noFireball:
	rtl
endif


;;;;;;;;;;;;;;;;;;;;;;;
;Flying Hijack Routine:
;;;;;;;;;;;;;;;;;;;;;;;


Flyroutine1:
	lda remap_ram(!MP)	;\
	cmp.b #!CapeMP	; |
	bcc .nofly	; |
	lda $19	; |
	cmp #$02	; |
	bne .nofly	; |
	lda remap_ram(!MP)	; | Disable Take-Off when MP is too low
	sec	; |
	sbc.b #!CapeMP	; |
	sta remap_ram(!MP)	; |
	lda #$50	; |
	sta remap_ram($149F)	; |
	jml remap_rom($00D67B)	;/
.nofly:
	lda #$00
	sta remap_ram($149F)
	jml remap_rom($00D67B)

Flyroutine2:
	lda remap_ram(!MP)	;\
	cmp.b #!CapeMP	; |
	bcc .nofly	; |
	ldx $19	; |
	cpx #$02	; |
	jml remap_rom($00D806)	;/
.nofly:
	lda $19
	cpx #$FF
	jml remap_rom($00D928)


Flyroutine3:
	lda $19
	cmp #$02
	bne .jump

	if !FloatRequiresMP
		lda remap_ram(!MP)	;\
		cmp.b #!CapeMP	; | Disable Floating when MP is too low
		bcc .jump	;/
	endif

.float:
	jml remap_rom($00D8ED)

.jump:
	jml remap_rom($00D928)


Flyroutine4:
	lda $19	;\
	cmp #$02	; |
	bne .nospin	; |
	lda remap_ram(!MP)	; | Disable Spin when MP is too low
	cmp.b #!SpinMP	; |
	bcc .nospin	; |
	lda $19	; |
	jml remap_rom($00D068)	;/

.nospin:
	lda $19
	jml remap_rom($00D081)


Flyroutine5:
	lda #$04	;\
	sta remap_ram($1DFC)	; |
	lda remap_ram(!MP)	; |
	sec	; | Reduce MP when Spinning
	sbc.b #!SpinMP	; |
	sta remap_ram(!MP)	; |
	jml remap_rom($00D080)	;/

Flyroutine6:
	lda remap_ram(!MP)	;\
	cmp.b #!CapeMP	; |
	bcc .nofly	; |
	inc remap_ram(!FlyTimer)	; |
	lda remap_ram(!FlyTimer)	; |
	cmp.b #!FlyReduceSpeed	; |
	bcc .return	; |
	stz remap_ram(!FlyTimer)	; |
	lda remap_ram(!MP)	; | Reduce MP while Flying
	sec	; |
	sbc.b #!CapeMP	; |
	sta remap_ram(!MP)	;/

.return:
	ldx #$03
	ldy $7D
	jml remap_rom($00D836)

.nofly:
	stz $15	;\
	stz $16	; | Fall down if MP too low
	jml remap_rom($00D836)	;/



;;;;;;;;;;;;;;;
;SRAM Handling;
;;;;;;;;;;;;;;;


SaveSRAMRoutine:
	jsr GetSaveFile

SaveScoreData:
	lda remap_ram($0F34),y	;\
	sta remap_rom($70079F),x	; |
	inx	; | Save Coins to SRAM
	iny	; | (From 6 Digit Coin Counter)
	cpy #32	; |
	bcc SaveScoreData	;/

	ldx remap_ram($010A)

	lda remap_ram($0DBE)	;\
	cmp.b #!LivesAtStart	; |
	bcc SaveMaxData	; | If lives are lower than Starting Lives, save Max Data to SRAM
	lda remap_ram($0DBE)	; |
	sta remap_ram(!SRAM_Lives),x	;/

	rep #$20	;\
	lda remap_ram($010A)	; |
	asl	; |
	tax	; |
	lda remap_ram(!HP)	; | Save Health to SRAM
	sta remap_ram(!SRAM_HP),x	; |
	lda remap_ram(!MaxHP)	; |
	sta remap_ram(!SRAM_MaxHP),x	; |
	ldx remap_ram($010A)	; |
	sep #$20	;/

	lda remap_ram(!MP)	;\
	sta remap_ram(!SRAM_MP),x	; | Save MP to SRAM
	lda remap_ram(!MaxMP)	; |
	sta remap_ram(!SRAM_MaxMP),x	;/

	lda remap_ram($0DC2)	;\
	sta remap_ram(!SRAM_Item),x	; | Save Item and Powerup to SRAM
	lda $19	; |
	sta remap_ram(!SRAM_Powerup),x	;/

	lda remap_rom($009CCB),x	;\ Return to Main Code
	rtl	;/


SaveMaxData:
	sta remap_ram(!SRAM_Lives),x
	rep #$20	;\
	lda remap_ram($010A)	; |
	asl	; |
	tax	; |
	lda remap_ram(!MaxHP)	; | Save Health to SRAM
	sta remap_ram(!SRAM_HP),x	; |
	sta remap_ram(!SRAM_MaxHP),x	; |
	ldx remap_ram($010A)	; |
	sep #$20	;/

	lda remap_ram(!MaxMP)	;\
	sta remap_ram(!SRAM_MP),x	; | Save MP to SRAM
	sta remap_ram(!SRAM_MaxMP),x	;/

	lda remap_ram($0DC2)	;\
	sta remap_ram(!SRAM_Item),x	; | Save Item and Powerup to SRAM
	lda $19	; |
	sta remap_ram(!SRAM_Powerup),x	;/

	lda remap_rom($009CCB),x	;\ Return to Main Code
	rtl	;/


GetSaveFile:
	lda remap_ram($010A)	;\
	asl #$5	; |
	tax	; | Used by Coin Saving Routine
	ldy #0	; |
	rts	;/



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Item Fix Patch (Used for Head in Status Bar);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Item Fix Patch (Required for Mario Head)
ItemFix:
	phx
	php
	; When in Bowser Battle, use OAM address 1 for player head, required for Sprite Status Bar priority
	ldy $01
	lda.w remap_ram($0D9B)
	cmp.b #$C1
	bne +
	ldy #$04
	sty $01
+	lda #$00
	xba
	lda remap_ram($0DC2)
	rep #$30
	asl
	tax
	lda.l ItemTable,x
	beq .return	;> If the value in the ItemTable is 0, don’t display it.

	ora.w #$3000
	sta remap_ram($0202),y

	lda.w #((!PlayerHead_Y&$FF)<<8)|(!PlayerHead_X&$FF)
	sta remap_ram($0200),y

	; Compatibility with VWF Dialogues
	if read1(remap_rom($008297)) == $5C
		!tmp_vwfloc	= read3(remap_rom($008298))
		!tmp_vwfmode	= read3(!tmp_vwfloc+2)
		if read1(!tmp_vwfloc) == $DA && read1(!tmp_vwfloc+1) == $AF && \
			or(select(!use_sa1_mapping,equal(get_bank_byte(!tmp_vwfmode)&$F0,$40),0),equal(get_bank_byte(!tmp_vwfmode)&$F0,$70))
			.vwfCompat:
				sep #$30
				lda remap_ram(!tmp_vwfmode)
				cmp #$03	;\
				bcc .return	; | if (vwfmode > $2
				cmp #$0C	; |  && vwfmode < $C) {
				bcs .return	; |   $0201[y] = $F0
				lda.b #$F0	; | }
				sta remap_ram($0201),y	;/
		endif
	endif

.return:
	plp	;\
	plx	; | Return to Main Code
	jml remap_rom($0090C7)	;/


ItemTable:
dw $0000,!PlayerHead_Sprite&$CFFF,$2A26,$2448
dw $240E,$6A24,$2AAE,$265C	;\
dw $0000,$218A,$21E4,$28E8,$6024,$60EC,$2825,$21E4	; |
dw $602A,$602A,$0000,$658C,$2060,$0000,$0000,$6BC2	; |
dw $25C5,$25AB,$239D,$0000,$2B80,$2B81,$2B0A,$0000	; |
dw $0000,$2B4B,$0000,$0000,$0000,$0000,$0000,$6580	; |
dw $2746,$2240,$27A0,$23EA,$2382,$2BC8,$2D46,$6B40	; |
dw $23A2,$21AA,$250A,$250C,$254A,$25A0,$0000,$6DA6	; |
dw $678A,$A14A,$214A,$6D64,$23C8,$2FAA,$202E,$61E0	; |
dw $6933,$236E,$252A,$A9AC,$2BE4,$6BE4,$66C0,$2BC4	; |
dw $23CC,$6330,$6686,$6BAE,$61C7,$6385,$2240,$6BA2	; |
dw $6D86,$2360,$29D6,$2D80,$6824,$282A,$0000,$0000	; |
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000	; |
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000	; |
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000	; |
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000	; | Item Fix Table
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000	; |
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000	; |
dw $0000,$0000,$0000,$0000,$0000,$6AC8,$68C8,$66E0	; |
dw $64C8,$6A94,$6894,$6694,$6494,$6A92,$6A92,$2892	; |
dw $2892,$6492,$23CC,$20EB,$64AA,$64A8,$6D80,$0000	; |
dw $6982,$6980,$2567,$0000,$2488,$6567,$0000,$28AC	; |
dw $618A,$62A6,$258E,$0000,$27A4,$2788,$24E8,$2B17	; |
dw $2917,$6B17,$6917,$238E,$23A2,$2D81,$2900,$0000	; |
dw $25DC,$0000,$0000,$698C,$2A2A,$6F82,$6FAA,$6F64	; |
dw $25AC,$654A,$2B02,$0000,$6F8C,$6D6A,$6DED,$27C4	; |
dw $27C6,$27C8,$678C,$0000,$65E8,$63C2,$67E2,$6788	; |
dw $27CE,$6380,$20E8,$0000,$2567,$6DC4,$2BA4,$6B8C	; |
dw $6BEC,$2440,$6184,$2186,$28AE,$28AE,$29A7,$61EB	; |
dw $0000,$0000,$23EA,$2385,$23EB,$2386,$2040,$2040	; |
dw $2161,$21EB,$2BCB,$2BCC,$21A2,$2B00,$23E2,$2160	; |
dw $0000,$21DE,$238E,$A38E,$236C,$25C8,$0000,$2060	; |
dw $0000,$0000,$202E,$6FC0,$6FAA,$258A,$0000,$0000	;/



;;;;;;;;;;;;;;;;;;;;;;;;;;
;Hex To Decimal Converter;
;;;;;;;;;;;;;;;;;;;;;;;;;;


Conversion8:
	ldx #$00	;> Set X to 0
	ldy #$00	;> Set Y to 0

.c100:
	cmp #$64	;\
	bcc .c10	; | While A >= 100:
	sbc #$64	; | Decrease A by 100
	iny	; | Increase Y by 1
	bra .c100	;/

.c10:
	cmp #$0A	;\
	bcc .return	; | While A >= 10:
	sbc #$0A	; | Decrease A by 10
	inx	; | Increase X by 1
	bra .c10	;/

.return:
	rtl


Conversion16:
	ldx #$00	;> Set X to 0
	ldy #$00	;> Set Y to 0

.c100:
	cmp #$0064	;\
	bcc .c10	; | While A >= 100:
	sbc #$0064	; | Decrease A by 100
	iny	; | Increase Y by 1
	bra .c100	;/

.c10:
	cmp #$000A	;\
	bcc .return	; | While A >= 10:
	sbc #$000A	; | Decrease A by 10
	inx	; | Increase X by 1
	bra .c10	;/

.return:
	rtl



;;;;;;;;;;;;;;;;;;;;;;;;
;Check for valid Inputs;
;;;;;;;;;;;;;;;;;;;;;;;;


Inputcheck8:
	cmp #$64	;\
	bcc +	; | Checks if a value is lower than $64 (=100)
	lda #$63	; |
+	rtl	;/


Inputcheck16:
	cmp #$03E8	;\
	bcc +	; | Checks if a value is lower than $03E8 (=1000)
	lda #$03E7	; |
+	rtl	;/

;;;;;;;;;;;;;;;
;MAIN CODE END;
;;;;;;;;;;;;;;;
if !EnableBowserBattleStatusBar
	BowserBattle_SBGFX:
	incbin sprite_sb.bin
endif

print "Patch inserted at $",hex(FreecodeStart),", ",freespaceuse," bytes of free space used."

namespace off


pulltable
