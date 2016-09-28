@asar 1.37

;;;;;;;;;;;;;;;;;;;;;;;
;Tolerance Timer Patch;
;;;;;;;;;;;;;;;;;;;;;;;


incsrc ttconfig.cfg
incsrc ../shared/shared.asm


print "Tolerance Timer v1.0 - (c) RPG Hacker"


math pri on
math round off


namespace tolerance_timer_


!allow_late_or_early_jumps = !allow_late_jumps|!allow_early_jumps





;;;;;;;;;
;Hijacks;
;;;;;;;;;


; Code to execute when the game checks whether Mario can jump

if !allow_late_or_early_jumps == 1
org remap_rom($00D5F2)
	autoclean jml OnCheckJumpPossible
endif
	
	
; Code to execute when the player successfully jumps

if !allow_late_or_early_jumps == 1
org remap_rom($00D63C)
	autoclean jml OnJump
endif
	
	
; Code to execute when the game checks whether we're pressing any jump button
	
if !allow_early_jumps == 1
org remap_rom($00D618)
	autoclean jml OnCheckJumpButtonPressed
endif





;;;;;;;;;;;;;;;;;
;MAIN CODE START;
;;;;;;;;;;;;;;;;;


freecode

FreecodeStart:





;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Check Jump Possible Hijack;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Hijacks the check that determines whether Mario can jump (so that we can potentially make him jump with a delay)

if !allow_late_or_early_jumps == 1
OnCheckJumpPossible:
	
.Recover:
	; If Mario isn't currently in the air in any form, jumping is possible, anyways, so don't check further
	lda remap_ram($72)
	; cmp #$00
	beq .CanJump

	{
	.Check:
if !allow_late_jumps == 1
		; We're technically in the air by now, but check if a late jump is still possible
		lda remap_ram(!late_jump_timer)
		; cmp #$00
		beq .CantJump
		
		{
			dec
			sta remap_ram(!late_jump_timer)
			
			bra .Return
		}
	
	.CantJump:
endif

if !allow_early_jumps == 1
		; We're currently in the air and no late jump is possible, so check if an early jump is possible instead
		lda remap_ram($16)
		ora remap_ram($18)
		bpl .NoButtonPressed
		
		{
		.Reset:
			; We're pressing any jump button, so reset the early jump timer
			lda #!early_jump_num_frames
			sta remap_ram(!early_jump_timer)
		
			; Store $18, so that we will later know whether we pressed A or B
			lda remap_ram($18)
			sta remap_ram(!early_jump_last_button)
			
			bra .DontStoreTimer
		}
		
	.NoButtonPressed:
		lda remap_ram(!early_jump_timer)
		; cmp #$00
		beq .DontStoreTimer
		
		{
		.StoreTimer:		
			dec
			sta remap_ram(!early_jump_timer)
		}
		
	.DontStoreTimer:		
endif
		
		jml remap_rom($00D5F6)
	}

.CanJump:
if !allow_late_jumps == 1
	lda #!late_jump_num_frames
	sta remap_ram(!late_jump_timer)
	lda remap_ram($7B)
	sta remap_ram(!late_jump_last_x_speed)
	lda remap_ram($13E4)
	sta remap_ram(!late_jump_last_dash_timer)
endif

.Return:
	jml remap_rom($00D5F9)
endif
	
	
	
	
	
;;;;;;;;;;;;;
;Jump Hijack;
;;;;;;;;;;;;;


; Hijacks the routine that starts Mario's jump so that we can clear flags and process early jumps
	
if !allow_late_or_early_jumps == 1
OnJump:
if !allow_late_jumps == 1
	lda remap_ram($72)
	; cmp #$00
	beq .NoLateJump
	
	{
	.LateJump:
		; If we're in a late jump, restore x speed if it makes sense (because falling of ledges slows Mario down)
		lda remap_ram($15)
		bit #%00000010
		; cmp #$00
		beq .NotHoldingLeft
		
		{
		.HoldingLeft:
			; Player is currently holding left - check if stored speed was negative
			lda remap_ram(!late_jump_last_x_speed)
			bpl .DontRestoreXSpeed
			
			{
			.XSpeedNegative:
				sta remap_ram($7B)
				lda remap_ram(!late_jump_last_dash_timer)
				sta remap_ram($13E4)
				bra .DontRestoreXSpeed
			}
		}
		
	.NotHoldingLeft:
		lda remap_ram($15)
		bit #%00000001
		; cmp #$00
		beq .NotHoldingRight
		
		{
		.HoldingRight:
			; Player is currently holding right - check if stored speed was positive
			lda remap_ram(!late_jump_last_x_speed)
			bmi .DontRestoreXSpeed
			
			{
			.XSpeedPositive:
				sta remap_ram($7B)
				lda remap_ram(!late_jump_last_dash_timer)
				sta remap_ram($13E4)
			}
		}
		
	.NotHoldingRight:
	.DontRestoreXSpeed:
	}
	
.NoLateJump:
	%sta_zero_or_stz(remap_ram(!late_jump_timer))
endif

.Recover:
	lda remap_ram($18)
	bpl .ANotPressed
	
	{
	; If A is being pressed during the current frame, we give it priority and don't check for early jumps to begin with
	.APressed:	
if !allow_early_jumps == 1
		%sta_zero_or_stz(remap_ram(!early_jump_timer))
endif
		jml remap_rom($00D640)
	}	

.ANotPressed:
if !allow_early_jumps == 1
	lda remap_ram(!early_jump_timer)
	; cmp #$00
	beq .NoEarlyJump
	
	{
	.EarlyJump:		
		lda remap_ram(!early_jump_last_button)
		bmi .APressed
		%sta_zero_or_stz(remap_ram(!early_jump_timer))
	}

.NoEarlyJump:
endif

.Return:
	jml remap_rom($00D65E)
endif





;;;;;;;;;;;;;;;;;;;;;;;;;;
;Check Jump Button Hijack;
;;;;;;;;;;;;;;;;;;;;;;;;;;


; Hijacks the routine that checks if a jump button is pressed so that we can apply early jump logic

if !allow_early_jumps == 1
OnCheckJumpButtonPressed:
	lda remap_ram(!early_jump_timer)
	; cmp #$00
	beq .NoEarlyJump
	
	{
	.EarlyJump:
	.CheckCancelOnYoshi:
		; Check if we're currently on Yoshi and pressing A, in which case early jump doesn't matter (and in fact, causes a minor glitch)
		lda remap_ram($187A)
		; cmp #$00
		beq .NoCancel
		{
		.OnYoshi:
			lda remap_ram(!early_jump_last_button)
			bpl .NoCancel
			
			{
			.Cancel:
				%sta_zero_or_stz(remap_ram(!early_jump_timer))
				bra .NoEarlyJump
			}
		}
		
	.NoCancel:
		jml remap_rom($00D630)
	}

.NoEarlyJump:
.Recover:
	lda remap_ram($16)
	ora remap_ram($18)

.Return:
	jml remap_rom($00D61C)
endif




	
;;;;;;;;;;;;;;;
;MAIN CODE END;
;;;;;;;;;;;;;;;

print "Patch inserted at $",hex(FreecodeStart),", ",freespaceuse," bytes of free space used."
