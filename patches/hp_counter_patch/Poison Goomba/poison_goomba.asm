;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A poisonous goomba that takes away 100 HP from Mario
;; For use with the Metroid Health Patch
;;
;;By ICB. Based on Shyguy by Mikeyk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	UpdateSpritePos = $01802A  
	SprSprInteract = $018032   
	MarioSprInteract = $01A7DC
	GetSpriteClippingA = $03B69F
	CheckForContact = $03B72B
	DisplayContactGfx = $01AB99 
	FinishOAMWrite = $01B7B3
	ShowSpinJumpStars = $07FC3B
	GivePoints = $02ACE5
	HurtMario = $00F5B7
	
        ExtraProperty1 = $7FAB28
	ExtraProperty2 = $7FAB34
	RAM_SpriteDir = $157C
	RAM_SprTurnTimer = $15AC

        HurtFlag = $0670

        FreeramHigh = $0061
        FreeramLow = $0060

        DamageHigh = $00
        DamageLow = $32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite init JSL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        dcb "INIT"
	LDA $167A,x
	STA $1528,x
	
	LDA #$01		
	STA $151C,x
	
        JSR SubHorzPos		; Face Mario
        TYA
        STA $157C,x
        RTL                 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite code JSL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        dcb "MAIN"                                    
        PHB                  
        PHK                  
        PLB                  
	CMP #09
	BCS HandleStunnd
        JSR SpriteMainSub    
        PLB                  
        RTL

HandleStunnd:
	LDA $167A,x		; Set to interact with Mario
	AND #$7F
	STA $167A,x

	LDY $15EA,X		; Replace Goomba's tile
	PHX
	LDX Tilemap
	LDA $302,Y
	CMP #$A8
	BEQ SetTile
	LDX Tilemap+1
SetTile:
	TXA
 	STA $302,Y
	PLX	
	PLB
	RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite main code 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SpeedX:
	dcb $08,$F8,$0C,$F4	
KILLED_X_SPEED
	dcb $F0,$10

Return:
	RTS
SpriteMainSub:
	JSR SubGfx
	
        LDA $9D                 ; \ if sprites locked, return
        BNE Return              ; /
	LDA $14C8,x
	CMP #$08
	BNE Return

        JSR SubOffScreen	; handle off screen situation
	INC $1570,x

	LDY $157C,x             ; Set x speed based on direction
	LDA ExtraProperty1,x
	AND #$01
	BEQ NoFastSpeed		; Increase speed if bit 0 is set
	INY
	INY
NoFastSpeed:
        LDA SpeedX,y           
        STA $B6,x

	JSL UpdateSpritePos     ; Update position based on speed values
	
	LDA $1588,x             ; If sprite is in contact with an object...
        AND #$03                  
        BEQ NoObjContact	
        JSR SetSpriteTurning    ;    ...change direction
NoObjContact:
	
	JSR MaybeStayOnLedges
	
	LDA $1588,x             ; if on the ground, reset the turn counter
        AND #$04
        BEQ NotOnGround
	STZ $AA,x
	STZ $151C,x		; Reset turning flag (used if sprite stays on ledges)
	JSR MaybeFaceMario
	JSR MaybeJumpShells
NotOnGround:
	
	LDA $1528,x
	STA $167A,x
	
        JSL SprSprInteract	; Interact with other sprites

        lda #$02
        sta HurtFlag

        lda #DamageHigh
        sta FreeramHigh
        lda #DamageLow
        sta FreeramLow

	JSL MarioSprInteract	; Check for mario/sprite contact (carry set = contact)

        BCC Return1             ; return if no contact

Return1:
        stz Hurtflag
	RTS                    



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MaybeStayOnLedges:	
	LDA ExtraProperty1,x	; Stay on ledges if bit 1 is set
	AND #$02                
	BEQ NoFlipDirection
	LDA $1588,x             ; If the sprite is in the air
	ORA $151C,x             ;   and not already turning
	BNE NoFlipDirection
	JSR SetSpriteTurning 	;   flip direction
        LDA #$01                ;   set turning flag
	STA $151C,x    
