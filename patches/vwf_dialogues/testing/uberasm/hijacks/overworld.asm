ORG $00A1C3
	%clean("JML main_ow")
	
ORG $00A18F
	%clean("JML init_ow")
	NOP #2

%origin(!OW_freespace)

main_ow:
	JSL $7F8000
	PHB				
	PHK				
	PLB							
	LDX $0DB3+!Base2
	LDA $1F11+!Base2,x
	ASL A				
	TAX				
	REP #$20		
	LDA OW_asm_table,x
	JSR run_code_ow
	PLB
	JML $00A1C7				

init_ow:
	PHK
	PEA.w .return-1
	PEA.w $84CE
	JML $0092A0
.return
	PHB				
	PHK				
	PLB							
	LDX $0DB3+!Base2
	LDA $1F11+!Base2,x
	ASL A				
	TAX				
	REP #$20		
	LDA OW_init_table,x
	JSR run_code_ow	
	PLB
	JML $0093F4
	
run_code_ow:
        STA $00
        SEP #$30
        LDX #$00
        JSR (!Base1,x)
        RTS

OW_asm_table:

dw MainOWcode
dw Yoshislandcode
dw VanillaDomecode
dw ForestIllusioncode
dw BowserofValleycode
dw SpecialWorldcode
dw Starworldcode

OW_init_table:

dw MainOWInit
dw YoshislandInit
dw VanillaDomeInit
dw ForestIllusionInit
dw BowserofValleyInit
dw SpecialWorldInit
dw StarworldInit
