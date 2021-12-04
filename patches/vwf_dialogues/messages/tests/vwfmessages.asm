;-------------------------------------------------------

; DIALOG DATA BEGIN

; Text macros:

%vwf_register_text_macro("Mario", "db ""Mario""")
%vwf_register_text_macro("Luigi", "db ""Luigi""")
%vwf_register_text_macro("Yoshi", "db ""Yoshi""")
%vwf_register_text_macro("Peach", "db ""Princess Peach""")
%vwf_register_text_macro("Bowser", "db ""Bowser""")
%vwf_register_text_macro("Toad", "db ""Toad""")
%vwf_register_text_macro("SwitchPalace", "db $FD,""- SWITCH PALACE -"",$FD,$FD")
%vwf_register_text_macro("PointOfAdvice", "db $FD,""-POINT OF ADVICE-"",$FA,$ED")


; Messages:

; RPG Hacker: Really, message $0050 (Yoshi's House) is the most important one for us, since it's the quickest one to get to.
;-------------------------------------------------------

%vwf_message_start(0050)	; Message 104-1

	%vwf_header()
	
.header
db $00
db %00000000,%01111111,%01010001,%11000000,$01,%00100000
dw $7FFF,$0000
db %11111100
db %00001111,$13,$13,$23,$29
db %00000010
;dl Message0050ASMLoc
dl .MessageSkipLoc

db "Select a test:",$FD

db $F0,$C4
db $A8

dl ..test_0
dl ..test_1
dl ..test_2
dl ..test_3
dl ..test_4
dl ..test_5
dl ..test_6
dl ..test_7
dl ..test_8
dl ..test_9
dl ..test_a
dl ..test_b

db "Reserved",$FD
db "Reserved",$FD
db "Reserved",$FD
db "Reserved",$FD
db "Reserved",$FD
db "Reserved",$FD
db "Reserved",$FD
db "Reserved",$FD
db "Reserved",$FD
db "Reserved",$FD
db "Reserved",$FD
db "Reserved",$FD

..test_0
..test_1
..test_2
..test_3
..test_4
..test_5
..test_6
..test_7
..test_8
..test_9
..test_a
..test_b
db "Thank you for using VWF Dialogues Patch by RPG Hacker!",$FA



.MessageSkipLoc
	;%vwf_close()

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0000)	; Message 000-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0001)	; Message 000-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0002)	; Message 001-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0003)	; Message 001-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0004)	; Message 002-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0005)	; Message 002-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0006)	; Message 003-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0007)	; Message 003-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0008)	; Message 004-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0009)	; Message 004-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000A)	; Message 005-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000B)	; Message 005-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000C)	; Message 006-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000D)	; Message 006-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000E)	; Message 007-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000F)	; Message 007-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0010)	; Message 008-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0011)	; Message 008-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0012)	; Message 009-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0013)	; Message 009-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0014)	; Message 00A-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0015)	; Message 00A-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0016)	; Message 00B-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0017)	; Message 00B-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0018)	; Message 00C-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0019)	; Message 00C-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(001A)	; Message 00D-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(001B)	; Message 00D-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(001C)	; Message 00E-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(001D)	; Message 00E-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(001E)	; Message 00F-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(001F)	; Message 00F-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0020)	; Message 010-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0021)	; Message 010-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0022)	; Message 011-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0023)	; Message 011-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0024)	; Message 012-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0025)	; Message 012-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0026)	; Message 013-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0027)	; Message 013-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0028)	; Message 014-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0029)	; Message 014-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002A)	; Message 015-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002B)	; Message 015-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002C)	; Message 016-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002D)	; Message 016-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002E)	; Message 017-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002F)	; Message 017-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0030)	; Message 018-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0031)	; Message 018-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0032)	; Message 019-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0033)	; Message 019-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0034)	; Message 01A-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0035)	; Message 01A-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0036)	; Message 01B-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0037)	; Message 01B-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0038)	; Message 01C-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0039)	; Message 01C-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(003A)	; Message 01D-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(003B)	; Message 01D-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(003C)	; Message 01E-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(003D)	; Message 01E-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(003E)	; Message 01F-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(003F)	; Message 01F-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0040)	; Message 020-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0041)	; Message 020-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0042)	; Message 021-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0043)	; Message 021-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0044)	; Message 022-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0045)	; Message 022-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0046)	; Message 023-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0047)	; Message 023-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0048)	; Message 024-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0049)	; Message 024-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004A)	; Message 101-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004B)	; Message 101-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004C)	; Message 102-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004D)	; Message 102-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004E)	; Message 103-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004F)	; Message 103-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0051)	; Message 104-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0052)	; Message 105-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0053)	; Message 105-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0054)	; Message 106-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0055)	; Message 106-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0056)	; Message 107-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0057)	; Message 107-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0058)	; Message 108-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0059)	; Message 108-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(005A)	; Message 109-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(005B)	; Message 109-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(005C)	; Message 10A-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(005D)	; Message 10A-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(005E)	; Message 10B-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(005F)	; Message 10B-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0060)	; Message 10C-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0061)	; Message 10C-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0062)	; Message 10D-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0063)	; Message 10D-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0064)	; Message 10E-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0065)	; Message 10E-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0066)	; Message 10F-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0067)	; Message 10F-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0068)	; Message 110-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0069)	; Message 110-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(006A)	; Message 111-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(006B)	; Message 111-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(006C)	; Message 112-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(006D)	; Message 112-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(006E)	; Message 113-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(006F)	; Message 113-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0070)	; Message 114-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0071)	; Message 114-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0072)	; Message 115-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0073)	; Message 115-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0074)	; Message 116-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0075)	; Message 116-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0076)	; Message 117-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0077)	; Message 117-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0078)	; Message 118-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0079)	; Message 118-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(007A)	; Message 119-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(007B)	; Message 119-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(007C)	; Message 11A-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(007D)	; Message 11A-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(007E)	; Message 11B-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(007F)	; Message 11B-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0080)	; Message 11C-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0081)	; Message 11C-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0082)	; Message 11D-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0083)	; Message 11D-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0084)	; Message 11E-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0085)	; Message 11E-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0086)	; Message 11F-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0087)	; Message 11F-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0088)	; Message 120-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0089)	; Message 120-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(008A)	; Message 121-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(008B)	; Message 121-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(008C)	; Message 122-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(008D)	; Message 122-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(008E)	; Message 123-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(008F)	; Message 123-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0090)	; Message 124-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0091)	; Message 124-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0092)	; Message 125-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0093)	; Message 125-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0094)	; Message 126-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0095)	; Message 126-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0096)	; Message 127-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0097)	; Message 127-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0098)	; Message 128-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0099)	; Message 128-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(009A)	; Message 129-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(009B)	; Message 129-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(009C)	; Message 12A-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(009D)	; Message 12A-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(009E)	; Message 12B-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(009F)	; Message 12B-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A0)	; Message 12C-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A1)	; Message 12C-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A2)	; Message 12D-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A3)	; Message 12D-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A4)	; Message 12E-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A5)	; Message 12E-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A6)	; Message 12F-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A7)	; Message 12F-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A8)	; Message 130-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A9)	; Message 130-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00AA)	; Message 131-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00AB)	; Message 131-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00AC)	; Message 132-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00AD)	; Message 132-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00AE)	; Message 133-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00AF)	; Message 133-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B0)	; Message 134-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B1)	; Message 134-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B2)	; Message 135-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B3)	; Message 135-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B4)	; Message 136-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B5)	; Message 136-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B6)	; Message 137-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B7)	; Message 137-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B8)	; Message 138-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B9)	; Message 138-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00BA)	; Message 139-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00BB)	; Message 139-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00BC)	; Message 13A-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00BD)	; Message 13A-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00BE)	; Message 13B-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00BF)	; Message 13B-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C0)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C1)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C2)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C3)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C4)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C5)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C6)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C7)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C8)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C9)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00CA)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00CB)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00CC)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00CD)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00CE)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00CF)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D0)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D1)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D2)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D3)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D4)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D5)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D6)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D7)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D8)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D9)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00DA)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00DB)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00DC)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00DD)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00DE)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00DF)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E0)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E1)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E2)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E3)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E4)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E5)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E6)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E7)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E8)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E9)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00EA)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00EB)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00EC)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00ED)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00EE)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00EF)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F0)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F1)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F2)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F3)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F4)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F5)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F6)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F7)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F8)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F9)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00FA)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00FB)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00FC)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00FD)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00FE)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00FF)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

; DIALOG DATA END
