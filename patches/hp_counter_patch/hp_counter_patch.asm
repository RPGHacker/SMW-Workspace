@asar 1.50

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;RPG-Styled HP and MP Counter Patch by RPG Hacker;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


incsrc free_7F4000/freeconfig.cfg
incsrc hpconfig.cfg
incsrc shared/shared.asm


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
	!HP = !HP_SA1
	!MP = !MP_SA1
	!MaxHP = !MaxHP_SA1
	!MaxMP = !MaxMP_SA1

	!FreeRAM = !FreeRAM_SA1
	!CheckRAM = !CheckRAM_SA1
	!PowerupRAM = !PowerupRAM_SA1
	!HurtFlag = !HurtFlag_SA1
	!FlyTimer = !FlyTimer_SA1
	!BowserRAM = !BowserRAM_SA1
	
	!SRAMBlock = !BWRAMBlock
endif

!IntroLevel #= select(equal(!IntroLevel,0),0,(!IntroLevel+$24))

!false	= 0
!true	= 1



;;;;;;;;;
;Hijacks;
;;;;;;;;;


; Disable bonus game

if !DisableBonusStars
org	remap_rom($05CF1B)
	nop #3
	
org	remap_rom($009E4B)
	nop #3
endif


; Disable 1UP increasing and sound

if !Disable1UPIncreasing
org	remap_rom($028ACD)
	nop #8
endif


; Remove bonus stars from status bar

org	remap_rom($008F9D)
	jml $008FC5
	nop
	
org	remap_rom($009053)
	nop #3
	
org	remap_rom($009068)
	nop #3


; Remove Yoshi Coin counter from status bar
	
if read2(remap_rom($008FF0)) == get_status_ram(8,2)
org	remap_rom($008FEF)
	nop #3
endif


; Remove Mario/Luigi from status bar

if read1(remap_rom($008FCB)) == $F0
org	remap_rom($008FCB)
	db $80
endif


; Jump to new status bar routine

org	remap_rom($008F49)
	autoclean jml StatusBar


; Disable item box getting used when hurt
	
org	remap_rom($00F5F8)
	nop #$4


; Disable item box getting used when pressing Select
	
org	remap_rom($00C570)
	db $80


; Disable item box reset at game start

org	remap_rom($009E48)
	nop #3


; Disable losing power-up when taking damage
	
org	remap_rom($00F600)
	nop #$2


; Eliminate power-down animation and jump to flash routine	

org	remap_rom($00D129)
	db $EA,$EA,$EA,$80


; Executed when loading a game or starting a new game
	
org	remap_rom($009E2C)
	autoclean jml NewGame
	nop #2


; Custom damage routine
	
org	remap_rom($00F5D5)
	autoclean jml DamageHP


; Custom death routine
	
org	remap_rom($00F606)
	autoclean jml CustomDeath


; Custom death routine for falling into a hole or lava
	
org	remap_rom($00F5B2)
	autoclean jsl CustomPitDeath


; Refill health when dying
	
org	remap_rom($00A0E6)
	autoclean jsl RefillHealth


; Execute new SRAM writing routine
	
org	remap_rom($009BCC)
	autoclean jsl SaveSRAMRoutine
	nop #2


; Disable second player
	
org	remap_rom($009D24)
	autoclean jsl OnePlayer
	nop

	
; Disable items being stored in item box
	
org	remap_rom($01C510)
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00


; Always execute mushroom power-up code
	
org	remap_rom($01C524)
	db $00,$00,$00,$00


; Always execute flower power-up code
	
org	remap_rom($01C528)
	db $04,$04,$04,$04


; Always execute star power-up code
	
org	remap_rom($01C52C)
	db $02,$02,$02,$02


; Always execute feather power-up code
	
org	remap_rom($01C530)
	db $03,$03,$03,$03


; Always execute 1UP mushroom power-up code
	
org	remap_rom($01C534)
	db $05,$05,$05,$05


; Power-up hijacks
	
org	remap_rom($01C561)
	autoclean jml Mushroom
	
org	remap_rom($01C592)
	autoclean jml Star
	
org	remap_rom($01C598)
	autoclean jml Feather
	
org	remap_rom($01C5EC)
	autoclean jml Flower
	
