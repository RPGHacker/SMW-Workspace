; This is a bit of nasty location to hijack, since it's at the end of a loop.
; Because of this, we're sometimes adding multiple JMLs per frame (up to 4 or so) instead of just one.
; However, we need this hijack to run at the very end of the status bar routine, and there was
; no later point to hijack than this.
; An alternative would have been to disassemble the whole Yoshi Coin status bar routine and
; let it run in here. While that would haven been slightly faster, I'm not sure it
; would have been the better solution, since I see a higher potential for patch conflicts that way.

ORG $008FF5
	%clean("JML statusbar_drawn_main")

%origin(!statusbar_drawn_freespace)
	statusbar_drawn_main:
		CPX #$04
		BEQ .yoshi_coins_done
		
		JML $008FE6
		
	.yoshi_coins_done	
		JSR statusbar_drawn_code
		
		JML $008FF9
