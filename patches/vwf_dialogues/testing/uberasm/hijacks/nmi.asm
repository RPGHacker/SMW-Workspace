ORG $008176
	%clean("JML nmi_hijack")
	NOP #2

%origin(!nmi_freespace)
nmi_hijack:
	LDA $4210
	JSR nmi_code
	LDA $1DFB+!Base2
	JML $00817C