org	remap_rom($01C5FE)
	autoclean jml Oneup

	
; Status bar item fix (needed for player head)
	
org	remap_rom($009095)
	autoclean jml ItemFix


; Fireball routine hijack
	
org	remap_rom($00D081)
	autoclean jml Fireball


; Flying routine hijacks
	
org	remap_rom($00D676)
	autoclean jml Flyroutine1
	nop
	
org	remap_rom($00D802)
	autoclean jml Flyroutine2
	
org	remap_rom($00D8E7)
	autoclean jml Flyroutine3
	
org	remap_rom($00D062)
	autoclean jml Flyroutine4
	
org	remap_rom($00D07B)
	autoclean jml Flyroutine5
	
org	remap_rom($00D832)
	autoclean jml Flyroutine6
	nop #2

	
; Intro level load routine
	
org	remap_rom($009CB0)
	autoclean jml InitialSetup
	nop

	
; Initial data load routine
	
org	remap_rom($00971A)
	autoclean jml IntroLevelSet

	
; Code to execute when intro already played
	
org	remap_rom($009CF8)
	autoclean jml IntroDone
	nop

	
; Status bar adjustments
	
org	remap_rom($008C81)
	db $FC,$38,$FC,$38,$FC,$38,$FC,$38,$FC,$38
	
org	remap_rom($008C8B)
	db $40,$3C,$41,$3C,$FC,$38,$11,$38,$19,$38,$FC,$38
	db $FC,$38,$FC,$38,$00,$38,$44,$38,$FC,$38,$FC,$38
	db $00,$38,$FC,$38,$FC,$38
	
org	remap_rom($008CC1)
	db $42,$3C,$43,$3C,$FC,$38,$16,$38,$19,$38,$FC,$38
	db $FC,$38,$FC,$38,$00,$38,$44,$38,$FC,$38,$FC,$38
	db $00,$38,$FC,$38,$FC,$38
	
org	remap_rom($008CF7)
	db $FC,$38,$FC,$38,$FC,$38,$FC,$38
	
	
; Bowser battle status bar hijack

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


; A macro to write a value to the status bar

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
	
	; Enforce that bowser’s battle mode always uses lines 4-5 of SP2 (underwater BG),
	; which are the only unused tiles in this battle mode.
	lda.b #<tile>+$C0
	sta.w remap_ram($0202+(<dest><<2))
	lda.b #$30
	sta.w remap_ram($0203+(<dest><<2))
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
	ldy.b #bank(BowserBattle_SBGFX)
	sty select(!use_sa1_mapping,$2234,$4304)

	lda.w #$0020
	sta select(!use_sa1_mapping,$2238,$4305)

	lda.w #remap_ram(!BowserRAM+(<dest><<5))
	sta select(!use_sa1_mapping,$2235,$2181)
	ldy.b #bank(remap_ram(!BowserRAM))
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


; Used for reading/writing save data

struct SaveData remap_ram(!SRAMBlock)
    .HP:                 skip 6
    .MaxHP:              skip 6
    .MP:                 skip 3
    .MaxMP:              skip 3
    .Item:               skip 3
    .Powerup:            skip 3
    .Lives:              skip 3
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
	; Return to main code, skip lives and bonus stars to save cycles
	jml remap_rom($008F5B)



