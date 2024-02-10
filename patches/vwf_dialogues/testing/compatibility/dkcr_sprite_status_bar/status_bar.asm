
        ; #################################################
        ; #                                               #
        ; #         DKCR styled sprite status bar         #
        ; #  made between 2012 and 2019 by WhiteYoshiEgg  #
        ; #                                               #
        ; #################################################

        ; defines and options are included in status_bar_config.asm.

        ; refer to README.txt for details.



header
lorom





; ##############
; # SA-1 check #
; ##############

if read1($00FFD5) == $23
        sa1rom
        !base = $6000
	!bank = $000000
else
        !base = $0000
	!bank = $800000
endif

incsrc status_bar_config.asm



; #########################
; # Custom Powerups check #
; #########################



!custom_powerups = 0

if read1($028008) == $5C
	!custom_powerups = 1
	incsrc status_bar_powerup_config.asm
endif



; ##########
; # Macros #
; ##########

; looks for the next free sprite slot in $0200-$03FC
; (16-bit X)

macro findSlot()
?loop:
        CPX #$0200
        BEQ ?break
        LDA $0201|!base,x
        CMP #$F0
        BEQ ?break
        INX #4
        BRA ?loop
?break:
endmacro



; finds n free slots
; (returns from the "calling" graphics routine if less than n found)

macro findFreeSlots(n)
        PHY : LDY #$0000
        LDX #$0010                              ; skip the first four slots
?loop:                                          ; to avoid message box conflicts
        CPX #$0200
        BEQ ?notEnoughFound

        LDA $0201|!base,x
        CMP #$F0
        BNE ?notFree
        INY
        CPY.w <n>
        BEQ ?enoughFound
?notFree:
        INX #4
        BRA ?loop
?notEnoughFound:
        PLY
        RTS
?enoughFound:
        PLY
endmacro



; sets OAM info in $0420+

macro setOAMInfo(size)
        PHX
        LDA $0200|!base,x
        PHA
        REP #$20
        TXA : LSR #2 : TAX
        SEP #$20
        PLA
        BMI ?leftEdge
?rightEdge:
        LDA <size>
        BRA ?store
?leftEdge:
        LDA <size>|1
?store:
        STA $0420|!base,x
        PLX
endmacro



; converts hex to decimal

macro hexToDec()
        LDY #$0000
?loop:
        CMP #$0A
        BCC ?break
        SBC #$0A
        INY
        BRA ?loop
?break:
endmacro





; ###########################
; # Hijacks for custom code #
; ###########################

org $008292
        autoclean JML IRQHack

org $00835C                                     ; fix mode 7 boss battles
        JML IRQHack_mode7

org $028ACD
        autoclean JML OnLivesChange

; (coin change is handled in StatusBarMain)

org $00F343
        autoclean JML OnYoshiCoinChange

if !ShowAtMidwayPoint == 1
org $00F2E8
        autoclean JML OnMidwayPoint
else
	if read1($00F2E8) == $5C
	org $00F2E8
	        LDA #$05
		STA $1DF9|!base
	endif
endif

if !ShowAtGoal == 1
org $01C0F9                                     ; goal point
        autoclean JSL OnGoal : NOP
org $01877B
        autoclean JSL OnGoal : NOP              ; goal sphere
else
	if read1($01C0F9) == $22
	org $01C0F9                                     ; goal point
		LDA #$FF
		STA $1493|!base
	endif
	if read1($01877B) == $22
	org $01877B                                     ; goal sphere
 		LDA #$FF
		STA $1493|!base
	endif
endif

if !ShowWhenPaused == 1
org $00A233
        autoclean JML OnPause
org $00A25B
        autoclean JML Paused
else 
	if read1($00A233) == $5C
	org $00A233
	        LDA $13D4|!base
		EOR #$01
	endif
	if read1($00A25B) == $5C
	org $00A25B
	        LDA $15
		AND #$20
	endif
endif

org $00A5AB
        autoclean JML StatusBarInit

org $00A2E6
        autoclean JML StatusBarMain



; #############################################
; # Hijacks to disable unwanted SMW mechanics #
; #############################################

org $00D0F1                                     ; disable "time up" message
        db $80



        ; disable SMW's status bar
        ; (by p4plus2)