NoFlipDirection:
	RTS
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
MaybeFaceMario:
	LDA ExtraProperty1,x	; Face Mario if bit 2 is set
	AND #$04
	BEQ Return4	
	LDA $1570,x
	AND #$7F
	BNE Return4
	LDA RAM_SpriteDir,x
	PHA
	
	JSR SubHorzPos         	; Face Mario
        TYA                       
	STA RAM_SpriteDir,X
	
	PLA
	CMP RAM_SpriteDir,x
	BEQ Return4
	LDA #$08
	STA RAM_SprTurnTimer,x
Return4:	
	RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
MaybeJumpShells:
	LDA ExtraProperty1,x    ; Face Mario if bit 3 is set
	AND #$08
	BEQ Return4
	TXA                     ; \ Process every 4 frames 
        EOR $13                 ;  | 
        AND #$03		;  | 
        BNE Return0188AB        ; / 
        LDY #$09		; \ Loop over sprites: 
JumpLoopStart:
	LDA $14C8,Y             ;  | 
        CMP #$0A       		;  | If sprite status = kicked, try to jump it 
        BEQ HandleJumpOver	;  | 
JumpLoopNext:
	DEY                     ;  | 
        BPL JumpLoopStart       ; / 
Return0188AB:
	RTS                     ; Return 

HandleJumpOver:
	LDA $00E4,Y             
        SEC                       
        SBC #$1A                
        STA $00                   
        LDA $14E0,Y             
        SBC #$00                
        STA $08                   
        LDA #$44                
        STA $02                   
        LDA $00D8,Y             
        STA $01                   
        LDA $14D4,Y             
        STA $09                   
        LDA #$10                
        STA $03                   
        JSL GetSpriteClippingA  
        JSL CheckForContact     
        BCC JumpLoopNext        ; If not close to shell, go back to main loop
	LDA $1588,x 		; \ If sprite not on ground, go back to main loop 
	AND #$04		;  |
        BEQ JumpLoopNext        ; / 
        LDA $157C,Y             ; \ If sprite not facing shell, don't jump 
        CMP $157C,X             ;  | 
        BEQ Return0188EB        ; / 
        LDA #$C0                ; \ Finally set jump speed 
        STA $AA,X               ; / 
Return0188EB:
	RTS                     ; Return
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetSpriteTurning:
	LDA #$08                ; Set turning timer 
	STA RAM_SprTurnTimer,X   
        LDA $157C,x
        EOR #$01
        STA $157C,x
Return0190B1:	
        RTS
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite graphics routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Tilemap:
	dcb $A8,$AA,$A8,$AA	; Walking 1, Walking 2, Killed, Turning

SubGfx:
	JSR GetDrawInfo   

	LDA $157C,x             ; $02 = direction
        STA $02

        LDA $14C8,x		; If killed...
        CMP #$02
	BNE NotKilled
	LDA #$02                ;    ...set killed frame
        STA $03			
        LDA $15F6,x		;    ...flip vertically
        ORA #$80
        STA $15F6,x
	BRA DrawSprite
NotKilled:

	LDA ExtraProperty2,x
	AND #$01
	BEQ NotTurning	
	LDA RAM_SprTurnTimer,x	; If turning...
	BEQ NotTurning
	LDA #$03		;    ...set turning frame
	STA $03
	BRA DrawSprite
NotTurning:
	
        LDA $14                 ; Set walking frame based on frame counter
        LSR A                   
        LSR A                   
        LSR A                   
        CLC                     
        ADC $15E9               
        AND #$01                
        STA $03                 

DrawSprite:
	PHX
	LDA $00                 ; Tile x position = sprite x location ($00)
        STA $0300,y             

        LDA $01                 ; Tile y position = sprite y location ($01)
        STA $0301,y             

        LDA $15F6,x             ; Yile properties xyppccct, format
        LDX $02                 ; If direction == 0...
        BNE NoFlip                
        ORA #$40                ;    ...flip tile
NoFlip:
        ORA $64                 ; Add in tile priority of level
        STA $0303,y             

        LDX $03                 ; Store tile
        LDA Tilemap,x           
        STA $0302,y             
        PLX
	
        LDY #$02                ; Set tiles to 16x16
        LDA #$00                ; We drew 1 tile
        JSL FinishOAMWrite      
        RTS                     
                    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; routines below can be shared by all sprites.  they are ripped from SMW
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; points routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

STAR_SOUNDS
	dcb $00,$13,$14,$15,$16,$17,$18,$19

