
%nextbank(freecode)


;-------------------------------------------------------

; Custom code meant for your VWF messages goes here.

;-------------------------------------------------------

; Some useful routines for your VWF messages.


; This routine lets you display a message and force the current textbox to close if one is already up.
; Call this routine from within your custom block/sprite/patch code.
; Entry code:
; REP #$20
; LDA.w #MessageNumber
; JSL DisplayAMessage


DisplayAMessage:
	STA !message
	SEP #$20
	LDA !vwfmode
	BNE .ForceActiveMessageToClose
	INC
	STA !vwfmode
	LDA #$6B
	STA !messageasmopcode
	RTL

.ForceActiveMessageToClose
	LDA #$01
	STA !vwfactiveflag
	RTL


; This routine allows you to change the text pointer to wherever you specify
; Entry code:
; LDA.b #TextPointer
; LDX.b #TextPointer>>8
; LDY.b #TextPointer>>16
; JML ChangeVWFTextPtr

ChangeVWFTextPtr:
	STA !vwftextsource
	TXA
	STA !vwftextsource+1
	TYA
	STA !vwftextsource+2
	RTL

; This routine allows you to change the MessageASM pointer to wherever you specify
; Entry code:
; LDA.b #ASMPointer
; LDX.b #ASMPointer>>8
; LDY.b #ASMPointer>>16
; JML ChangeMessageASMPtr

ChangeMessageASMPtr:
	STA !messageasmloc
	TXA
	STA !messageasmloc+1
	TYA
	STA !messageasmloc+2
	RTL

; This routine allows you to change the message skip pointer to wherever you specify
; Entry code:
; LDA.b #TextPointer
; LDX.b #TextPointer>>8
; LDY.b #TextPointer>>16
; JML ChangeMessageSkipPtr

ChangeMessageSkipPtr:
	STA !skipmessageloc
	TXA
	STA !skipmessageloc+1
	TYA
	STA !skipmessageloc+2
	RTL

; This routine lets you check if the player skipped the current message with start.
; It only works if the current message was set to be skippable initially. 
;Entry code:
; JSL CheckIfMessageWasSkipped
; BCS .MessageWasSkipped

CheckIfMessageWasSkipped:
	CLC
	LDA !initialskipmessageflag
	BEQ .NoSkipping
	LDA !skipmessageflag
	BNE .NoSkipping
	SEC
.NoSkipping
	RTL

; This routine lets you buffer, then display a string of text that can potentially change. For example displaying the name
; of a randomly selected item.
; Entry code 1:
; (Some code that sets X to a multiple of 2)
; REP #$30
; STZ $03
; LDY.w #.StringTable>>16
; LDA.l .StringTable,x
; JML BufferVWFText_Main
;
; Entry code 2:
; (Some code that sets X to a multiple of 2)
; REP #$30
; SEC
; ROL $03
; LDA.w #TextPointer
; STA $04
; LDA.w #TextPointer>>8
; STA $05
; LDY.w #.StringTable>>16
; LDA.l .StringTable,x
; JML BufferVWFText_Main
;
;.StringTable
;dw .String1,.String2,.String3 ...
;
;.String1
;db "Insert any valid text/commands here",$E7
;
;
; Notes:
; - If using Entry Code 1, use the $E8 command to call text macros 0000-000F. The order you buffer the strings is in ascending order starting from 0000.
; - If using Entry Code 2, "TextPointer" is where the textbox should jump to after the buffered text is done displaying since command byte $FB
; is automatically stored at the end of the buffered text. Useful for displaying stuff like the speaker's name at the start of a text box automatically.
; You should only use this entry code once if you plan on buffering multiple strings consecuatively.
; - The buffered strings must end with command byte $E7 to signify the end of the string.
; - It's highly recommended that you call this at the start of a text box and buffer all the necessary text ahead of time. Otherwise, word wrapping
; might not work correctly. Check if !isnotatstartoftext is non-zero to see if you're at the start of the current text box.
; - If you plan on buffering multiple text strings, do so consecuatively, where the first call to this routine is to BufferVWFText_Main, while each
; subsequent call is to BufferVWFText_Entry2. Also, change the JML for all but the last the call to BufferVWFText in a row to JSL.

BufferVWFText:
.Main
	STY $02
	STA $00
	LDA #$0000
	STA !vwftbufferedtextpointerindex
	STA !vwftbufferedtextindex
	BRA +