;;;;;;;;;;;;;;;;;;;;;;;;;;
;Bowser Battle Status Bar;
;;;;;;;;;;;;;;;;;;;;;;;;;;


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
		ldy.b #bank(BowserBattle_SBGFX)
		sty select(!use_sa1_mapping,$2234,$4304)

		lda.w #$0360
		sta select(!use_sa1_mapping,$2238,$4305)

		lda.w #remap_ram(!BowserRAM)
		sta select(!use_sa1_mapping,$2235,$2181)
		ldy.b #bank(remap_ram(!BowserRAM))
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
		; If we’re done fighting Bowser, hide the status bar.
		lda remap_ram($0D9B)
		cmp #$C1
		bne .returnSepXY
		lda remap_ram($190D)
		beq +
		stz remap_ram($0DC2)
		bra .returnSepXY

	+	lda #$00 : xba
		phx
		rep #%00010000	; 16-bit X/Y

		if !PlayerHeadSpriteProps
			%BowserBattle_SBTile($00,!PlayerHeadXCoord,!PlayerHeadYCoord,$00,%10)
		endif
		%BowserBattle_SBTile(select(!PlayerHeadSpriteProps,$02,$00),$30,$0F,$02,%10)
		%BowserBattle_SBTile(select(!PlayerHeadSpriteProps,$03,$01),$48,$0F,$04,%10)
		%BowserBattle_SBTile(select(!PlayerHeadSpriteProps,$04,$02),$50,$0F,$05,%10)
		%BowserBattle_SBTile(select(!PlayerHeadSpriteProps,$2A,$03),$60,$0F,$07,%10)
		%BowserBattle_SBTile(select(!PlayerHeadSpriteProps,$2B,$04),$70,$0F,$09,%10)

		sep #%00010000	; 8-bit X/Y
		rep #%00100000	; 16-bit A
		
		; HP
		%BowserBattle_SBDigit(get_status_ram($09,$02),$04,$00)
		%BowserBattle_SBDigit(get_status_ram($0A,$02),$05,$00)
		%BowserBattle_SBDigit(get_status_ram($0B,$02),$06,$00)
		
		; Max HP
		%BowserBattle_SBDigit(get_status_ram($0D,$02),$08,$00)
		%BowserBattle_SBDigit(get_status_ram($0E,$02),$09,$00)
		%BowserBattle_SBDigit(get_status_ram($0F,$02),$0A,$00)

		; MP
		%BowserBattle_SBDigit(get_status_ram($09,$03),$14,$00)
		%BowserBattle_SBDigit(get_status_ram($0A,$03),$15,$00)
		%BowserBattle_SBDigit(get_status_ram($0B,$03),$16,$00)
		
		; Max MP
		%BowserBattle_SBDigit(get_status_ram($0D,$03),$18,$00)
		%BowserBattle_SBDigit(get_status_ram($0E,$03),$19,$00)
		%BowserBattle_SBDigit(get_status_ram($0F,$03),$1A,$00)

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
		
		; Increment when high byte is accessed
		ldy #%10000000
		sty $2115
		
		; Set VRAM destination to start of sprite GFX index 0C0
		lda.w #($0C0<<4)+$6000
		sta $2116
		
		; Set DMA registers
		ldy #$01
		sty $4300
		ldy #$18
		sty $4301
		lda.w #remap_ram(!BowserRAM)
		sta $4302
		ldy.b #bank(remap_ram(!BowserRAM))
		sty $4304
		lda #$0360
		sta $4305
		
		; Start DMA
		ldy #%00000001
		sty $420B
		
		sep #%00100000	; 8-bit A
		
	..return:
		jml remap_rom($0082EB)
endif



;;;;;;;;;;;;;;;;;
;One Player Only;
;;;;;;;;;;;;;;;;;


OnePlayer:
	inc remap_ram($0100)
	lda remap_ram($0100)
	cmp #$0A
	bne .return
	inc remap_ram($0100)
	pea $8074
	pea $9E64
	pea $9E12
	jml remap_rom($00A195)

.return:
	ldy #$12
	rtl

	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Starting a New Game/Loading a Game;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


InitialSetup:
	; Load intro level at start-up
	lda.b #!IntroLevel
	sta remap_ram($0109)
	beq .skippedIntro
	%sta_zero_or_stz(remap_ram(!CheckRAM))
	jml remap_rom($009CB5)

.skippedIntro:
	%sta_one_or_inc(remap_ram(!CheckRAM))
	jml remap_rom($009CB5)


IntroDone:
	; Don't load intro if save file exists
	stz remap_ram($0109)
	%sta_zero_or_stz(remap_ram(!CheckRAM))
	lda #$8F
	jml remap_rom($009CFD)


IntroLevelSet:
	; Check if into level was loaded
	lda remap_ram(!CheckRAM)
	bne .introWasSkipped
	lda remap_ram($0109)
	cmp #$00
	beq .skipIntroLevel
	cmp.b #!IntroLevel
	bne .noInitialLoad