SUB_STOMP_PTS:
	PHY                      
        LDA $1697               ; \
        CLC                     ;  | 
        ADC $1626,x             ; / some enemies give higher pts/1ups quicker??
        INC $1697               ; increase consecutive enemies stomped
        TAY                     ;
        INY                     ;
        CPY #$08                ; \ if consecutive enemies stomped >= 8 ...
        BCS NO_SOUND            ; /    ... don't play sound 
        LDA STAR_SOUNDS,y       ; \ play sound effect
        STA $1DF9               ; /   
NO_SOUND:
	TYA                     ; \
        CMP #$08                ;  | if consecutive enemies stomped >= 8, reset to 8
        BCC NO_RESET            ;  |
        LDA #$08                ; /
NO_RESET:
	JSL GivePoints
        PLY                     
        RTS                     ; return
                
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This routine determines if Mario is above or below the sprite.  It sets the Y register
; to the direction such that the sprite would face Mario
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SubVertPos:
	LDY #$00
        LDA $96
        SEC
        SBC $D8,x
        STA $0F
        LDA $97
        SBC $14D4,x
        BPL VertIncY
        INY
VertIncY:
        RTS   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This routine determines which side of the sprite Mario is on.  It sets the Y register
; to the direction such that the sprite would face Mario
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SubHorzPos:
	LDY #$00
	LDA $94
	SEC
	SBC $E4,x
	STA $0F
	LDA $95
	SBC $14E0,x
	BPL HorzIncY
	INY 
HorzIncY:
	RTS 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GET_DRAW_INFO
; This is a helper for the graphics routine.  It sets off screen flags, and sets up
; variables.  It will return with the following:
;
;		Y = index to sprite OAM ($300)
;		$00 = sprite x position relative to screen boarder
;		$01 = sprite y position relative to screen boarder  
;
; It is adapted from the subroutine at $03B760
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 	
DATA_03B75C:
	dcb $0C,$1C
DATA_03B75E:
	dcb $01,$02

GetDrawInfo:
	STZ $186C,X             ; Reset sprite offscreen flag, vertical 
        STZ $15A0,X             ; Reset sprite offscreen flag, horizontal 
        LDA $E4,X               ; \ 
        CMP $1A                 ;  | Set horizontal offscreen if necessary 
        LDA $14E0,X             ;  | 
        SBC $1B                 ;  | 
        BEQ ADDR_03B774         ;  | 
        INC $15A0,X             ; / 
ADDR_03B774:
        LDA $14E0,X             ; \ 
        XBA                     ;  | Mark sprite invalid if far enough off screen 
        LDA $E4,X               ;  | 
        REP #$20                ; Accum (16 bit) 
        SEC                     ;  | 
        SBC $1A                 ;  | 
        CLC                     ;  | 
        ADC.W #$0040            ;  | 
        CMP.W #$0180            ;  | 
        SEP #$20                ; Accum (8 bit) 
        ROL                     ;  | 
        AND.B #$01              ;  | 
        STA $15C4,X             ;  | 
        BNE ADDR_03B7CF         ; /  
        LDY.B #$00              ; \ set up loop: 
        LDA $1662,X             ;  |  
        AND.B #$20              ;  | if not smushed (1662 & 0x20), go through loop twice 
        BEQ ADDR_03B79A         ;  | else, go through loop once 
        INY                     ; /                        
ADDR_03B79A:
        LDA $D8,X               ; \                        
        CLC                     ;  | set vertical offscree 
        ADC DATA_03B75C,Y       ;  |                       
        PHP                     ;  |                       
        CMP $1C                 ;  | (vert screen boundry) 
        ROL $00                 ;  |                       
        PLP                     ;  |                       
        LDA $14D4,X             ;  |                       
        ADC.B #$00              ;  |                       
        LSR $00                 ;  |                       
        SBC $1D                 ;  |                       
        BEQ ADDR_03B7BA         ;  |                       
        LDA $186C,X             ;  | (vert offscreen)      
        ORA DATA_03B75E,Y       ;  |                       
        STA $186C,X             ;  |                       