.Entry2
	STY $02
	STA $00
	LDA !vwftbufferedtextindex
+
	TAY
	LDA !vwftbufferedtextpointerindex
	AND #$00FF
	TAX
	TYA
	CLC
	ADC.w #!vwftextbuffer
	STA !vwftbufferedtextpointers,x
	SEP #$20
	LDA.b #!vwftextbuffer>>16
	STA !vwftbufferedtextpointers+2,x
	TYX
	LDY #$0000
.Loop
	LDA [$00],Y
	CMP #$E7
	BNE +
	JMP .DoneVWFBuffer

+
	STA !vwftextbuffer,x
	INY
	INX
	BCC .Loop
	PHX
	SEC
	SBC #$E7
	TAX
	CPX.w #$F0-$E7
	BNE .NotDisplayOptionCommand
	PLX
	JMP .HandleF0Command

.NotDisplayOptionCommand
	LDA.l .CommandSizeTable,x
	PLX
	CMP #$01
	BEQ .Store8BitData
	CMP #$02
	BEQ .Store16BitData
	CMP #$03
	BEQ .Store24BitData
	CMP #$04
	BEQ .Store32BitData
	BRA .Loop

.Store32BitData
	LDA [$00],Y
	STA !vwftextbuffer,x
	INY
	INX
.Store24BitData
	LDA [$00],Y
	STA !vwftextbuffer,x
	INY
	INX
.Store16BitData
	LDA [$00],Y
	STA !vwftextbuffer,x
	INY
	INX
.Store8BitData
	LDA [$00],Y
	STA !vwftextbuffer,x
	INY
	INX
	JMP .Loop

.DoneVWFBuffer
	STA !vwftextbuffer,x
	LDA !vwftbufferedtextpointerindex
	CLC
	ADC #$03
	STA !vwftbufferedtextpointerindex
	LDA $03
	BEQ .NoTextHijack
	STZ $03
	LDA $04
	XBA
	LDA #$FB
	REP #$21
	STA !vwftextbuffer,x
	LDA $05
	STA !vwftextbuffer+2,x
	TXA
	ADC #$0004
	STA !vwftbufferedtextindex
	SEP #$30
	LDY.b #!vwftextbuffer>>16
	LDX.b #!vwftextbuffer>>8
	LDA.b #!vwftextbuffer
	JML ChangeVWFTextPtr

.NoTextHijack
	INX
	TXA
	STA !vwftbufferedtextindex
	SEP #$30
	RTL

.HandleF0Command
	LDA [$00],Y
	STA !vwftextbuffer,x
	INY
	INX
	AND #$F0
	LSR #4
	STA $0E
-
	LDA [$00],Y
	STA !vwftextbuffer,x
	INY
	INX
	LDA [$00],Y
	STA !vwftextbuffer,x
	INY
	INX
	LDA [$00],Y
	STA !vwftextbuffer,x
	INY
	INX
	DEC $0E
	BNE -
	JMP .Loop

.CommandSizeTable					; Commands...
	db $00,$02,$00,$00,$00				; $E7-$EB
	db $01,$00,$02,$03,$02				; $EC-$F0
	db $03,$01,$01,$01,$03				; $F1-$F5
	db $03,$04,$01,$01,$00				; $F6-$FA
	db $03,$02,$00,$00,$00				; $FB-$FF

; These two routines lets you toggle MessageASM. Call directly with the $F1 command or within a MessageASM routine.

ToggleMessageASMPtr:
.Disable
	LDA #$6B
	BRA +

.Enable
	LDA #$5C
+
	STA !messageasmopcode
	RTL


; These three routines let you warp to the overworld and trigger an event (if desired).
; Call directly with the $F1 command.
; Note that if you're using Lunar Magic 3.00+, then you can set a secondary entrance to exit to the overworld.
; In that case, use the $EF command and set it to the appropriate secondary entrance.

CloseMessageAndGoToOverworld:
.NormalExit
	LDA #$01
	TAY
	BRA +

.SecretExit
	LDA #$02
	LDY #$01
	BRA +

.StartPlusSelect
	LDA #$80
	LDY #$00
+
	STA remap_ram($0DD5)
	STY remap_ram($13CE)
	INC remap_ram($1DE9)
	LDA #$0B
	STA remap_ram($0100)
	RTL