.introWasSkipped:
	; Reset SRAM when starting a new game
	rep #$20
	lda remap_ram($010A)
	asl
	tax
	lda.w #!StartMaxHP
	jsl Cap999_16Bit	; Cap to 999
	sta remap_ram(!FreeRAM)
	lda remap_ram(!FreeRAM)
	sta remap_ram(!MaxHP)
	sta SaveData.MaxHP,x
	sta remap_ram(!HP)
	sta SaveData.HP,x
	ldx remap_ram($010A)
	sep #$20
	
	lda.b #!StartMaxMP
	jsl Cap99_8Bit
	sta remap_ram(!FreeRAM)
	sta remap_ram(!MaxMP)
	sta SaveData.MaxMP,x
	sta remap_ram(!MP)
	sta SaveData.MP,x
	
	lda #$01
	sta remap_ram($0DC2)
	sta remap_ram($0DBC)
	sta SaveData.Item,x
	sta $19
	sta remap_ram($0DB8)
	sta SaveData.Powerup,x
	
	lda.b #!LivesAtStart
	sta remap_ram($0DBE)
	sta remap_ram($0DB4)
	sta SaveData.Lives,x

	; Was intro skipped?
	lda remap_ram(!CheckRAM)
	bne .skipIntroLevel

.noInitialLoad:
	; Return to main code
	lda remap_ram($0109)
	cmp #$E9
	bne ..ChangedIntroLevel
	jml remap_rom($009723)

..ChangedIntroLevel:
	jml remap_rom($009740)

.skipIntroLevel:
	%sta_zero_or_stz(remap_ram(!CheckRAM))
	jml remap_rom($009728)


NewGame:
	; Set coins at game start
	stz remap_ram($0DBF)
	ldx remap_ram($0DB2)
	phx

	; Load SRAM data
	rep #$20
	lda remap_ram($010A)
	asl
	tax
	lda SaveData.MaxHP,x
	sta remap_ram(!MaxHP)
	lda SaveData.HP,x
	sta remap_ram(!HP)
	ldx remap_ram($010A)
	sep #$20
	
	lda SaveData.MaxMP,x
	sta remap_ram(!MaxMP)
	lda SaveData.MP,x
	sta remap_ram(!MP)
		; |
	lda SaveData.Item,x
	sta remap_ram($0DC2)
	sta remap_ram($0DBC)
	
	lda SaveData.Powerup,x
	sta $19
	
	lda SaveData.Lives,x
	sta remap_ram($0DBE)

	; Return to main code
	plx
	stz remap_ram($0DC1)
	jml remap_rom($009E3A)

	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Custom Damage Handling and HP Setting;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DamageHP:
	lda $19
	sta remap_ram(!PowerupRAM)
	lda remap_ram(!HurtFlag)
	cmp #$02
	beq .calculation
	; Load regular damage
	rep #$20
	lda.w #!Damage
	sta remap_ram(!FreeRAM)

.calculation:
	; Cap damage to 999
	rep #$20
	lda remap_ram(!FreeRAM)
	jsl Cap999_16Bit
	sta remap_ram(!FreeRAM)

	; Apply damage to HP
	lda remap_ram(!HP)
	cmp remap_ram(!FreeRAM)
	bcs +
	jmp CustomDeath		; We ran out of HP and are dying
+	sec
	sbc remap_ram(!FreeRAM)
	sta remap_ram(!HP)
	lda remap_ram(!HP)
	cmp #$0000
	beq CustomDeath
	sep #$20
	stz remap_ram(!HurtFlag)

	; Play damage sound effect
	lda #$38
	sta remap_ram($1DFC)

	; Disable knockback in Iggy/larry battles
	lda remap_ram($0D9B)
	cmp #$80
	beq .return

	; Apply knockback
	lda.b #($100-(!Knockback*sin(deg_to_rad(!KnockbackAngle))))
	sta $7D
	lda.b #!Knockback*cos(deg_to_rad(!KnockbackAngle))
	ldy $76
	beq +
	lda.b #($100-(!Knockback*cos(deg_to_rad(!KnockbackAngle))))
+	sta $7B

.return:
	jml remap_rom($00F5DD)


; Custom death routines

