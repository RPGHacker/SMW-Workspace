@asar 1.50

;;;;;;;;;;;;;;;;;;;;;;;;;
;Power VWF by RPG Hacker;
;;;;;;;;;;;;;;;;;;;;;;;;;


incsrc vwfconfig.cfg
incsrc ../shared/shared.asm


if !use_ow_reload_patch == 1
	incsrc ../free_7F4000/free_7f4000.asm
	print ""
endif


print "Power VWF v1.0 - (c) RPG Hacker"


math pri on
math round off

pushtable
cleartable


namespace vwf2_





;;;;;;;;;
;Helpers;
;;;;;;;;;


!use_misc_vram_flag       = %00000001
!use_bg_vram_flag         = %00000010
!use_status_bar_vram_flag = %00000100





;;;;;;;;;
;Hijacks;
;;;;;;;;;


; Code to execute when the game is started

org remap_rom($008064)
	autoclean jsl OnStartupGame
	nop	


; Code to execute when we enter the title screen
	
org remap_rom($0096B4)
	jsl remap_rom(OnEnterTitleScreen)
	

	
; Code to execute when we hit a message box

if !hijack_original_message_box == 1

org remap_rom($00A1DF)
	jsl remap_rom(OnMessageBoxHit)
	
endif



; Code to execute just before status bar rendering (during V-Blank)

org remap_rom($008DAC)
	jml remap_rom(OnVBlank)
	
SkipStatusBar:
	rts
	
RenderStatusBar:


; Code to execute when the status bar's IRQ is set up

org remap_rom($008292)
	jml remap_rom(OnSetupStatusBarIRQ)
	nop





;;;;;;;;;;;;;;;;;
;MAIN CODE START;
;;;;;;;;;;;;;;;;;


freecode

FreecodeStart:





;;;;;;;;;;;;;;;;
;Initialization;
;;;;;;;;;;;;;;;;


; This hijacks a few key points in the game to initialize the RAM used by the patch and prevent unexpected behavior

OnStartupGame:
	jsr remap_rom(Initialize)
	
.Recover:
	lda #$03
	sta remap_ram($2101)
	
.Return:
	rtl
	

OnEnterTitleScreen:
	jsr remap_rom(Initialize)

.Recover:
	ldx #$07
	lda #$FF

.Return:
	rtl



; Actual initialization routine

Initialize:
	lda #$00
	sta remap_ram(!vwf2_state)
	sta remap_ram(!skip_status_bar_flag)

.Return:
	rts





;;;;;;;;;;;;;;;;;;;;
;Message Box Hijack;
;;;;;;;;;;;;;;;;;;;;


; This hijacks SMW's original message box routine to call Power VWF

if !hijack_original_message_box == 1

OnMessageBoxHit:
	lda remap_ram(!vwf2_state)
	; cmp #$00
	bne .Recover
	

	{
	.Check:
if !use_ow_reload_patch == 1
if !use_dirty_flag_for_ow_reload == 1
		lda #$01
		sta remap_ram(!ow_dirty_flag)
endif
endif
		
		; Is this Yoshi's special introduction message?
		
		lda remap_ram($1426)
		cmp #$03
		bne .NotYoshi
		
		{
			lda #$01
			sta remap_ram(!message_index)
			bra .Start
		}
		
		
	.NotYoshi:
		; Is this the intro level message?
		
		lda remap_ram($0109)
		; cmp #$00
		beq .NotIntro
		
		{
			%sta_zero_or_stz(remap_ram(!message_index))
			bra .Start
		}
		
		
	.NotIntro:
		; Is this Yoshi's house?
	
		lda remap_ram($13BF)
		
if read1($03BB9B) != $FF
		; Was this ROM modified in Lunar Magic?
		cmp remap_rom($03BB9B)		; We could replace this by read1($03BB9B), but that might force us to re-apply the patch when editing certain things in Lunar Magic
else
		; Or is it a "clean" ROM?
		cmp #$28
endif
		bne .RegularMessage
		
		lda remap_ram($187A)
		; cmp #$00
		beq .RegularMessage
		
		{
			lda #$02
			sta remap_ram($1426)
		}
		
		
	.RegularMessage:
		lda remap_ram($13BF)
		asl
		clc
		adc remap_ram($1426)
		dec
		sta remap_ram(!message_index)
	}
	
	
.Start:
	%sta_zero_or_stz(remap_ram(!message_index)+1)
	%sta_one_or_inc(remap_ram(!vwf2_state))
	
.Recover:
	stz remap_ram($1426)
	
.Return:
	rtl
	
endif





;;;;;;;;;
;V-Blank;
;;;;;;;;;


; Hijack SMW's status bar drawing routine to do some V-Blank-dependent stuff and also skip status bar rendering if necessary

OnVBlank:
	lda remap_ram(!skip_status_bar_flag)
	; cmp #$00
	beq .Recover

	{
	.SkipStatusBar:
		jml remap_rom(SkipStatusBar)
	}

.Recover:
	stz remap_ram($2115)
	lda #$42 

.Return:
	jml remap_rom(RenderStatusBar)





; Hijack the code that sets up SMW's status bar NMI to either disable it completely or modify it


OnSetupStatusBarIRQ:
	lda remap_ram(!vwf2_state)
	; cmp #$00
	beq .Recover

	{
	.CustomIRQ:
		lda remap_ram($4211)
	
		stz remap_ram($11)
		
		lda #$81
		sta remap_ram($4200)
		
		lda #$00
		sta remap_ram($2111)
		lda #$01
		sta remap_ram($2111)
		lda #$1F
		sta remap_ram($2112)
		lda #$01
		sta remap_ram($2112)
	
		jml remap_rom($0082B0)
	}
	
.Recover:
	ldy #$24 
	lda remap_ram($4211)

.Return:
	jml remap_rom($008297)




	
;;;;;;;;;;;;;;;
;MAIN CODE END;
;;;;;;;;;;;;;;;

print "Patch inserted at $",hex(FreecodeStart),", ",freespaceuse," bytes of free space used."

namespace off


pulltable