if read3($0081F4) == $8DAC20                    ; call to $008DAC
org $0081F4                                     ; (only change this if it's not already changed,
        NOP #3                                  ; since the VWF dialogues patch hijacks $0081F2)
endif
org $0082E8                                     ; call to $008DAC
        NOP #3
org $008C89                                     ; status bar routines
        NOP #955
org $00A2D5                                     ; call to $008E1A
        NOP #3
org $00A5D5                                     ; call to $008E1A
        NOP #3
org $009051                                     ; score routine part 2?
        RTS : NOP #39
org $00985A                                     ; call to $008CFF
        NOP #3
org $00A5A8                                     ; call to $008CFF
        NOP #3
org $008F98                                     ; call to $009051
        NOP #3
org $03B43C                                     ; bowser battle item box graphics
        NOP #3                                  ; (this one's not by p4)



        ; free up RAM
        ; (by p4plus2)

org $0091BD                                     ; $0F31 - $0F33
        NOP #9
org $009A91
        NOP #3
org $00D0E8
        NOP #9
org $01F10E
        NOP #6
org $058583
        NOP #13

org $028758                                     ; $0F34 - $0F36
        BRA + : NOP #25 : +
org $02AE12
        BRA + : NOP #33 : +
org $05CEF6
        BRA + : NOP #13 : +

org $009E4B                                     ; $0F48, $0F34, $0F37
        NOP #9
org $05CF1B
        NOP #3

org $02AA4A                                     ; $0F4A - $0F5D
        STA $0F5E|!base,x                       ; (trading with $0F5E - $0F71)
org $02AA86
        STA $0F5E|!base,x
org $02AAEC
        STA $0F5E|!base,x
org $02AB3F
        STA $0F5E|!base,x
org $02DF76
        STA $0F5E|!base,y
org $02F91C
        LDA $0F5E|!base,x
org $02F925
        DEC $0F5E|!base,x
org $02F9B5
        LDA $0F5E|!base,x
org $02FA28
        INC $0F5E|!base,x
org $02FA42
        LDA $0F5E|!base,x
org $02FAA8
        LDA $0F5E|!base,x
org $02FCF8
        LDA $0F5E|!base,x
org $02FD0D
        INC $0F5E|!base,x



        ; remap SP1 tiles to make room
        ; (by p4plus2)

org $00FBA4                                     ; smoke tile
        db $64,$64,$62,$60,$E8,$EA,$EC,$EA
org $01E985
        db $64,$64,$62,$60
org $028C6A
        db $64,$64,$62,$60
org $028D42
        db $68,$68,$6A,$6A,$6A,$62,$62,$62
        db $64,$64,$64,$64,$64
org $0296D8
        db $64,$62,$64,$62,$60,$62,$60
org $029922
        db $64,$62,$64,$62,$62
org $029922
        db $64,$62,$64,$62,$62
org $029C33
        db $64,$64,$62,$60,$60,$60,$60,$60
org $02A347
        db $64,$64,$60,$62
org $028ECC                                     ; glitter (this one's not by p4 i think?)
        db $69




       ; remaps shelless koopas to share the same graphics and flopping cheep cheeps
       ; (by lx5)

if !custom_powerups == 1
org $019B8C
        db $E0,$E2,$E2,$E6,$CC,$86,$4E

org $01B117                                     ; make cheep cheeps use SP3/SP4
        ORA #!cheep_cheep_page

org $019C0F                                     ; remap flopping cheep cheeps
        db !flopping_cheep_tile_1,!flopping_cheep_tile_2

endif



        ; disable score
        ; (by p4plus2)

org $02ADBD                                     ; (except for 1-ups)
        JML DisableScore
org $00F9F5
DisableScore:
        LDA $16E1|!base,x
        CMP #$0D
        BCC .no1Up
        JML $02ADC2|!bank
.no1Up
        JML $02ADC5|!bank

org $05CC42                                     ; part of the "course clear" tilemap
        db $FC,$38,$FC,$38,$FC,$38,$FC,$38
        db $FC,$38,$FC,$38,$FC,$38,$FC,$38
        db $FC,$38,$FC,$38,$FC,$38,$FC,$38
        db $FC,$38,$FC,$38,$FC,$38,$FF

org $05CC77                                     ; some score stuff I guess?
        BRA + : NOP #11 : +
org $05CCAA
        BRA + : NOP #76 : +
org $05CE4C
        JMP + : NOP #83 : +
org $05CEAF
        db $FC
org $05CCFB
        BRA + : NOP #41 : +
org $05CECF
        BRA + : NOP #52 : +
org $05CF36
        NOP #3
org $05CF78
        BRA + : NOP #38 : +
org $05CDFD
        JMP + : NOP #57 : +



        ; disable bonus stars
        ; (by Aiyo/Aika and imamelia)

org $008F9D
        BRA + : NOP #38 : +
org $05CF1B
        NOP #3
org $009053
        NOP #3
org $009068
        NOP #3
org $01C11F
        BRA $07
org $01C178
        db $80





; ###############
; # Custom code #
; ###############

freecode
print " Inserted at $",pc
reset bytes





        ; IRQ hack
        ; (by edit1754)

IRQHack:

if !UseVWFDialogues
        LDA !VWFState                           ; \
        BNE .defaultIRQ                         ;  | disable the status bar IRQ
endif
        LDX.w $0100|!base                       ;  | during levels and their fading in and out
        LDA.l .allowedModes,x                   ;  |
        BNE .disableIRQ                         ;  | additions by me:
                                                ;  | - use default IRQ the VWF dialogues patch
.defaultIRQ                                     ;  |   is used and a dialogue box is active
        LDY #$00                                ;  | - take mode 7 boss battles into account
        LDA.w $4211                             ;  |
        JML $008297|!bank                       ;  |
                                                ;  |
.disableIRQ                                     ;  |
        LDY.b #$E0                              ;  |
        LDA.w $4211                             ;  |
        STY.w $4209                             ;  |
        STZ.w $420A                             ;  |
        LDA.w $0DAE|!base                       ;  |
        STA.w $2100                             ;  |
        LDA.w $0D9F|!base                       ;  |
        STA.w $420C                             ;  |
        JML $008394|!bank                       ;  |
                                                ;  |
.mode7                                          ;  |
        LDY #$24                                ;  |
        BIT $0D9B|!base                         ;  |
        BVC +                                   ;  |
        LDA $13FC|!base                         ;  |
        ASL                                     ;  |
        TAX                                     ;  |
        LDA $00F8E8|!bank,x                     ;  |
        CMP #$2A                                ;  |
        BNE +                                   ;  |
        LDY #$2D                                ;  |
+       LDA $4211                               ;  |
        JML $008297|!bank                       ;  |
                                                ;  |
.allowedModes                                   ;  |
        db $00,$00,$00,$00,$00,$00,$00,$00      ;  |
        db $00,$00,$00,$01,$00,$00,$00,$01      ;  |
        db $00,$00,$01,$01,$01,$01,$00,$00      ;  |
        db $00,$00,$00,$00,$00                  ; /





        ; set lives timer

OnLivesChange:

        LDA #!CounterShowTime
        STA !LivesCounterTimer

        LDA #$05                                ; \  restore hijacked code
        STA $1DFC|!base                         ; /
        JML $028AD2|!bank





        ; set yoshi coin timer

OnYoshiCoinChange:

        LDA #!CounterShowTime
        STA !YoshiCoinCounterTimer

        INC $1422|!base                         ; \  restore hijacked code
        LDA $1422|!base                         ; /
        JML $00F349|!bank





        ; set all timers on getting a midway point

if !ShowAtMidwayPoint == 1
OnMidwayPoint:

        LDA #$05                                ; \  restore hijacked code
        STA $1DF9|!base                         ; /

        LDA #!CounterShowTime
        STA !LivesCounterTimer
        STA !CoinCounterTimer
        STA !YoshiCoinCounterTimer

        JML $00F2ED|!bank
endif





        ; set all timers on getting the goal (goal point or sphere)

if !ShowAtGoal == 1
OnGoal:
        LDA #$FF                                ; \  restore hijacked code
        STA $1493|!base                         ; /

        LDA #!CounterShowTime
        STA !LivesCounterTimer
        STA !CoinCounterTimer
        STA !YoshiCoinCounterTimer

        RTL
endif





        ; set all timers at the beginning of a pause

if !ShowWhenPaused == 1
OnPause:
        LDA $13D4|!base                         ; \
        EOR #$01                                ;  | restore hijacked code
        STA $13D4|!base                         ; /

        BEQ .return

.paused                                         ; \
        LDA !LivesCounterTimer                  ;  |
        BNE +                                   ;  | make all counters appear briefly
        INC !LivesCounterTimer                  ;  | (if they're not already there,
+       LDA !CoinCounterTimer                   ;  | set their timers to 1 so that they'll
        BNE +                                   ;  | go away right after unpausing)
        INC !CoinCounterTimer                   ;  |
+       LDA !YoshiCoinCounterTimer              ;  |
        BNE +                                   ;  |
        INC !YoshiCoinCounterTimer              ;  |
+                                               ; /

        LDA $13D4|!base                         ;    also kind of restore hijacked code
.return
        JML $00A23B|!bank



        ; handle counter actions and sprite tile drawing
        ; when the game is paused

Paused:

        LDA !DisableStatusBar
        BNE .return

        PHB : PHK : PLB

        REP #$10                                ; \
        LDX #$01FE                              ;  |
.loop                                           ;  | clear OAM before drawing new tiles
        LDY #$0013                              ;  |
.innerLoop                                      ;  | we can't call $7F8000 like SMW usually does
        LDA $0201|!base,x                       ;  | because most sprite tiles aren't redrawn
        AND #$31                                ;  | during a pause, so make a new routine
        CMP #$30                                ;  | that only clears tiles used by the status bar
        BNE .continue                           ;  |
        LDA AllTiles,y                          ;  |
        CMP $0200|!base,x                       ;  | (loop through each slot, check the tile number
        BNE .dontEraseTile                      ;  | and clear it if it's a status bar tile -
        LDA #$F0                                ;  | because powerup tiles aren't used solely for the
        STA $01FF|!base,x                       ;  | status bar, also check the PP bits to distinguish)
.dontEraseTile                                  ;  |
        DEY                                     ;  |
        BPL .innerLoop                          ;  |
.continue                                       ;  |
        DEX #4                                  ;  |
        BPL .loop                               ;  |
        SEP #$10                                ; /

        JSR StatusBarMain_handleLivesCounter    ; \
        JSR StatusBarMain_handleCoinCounter     ;  | recreate the necessary parts
        JSR StatusBarMain_handleYoshiCoinCounter;  | of the status bar main routine
        JSR StatusBarMain_handleReserveItem     ; /

        PLB

        PHK : PEA.w .return-1 : PEA.w $84CE     ; \  copy OAM info from $0420+ to $0400+
        JML $008494|!bank                       ; /  (just call SMW's routine)

.return

        LDA $15                                 ; \
        AND #$20                                ;  | restore hijacked code
        JML $00A25F|!bank                       ; /
endif



        ; initialize status bar

StatusBarInit:

        JSL $05809E|!bank                       ;    restore hijacked code

        PHA : PHX                               ; \
        LDX #$00                                ;  |
.loop                                           ;  | clear the newly-emptied RAM
        STZ $0EF9|!base,x                       ;  |
        INX                                     ;  |
        CPX #$66                                ;  |
        BNE .loop                               ; /

        LDA #$C0                                ; \
        STA !LivesCounterXPos                   ;  |
        STA !CoinCounterXPos                    ;  | initialize the counter positions
        STA !YoshiCoinCounterXPos               ;  | that aren't zero
        LDA #$E0                                ;  |
        STA !ReserveItemYPos                    ; /

        if !ShowAtStart == 1
        LDA #!CounterShowTime
        STA !LivesCounterTimer
        STA !CoinCounterTimer
        STA !YoshiCoinCounterTimer
        endif

        PLX : PLA

        JML $00A5AF|!bank





        ; status bar main routine

StatusBarMain:
if read1($00FFD5) == $23
	LDA #$B1
	STA $3180
	LDA #$8A
	STA $3181
	LDA #$02
	STA $3182
	JSR $1E80
else
        JSL $028AB1|!bank                       ;    restore hijacked code
endif

        PHP : SEP #$30
        PHB : PHK : PLB

        LDA $13CC|!base                         ; \
        BEQ +                                   ;  |
        DEC $13CC|!base                         ;  |
        INC $0DBF|!base                         ;  |
        LDA #!CounterShowTime                   ;  | the $13CC routine was removed
        STA !CoinCounterTimer                   ;  | by the hijacks above,
        LDA $0DBF|!base                         ;  | so let's not only recreate it here
        CMP #!CoinsFor1Up                       ;  | but also add the coin counter
        BCC +                                   ;  | activation code while we're at it
        SEC : SBC #!CoinsFor1Up                 ;  |
        STA $0DBF|!base                         ;  |
        INC $18E4|!base                         ;  |
+                                               ; /

        LDA $0100|!base                         ; \
        CMP #$14                                ;  |
        BNE .dontCapLives                       ;  | cap lives at the max value
        LDA $0DBE|!base                         ;  | (this is as good a place as any to put this)
        CMP #!MaxLives-1                        ;  |
        BCC .dontCapLives                       ;  | (only during levels though,
.capLives                                       ;  | to not break the "game over" process)
        LDA #!MaxLives-1                        ;  |
        STA $0DBE|!base                         ;  |
.dontCapLives                                   ; /

        if !ShowWhenIdle == 1                   ; \
        LDA $15                                 ;  |
        ORA $17                                 ;  | show all counters if the player has been idle
        BEQ .idle                               ;  | (i.e. no buttons have been pressed) for long enough
        STZ !IdleTimer                          ;  |
        BRA +                                   ;  | (and keep showing them until a button is pressed)
.idle                                           ;  |
        LDA !IdleTimer                          ;  |
        CMP.b #!IdleTime                        ;  |
        BEQ .idleEnough                         ;  |
.notIdleEnough                                  ;  |
        LDA $13                                 ;  |
        AND #$01                                ;  |
        BNE +                                   ;  |
        INC !IdleTimer                          ;  |
        BRA +                                   ;  |
.idleEnough                                     ;  |
        LDA #$02                                ;  | (set their timers low so they'll go away
        STA !LivesCounterTimer                  ;  | as soon as the player moves again)
        STA !CoinCounterTimer                   ;  |
        STA !YoshiCoinCounterTimer              ;  |
+                                               ;  |
        endif                                   ; /

        LDA !DisableStatusBar                   ; \
        BNE .return                             ;  |
                                                ;  | if the status bar should be disabled,
        if !ShowOnTitleScreen != 1              ;  | do nothing
        LDA $0100|!base                         ;  |
        CMP #$0C                                ;  |
        BCC .return                             ;  |
        endif                                   ;  |
                                                ;  |
        if !ShowInIntroLevel != 1               ;  |
        LDA $0100|!base                         ;  |
        CMP #$0C                                ;  |
        BCC +                                   ;  |
        LDA $0109|!base                         ;  |
        BNE .return                             ;  |
        +                                       ;  |
        endif                                   ; /

        JSR .handleLivesCounter                 ; \
        JSR .handleCoinCounter                  ;  | movement, state handling and graphics
        JSR .handleYoshiCoinCounter             ;  | are outsourced to separate routines per counter
        JSR .handleReserveItem                  ; /

.return
        PLB
        PLP
	
        JML $00A2EA|!bank




        ; lives counter handling

.handleLivesCounter

        LDA $0D9B|!base                         ; \  disable the counter in mode 7 boss battles
        BMI ..return                            ; /  (not sure why it looks glitchy there)

        LDA !LivesCounterState
        JSL $0086DF|!bank
        dw ..nothing
        dw ..movingIn
        dw ..there
        dw ..movingOut

..return
        RTS



        ; lives counter state 00: non-existent

..nothing

        LDA !LivesCounterTimer                  ; \  don't change the counter state
        BEQ ...return                           ; /  if the timer gives no reason to

        LDA !Slot1Occupied                      ; \
        BEQ ...slot1                            ;  |
        LDA !Slot2Occupied                      ;  | set Y position
        BEQ ...slot2                            ;  | to the next free counter slot
...slot3                                        ;  |
        LDA #64                                 ;  |
        BRA ...store                            ;  |
...slot2                                        ;  |
        LDA #$01                                ;  |
        STA !Slot2Occupied                      ;  |
        LDA #32                                 ;  |
        BRA ...store                            ;  |
...slot1                                        ;  |
        LDA #$01                                ;  |
        STA !Slot1Occupied                      ;  |
        LDA #$00                                ;  |
...store                                        ;  |
        STA !LivesCounterYPos                   ; /

        LDA #$C0                                ; \  initialize X position
        STA !LivesCounterXPos                   ; /

...nextState
        INC !LivesCounterState                  ;    change state to 01

...return
        RTS                                     ;    end of state 00



        ; lives counter state 01: moving in

..movingIn

        if !AppearInstantly != 1
        LDA !LivesCounterXPos                   ; \
        CLC : ADC #!CounterSpeedIn              ;  |
        BPL ...nextState                        ;  | increment the X position up to zero
        STA !LivesCounterXPos                   ;  |
        BRA ...return                           ; /
        endif

...nextState
        STZ !LivesCounterXPos                   ;    force X position to zero in case it overshot
        INC !LivesCounterState                  ;    change the state to 02

...return
        JSR ..draw                              ;    display the counter
        RTS                                     ;    end of state 01



        ; lives counter state 02: not moving, fully visible

..there

        LDA $9D                                 ; \
        ORA $13D4|!base                         ;  |
        BNE +                                   ;  | decrement timer
        LDA !LivesCounterTimer                  ;  |
        BEQ +                                   ;  |
        DEC !LivesCounterTimer                  ;  |
+                                               ; /

        LDA !LivesCounterTimer                  ; \
        BNE ...return                           ;  | start moving out
                                                ;  | when the timer reaches zero
...nextState                                    ;  |
        INC !LivesCounterState                  ; /

...return
        JSR ..draw                              ;    display the counter
        RTS                                     ;    end of state 02



        ; lives counter state 03: moving out

..movingOut

        LDA !LivesCounterTimer                  ; \
        BEQ ...dontMoveBackIn                   ;  | move back in if the timer is set
        LDA #$01                                ;  | while the counter is moving out
        STA !LivesCounterState                  ;  |
...dontMoveBackIn                               ; /

        if !DisappearInstantly != 1
        LDA !LivesCounterXPos                   ; \
        BEQ +                                   ;  |
        CMP #$C1                                ;  |
        BCC ...nextState                        ;  | decrement the X position up to #$C0
+       LDA !LivesCounterXPos                   ;  | (or less)
        SEC : SBC #!CounterSpeedOut             ;  |
        STA !LivesCounterXPos                   ;  |
        BRA ...return                           ; /
        endif

...nextState
        STZ !LivesCounterState                  ;    reset to state 00

        LDA #$01                                ; \
        CMP !Slot1Occupied                      ;  |
        BEQ ....clearSlot1                      ;  | determine which slot the counter
        CMP !Slot2Occupied                      ;  | was occupying and mark that as free
        BEQ ....clearSlot2                      ;  |
        BRA ...return                           ;  |
....clearSlot1                                  ;  |
        STZ !Slot1Occupied                      ;  |
        BRA ...return                           ;  |
....clearSlot2                                  ;  |
        STZ !Slot2Occupied                      ; /

...return
        JSR ..draw                              ;    display the counter
        RTS                                     ;    end of state 03



        ; lives counter graphics routine

..draw

        REP #$10
        ;LDX #$0000

        %findFreeSlots(#$0009)

        %findSlot()                             ; \
        LDA !LivesCounterXPos                   ;  |
        CLC : ADC #$08                          ;  | player head
        STA $0200|!base,x                       ;  |
        LDA !LivesCounterYPos                   ;  |
        CLC : ADC #$07                          ;  |
        STA $0201|!base,x                       ;  |
        LDA #!PlayerHeadTile                    ;  |
        STA $0202|!base,x                       ;  |
        LDA #$30                                ;  |
        STA $0203|!base,x                       ;  |
        %setOAMInfo(#$02)                       ; /

        LDA $0DBE|!base : INC                   ; \
        CMP #$0A                                ;  | determine number of digits to show
        BCS ...twoDigits                        ; /

...oneDigit                                     ; \
                                                ;  |
        TAY                                     ;  | one digit
        %findSlot()                             ;  |
        LDA !LivesCounterXPos                   ;  |
        CLC : ADC #33                           ;  |
        STA $0200|!base,x                       ;  |
        LDA !LivesCounterYPos                   ;  |
        CLC : ADC #11                           ;  |
        STA $0201|!base,x                       ;  |
        LDA Digits,y                            ;  |
        STA $0202|!base,x                       ;  |
        LDA #$3E                                ;  |
        STA $0203|!base,x                       ;  |
        %setOAMInfo(#$00)                       ;  |
                                                ;  |
        JMP +                                   ; /

...twoDigits                                    ; \
                                                ;  |
        %hexToDec()                             ;  | two digits: tens digit
        %findSlot()                             ;  |
        LDA !LivesCounterXPos                   ;  |
        CLC : ADC #29                           ;  |
        STA $0200|!base,x                       ;  |
        LDA !LivesCounterYPos                   ;  |
        CLC : ADC #11                           ;  |
        STA $0201|!base,x                       ;  |
        LDA Digits,y                            ;  |
        STA $0202|!base,x                       ;  |
        LDA #$3E                                ;  |
        STA $0203|!base,x                       ;  |
        %setOAMInfo(#$00)                       ; /

        LDA $0DBE|!base : INC                   ; \
        %hexToDec()                             ;  |
        TAY                                     ;  | two digits: ones digit
        %findSlot()                             ;  |
        LDA !LivesCounterXPos                   ;  |
        CLC : ADC #37                           ;  |
        STA $0200|!base,x                       ;  |
        LDA !LivesCounterYPos                   ;  |
        CLC : ADC #11                           ;  |
        STA $0201|!base,x                       ;  |
        LDA Digits,y                            ;  |
        STA $0202|!base,x                       ;  |
        LDA #$3E                                ;  |
        STA $0203|!base,x                       ;  |
        %setOAMInfo(#$00)                       ;  |
                                                ;  |
+                                               ; /

        LDY #$0000                              ; \
                                                ;  |
...loop                                         ;  | frame
        %findSlot()                             ;  |
                                                ;  |
        LDA !LivesCounterXPos                   ;  |
        CLC : ADC LivesCoinsXOffsets,y          ;  |
        STA $0200|!base,x                       ;  |
                                                ;  |
        LDA !LivesCounterYPos                   ;  |
        CLC : ADC LivesCoinsYOffsets,y          ;  |
        STA $0201|!base,x                       ;  |
                                                ;  |
        LDA LivesCoinsTilemap,y                 ;  |
        STA $0202|!base,x                       ;  |
                                                ;  |
        LDA LivesCoinsProperties,y              ;  |
        STA $0203|!base,x                       ;  |
                                                ;  |
        %setOAMInfo(#$02)                       ;  |
                                                ;  |
        INY                                     ;  |
        CPY #$0006                              ;  |
        BNE ...loop                             ; /


        SEP #$10
        RTS





        ; coin counter handling

.handleCoinCounter

        LDA $0D9B|!base                         ;    see .handleLivesCounter for comments,
        BMI ..return                            ;    the code is essentially the same

        LDA !CoinCounterState
        JSL $0086DF|!bank
        dw ..nothing
        dw ..movingIn
        dw ..there
        dw ..movingOut

..return
        RTS



        ; coin counter state 00: non-existent

..nothing

        LDA !CoinCounterTimer
        BEQ ...return

        LDA !Slot1Occupied
        BEQ ...slot1
        LDA !Slot2Occupied
        BEQ ...slot2
...slot3
        LDA #64
        BRA ...store
...slot2
        LDA #$02
        STA !Slot2Occupied
        LDA #32
        BRA ...store
...slot1
        LDA #$02
        STA !Slot1Occupied
        LDA #$00
...store
        STA !CoinCounterYPos

        LDA #$C0
        STA !CoinCounterXPos

...nextState
        INC !CoinCounterState

...return
        RTS



        ; coin counter state 01: moving in

..movingIn

        if !AppearInstantly != 1
        LDA !CoinCounterXPos
        CLC : ADC #!CounterSpeedIn
        BPL ...nextState
        STA !CoinCounterXPos
        BRA ...return
        endif

...nextState
        STZ !CoinCounterXPos
        INC !CoinCounterState

...return
        JSR ..draw
        RTS



        ; coin counter state 02: not moving, fully visible

..there

        LDA $9D
        ORA $13D4|!base
        BNE +
        LDA !CoinCounterTimer
        BEQ +
        DEC !CoinCounterTimer
+

        LDA !CoinCounterTimer
        BNE ...return

...nextState
        INC !CoinCounterState

...return
        JSR ..draw
        RTS



        ; coin counter state 03: moving out

..movingOut

        LDA !CoinCounterTimer
        BEQ ...dontMoveBackIn
        LDA #$01
        STA !CoinCounterState
...dontMoveBackIn

        if !DisappearInstantly != 1
        LDA !CoinCounterXPos
        BEQ +
        CMP #$C1
        BCC ...nextState
+       LDA !CoinCounterXPos
        SEC : SBC #!CounterSpeedOut
        STA !CoinCounterXPos
        BRA ...return
        endif

...nextState
        STZ !CoinCounterState

        LDA #$02
        CMP !Slot1Occupied
        BEQ ....clearSlot1
        CMP !Slot2Occupied
        BEQ ....clearSlot2
        BRA ...return
....clearSlot1
        STZ !Slot1Occupied
        BRA ...return
....clearSlot2
        STZ !Slot2Occupied

...return
        JSR ..draw
        RTS



        ; coin counter graphics routine

..draw

        REP #$10
        ;LDX #$0000

        %findFreeSlots(#$0009)

        %findSlot()                             ; \
        LDA !CoinCounterXPos                    ;  |
        CLC : ADC #$08                          ;  |  coin symbol
        STA $0200|!base,x                       ;  |
        LDA !CoinCounterYPos                    ;  |
        CLC : ADC #$08                          ;  |
        STA $0201|!base,x                       ;  |
        LDA #!CoinTile                          ;  |
        STA $0202|!base,x                       ;  |
        LDA #$34                                ;  |
        STA $0203|!base,x                       ;  |
        %setOAMInfo(#$02)                       ; /

        LDA $0DBF|!base
        CMP #$0A
        BCS ...twoDigits

...oneDigit                                     ; \
                                                ;  |
        TAY                                     ;  | one digit
        %findSlot()                             ;  |
        LDA !CoinCounterXPos                    ;  |
        CLC : ADC #33                           ;  |
        STA $0200|!base,x                       ;  |
        LDA !CoinCounterYPos                    ;  |
        CLC : ADC #11                           ;  |
        STA $0201|!base,x                       ;  |
        LDA Digits,y                            ;  |
        STA $0202|!base,x                       ;  |
        LDA #$3E                                ;  |
        STA $0203|!base,x                       ;  |
        %setOAMInfo(#$00)                       ;  |
        JMP +                                   ; /

...twoDigits                                    ; \
                                                ;  |
        %hexToDec()                             ;  | two digits: tens digit
        %findSlot()                             ;  |
        LDA !CoinCounterXPos                    ;  |
        CLC : ADC #29                           ;  |
        STA $0200|!base,x                       ;  |
        LDA !CoinCounterYPos                    ;  |
        CLC : ADC #11                           ;  |
        STA $0201|!base,x                       ;  |
        LDA Digits,y                            ;  |
        STA $0202|!base,x                       ;  |
        LDA #$3E                                ;  |
        STA $0203|!base,x                       ;  |
        %setOAMInfo(#$00)                       ; /

        LDA $0DBF|!base                         ; \
        %hexToDec()                             ;  |
        TAY                                     ;  | two digits: ones digit
        %findSlot()                             ;  |
        LDA !CoinCounterXPos                    ;  |
        CLC : ADC #37                           ;  |
        STA $0200|!base,x                       ;  |
        LDA !CoinCounterYPos                    ;  |
        CLC : ADC #11                           ;  |
        STA $0201|!base,x                       ;  |
        LDA Digits,y                            ;  |
        STA $0202|!base,x                       ;  |
        LDA #$3E                                ;  |
        STA $0203|!base,x                       ;  |
        %setOAMInfo(#$00)                       ;  |
                                                ;  |
+                                               ; /

        LDY #$0000                              ; \
                                                ;  |
...loop                                         ;  |
        %findSlot()                             ;  |
                                                ;  | frame
        LDA !CoinCounterXPos                    ;  |
        CLC : ADC LivesCoinsXOffsets,y          ;  |
        STA $0200|!base,x                       ;  |
                                                ;  |
        LDA !CoinCounterYPos                    ;  |
        CLC : ADC LivesCoinsYOffsets,y          ;  |
        STA $0201|!base,x                       ;  |
                                                ;  |
        LDA LivesCoinsTilemap,y                 ;  |
        STA $0202|!base,x                       ;  |
                                                ;  |
        LDA LivesCoinsProperties,y              ;  |
        STA $0203|!base,x                       ;  |
                                                ;  |
        %setOAMInfo(#$02)                       ;  |
                                                ;  |
        INY                                     ;  |
        CPY #$0006                              ;  |
        BNE ...loop                             ; /


        SEP #$10
        RTS





        ; yoshi coin counter handling

.handleYoshiCoinCounter

        LDA $0D9B|!base                         ;    see .handleLivesCounter for comments,
        BMI ..return                            ;    the code is essentially the same

        LDA !YoshiCoinCounterState
        JSL $0086DF|!bank
        dw ..nothing
        dw ..movingIn
        dw ..there
        dw ..movingOut

..return
        RTS



        ; yoshi coin counter state 00: non-existent

..nothing

        LDA !YoshiCoinCounterTimer
        BEQ ...return

        LDA !Slot1Occupied
        BEQ ...slot1
        LDA !Slot2Occupied
        BEQ ...slot2
...slot3
        LDA #64
        BRA ...store
...slot2
        LDA #$03
        STA !Slot2Occupied
        LDA #32
        BRA ...store
...slot1
        LDA #$03
        STA !Slot1Occupied
        LDA #$00
...store
        STA !YoshiCoinCounterYPos

        LDA #$C0
        STA !YoshiCoinCounterXPos

...nextState
        INC !YoshiCoinCounterState

...return
        RTS



        ; yoshi coin counter state 01: moving in

..movingIn

        if !AppearInstantly != 1
        LDA !YoshiCoinCounterXPos
        CLC : ADC #!CounterSpeedIn
        BPL ...nextState
        STA !YoshiCoinCounterXPos
        BRA ...return
        endif

...nextState
        STZ !YoshiCoinCounterXPos
        INC !YoshiCoinCounterState

...return
        JSR ..draw
        RTS



        ; yoshi coin counter state 02: not moving, fully visible

..there

        LDA $9D
        ORA $13D4|!base
        BNE +
        LDA !YoshiCoinCounterTimer
        BEQ +
        DEC !YoshiCoinCounterTimer
+

        LDA !YoshiCoinCounterTimer
        BNE ...return

...nextState
        INC !YoshiCoinCounterState

...return
        JSR ..draw
        RTS



        ; yoshi coin counter state 03: moving out

..movingOut

        LDA !YoshiCoinCounterTimer
        BEQ ...dontMoveBackIn
        LDA #$01
        STA !YoshiCoinCounterState
...dontMoveBackIn

        if !DisappearInstantly != 1
        LDA !YoshiCoinCounterXPos
        BEQ +
        CMP #$C1
        BCC ...nextState
+       LDA !YoshiCoinCounterXPos
        SEC : SBC #!CounterSpeedOut
        STA !YoshiCoinCounterXPos
        BRA ...return
        endif

...nextState
        STZ !YoshiCoinCounterState

        LDA #$03
        CMP !Slot1Occupied
        BEQ ....clearSlot1
        CMP !Slot2Occupied
        BEQ ....clearSlot2
        BRA ...return
....clearSlot1
        STZ !Slot1Occupied
        BRA ...return
....clearSlot2
        STZ !Slot2Occupied

...return
        JSR ..draw
        RTS



        ; yoshi coin counter graphics routine

..draw

        REP #$10
        ;LDX #$0000

        %findFreeSlots(#$0007)

        %findSlot()                             ; \
        LDA !YoshiCoinCounterXPos               ;  |
        CLC : ADC #$08                          ;  | yoshi coin symbol
        STA $0200|!base,x                       ;  |
        LDA !YoshiCoinCounterYPos               ;  |
        CLC : ADC #$08                          ;  |
        STA $0201|!base,x                       ;  |
        LDA #!YoshiCoinTile                     ;  |
        STA $0202|!base,x                       ;  |
        LDA #$34                                ;  |
        STA $0203|!base,x                       ;  |
        %setOAMInfo(#$02)                       ; /

        LDY #$0000                              ; \
        LDA $1422|!base                         ;  |
        TAY                                     ;  | number
        %findSlot()                             ;  | (phew, just one digit)
        LDA !YoshiCoinCounterXPos               ;  |
        CLC : ADC #29                           ;  |
        STA $0200|!base,x                       ;  |
        LDA !YoshiCoinCounterYPos               ;  |
        CLC : ADC #12                           ;  |
        STA $0201|!base,x                       ;  |
        LDA Digits,y                            ;  |
        STA $0202|!base,x                       ;  |
        LDA #$3E                                ;  |
        STA $0203|!base,x                       ;  |
        %setOAMInfo(#$00)                       ; /


        LDY #$0000

...loop                                         ; \
        %findSlot()                             ;  |
                                                ;  | frame
        LDA !YoshiCoinCounterXPos               ;  |
        CLC : ADC YoshiCoinsXOffsets,y          ;  |
        STA $0200|!base,x                       ;  |
                                                ;  |
        LDA !YoshiCoinCounterYPos               ;  |
        CLC : ADC YoshiCoinsYOffsets,y          ;  |
        STA $0201|!base,x                       ;  |
                                                ;  |
        LDA YoshiCoinsTilemap,y                 ;  |
        STA $0202|!base,x                       ;  |
                                                ;  |
        LDA YoshiCoinsProperties,y              ;  |
        STA $0203|!base,x                       ;  |
                                                ;  |
        %setOAMInfo(#$02)                       ;  |
                                                ;  |
        INY                                     ;  |
        CPY #$0005                              ;  |
        BNE ...loop                             ; /


        SEP #$10
        RTS





        ; reserve item handling

.handleReserveItem

        ; don't disable this one in mode 7 boss battles,
        ; since apparently this one doesn't glitch as hard?
        ; (nice coincidence, since it's the only one that's actually needed)

        LDA !ReserveItemState                   ;    see .handleLivesCounter for comments,
        JSL $0086DF|!bank                       ;    the code is essentially the same
        dw ..nothing
        dw ..movingIn
        dw ..there
        dw ..movingOut

..return
        RTS



        ; reserve item state 00: non-existent

..nothing

        LDA $0DC2|!base
        BEQ ...return

        LDA #$E0
        STA !ReserveItemYPos

...nextState
        INC !ReserveItemState

...return
        RTS



        ; reserve item state 01: moving in

..movingIn

        if !AppearInstantly != 1
        LDA !ReserveItemYPos                    ; \
        CLC : ADC #!CounterSpeedIn              ;  | the reserve item
        BPL ...nextState                        ;  | comes in from the top,
        STA !ReserveItemYPos                    ;  | so mess with the Y position instead
        BRA ...return                           ; /
        endif

...nextState
        STZ !ReserveItemYPos
        INC !ReserveItemState

...return
        JSR ..draw
        RTS



        ; reserve item state 02: not moving, fully visible

..there

        LDA $0DC2|!base                         ; \
        BNE ...return                           ;  |
                                                ;  | start moving out when empty
...nextState                                    ;  |
        INC !ReserveItemState                   ; /

...return
        JSR ..draw
        RTS



        ; reserve item state 03: moving out

..movingOut

        LDA $0DC2|!base
        BEQ ...dontMoveBackIn
        LDA #$01
        STA !ReserveItemState
...dontMoveBackIn

        if !DisappearInstantly != 1
        LDA $9D
        BNE ...return
        LDA !ReserveItemYPos
        BEQ +
        CMP #$E1
        BCC ...nextState
+       LDA !ReserveItemYPos
        SEC : SBC #!CounterSpeedOut
        STA !ReserveItemYPos
        BRA ...return
        endif

...nextState
        STZ !ReserveItemState

...return
        JSR ..draw
        RTS



        ; reserve item graphics routine

..draw

        REP #$30
        LDA #$0000
        SEP #$20
        LDX #$0000
        ;LDY #$0000

        LDA $0DC2|!base                         ; \
        BEQ ...skip                             ;  | only draw when there's an item
                                                ;  | to be drawn
        %findFreeSlots(#$0005)                  ;  |
                                                ;  |
        LDA $0DC2|!base                         ;  |
        DEC                                     ;  |
        TAY                                     ;  |
        %findSlot()                             ;  |
        LDA #$78                                ;  |
        STA $0200|!base,x                       ;  |
        LDA !ReserveItemYPos                    ;  |
        CLC : ADC #$08                          ;  |
        STA $0201|!base,x                       ;  |
if !custom_powerups == 0                        ;  |
        LDA ReserveItems,y                      ;  |
        STA $0202|!base,x                       ;  |
        LDA ReserveItemProperties,y             ;  |
        STA $0203|!base,x                       ;  |
else                                            ;  |
	REP #$20                                ;  |
	LDA.w #read2($02800C)+$2                ;  |
	STA $8A                                 ;  |
	LDA.w #read2($02800D)                   ;  | I used this method in case the table
	STA $8B                                 ;  | gets moved around if powerup.asm is
	TYA                                     ;  | reinserted to the ROM.
	ASL                                     ;  |
	TAY                                     ;  |
	LDA [$8A],y                             ;  |
	STA $0202|!base,x                       ;  |
	SEP #$20                                ;  |
endif                                           ;  |
        PHX                                     ;  | (%setOAMInfo() isn't needed here,
        REP #$20                                ;  | the X position won't be negative)
        TXA : LSR #2 : TAX                      ;  |
        SEP #$20                                ;  |
        LDA #$02                                ;  |
        STA $0420|!base,x                       ;  |
        PLX                                     ;  |
                                                ;  |
...skip                                         ; /

        LDA $0D9B|!base
        BMI ...dontDrawFrame

        LDY #$0000                              ; \
                                                ;  |
...loop                                         ;  |
        %findSlot()                             ;  |
                                                ;  | frame
        LDA #$70                                ;  |
        CLC : ADC LivesCoinsXOffsets,y          ;  | (the circle only,
        STA $0200|!base,x                       ;  | and we can use the lives counter's
                                                ;  | tilemap for that)
        LDA !ReserveItemYPos                    ;  |
        CLC : ADC LivesCoinsYOffsets,y          ;  |
        STA $0201|!base,x                       ;  |
                                                ;  |
        LDA LivesCoinsTilemap,y                 ;  |
        STA $0202|!base,x                       ;  |
                                                ;  |
        LDA LivesCoinsProperties,y              ;  |
        STA $0203|!base,x                       ;  |
                                                ;  |
        PHX                                     ;  | (%setOAMInfo() can't even be used
        REP #$20                                ;  | here since it won't allow tiles
        TXA : LSR #2 : TAX                      ;  | on the right half of the screen)
        SEP #$20                                ;  |
        LDA #$02                                ;  |
        STA $0420|!base,x                       ;  |
        PLX                                     ;  |
                                                ;  |
....skip                                        ;  |
        INY                                     ;  |
        CPY #$0004                              ;  |
        BNE ...loop                             ; /

...dontDrawFrame

        SEP #$10
        RTS





        ; misc. data



        ; frame tiles for the lives, coins and reserve item counter

LivesCoinsXOffsets:
        db $00,$00,$10,$10,$19,$22
LivesCoinsYOffsets:
        db $00,$10,$00,$10,$08,$08
LivesCoinsTilemap:
        db !FrameTile1,!FrameTile1,!FrameTile1,!FrameTile1
        db !FrameTile2,!FrameTile2+1
LivesCoinsProperties:
        db $3E,$BE,$7E,$FE,$3E,$3E



        ; frame tiles for the yoshi coin counter

YoshiCoinsXOffsets:
        db $00,$00,$10,$10,$19
YoshiCoinsYOffsets:
        db $00,$10,$00,$10,$08
YoshiCoinsTilemap:
        db !FrameTile1,!FrameTile1,!FrameTile1,!FrameTile1
        db !FrameTile2+1
YoshiCoinsProperties:
        db $3E,$BE,$7E,$FE,$3E



        ; digit tiles

Digits:
        db !Digit0,!Digit1,!Digit2,!Digit3,!Digit4
        db !Digit5,!Digit6,!Digit7,!Digit8,!Digit9



        ; reserve item tiles

ReserveItems:
        db !MushroomTile,!FlowerTile,!StarTile,!CapeTile
ReserveItemProperties:
        db $38,$3A,$34,$34



        ; all tiles in a single table
        ; (used for checking which OAM slots to clear during pause
        ; if !ShowWhenPaused is set to 1)

AllTiles:
        db !FrameTile1,!FrameTile2,!FrameTile2+1,!PlayerHeadTile,!CoinTile,!YoshiCoinTile
        db !MushroomTile,!FlowerTile,!StarTile,!CapeTile
        db !Digit1,!Digit2,!Digit3,!Digit4,!Digit5,!Digit6,!Digit7,!Digit8,!Digit9,!Digit0




print " ", bytes, " bytes used."





        ; install the mario GFX DMA patch if necessary
        ; (code by Ladida)

if !custom_powerups == 0
if read4($00A300) == $04A220C2

print " The Mario GFX DMA patch has not been applied yet. Applying it now (version 3)..."


        !Tile = $0C                             ; tile where the extended tiles will be loaded to
                                                ; takes up 2 8x8's located in SP1

org $00A300
        autoclean JML BEGINDMA

org $00F691
        ADC.w #BEGINXTND

org $00E1D4+$2B
        db $00,$8C,$14,$14,$2E
        db $00,$CA,$16,$16,$2E
        db $00,$8E,$18,$18,$2E
        db $00,$EB,$1A,$1A,$2E
        db $04,$ED,$1C,$1C

org $00DF1A
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00

        db $00,$00,$00,$00,$00,$00,$28,$00
        db $00

        db $00,$00,$00,$00,$82,$82,$82,$00
        db $00,$00,$00,$00,$84,$00,$00,$00
        db $00,$86,$86,$86,$00,$00,$88,$88
        db $8A,$8A,$8C,$8C,$00,$00,$90,$00
        db $00,$00,$00,$8E,$00,$00,$00,$00
        db $92,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00

        db $00,$00,$00,$00,$82,$82,$82,$00
        db $00,$00,$00,$00,$84,$00,$00,$00
        db $00,$86,$86,$86,$00,$00,$88,$88
        db $8A,$8A,$8C,$8C,$00,$00,$90,$00
        db $00,$00,$00,$8E,$00,$00,$00,$00
        db $92,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00,$00,$00,$00
        db $00,$00,$00,$00,$00

org $00E3B1
        JSR CharTileHijack

org $00E40D
        JSR CapeTileHijack

org $00DFDA
        db $00,$02,$80,$80                      ; [00-03]
        db $00,$02,!Tile,!Tile+$1               ; [04-07]

CharTileHijack:

        LDA $DF1A,y
        BPL +
        AND #$7F
        STA $0D
        LDA #$04
        +
        RTS

CapeTileHijack:

        LDA $0D
        CPX #$2B
        BCC +
        CPX #$40
        BCS +
        LDA $E1D7,x
        +
        RTS
        db $FF,$FF                              ; [22-23]
        db $FF,$FF,$FF,$FF                      ; [24-27]
        db $00,$02,$02,$80                      ; [28-2B]       balloon Mario
        db $04                                  ; [2C]          cape
        db !Tile,!Tile+$1                       ; [2D-2E]       random gliding tiles
        db $FF,$FF,$FF                          ; [2F-31]



freedata
reset bytes

BEGINDMA:
        REP #$20
        LDX #$02
        LDY $0D84|!base
        BNE + : JMP .skipall : +

        ; mario's palette

        LDY #$86
        STY $2121
        LDA #$2200
        STA $4310
        TAY
        LDA $0D82|!base
        STA $4312
        STY $4314
        LDA #$0014
        STA $4315
        STX $420B

        LDY #$80
        STY $2115
        LDA #$1801
        STA $4310
        LDY #$7E
        STY $4314

        ; misc. top tiles (mario, cape, yoshi, podoboo)

        LDA #$6000
        STA $2116
        TAY
        -
        LDA $0D85|!base,y
        STA $4312
        LDA #$0040
        STA $4315
        STX $420B
        INY #2
        CPY $0D84|!base
        BCC -

        ; misc. bottom tiles (mario, cape, yoshi, podoboo)

        LDA #$6100
        STA $2116
        TAY
        -
        LDA $0D8F|!base,y
        STA $4312
        LDA #$0040
        STA $4315
        STX $420B
        INY #2
        CPY $0D84|!base
        BCC -

        ; mario's 8x8 tiles

        LDY $0D9B|!base
        CPY #$02
        BEQ .skipall

        LDA.w #!Tile<<4|$6000
        STA $2116
        LDA $0D99|!base
        STA $4312
        LDY.b #BEGINXTND>>16
        STY $4314
        LDA #$0040
        STA $4315
        STX $420B

        .skipall
        SEP #$20
        JML $00A38F|!bank


BEGINXTND:
incbin extendgfx.bin

print " ",bytes," bytes used."

endif
endif