CustomPitDeath:
	; If we die from a pit/lava, backup our power-up
	; so that we can restore it later and don't lose it.
	lda $19
	sta remap_ram(!PowerupRAM)

CustomDeath:
	rep #$20
	lda #$0000
	sta remap_ram(!HP)
	sep #$20
	stz remap_ram(!HurtFlag)
	lda #$90
	sta $7D
	lda #$09
	sta remap_ram($1DFB)
	lda #$FF
	sta remap_ram($0DDA)
	lda #$09
	sta $71
	stz remap_ram($140D)
	lda #$30
	sta remap_ram($1496)
	sta $9D
	stz remap_ram($1407)
	stz remap_ram($188A)
	rtl

RefillHealth:
	; Reset our HP and MP after we died
	rep #$20
	lda remap_ram(!HP)
	cmp #$0000
	bne .noRefill
	lda remap_ram(!MaxHP)
	sta remap_ram(!HP)
	sep #$20

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
	; Recover HP from collecting a mushroom
	lda #$0A
	sta remap_ram($1DF9)
	rep #$20
	lda.w #!MushroomHeal
	jsl Cap999_16Bit
	sta remap_ram(!FreeRAM)
	lda remap_ram(!HP)
	clc
	adc remap_ram(!FreeRAM)
	sta remap_ram(!HP)
	bcs ReduceHP
	cmp remap_ram(!MaxHP)
	bcs ReduceHP
	sep #$20
	jmp ItemReturn

ReduceHP:
	; Cap HP to max HP
	lda remap_ram(!MaxHP)
	sta remap_ram(!HP)
	sep #$20
	jmp ItemReturn


Star:
	; Give star power-up
	lda #$0A
	sta remap_ram($1DF9)
	lda #$FF
	sta remap_ram($1490)
	lda #$0D
	sta remap_ram($1DFB)
	asl remap_ram($0DDA)
	sec
	ror remap_ram($0DDA)
	jmp ItemReturn


Feather:
	; Give feather power-up or recover MP
	lda $19
	cmp #$02
	beq PowerupMPHeal
	lda #$02
	sta $19
	lda #$0D
	sta remap_ram($1DF9)
	lda #$04
	jsl remap_rom($02ACE5)
	jsl remap_rom($01C5AE)
	inc $9D
	jmp ItemReturn
	bra PowerupMPHeal


Flower:
	; Give flower power-up or recover MP
	lda $19
	cmp #$03
	beq PowerupMPHeal
	lda #$20
	sta remap_ram($149B)
	sta $9D
	lda #$04
	sta $71
	lda #$03
	sta $19
	jml remap_rom($01C56F)
	lda #$08
	clc
	adc remap_ram($1594),x
	jsl remap_rom($02ACE5)
	jmp ItemReturn
	bra PowerupMPHeal

Oneup:
	; Recover MP from collecting a 1UP mushroom
	lda #$0A
	sta remap_ram($1DF9)
	lda.b #!MPHeal
	sta remap_ram(!FreeRAM)
	bra AddMP


PowerupMPHeal:
	; Feather/flower MP recovery
	lda #$0A
	sta remap_ram($1DF9)
	lda.b #!MPHeal
	lsr
	sta remap_ram(!FreeRAM)
	bra AddMP


ItemReturn:
	; Return to main code
	jml remap_rom($01C608)


AddMP:
	; MP usage calculation
	lda remap_ram(!MP)
	clc
	adc remap_ram(!FreeRAM)
	sta remap_ram(!FreeRAM)
	bcs .ReduceMP
	cmp remap_ram(!MaxMP)
	bcs .ReduceMP
	sta remap_ram(!MP)
	jmp ItemReturn

.ReduceMP:
	; Cap MP to max MP
	lda remap_ram(!MaxMP)
	sta remap_ram(!MP)
	jmp ItemReturn



;;;;;;;;;;;;;;;;;;;;;;;;;
;Fireball Hijack Routine;
;;;;;;;;;;;;;;;;;;;;;;;;;


Fireball:
	; Disable auto-shooting fireballs while spinning to note waste MP.
	cmp #$03
	bne .return
	lda $73
	ora remap_ram($187A)
	bne .return
	bit select(!FireballsOnlyOnX,$18,$16)	; Shoot with X/Y buttons or only with X button?
	bvc .return
	jsl ShootFireball
	
