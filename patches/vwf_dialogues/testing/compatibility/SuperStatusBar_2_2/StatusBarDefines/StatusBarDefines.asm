;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Defines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Statusbar tile RAM location
	if !sa1 == 0
		!RAM_BAR	= $7FA000
	else
		!RAM_BAR	= $404000
	endif
	;^Free ram for status bar (needs $140 (320 decimal) bytes)

;Valid numbers for these offsets: $000-$13F
;Use even numbers ONLY!
;Properties (palette/ect) are set in the DATA_TILES tables, or using Smallhacker's status bar editor
;They are not updated automatically if you just change these 
;If you move the time counter, for example, it will probably be white until you change the properties byte
;of the tiles it writes to (through ASM, since it writes using DMA).

;If you want to remove a counter/routine controlled tile(s), change the "1"'s in labels that have "!Enable"
;in its name to 0. Note that it does not guarantee there will be a blank tile left behind when removed.

	!IRQ_line_Y_pos = $26		;\($26 by default), layer 3 status bar/HUD IRQ/cutoff line Y position (in pixels),
					;/If you are not using the last row of 8x8 tiles, change it to $24.

	!Enable_TIME	= 1		;>display time limit: 0 = false (will be black squares on 1st and 2nd digits,
					; Also, you need to disable the "time bonus" that happens if beating the level),
					; 1 = true. 
	!TIME_OFFSET	= $0E6		;>Position of numbers of the time limit (not the word "TIME" itself)
	!TIME_SPEED	= $28		;>($28 by default) how many frames before each (or "period") decrement of time limit, put
					; "$3C" for real seconds because the game runs 60 fps or HZ (barring lags and slowdowns).
	!timer_warning	= 0		;>if the timer hits below 100, the "TIME" and digits palette changes to red and if
					; it is less than 10, will play the "beeping" sound, inspired by SM3DL/SM3DW/NSMB2.
					; 0 = false, 1 = true.
	!Enable_SCORE	= 1		;>Display score: 0 = false (will display last 0 digit, also you need to download GHB's
					; disable score patch, modify the status bar hijacks and insert it in so the goal
					; doesn't still give you points), 1 = true.
	!SCORE_OFFSET	= $0EE		;>Position of score counter.

	!Enable_LIVES	= 1		;>Display lives: 0 = false (always says 0 lives), 1 = true.
	!LIVES_OFFSET	= $0C8		;>Position of lives counter

	!Enable_COINS	= 1		;>Display coin counter (numbers only): 0 = false (always says 0 coins), 1 = true.
	!COINS_OFFSET	= $0B8		;>Position of coin counter

	!Enable_NAME	= 1		;>Show Mario/Luigi name: 0 = false (always say "MARIO"), 1 = true.
	!NAME_OFFSET	= $084		;>Position of player name (MARIO/LUIGI)

	!Enable_DRAGON	= 1		;>Display (repeating by # of icons) yoshi coins: 0 = false, 1 = true.
	!DRAGON_OFFSET	= $090		;>Position of dragon coins (yoshi coins, whatever)
	!TILE_EMPTY	= $FC		;>Tile number that represents "no yoshi coins"
	!TILE_FULL	= $2E		;>tile number that represents "yoshi coin(s) collected"

	!Enable_STARS	= 1		;>display bonus stars: 0 = false (you might want to use a custom goal, the victory bonus
					; stars are now useless), 1 = true.
	!STARS_OFFSET	= $0D8		;>Position of bonus stars counter (large numbers next to item box normally)
					; This corresponds to the BOTTOM LEFT corner (bottom half of the tens digit) of the counter


	!ITEM_X		= $78		;>X position of item in item box (screen) DOES NOT AFFECT WHERE ITEM DROPS FROM
	!ITEM_Y		= $0F		;>Y position of item in item box (screen) DOES NOT AFFECT WHERE ITEM DROPS FROM
	!ITEM_PRIORITY	= $30		;>Priority bits of item in item box. (can be used to force palette/flip/ect too)
					; YXPPCCCT
	!ITEM_SIZE	= $02		;>Size/high x position bit of item box item sprite tile. $02 = 16x16, $00 = 8x8
					; Setting the first bit ($01/$03) will push it far off the screen to the left
					; With a high x position ($F0-FF), it will still be visible though. 
					; Just on the left side of the screen