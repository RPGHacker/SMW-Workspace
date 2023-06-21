ORG $00804E
	%clean("JML clear_pointers")

ORG $00806B
	%clean("JML global_main")
	
%origin(!global_freespace)
	clear_pointers:
		STA $7F8182
		LDA #$00
	if !SA1
		LDX #$6E
	else
		LDX #$40
	endif
		-
			STA !sprite_RAM,x
			DEX
		BPL -
		JML $008052
	
	global_main:
		LDA $10
		BEQ global_main
		JSR global_code
		LDA $0100+!Base2
		CMP #$14
		BNE +
			print pc
			%sprite_code_conditional("JSR sprite_code")
		+
		JML $00806F