.return:
	jml remap_rom($00D0AD)


ShootFireball:
	; We are trying to shoot a fireball
	ldx #$09
-	lda remap_ram($170B),x
	beq .subroutine
	dex
	if !MaxFireballCount < 10
		cpx.b #($09-clamp(!MaxFireballCount,0,10))
		bne -
	else
		bpl -	;> SMW only supports 10 extended sprites
	endif
	rtl

.subroutine:
	; Check if we actually have enough MP to do so, and if so, consume it
	lda remap_ram(!MP)
	cmp.b #!FireballMP
	bcc ..noFireball
	sec
	sbc.b #!FireballMP
	sta remap_ram(!MP)

	; Spawn the fireball
	lda #$06
	sta remap_ram($1DFC)
	lda #$0A
	sta remap_ram($149C)
	lda #$05
	sta remap_ram($170B),x
	lda #$30
	sta remap_ram($173D),x
	ldy $76
	lda $FE94,y
	sta remap_ram($1747),x
	lda remap_ram($187A)
	beq +
	iny
	iny
	lda remap_ram($18DC)
	beq +
	iny
	iny
+	lda $94
	clc
	adc $FE96,y
	sta remap_ram($171F),x
	lda $95
	adc $FE9C,y
	sta remap_ram($1733),x
	lda $96
	clc
	adc $FEA2,y
	sta remap_ram($1715),x
	lda $97
	adc #$00
	sta remap_ram($1729),x
	lda remap_ram($13F9)
	sta remap_ram($1779),x
	
..return:
if !NoFireballSound
	rtl

..noFireball:
	; If we're out of MP and try to shoot a fireball, play a sound effect
	lda remap_ram($140D)
	cmp #$00
	bne ...return
	lda #$54
	sta remap_ram($1DFC)
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
	; Disable take-off when MP is too low
	lda remap_ram(!MP)
	cmp.b #!CapeMP
	bcc .nofly
	lda $19
	cmp #$02
	bne .nofly
	lda remap_ram(!MP)
	sec
	sbc.b #!CapeMP
	sta remap_ram(!MP)
	lda #$50
	sta remap_ram($149F)
	jml remap_rom($00D67B)
.nofly:
	lda #$00
	sta remap_ram($149F)
	jml remap_rom($00D67B)

Flyroutine2:
	lda remap_ram(!MP)
	cmp.b #!CapeMP
	bcc .nofly
	ldx $19
	cpx #$02
	jml remap_rom($00D806)
.nofly:
	lda $19
	cpx #$FF
	jml remap_rom($00D928)


Flyroutine3:
	; Disable floating when MP is too low
	lda $19
	cmp #$02
	bne .jump

	if !FloatRequiresMP
		lda remap_ram(!MP)
		cmp.b #!CapeMP
		bcc .jump
	endif

.float:
	jml remap_rom($00D8ED)

.jump:
	jml remap_rom($00D928)


Flyroutine4:
	; Disable spinning when MP is too low
	lda $19
	cmp #$02
	bne .nospin
	lda remap_ram(!MP)
	cmp.b #!SpinMP
	bcc .nospin
	lda $19
	jml remap_rom($00D068)

.nospin:
	lda $19
	jml remap_rom($00D081)


Flyroutine5:
	; Consume MP from spinning
	lda #$04
	sta remap_ram($1DFC)
	lda remap_ram(!MP)
	sec
	sbc.b #!SpinMP
	sta remap_ram(!MP)
	jml remap_rom($00D080)

Flyroutine6:
	; Consume MP from flying
	lda remap_ram(!MP)
	cmp.b #!CapeMP
	bcc .nofly
	inc remap_ram(!FlyTimer)
	lda remap_ram(!FlyTimer)
	cmp.b #!CapeMPTickRate
	bcc .return
	stz remap_ram(!FlyTimer)
	lda remap_ram(!MP)
	sec
	sbc.b #!CapeMP
	sta remap_ram(!MP)

.return:
	ldx #$03
	ldy $7D
	jml remap_rom($00D836)