ADDR_03B7BA:
        DEY                     ;  |                       
        BPL ADDR_03B79A         ; /                        
        LDY $15EA,X             ; get offset to sprite OAM                           
        LDA $E4,X               ; \ 
        SEC                     ;  |                                                     
        SBC $1A                 ;  |                                                    
        STA $00                 ; / $00 = sprite x position relative to screen boarder 
        LDA $D8,X               ; \                                                     
        SEC                     ;  |                                                     
        SBC $1C                 ;  |                                                    
        STA $01                 ; / $01 = sprite y position relative to screen boarder 
        RTS                     ; Return 

ADDR_03B7CF:
        PLA                     ; \ Return from *main gfx routine* subroutine... 
        PLA                     ;  |    ...(not just this subroutine) 
        RTS                     ; / 

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SUB_OFF_SCREEN
; This subroutine deals with sprites that have moved off screen
; It is adapted from the subroutine at $01AC0D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
DATA_01AC0D:
	dcb $40,$B0
DATA_01AC0F:
	dcb $01,$FF
DATA_01AC11:
        dcb $30,$C0
DATA_01AC19:
        dcb $01,$FF

SubOffScreen:
	JSR IsSprOnScreen       ; \ if sprite is not off screen, return                                       
        BEQ Return01ACA4        ; /                                                                           
        LDA $5B                 ; \  vertical level                                    
        AND #$01                ;  |                                                                           
        BNE VerticalLevel       ; /                                                                           
        LDA $D8,X               ; \                                                                           
        CLC                     ;  |                                                                           
        ADC #$50                ;  | if the sprite has gone off the bottom of the level...                     
        LDA $14D4,X             ;  | (if adding 0x50 to the sprite y position would make the high byte >= 2)   
        ADC #$00                ;  |                                                                           
        CMP #$02                ;  |                                                                           
        BPL OffScrEraseSprite   ; /    ...erase the sprite                                                    
        LDA $167A,X             ; \ if "process offscreen" flag is set, return                                
        AND #$04                ;  |                                                                           
        BNE Return01ACA4        ; /                                                                           
        LDA $13                   
        AND #$01                
        STA $01                   
        TAY                       
        LDA $1A                   
        CLC                       
        ADC DATA_01AC11,Y       
        ROL $00                   
        CMP $E4,X                 
        PHP                       
        LDA $1B                   
        LSR $00                   
        ADC DATA_01AC19,Y       
        PLP                       
        SBC $14E0,X             
        STA $00                   
        LSR $01                   
        BCC ADDR_01AC7C           
        EOR #$80                
        STA $00                   
ADDR_01AC7C:
        LDA $00                   
        BPL Return01ACA4          
OffScrEraseSprite:
	LDA $14C8,X             ; \ If sprite status < 8, permanently erase sprite 
        CMP #$08                ;  | 
        BCC OffScrKillSprite    ; / 
        LDY $161A,X             
        CPY #$FF                
        BEQ OffScrKillSprite      
        LDA #$00                
        STA $1938,Y             
OffScrKillSprite:
	STZ $14C8,X             ; Erase sprite 
Return01ACA4:
	RTS                       

VerticalLevel:
	LDA $167A,X             ; \ If "process offscreen" flag is set, return                
        AND #$04                ;  |                                                           
        BNE Return01ACA4        ; /                                                           
        LDA $13                 ; \                                                           
        LSR                     ;  |                                                           
        BCS Return01ACA4        ; /                                                           
        LDA $E4,X               ; \                                                           
        CMP #$00                ;  | If the sprite has gone off the side of the level...      
        LDA $14E0,X             ;  |                                                          
        SBC #$00                ;  |                                                          
        CMP #$02                ;  |                                                          
        BCS OffScrEraseSprite   ; /  ...erase the sprite      
        LDA $13                   
        LSR                       
        AND #$01                
        STA $01                   
        TAY                       
	LDA $1C                   
        CLC                       
        ADC DATA_01AC0D,Y       
        ROL $00                   
        CMP $D8,X                 
        PHP                       
        LDA $001D               
        LSR $00                   
        ADC DATA_01AC0F,Y       
        PLP                       
        SBC $14D4,X             
        STA $00                   
        LDY $01                   
        BEQ ADDR_01ACF3           
        EOR #$80                
        STA $00                   
ADDR_01ACF3:
        LDA $00                   
        BPL Return01ACA4          
        BMI OffScrEraseSprite  

IsSprOnScreen:
	LDA $15A0,X             ; \ A = Current sprite is offscreen 
        ORA $186C,X             ; /  
        RTS                     ; Return 
		
