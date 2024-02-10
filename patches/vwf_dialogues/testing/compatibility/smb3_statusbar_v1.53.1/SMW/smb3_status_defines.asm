@include

;if you want to insert the status bar gfx and/or tilemap as exgfx (rather than
;have the patch insert the files raw), set these to the exgfx file number.
;when inserted as exgfx, !StatusBarMAP and/or !StatusBarGFX below will
;be ignored. values below $0080 will insert the gfx/tilemap raw rather
;than as exgfx (and thus these values will be ignored)

!GraphicExGFX = $007F
!TilemapExGFX = $007F

!CustomCode = "smb3_status_counters.asm"
!Worlds = "smb3_status_worlds.asm"
!StatusBarMAP = "SMW/smb3_status_map.bin"	;only used if !TilemapExGFX < $0080
!StatusBarGFX = "SMW/smb3_status_gfx.bin"	;only used if !GraphicExGFX < $0080
!StatusBarPAL = "SMW/smb3_status_pal.bin"



;this define allows you to move the IRQ up (or down) by the specified amount
;of scanlines. the default value (0) puts it at the same location as it is in
;All-Stars SMB3, though the top 3 pixels of the tilemap are cut off as a result.
;if you want to see the top 3 pixels of the status bar tilemap, set this to 3.
;DO NOT USE VALUES GREATER THAN 3 OR LESS THAN -6! they will glitch!
;note that the IRQ itself lasts for 2 scanlines (aka 2px thick black line)

!status_fblank = 0



;this define will offset the status bar's X position by the given amount
;pointless for most cases; only really useful if your status bar is off-center
;due to the way it's designed.

!x_off = 0



;SMB3 and SMW differ in which counters keep leading zeros and which replace them
;with spaces. the below defines are defaulted to SMB3 behavior
;0 = keep the leading zeroes
;anything else = replace leading zeroes with this tile # in GFX28/29

!ZERO_coins = $3F
!ZERO_lives = $3F
!ZERO_score = $3F
!ZERO_time = $3F
!ZERO_bonus = $3F



;SMW uses big numbers (8x16) for the bonus stars. these defines will allow you
;to use big numbers for any of the numeric counters
;0 = use small numbers (8x8)
;1 = use big numbers (8x16)
;the graphics for the small numbers start at x00, but the graphics for the
;big numbers can be changed; see further down

!SIZE_coins = 0
!SIZE_lives = 0
!SIZE_score = 0
!SIZE_time = 0
!SIZE_bonus = 1
!SIZE_yicoins = 0	;only if numeric yoshi coins are used, see further down

;start of tile #s for big numbers

!TILE_big_top = $15	;start of top tiles
!TILE_big_bottom = $10	;bottom. note that this is OFFSET from !TILE_big_top



;by default, Yoshi coins are displayed as a numeric value. changing this
;define to anything but 0 will let you display Yoshi coins as they were in SMW,
;with this value being the maximum displayed. this is meant for a custom
;status bar, as it will glitch with the default SMB3 status bar

!yicoins_max = 5

;regular Yoshi coin icon if non-numeric

!TILE_yicoins = $2F

;(for above) if you want Yoshi coins on the status bar to disappear when you
;collect them all, change this from 0 to the tile you want them replaced with
;note that the maximum # of yoshi coins displayed before they disappear
;will be !yicoins_max - 1

!ZERO_yicoins = $3F



;# of tiles the current player icon occupies (dont make it 0)

!SIZE_player = 5

;tile/properties for the current player. if the above define is > 1, then
;the additional tiles will be adjacent to this one (tilemap & GFX)

!player_1_TILE = $10
!player_1_PROP = $20
!player_2_TILE = $20
!player_2_PROP = $20



;location of counters in status bar. set them to a row, then add an offset
;
;if you want the counter disabled, set it equal to 0 instead of !rowx+whatever
;note that disabling a counter ONLY affects the display, NOT the functionality
;(and if you want it fully removed from the status bar, edit the tilemap file)
;
;note that if you use big numbers, then the amount of tiles is double whats listed
;here, as each number will be 2 tiles high. the location here is for the top tile,
;and the bottom tile will be put at location+$20. DO NOT PUT BIG NUMBERS ON THE BOTTOM
;ROW OF THE STATUS BAR

