;RPG-Styled HP and MP Counter Patch by RPG Hacker

header
lorom



;;;;;;;;;;;;;;;
;Value Defines;
;;;;;;;;;;;;;;;


!IntroLevel = $E9   ;Set Intro Level Number + #$24 (Setting to $00 will disable Intro)

!LifesatStart = $04   ; These are the lives you start with minus one

!Damage = $0012   ; Set Damage a regular Sprite deals (in Hex)

!StartMaxHealth = $0096   ; Max HP to start with (in Hex)

!StartMaxMP = $0F   ; Set MP to start with (in Hex)

!RefillMPAfterDeath = $00   ; Set to $00 and your MP aren't refilled when you die

!LosePowerupAfterDeath = $01   ; Set to $00 to not lose your Powerup after Death

!MushroomHeal = $0019   ; Set HP a Mushroom restores (in Hex)

!MPHeal = $04   ; Set MP, a 1UP-Mushroom recovers (in Hex)

!FireballMP = $01   ; Set MP, a Fireball takes (In Hex)

!CapeMP = $01   ; Set MP, Flying takes per second (In Hex)

!FloatRequiresMP = $00   ; Set to $00 if you don't want Floating to require MP

!SpinMP = $00    ; Set MP, Cape-Spinning takes (in Hex)