.nofly:
	; Fall down if MP got too low while we were flying
	stz $15
	stz $16
	jml remap_rom($00D836)



;;;;;;;;;;;;;;;
;SRAM Handling;
;;;;;;;;;;;;;;;


SaveSRAMRoutine:
	jsr GetSaveFileForScoreData

SaveScoreData:
	; Save score (coins from 6-Digit Coin Counter) to SRAM
	lda remap_ram($0F34),y
	sta remap_rom($70079F),x
	inx
	iny
	cpy #32
	bcc SaveScoreData

	ldx remap_ram($010A)

	; If we have less lives than the default, save the default to SRAM
	; and also refill our MP/MP etc. in SRAM.
	; If we have >= default lives, store oure current values to SRAM.
	lda remap_ram($0DBE)
	cmp.b #!LivesAtStart
	bcc SaveMaxData
	lda remap_ram($0DBE)
	sta SaveData.Lives,x

	; Save HP and max MP to SRAM
	rep #$20
	lda remap_ram($010A)
	asl
	tax
	lda remap_ram(!HP)
	sta SaveData.HP,x
	lda remap_ram(!MaxHP)
	sta SaveData.MaxHP,x
	ldx remap_ram($010A)
	sep #$20

	; Save MP and max MP to SRAM
	lda remap_ram(!MP)
	sta SaveData.MP,x
	lda remap_ram(!MaxMP)
	sta SaveData.MaxMP,x

	; Save our item and power-up to SRAM
	lda remap_ram($0DC2)
	sta SaveData.Item,x
	lda $19
	sta SaveData.Powerup,x

	; Return to main code
	lda remap_rom($009CCB),x
	rtl


SaveMaxData:
	; Store default lives and refilled HP/MP etc. in SRAM. 
	sta SaveData.Lives,x
	rep #$20
	lda remap_ram($010A)
	asl
	tax
	lda remap_ram(!MaxHP)
	sta SaveData.HP,x
	sta SaveData.MaxHP,x
	ldx remap_ram($010A)
	sep #$20

	lda remap_ram(!MaxMP)
	sta SaveData.MP,x
	sta SaveData.MaxMP,x

	lda remap_ram($0DC2)
	sta SaveData.Item,x
	lda $19
	sta SaveData.Powerup,x

	; Return to main code
	lda remap_rom($009CCB),x
	rtl


; Get the index of our save file for saving score data
GetSaveFileForScoreData:
	lda remap_ram($010A)
	asl #$5
	tax
	ldy #0
	rts



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Item Fix Patch (Used for Head in Status Bar);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ItemFix:
	phx
	php
	
	; When in Bowser battle, use OAM address 1 for player head, required for Sprite Status Bar priority
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
	
	; If the value in the ItemTable is 0, don’t display it.
	lda.l ItemTable,x	
	beq .return

	ora.w #$3000
	sta remap_ram($0202),y

	lda.w #((!PlayerHeadYCoord&$FF)<<8)|(!PlayerHeadXCoord&$FF)
	sta remap_ram($0200),y

	; Compatibility with VWF Dialogues patch
	; Hides player head when a dialogue is active
	if read1(remap_rom($008297)) == $5C
		!tmp_vwfloc	= read3(remap_rom($008298))
		!tmp_vwfmode	= read3(!tmp_vwfloc+2)
		if read1(!tmp_vwfloc) == $DA && read1(!tmp_vwfloc+1) == $AF && \
			or(select(!use_sa1_mapping,equal(bank(!tmp_vwfmode)&$F0,$40),0),equal(bank(!tmp_vwfmode)&$F0,$70))
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
	; Return to main code
	plp
	plx
	jml remap_rom($0090C7)