!row1 = !status_tile
!row2 = !status_tile+$20
!row3 = !status_tile+$40
!row4 = !status_tile+$60

!world		= 0		;1 tile
!pmeter		= 0		;depends on !LEN_pmeter
!pmeter_icon	= 0		;depends on !SIZE_pmeter
!coins		= !row2+$1C	;2 tiles
!bonus		= !row2+$0C	;2 tiles
!player		= !row2+$02	;depends on !SIZE_player
!lives		= !row3+$04	;2 tiles
!score		= !row3+$17	;6 tiles (final zero is not included)
!time		= !row3+$13	;3 tiles
!yicoins	= !row2+$08	;depends on !yicoins_max
!itembox	= !row2+$0F	;see below for more info


;this define handles how the item box is displayed
;0 means the item box will be disabled
;1 means the item box will be a sprite. its position is handled by !sprite0_YX below
;  and the tiles/properties will be pulled from the original ROM addresses
;  the !itembox define above will be unused
;2 means the item box will be an 8x8 layer 3 tile. !sprite0_YX and !sprite0_PT
;  will be free to use for a custom sprite tile. the item box position will be
;  handled by the !itembox define above as it's now treated as a regular counter.
;  the item box tiles and properties are handled below
;3 means the item box will be a 16x16 layer 3 image. similarly to setting 2,
;  !sprite0_YX and !sprite0_PT are free to use. likewise, the item box position is
;  handled by the !itembox define above, but similar to a 2-tile-high bonus star
;  counter in that !itembox has the top 2 tiles and !itembox+$20 has the bottom 2.
;  the tiles/properties themselves are handled below, though only the first tile (top-left)
;  is referenced; the other 3 tiles will follow this one, similar to the player icon.
;  (aka if top-left is $24, then top-right is $25, bottom-left $26, and bottom-right $27)
;  properties are the same for all 4 tiles
;  note that the blank tile is handled specially and thus can safely point to a single 8x8

!itemboxtype	= 1


;below are item box item tile/properties when !itemboxtype >= 2
;high byte = properties, low byte = tile

!itemboxblank		= $303F
!itemboxmushroom	= $3015
!itemboxflower		= $3419
!itemboxstar		= $3825
!itemboxfeather		= $3C29



;below are default values for the 5 sprites uploaded to the status bar
;YX = high byte Ypos, low byte Xpos
;PT = high byte properties (yxppccct), low byte tile #
;S = size (0=8x8, 1=16x16)

!sprite0_YX = $C778	;this is the item box position (if enabled above)
!sprite0_PT = $0000
!sprite0_S = %1
!sprite1_YX = $F000
!sprite1_PT = $0000
!sprite1_S = %1
!sprite2_YX = $F000
!sprite2_PT = $0000
!sprite2_S = %1
!sprite3_YX = $F000
!sprite3_PT = $0000
!sprite3_S = %1
!sprite4_YX = $F000
!sprite4_PT = $0000
!sprite4_S = %1



;below defines are for the P-Meter

;# of tiles the (P) icon occupies (dont make it 0)

!SIZE_pmeter = 2

;tile/properties for the (P) icon. if the above define is > 1, then
;the additional tiles will be adjacent to this one (tilemap & GFX)

!EmptyP_TILE = $0A
!EmptyP_PROP = $28
!FillP_TILE = $0C
!FillP_PROP = $20


;the length of the P-meter, AKA how many arrows there are
;(dont make this 0)

!LEN_pmeter = 6

;tile/properties for the arrows

!EmptyTri	= $0F		;Empty tile of triangle
!EmptyPal	= $28
!FillTri	= $0E		;Filled tile of triangle
!FillPal	= $20


!Sound = $01			;Sound effect to play when you are at full speed
!SoundBank = $1DFC|!addr	;Sound bank for above sound effect