!FlyReduceSpeed = $32   ; Set, how fast your MP are reduced while Flying ($32 = 1 second)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Adress Defines (Touch only if you know what you're doing);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


!freeram = $0060   ; Have to be TWO Bytes!

!displayram = $0062   ; Used for Status Bar

!bowserram = $0113   ; Used for removing Mario head in Bowser Battle

!checkram = $0DC4   ; Used for loading Initial Data

!powerupram = $0DC5   ; Used for saving Powerup when you die

!HurtFlag = $0670   ; $02 means Custom Damage, anything else means Normal Damage

!FlyTimer = $0671   ; Used for reducing MP while Flying

!Health = $010D   ; Adress for storing current HP, have to be TWO Bytes!

!MaxHealth = $010F   ; Adress for storing Maximum HP, have to be TWO Bytes!

!MP = $0111   ; Adress for storing current MP

!MaxMP = $0112   ; Adress for storing Maximum MP

!HealthSRAM = $700360   ; SRAM Adress for saving Health Data, have to be SIX Bytes!

!MaxHealthSRAM = $700366   ; SRAM Adress for saving Maximum Health Data, have to be SIX Bytes!

!MPSRAM = $70036C   ; SRAM Adress for saving MP Data, have to be THREE Bytes!

!MaxMPSRAM = $70036F   ; SRAM Adress for saving Maximum MP Data, have to be THREE Bytes!

!ItemSRAM = $700372   ; SRAM Adress for saving Item Data, have to be THREE Bytes!

!PowerupSRAM = $700375   ; SRAM Adress for saving Powerup Data, have to be THREE Bytes!

!LifesSRAM = $700378    ; SRAM Adress for saving Lifes



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Original SMW Routine Reroutes/Hacks;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;org $05CF1B      ;\
;        nop #3   ; |
;                 ; | Disable Bonus Game
;                 ; |
;org $009E4B      ; |
;        nop #3   ;/


;org $028ACD     ;\ Disable 1UP Increasing and Sound
;        nop #8  ;/


org $008F9D          ;
			jml $008FC5  ; |
        nop          ; |
                     ; |
                     ; |
org $009053          ; | Remove Bonus Stars from Status Bar
        nop #3       ; |
                     ; |
                     ; |
org $009068          ; |
        nop #3       ;/


org $00F343     ;\ Remove Yoshi Coin Counter from Status Bar
        nop #3  ;/


org $008FEF     ;\ Remove Mario/Luigi from Status Bar
        nop #3  ;/ 


org $008F49            ;\ Jump to new Status Bar Routine
        autoclean jml Statusbar  ;/


org $00F5F8       ;\ Disable Item Box getting used when hurt
	nop #$4   ;/ 


org $00C570     ;\ Disable Item Box getting used when pressing Select
        db $80  ;/


org $009E48     ;\ Disable Item Box Reset at Game Start
        nop #3  ;/


org $00F600       ;\ Disable Powerup Taking when hurt
        nop #$2   ;/ 


org $00D129	             ;\ Eliminate Powerdown Animation and jump to Flash Routine
	db $EA,$EA,$EA,$80   ;/


org $009E2C           ;\
        autoclean jml newgame   ; | Loading/starting a game from title screen
        nop #2        ;/


org $00F5D5      ;\ Custom Damage Routine
       autoclean jml hit   ;/


org $00F5B2                  ;\ When falling into a hole or lava
	autoclean jsl CustomPitDeath   ;/


org $00F606               ;\ Jump to Custom Death Routine
        autoclean jml customdeath   ;/


org $00A0E6                ;\ Refill Health when you die
        autoclean jsl RefillHealth   ;/


org $009BCC                   ;\
        autoclean jsl SaveSRAMRoutine   ; | Jump to new SRAM Saving Routine
        nop #2                ;/


org $009D24            ;\ Jump to 2-Player-Disable Code
	autoclean jsl oneplayer  ;/


org $01C510                                         ;\
        db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; | Disable Items giving Status Bar Items
        db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;/


org $01C524                 ;\ Mushroom always gives Mushroom Power
        db $00,$00,$00,$00  ;/


org $01C528                 ;\ Flower always gives Flower Power
        db $04,$04,$04,$04  ;/


org $01C52C                 ;\ Star always gives Star Power
        db $02,$02,$02,$02  ;/


org $01C530                 ;\ Feather always gives Feather Power
        db $03,$03,$03,$03  ;/


org $01C534                 ;\ 1UP-Mushroom always gives 1UP-Mushroom Power
        db $05,$05,$05,$05  ;/


org $01C561           ;\
        autoclean jml Mushroom  ; |
                      ; |
org $01C592           ; |
	autoclean jml Star      ; |
                      ; |
org $01C598           ; |
	autoclean jml Feather   ; | Powerup Hijacks
                      ; |
org $01C5EC           ; |
	autoclean jml Flower    ; |
                      ; |
org $01C5FE           ; |
        autoclean jml Oneup     ;/


org $009095           ;\ Fix Status Bar Item
        autoclean jml ItemFix   ;/


org $00D081           ;\ Hijack Fireball Routine
        autoclean jml Fireball  ;/


org $00D676              ;\
        autoclean jml Flyroutine1  ; |
        nop              ; |
                         ; |
org $00D802              ; |
        autoclean jml Flyroutine2  ; |
                         ; |
org $00D8E7              ; |
        autoclean jml Flyroutine3  ; |
                         ; | Hijack Flying Routines
org $00D062              ; |
        autoclean jml Flyroutine4  ; |
                         ; |
org $00D07B              ; |
        autoclean jml Flyroutine5  ; |
                         ; |
org $00D832              ; |
        autoclean jml Flyroutine6  ; |
        nop #2           ;/

org $009CB0               ;\
        autoclean jml InitialSetup  ; | Load Intro Level
        nop               ;/

org $00971A                ;\ Load Initial Data
        autoclean jml IntroLevelSet  ;/

org $009CF8            ;\
        autoclean jml IntroDone  ; | If Intro already played through
        nop            ;/

org $008C81                                                  ;\
        db $FC,$38,$FC,$38,$FC,$38,$FC,$38,$FC,$38,$42,$3C   ; |
        db $41,$7C,$FC,$38,$11,$38,$19,$38,$FC,$38,$FC,$38   ; |
        db $FC,$38,$00,$38,$40,$38,$FC,$38,$FC,$38,$00,$38   ; |
        db $FC,$38,$FC,$38,$FC,$38                           ; |
                                                             ; |
org $008CC1                                                  ; | Status Bar Rearrangement
        db $43,$BC,$44,$FC,$FC,$38,$16,$38,$19,$38,$FC,$38   ; |
        db $FC,$38,$FC,$38,$00,$38,$40,$38,$FC,$38,$FC,$38   ; |
        db $00,$38,$FC,$38,$FC,$38,$FC,$38                   ; |
                                                             ; |
org $008CF7                                                  ; |
        db $FC,$38,$FC,$38,$FC,$38,$FC,$38                   ;/


;;;;;;;;;;;;;;;;;
;MAIN CODE START;
;;;;;;;;;;;;;;;;;

                                    
freedata ; this one doesn't change the data bank register, so it uses the RAM mirrors from another bank, so I might as well toss it into banks 40+



;;;;;;;;;;;;;;;;;
;One Player Only;
;;;;;;;;;;;;;;;;;


        oneplayer:

	inc $0100                   ;\
	lda $0100                   ; |
	cmp #$0A                    ; |
	bne return                  ; |
	inc $0100                   ; |
	pea $8074                   ; | Disable second Player
	pea $9E64                   ; |
	pea $9E12                   ; |
	jml $00A195                 ; |
                                    ; |
        return:                     ; |
        rtl                         ;/



;;;;;;;;;;;;;;;;;;;;;;;;;;
;Status Bar Rearrangement;
;;;;;;;;;;;;;;;;;;;;;;;;;;


        Statusbar:

        rep #$20           ;\
        lda !Health        ; |
        jsl Conversion16   ; |
        sep #$20           ; |
        sty !displayram    ; |
        cpy #$00           ; |
        bne write3         ; |
        ldy #$FC           ; |
        write3:            ; |
        sty $0F00          ; | Write current HP to Status Bar
        pha                ; |
        txa                ; |
        ora !displayram    ; |
        cmp #$00           ; |
        bne write4         ; |
        ldx #$FC           ; |
        write4:            ; |
        stx $0F01          ; |
        pla                ; |
        sta $0F02          ;/


        rep #$20           ;\
        lda !MaxHealth     ; |
        jsl Conversion16   ; |
        sep #$20           ; |
        sty !displayram    ; |
        cpy #$00           ; |
        bne write5         ; |
        ldy #$FC           ; |
        write5:            ; |
        sty $0F04          ; |
        pha                ; | Write Maximum HP to Status Bar
        txa                ; |
        ora !displayram    ; |
        cmp #$00           ; |
        bne write6         ; |
        ldx #$FC           ; |
        write6:            ; |
        stx $0F05          ; |
        pla                ; |
        sta $0F06          ;/

        lda !MP          ;\
        jsl Conversion8  ; |
        sta $0F1D        ; |
        cpx #$00         ; | Write current MP to Status Bar
        bne write1      ; |
        ldx #$FC         ; |
        write1:          ; |
        stx $0F1C        ;/


        lda !MaxMP       ;\
        jsl Conversion8  ; |
        sta $0F21        ; |
        cpx #$00         ; | Write Maximum MP to Status Bar
        bne write2      ; |
        ldx #$FC         ; |
        write2:          ; |
        stx $0F20        ;/

        lda $0D9B        ;\
        cmp #$C1         ; |
        bne NoBowser     ; |
        lda $0DC2        ; |
        cmp #$00         ; |
        beq BowserSkip   ; |
        sta !bowserram   ; |
        stz $0DC2        ; |
        stz $0DBC        ; |
        bra BowserSkip   ; | Remove Mario head in Bowser Battles
                         ; |
        NoBowser:        ; |
        lda !bowserram   ; |
        cmp #$00         ; |
        beq BowserSkip   ; |
        cmp #$55         ; |
        beq BowserSkip   ; |
        lda !bowserram   ; |
        sta $0DC2        ; |
        sta $0DBC        ; |
        stz !bowserram   ;/

        BowserSkip:
        jml $008F5B      ; Return to Main Code, skip lives and Bonus Stars to save cycles



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Starting a new game/Loading a Game;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


        InitialSetup:     ;\
        lda #!IntroLevel  ; |
        sta $0109         ; |
        cmp #$00          ; |
        beq SkippedIntro  ; |
        lda #$00          ; |
        sta !checkram     ; | Load Intro Level at Start Up
        jml $009CB5       ; |
                          ; |
        SkippedIntro:     ; |
        lda #$01          ; |
        sta !checkram     ; |
        jml $009CB5       ;/


        IntroDone:     ;\
        stz $0109      ; |
        stz !checkram  ; | Don't load Intro if Save File exists
        lda #$8F       ; |
        jml $009CFD    ;/


        IntroLevelSet:       ;\
        lda !checkram        ; |
        cmp #$01             ; |
        beq IntroWasSkipped  ; |
        lda $0109            ; | Check, if Intro Level was loaded
        cmp #$00             ; |
        beq SkipIntroLevel   ; |
        cmp #!IntroLevel     ; |
        bne NoInitialLoad    ;/


        IntroWasSkipped:      ;\
        rep #$20              ; |
        lda $010A             ; |
        asl a                 ; |
        tax                   ; |
        lda #!StartMaxHealth  ; |
        jsl Inputcheck16      ; |
        sta !freeram          ; |
        lda !freeram          ; |
        sta !MaxHealth        ; |
        sta !MaxHealthSRAM,x  ; |
        sta !Health           ; |
        sta !HealthSRAM,x     ; |
        ldx $010A             ; |
        sep #$20              ; |
                              ; |
        lda #!StartMaxMP      ; |
        jsl Inputcheck8       ; | Reset SRAM Data at New Game
        sta !freeram          ; |
        sta !MaxMP            ; |
        sta !MaxMPSRAM,x      ; |
        sta !MP               ; |
        sta !MPSRAM,x         ; |
                              ; |
        lda #$01              ; |
        sta $0DC2             ; |
        sta $0DBC             ; |
        sta !ItemSRAM,x       ; |
        sta $19               ; |
        sta $0DB8             ; |
        sta !PowerupSRAM,x    ; |
                              ; |
        lda #!LifesatStart    ; |
        sta $0DBE             ; |
        sta $0DB4             ; |
        sta !LifesSRAM,x      ;/

        
        lda !checkram         ;\
        cmp #$01              ; | If Intro was Skipped
        beq SkipIntroLevel    ;/


        NoInitialLoad:          ;\
        lda $0109               ; |
        cmp #$E9                ; |
        bne ChangedIntroLevel   ; |
        jml $009723             ; |
        ChangedIntroLevel:      ; | Return to Main Code
        jml $009740             ; |
                                ; |
        SkipIntroLevel:         ; |
        stz !checkram           ; |
        jml $009728             ;/



        newgame:             ;\
	stz $0DBF            ; | Set Coins at Game Start
	ldx $0DB2            ; |
        phx                  ;/
        
        rep #$20              ;\
        lda $010A             ; |
        asl a                 ; |
        tax                   ; |
        lda !MaxHealthSRAM,x  ; |
        sta !MaxHealth        ; |
        lda !HealthSRAM,x     ; |
        sta !Health           ; |
        ldx $010A             ; |
        sep #$20              ; |
                              ; |
        lda !MaxMPSRAM,x      ; | Load SRAM Data
        sta !MaxMP            ; |
        lda !MPSRAM,x         ; |
        sta !MP               ; |
                              ; |
        lda !ItemSRAM,x       ; |
        sta $0DC2             ; |
        sta $0DBC             ; |
                              ; |
        lda !PowerupSRAM,x    ; |
        sta $19               ; |
                              ; |
        lda !LifesSRAM,x      ; |
        sta $0DBE             ;/

        plx          ;\
	stz $0DC1    ; | Return to Main Code
  	jml $009E3A  ;/



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Custom Damage Handling and HP Setting;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


        hit:              ;\        
        lda $19           ; |
        sta !powerupram   ; |
        lda !HurtFlag     ; |
        cmp #$02          ; | Load regular Damage
        beq calculation   ; |
        rep #$20          ; |
        lda #!Damage      ; |
        sta !freeram      ;/

        calculation:      ;\
        rep #$20          ; |
        lda !freeram      ; | Check, if Damage is a valid Input
        jsl Inputcheck16  ; |
        sta !freeram      ;/

        lda !Health       ;\
        cmp !freeram      ; |
        bcs Dealdamage    ; |
        jmp customdeath   ; |
                          ; |
        Dealdamage:       ; |
        sec               ; | Damage Calculation
        sbc !freeram      ; |
        sta !Health       ; |
        lda !Health       ; |
        cmp #$0000        ; |
        beq customdeath   ; |
        sep #$20          ; |
        stz !HurtFlag     ;/

        lda #$38    ;\ Play Hurt Sound
        sta $1DFc   ;/

        lda $0D9B        ;\
        cmp #$80         ; | Disable Knockback in Iggy/Larry Battles
        beq NoKnockback  ;/

        lda #$D7     ;\
        sta $7D      ; |
                     ; |
        lda $76      ; |
        bne other    ; |
                     ; |
        lda #$29     ; |
        sta $7B      ; |
        bra next     ; | Knockback Code
                     ; |
        other:       ; |
        lda #$D7     ; |
        sta $7B      ; |
                     ; |
        next:        ; |
                     ; |
        NoKnockback: ; |
        jml $00F5DD  ;/

        CustomPitDeath:   ;\
        lda $19           ; | Save Powerup when you fall into a hole
        sta !powerupram   ;/


        customdeath:      ;\
        rep #$20          ; |
        lda #$0000        ; |
        sta !Health       ; |
        sep #$20          ; |
        stz !HurtFlag     ; |
        lda #$90          ; |
        sta $7D           ; |
        lda #$09          ; |
        sta $1DFB         ; | Custom Death Routine
        lda #$FF          ; |
        sta $0DDA         ; |
        lda #$09          ; |
        sta $71           ; |
        stz $140D         ; |
        lda #$30          ; |
        sta $1496         ; |
        sta $9D           ; |
        stz $1407         ; |
        stz $188A         ; |
        rtl               ;/

        RefillHealth:                 ;\
        rep #$20                      ; |
        lda !Health                   ; |
        cmp #$0000                    ; |
        bne NoRefill                  ; |
        lda !MaxHealth                ; |
        sta !Health                   ; |
        sep #$20                      ; |
        lda #!RefillMPAfterDeath      ; |
        cmp #$00                      ; |
        beq NoMPRefill                ; |
        lda !MaxMP                    ; |
        sta !MP                       ; |
        NoMPRefill:                   ; |
        lda #!LosePowerupAfterDeath   ; | Reset Health and MP when you die
        cmp #$00                      ; |
        bne ResetPowerup              ; |
        lda !powerupram               ; |
        sta $19                       ; |
        sta $0DB8                     ; |
        NoRefill:                     ; |
        sep #$20                      ; |
        lda #$03                      ; |
        sta $44                       ; |
        rtl                           ; |
                                      ; |
        ResetPowerup:                 ; |
        lda #$01                      ; |
        sta $19                       ; |
        sta $0DB8                     ; |
        bra NoRefill                  ;/



;;;;;;;;;;;;;;;;;;;;;;
;Item Hijack Routines;
;;;;;;;;;;;;;;;;;;;;;;


        Mushroom:            ;\
        lda #$0A             ; |
        sta $1DF9            ; |
        rep #$20             ; |
        lda #!MushroomHeal   ; |
        jsl Inputcheck16     ; |
        sta !freeram         ; |
        lda !Health          ; | Mushroom recovers HP
        clc                  ; |
        adc !freeram         ; |
        sta !Health          ; |
        cmp !MaxHealth       ; |
        bcs ReduceHealth     ; |
        sep #$20             ; |
        jmp itemreturn       ;/

        ReduceHealth:        ;\
        lda !MaxHealth       ; |
        sta !Health          ; | If HP are higher then Max HP, reduce them
        sep #$20             ; |
        jmp itemreturn       ;/


        Star:               ;\
        lda #$0A            ; |
        sta $1DF9           ; |
        lda #$FF            ; |
        sta $1490           ; |
        lda #$0D            ; | Star Powerup
        sta $1DFB           ; |
        asl $0DDA           ; |
        sec                 ; |
        ror $0DDA           ; |
        jmp itemreturn      ;/


        Feather:            ;\
        lda $19             ; |
        cmp #$02            ; |
        beq PowerupMPHeal   ; |
        lda #$02            ; |
        sta $19             ; |
        lda #$0D            ; | Feather Powerup
        sta $1DF9           ; |
        lda #$04            ; |
        jsl $02ACE5         ; |
        jsl $01C5AE         ; |
        inc $9D             ; |
        jmp itemreturn      ;/


        Flower:             ;\
        lda $19             ; |
        cmp #$03            ; |
        beq PowerupMPHeal   ; |
        lda #$20            ; |
        sta $149B           ; |
        sta $9D             ; |
        lda #$04            ; |
        sta $71             ; | Flower Powerup
        lda #$03            ; |
        sta $19             ; |
        jml $01C56F         ; |
        lda #$08            ; |
        clc                 ; |
        adc $1594,x         ; |
        jsl $02ACE5         ; |
        jmp itemreturn      ;/


        Oneup:          ;\
        lda #$0A        ; |
        sta $1DF9       ; |
        lda #!MPHeal    ; | 1UP-Mushroom recovers MP
        jsl Inputcheck8 ; |
        sta !freeram    ; |
        bra addmp       ;/


        PowerupMPHeal:  ;\
        lda #$0A        ; |
        sta $1DF9       ; |
        lda #!MPHeal    ; |
        lsr a           ; | Recover MP if you get the same Powerup twice
        jsl Inputcheck8 ; |
        sta !freeram    ; |
        bra addmp       ;/


        itemreturn:     ;\ Jump back to Main Code
        jml $01C608     ;/


        addmp:          ;\
        lda !MP         ; |
        clc             ; |
        adc !freeram    ; |
        sta !freeram    ; | MP Caculation
        cmp !MaxMP      ; |
        bcs ReduceMP    ; |
        sta !MP         ; |
        jmp itemreturn  ;/

        ReduceMP:       ;\
        lda !MaxMP      ; | If MP higher then Maximum MP, reduce them
        sta !MP         ; |
        jmp itemreturn  ;/



;;;;;;;;;;;;;;;;;;;;;;;;;
;Fireball Hijack Routine;
;;;;;;;;;;;;;;;;;;;;;;;;;


        Fireball:                    ;\
        cmp #$03                     ; |
        bne Fireballreturn           ; |
        lda $73                      ; |
        ora $187A                    ; |
        bne Fireballreturn           ; |
        bit $16                      ; |
        bvs Fireballjump             ; |
        lda $140D                    ; |
        beq Fireballreturn           ; |
        inc $13E2                    ; |
        lda $13E2                    ; |
        and #$0F                     ; | Original Fireball Routine
        bne Fireballreturn           ; |
        tay                          ; |
        lda $13E2                    ; |
        and #$10                     ; |
        beq Fireballskip             ; |
        iny                          ; |
                                     ; |
        Fireballskip:                ; |
        sty $76                      ; |
                                     ; |
        Fireballjump:                ; |
        jsl Fireballsubroutine       ; |
                                     ; |
        Fireballreturn:              ; |
        jml $00D0AD                  ;/


        Fireballsubroutine:          ;\
        ldx #$09                     ; |
                                     ; |
        Fireballsubroutineloop:      ; |
        lda $170B,x                  ; | Original Fireball Subroutine
        beq Fireballsubsubroutine    ; |
        dex                          ; |
        cpx #$07                     ; |
        bne Fireballsubroutineloop   ; |
        rtl                          ;/


        Fireballsubsubroutine:   ;\
        lda !MP                  ; |
        cmp #!FireballMP         ; |
        bcc NoFireball           ; | Check and use MP
        sec                      ; |
        sbc #!FireballMP         ; |
        sta !MP                  ;/

        lda #$06                           ;\
        sta $1DFC                          ; |
        lda #$0A                           ; |
        sta $149C                          ; |
        lda #$05                           ; |
        sta $170B,x                        ; |
        lda #$30                           ; |
        sta $173D,x                        ; |
        ldy $76                            ; |
        lda $FE94,y                        ; |
        sta $1747,x                        ; |
        lda $187A                          ; |
        beq Fireballsubsubroutinejump      ; |
        iny                                ; |
        iny                                ; |
        lda $18DC                          ; |
        beq Fireballsubsubroutinejump      ; |
        iny                                ; | Original Fireball-Subroutine Subroutine
        iny                                ; |
                                           ; |
        Fireballsubsubroutinejump:         ; |
        lda $94                            ; |
        clc                                ; |
        adc $FE96,y                        ; |
        sta $171F,x                        ; |
        lda $95                            ; |
        adc $FE9C,y                        ; |
        sta $1733,x                        ; |
        lda $96                            ; |
        clc                                ; |
        adc $FEA2,y                        ; |
        sta $1715,x                        ; |
        lda $97                            ; |
        adc #$00                           ; |
        sta $1729,x                        ; |
        lda $13F9                          ; |
        sta $1779,x                        ; |
                                           ; |
        Fireballend:                       ; |
        rtl                                ;/

        NoFireball:       ;\
        ;lda $140D        ; |
        ;cmp #$00         ; |
        ;bne NoSound      ; | Remove Semicolons if you want Mario to make a Sound Effect
        ;lda #$54         ; | when he doesn't have enough MP for a Fireball
        ;sta $1DFC        ; |
        ;NoSound:         ; |
        bra Fireballend   ;/



;;;;;;;;;;;;;;;;;;;;;;;
;Flying Hijack Routine:
;;;;;;;;;;;;;;;;;;;;;;;


        Flyroutine1:    ;\
        lda !MP         ; |
        cmp #!CapeMP    ; |
        bcc Nofly1      ; |
        lda $19         ; |
        cmp #$02        ; |
        bne NoMPReduce  ; |
        lda !MP         ; |
        sec             ; |
        sbc #!CapeMP    ; |
        sta !MP         ; |
        NoMPReduce:     ; |
        lda #$50        ; |
        sta $149F       ; |
        jml $00D67B     ; |
                        ; |
        Nofly1:         ; | Disable Take-Off when MP are too low
        lda #$00        ; |
        sta $149F       ; |
        jml $00D67B     ; |
                        ; |
                        ; |
        Flyroutine2:    ; |
        lda !MP         ; |
        cmp #!CapeMP    ; |
        bcc Nofly2      ; |
        LDX $19         ; |
        CPX #$02        ; |
        jml $00D806     ; |
                        ; |
        Nofly2:         ; |
        lda $19         ; |
        cpx #$FF        ; |
        jml $00D806     ;/


        Flyroutine3:            ;\
        lda $19                 ; |
        cmp #$02                ; |
        bne Regularjump         ; |        
        lda #!FloatRequiresMP   ; |
        cmp #$00                ; |
        beq Returnfloat         ; |
        lda !MP                 ; | Disable Floating when MP are too low
        cmp #!CapeMP            ; |
        bcc Regularjump         ; |
        Returnfloat:            ; |
        jml $00D8ED             ; |
                                ; |
        Regularjump:            ; |
        jml $00D928             ;/


        Flyroutine4:   ;\
        lda $19        ; |
        cmp #$02       ; |
        bne Nospin     ; |
        lda !MP        ; |
        cmp #!SpinMP   ; |
        bcc Nospin     ; | Disable Spin when MP are too low
        lda $19        ; |
        jml $00D068    ; |
                       ; |
        Nospin:        ; |
        lda $19        ; |
        jml $00D081    ;/


        Flyroutine5:   ;\
        lda #$04       ; |
        sta $1DFC      ; |
        lda !MP        ; | Reduce MP when Spinning
        sec            ; |
        sbc #!SpinMP   ; |
        sta !MP        ; |
        jml $00D080    ;/


        Flyroutine6:          ;\
        lda !MP               ; |
        cmp #!CapeMP          ; |
        bcc NoFly6            ; |
        inc !FlyTimer         ; |
        lda !FlyTimer         ; |
        cmp #!FlyReduceSpeed  ; |
        bcc ReturnFly6        ; |
        stz !FlyTimer         ; |
        lda !MP               ; | Reduce MP while Flying
        sec                   ; |
        sbc #!CapeMP          ; |
        sta !MP               ; |
        ReturnFly6:           ; |
        ldx #$03              ; |
        ldy $7D               ; |
        jml $00D836           ;/

        NoFly6:               ;\
        stz $15               ; | Fall down if MP too low
        stz $16               ; |
        jml $00D836           ;/



;;;;;;;;;;;;;;;
;SRAM Handling;
;;;;;;;;;;;;;;;


        SaveSRAMRoutine:     ;\
        jsr GetSaveFile      ; |
                             ; |
        SaveScoreData:       ; |
                             ; | Save Coins to SRAM
        lda $0F34,y          ; | (From 6 Digit Coin Counter)
        sta $70079F,x        ; |
        inx                  ; |
        iny                  ; |
        cpy #32              ; |
        bcc SaveScoreData    ;/

        ldx $010A

        lda $0DBE           ;\
        cmp #!LifesatStart  ; |
        bcc SaveMaxData     ; | If Lifes are lower then Starting Lifes, save Max Data to SRAM
        lda $0DBE           ; |
        sta !LifesSRAM,x    ;/

        rep #$20               ;\
        lda $010A              ; |
        asl a                  ; |
        tax                    ; |
        lda !Health            ; | Save Health to SRAM
        sta !HealthSRAM,x      ; |
        lda !MaxHealth         ; |
        sta !MaxHealthSRAM,x   ; |
        ldx $010A              ; |
        sep #$20               ;/

        lda !MP           ;\
        sta !MPSRAM,x     ; | Save MP to SRAM
        lda !MaxMP        ; |
        sta !MaxMPSRAM,x  ;/

        lda $0DC2           ;\
        sta !ItemSRAM,x     ; | Save Item and Powerup to SRAM
        lda $19             ; |
        sta !PowerupSRAM,x  ;/

        lda $009CCB,x    ;\ Return to Main Code
        rtl              ;/


        SaveMaxData:        ;\ If Lifes are lower then Starting Lifes
        sta !LifesSRAM,x    ;/

        rep #$20               ;\
        lda $010A              ; |
        asl a                  ; |
        tax                    ; |
        lda !MaxHealth         ; | Save Health to SRAM
        sta !HealthSRAM,x      ; |
        sta !MaxHealthSRAM,x   ; |
        ldx $010A              ; |
        sep #$20               ;/

        lda !MaxMP        ;\
        sta !MPSRAM,x     ; | Save MP to SRAM
        sta !MaxMPSRAM,x  ;/

        lda $0DC2           ;\
        sta !ItemSRAM,x     ; | Save Item and Powerup to SRAM
        lda $19             ; |
        sta !PowerupSRAM,x  ;/

        lda $009CCB,x    ;\ Return to Main Code
        rtl              ;/


        GetSaveFile:  ;\
        lda $010A     ; |
	asl           ; |
	asl           ; |
	asl           ; | Used by Coin Saving Routine
	asl           ; |
	asl           ; |
	tax           ; |
	ldy #0        ; |
	rts           ;/



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Item Fix Patch (Used for Head in Status Bar);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	ItemFix:         ;\
                         ; |
	phx              ; |
	php              ; |
	lda #$18         ; |
	sta $0201,Y      ; |
	ldy $01          ; | Item Fix Patch (Required for Mario Head)
	lda #$00         ; |
	xba              ; |
	lda $0DC2        ; |
	rep #$30         ; |
	asl a            ; |
	tax              ; |
	lda.l ItemTable,x  ; |
	sta $0202,y      ;/

	lda #$0F18       ;\ Y and X Position of Item Box
	sta $0200,y      ;/

	plp              ;\
	plx              ; | Return to Main Code
	jml $0090C7      ;/


ItemTable:
dw $0000,$20C2,$2A26,$2448,$240E,$6A24,$2AAE,$265C   ;\ "$20CE" used to display Cheap Cheap (Mario head) with Mario's Palettes in Status Bar
dw $0000,$218A,$21E4,$28E8,$6024,$60EC,$2825,$21E4   ; |
dw $602A,$602A,$0000,$658C,$2060,$0000,$0000,$6BC2   ; |
dw $25C5,$25AB,$239D,$0000,$2B80,$2B81,$2B0A,$0000   ; |
dw $0000,$2B4B,$0000,$0000,$0000,$0000,$0000,$6580   ; |
dw $2746,$2240,$27A0,$23EA,$2382,$2BC8,$2D46,$6B40   ; |
dw $23A2,$21AA,$250A,$250C,$254A,$25A0,$0000,$6DA6   ; |
dw $678A,$A14A,$214A,$6D64,$23C8,$2FAA,$202E,$61E0   ; |
dw $6933,$236E,$252A,$A9AC,$2BE4,$6BE4,$66C0,$2BC4   ; |
dw $23CC,$6330,$6686,$6BAE,$61C7,$6385,$2240,$6BA2   ; |
dw $6D86,$2360,$29D6,$2D80,$6824,$282A,$0000,$0000   ; |
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000   ; |
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000   ; |
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000   ; |
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000   ; | Item Fix Table
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000   ; |
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000   ; |
dw $0000,$0000,$0000,$0000,$0000,$6AC8,$68C8,$66E0   ; |
dw $64C8,$6A94,$6894,$6694,$6494,$6A92,$6A92,$2892   ; |
dw $2892,$6492,$23CC,$20EB,$64AA,$64A8,$6D80,$0000   ; |
dw $6982,$6980,$2567,$0000,$2488,$6567,$0000,$28AC   ; |
dw $618A,$62A6,$258E,$0000,$27A4,$2788,$24E8,$2B17   ; |
dw $2917,$6B17,$6917,$238E,$23A2,$2D81,$2900,$0000   ; |
dw $25DC,$0000,$0000,$698C,$2A2A,$6F82,$6FAA,$6F64   ; |
dw $25AC,$654A,$2B02,$0000,$6F8C,$6D6A,$6DED,$27C4   ; |
dw $27C6,$27C8,$678C,$0000,$65E8,$63C2,$67E2,$6788   ; |
dw $27CE,$6380,$20E8,$0000,$2567,$6DC4,$2BA4,$6B8C   ; |
dw $6BEC,$2440,$6184,$2186,$28AE,$28AE,$29A7,$61EB   ; |
dw $0000,$0000,$23EA,$2385,$23EB,$2386,$2040,$2040   ; |
dw $2161,$21EB,$2BCB,$2BCC,$21A2,$2B00,$23E2,$2160   ; |
dw $0000,$21DE,$238E,$A38E,$236C,$25C8,$0000,$2060   ; |
dw $0000,$0000,$202E,$6FC0,$6FAA,$258A,$0000,$0000   ;/



;;;;;;;;;;;;;;;;;;;;;;;;;;
;Hex To Decimal Converter;
;;;;;;;;;;;;;;;;;;;;;;;;;;


        Conversion8:
        ldx #$00                ;> Set X to 0
        ldy #$00                ;> Set Y to 0

        StartCompare1:
        cmp #$64                ;\
        bcc StartCompare2       ; |While A >= 100:
        sbc #$64                ; |Decrease A by 100
        iny                     ; |Increase Y by 1
        bra StartCompare1       ;/

        StartCompare2:
        cmp #$0A                ;\
        bcc ReturnLong1         ; |While A >= 10:
        sbc #$0A                ; |Decrease A by 10
        inx                     ; |Increase X by 1
        bra StartCompare2       ;/

        ReturnLong1:
        rtl


        Conversion16:
        ldx #$00                ;> Set X to 0
        ldy #$00                ;> Set Y to 0

        StartCompare3:
        cmp #$0064              ;\
        bcc StartCompare4       ; |While A >= 100:
        sbc #$0064              ; |Decrease A by 100
        iny                     ; |Increase Y by 1
        bra StartCompare3       ;/

        StartCompare4:
        cmp #$000A              ;\
        bcc ReturnLong2         ; |While A >= 10:
        sbc #$000A              ; |Decrease A by 10
        inx                     ; |Increase X by 1
        bra StartCompare4       ;/

        ReturnLong2:
        rtl



;;;;;;;;;;;;;;;;;;;;;;;;
;Check for valid Inputs;
;;;;;;;;;;;;;;;;;;;;;;;;


        Inputcheck8:
        cmp #$64          ;\
        bcc store1        ; |
        lda #$63          ; | Checks, if a value is lower then $64 (=100)
        store1:           ; |
        rtl               ;/


        Inputcheck16:
        cmp #$03E8        ;\
        bcc store2        ; |
        lda #$03E7        ; | Checks, if a value is lower then $03E8 (=1000)
        store2:           ; |
        rtl               ;/
