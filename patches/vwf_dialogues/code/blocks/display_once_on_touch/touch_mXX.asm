; Displays whatever message you set !message_id to once on contact, then
; sets a RAM address to prevent the dialogue from being displayed again.
; This is a very simple block that mainly serves as a reference for how you
; can integrate VWF Dialogues functionality in your own patches.


; The ID of the message to display.
!message_id = $0051

; The free RAM address to use.
; If you leave this at $60, the RAM address will automatically be cleared at
; level load, thus you will get the message again whenever you re-enter the
; level, instead of just getting it once per session.
!free_ram = $60


incsrc "vwfsharedroutines.asm"

db $37
jmp MarioContact : jmp MarioContact : jmp MarioContact
jmp Return : jmp Return : jmp Return : jmp Return
jmp MarioContact : jmp MarioContact : jmp MarioContact : jmp MarioContact : jmp MarioContact

MarioContact:
	lda !free_ram
	bne Return

	lda.b #!message_id
	ldx.b #!message_id>>8
	jsl VWF_DisplayAMessage
	
	lda.b #$01
	sta !free_ram

Return:
	rtl
	