ItemTable:
dw $0000,!PlayerHeadSpriteProps&$CFFF,$2A26,$2448
dw $240E,$6A24,$2AAE,$265C
dw $0000,$218A,$21E4,$28E8,$6024,$60EC,$2825,$21E4
dw $602A,$602A,$0000,$658C,$2060,$0000,$0000,$6BC2
dw $25C5,$25AB,$239D,$0000,$2B80,$2B81,$2B0A,$0000
dw $0000,$2B4B,$0000,$0000,$0000,$0000,$0000,$6580
dw $2746,$2240,$27A0,$23EA,$2382,$2BC8,$2D46,$6B40
dw $23A2,$21AA,$250A,$250C,$254A,$25A0,$0000,$6DA6
dw $678A,$A14A,$214A,$6D64,$23C8,$2FAA,$202E,$61E0
dw $6933,$236E,$252A,$A9AC,$2BE4,$6BE4,$66C0,$2BC4
dw $23CC,$6330,$6686,$6BAE,$61C7,$6385,$2240,$6BA2
dw $6D86,$2360,$29D6,$2D80,$6824,$282A,$0000,$0000
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
dw $0000,$0000,$0000,$0000,$0000,$6AC8,$68C8,$66E0
dw $64C8,$6A94,$6894,$6694,$6494,$6A92,$6A92,$2892
dw $2892,$6492,$23CC,$20EB,$64AA,$64A8,$6D80,$0000
dw $6982,$6980,$2567,$0000,$2488,$6567,$0000,$28AC
dw $618A,$62A6,$258E,$0000,$27A4,$2788,$24E8,$2B17
dw $2917,$6B17,$6917,$238E,$23A2,$2D81,$2900,$0000
dw $25DC,$0000,$0000,$698C,$2A2A,$6F82,$6FAA,$6F64
dw $25AC,$654A,$2B02,$0000,$6F8C,$6D6A,$6DED,$27C4
dw $27C6,$27C8,$678C,$0000,$65E8,$63C2,$67E2,$6788
dw $27CE,$6380,$20E8,$0000,$2567,$6DC4,$2BA4,$6B8C
dw $6BEC,$2440,$6184,$2186,$28AE,$28AE,$29A7,$61EB
dw $0000,$0000,$23EA,$2385,$23EB,$2386,$2040,$2040
dw $2161,$21EB,$2BCB,$2BCC,$21A2,$2B00,$23E2,$2160
dw $0000,$21DE,$238E,$A38E,$236C,$25C8,$0000,$2060
dw $0000,$0000,$202E,$6FC0,$6FAA,$258A,$0000,$0000



;;;;;;;;;;;;;;;;;;;;;;;;;;
;Hex To Decimal Converter;
;;;;;;;;;;;;;;;;;;;;;;;;;;


; 8-bit A

Conversion8:
	ldx.b #0	; Set X to 0
	ldy.b #0	; Set Y to 0

.c100:
	; While A >= 100, decrease A by 100 and increase Y by 1
	cmp.b #100
	bcc .c10
	sbc.b #100
	iny
	bra .c100

.c10:
	; While A >= 10, decrease A by 10 and increase X by 1
	cmp.b #10
	bcc .return
	sbc.b #10
	inx
	bra .c10

.return:
	; A now stores the ones, X the tens and Y the hundreds
	rtl


; 16-bit A
	
Conversion16:
	ldx.b #0	; Set X to 0
	ldy.b #0	; Set Y to 0

.c100:
	; While A >= 100, decrease A by 100 and increase Y by 1
	cmp.w #100
	bcc .c10
	sbc.w #100
	iny
	bra .c100

.c10:
	; While A >= 10, decrease A by 10 and increase X by 1
	cmp.w #10
	bcc .return
	sbc.w #10
	inx
	bra .c10

.return:
	; A now stores the ones, X the tens and Y the hundreds
	rtl



;;;;;;;;;;;;;;;;;;;;;;;;
;Check for Valid Inputs;
;;;;;;;;;;;;;;;;;;;;;;;;


; Caps an 8-bit value to 99

Cap99_8Bit:
	cmp.b #100
	bcc .return
	lda.b #100
.return:
	rtl


; Caps a 16-bit value to 999

Cap999_16Bit:
	cmp.w #1000
	bcc .return
	lda.w #1000
.return:
	rtl
	
	

;;;;;;;;;;;;;;;
;MAIN CODE END;
;;;;;;;;;;;;;;;


; Bowser status bar GFX data

if !EnableBowserBattleStatusBar
	BowserBattle_SBGFX:
	incbin sprite_sb.bin
endif


print "Patch inserted at $",hex(FreecodeStart),", ",freespaceuse," bytes of free space used."

namespace off


pulltable
