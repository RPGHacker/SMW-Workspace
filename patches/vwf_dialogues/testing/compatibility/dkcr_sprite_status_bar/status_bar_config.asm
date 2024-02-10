@includefrom status_bar.asm

        ; ###################################################
        ; #                                                 #
        ; #  DKCR styled sprite status bar - configuration  #
        ; #                                                 #
        ; ###################################################

        ; do not patch this file to your ROM! patch status_bar.asm instead.





        ; options

        ; how long to show counters (frames)
        !CounterShowTime        = $C0

        ; how fast to slide counters in (pixels per frame; decimal)
        ; (this is only used when !AppearInstantly is set to 0)
        ; (ridiculous values like -1, 0 or 255 may behave weirdly)
        !CounterSpeedIn         = 3

        ; how fast to slide counters out (pixels per frame; decimal)
        ; (this is only used when !DisappearInstantly is set to 0)
        ; (ridiculous values like -1, 0 or 255 may behave weirdly)
        !CounterSpeedOut        = 2

        ; make counters appear instantly instead of sliding in?
        ; (1 = yes, 0 = no)
        !AppearInstantly        = 0

        ; make counters disappear instantly instead of sliding out?
        ; (1 = yes, 0 = no)
        !DisappearInstantly     = 0

        ; show all counters at the start of a level?
        ; (1 = yes, 0 = no)
        !ShowAtStart            = 1

        ; show all counters when the game is paused?
        ; (1 = yes, 0 = no)
        !ShowWhenPaused         = 1

        ; show all counters when the player gets a midway point?
        ; (1 = yes, 0 = no)
        !ShowAtMidwayPoint      = 1

        ; show all counters when the player beats the level?
        ; (1 = yes, 0 = no)
        !ShowAtGoal             = 1

        ; show all counters when the player is idle for a while?
        ; (1 = yes, 0 = no)
        !ShowWhenIdle           = 1

        ; how long the player has to stay idle for the counters to appear
        ; (multiplied by 2, so $FF actually means $1FE frames)
        ; (this is only used when !ShowWhenIdle is set to 1)
        ; (see below for the corresponding RAM address define)
        !IdleTime               = $FF

        ; show the status bar on the title screen?
        ; (1 = yes, 0 = no)
        !ShowOnTitleScreen      = 0

        ; show the status bar in the intro level?
        ; (1 = yes, 0 = no)
        !ShowInIntroLevel       = 0

        ; how many coins are needed for a 1-up
        ; (decimal; values greater than 100 may glitch)
        !CoinsFor1Up            = 100

        ; maximum amount of lives
        ; (decimal; values greater than 99 may glitch)
        !MaxLives               = 99

        ; if you use VFW dialogues, set this to 1.
		!UseVWFDialogues = 0

        ; VWF state address
        ; (you can ignore this if you're not using the VWF dialogues patch)
        ; (keep this value the same as that of !varram in the VWF patch)
        !VWFState               = $702000





        ; tilemap definitions (GFX00/01)

        !FrameTile1             = $0A
        !FrameTile2             = $20
        !PlayerHeadTile         = $66
        !CoinTile               = $E8
        !YoshiCoinTile          = $4A
        !MushroomTile           = $24
        !FlowerTile             = $26
        !StarTile               = $48
        !CapeTile               = $0E

        !Digit0                 = $23
        !Digit1                 = $33
        !Digit2                 = $44
        !Digit3                 = $45
        !Digit4                 = $46
        !Digit5                 = $47
        !Digit6                 = $54
        !Digit7                 = $55
        !Digit8                 = $7E
        !Digit9                 = $7F





        ; RAM address definitions

        ; there's no need to change them since they were used by the
        ; old status bar which is obsolete now, but you can if you want.

        ; using this configuration, all RAM addresses from $0F0B-$0F5D
        ; are free to use for whatever you want! (cleared on level load)

        !LivesCounterTimer      = $0EF9|!base
        !CoinCounterTimer       = $0EFA|!base
        !YoshiCoinCounterTimer  = $0EFB|!base

        !LivesCounterState      = $0EFC|!base
        !CoinCounterState       = $0EFD|!base
        !YoshiCoinCounterState  = $0EFE|!base
        !ReserveItemState       = $0EFF|!base

        !LivesCounterXPos       = $0F00|!base
        !CoinCounterXPos        = $0F01|!base
        !YoshiCoinCounterXPos   = $0F02|!base
        !LivesCounterYPos       = $0F03|!base
        !CoinCounterYPos        = $0F04|!base
        !YoshiCoinCounterYPos   = $0F05|!base
        !ReserveItemYPos        = $0F06|!base

        !Slot1Occupied          = $0F07|!base
        !Slot2Occupied          = $0F08|!base

        !DisableStatusBar       = $0F09|!base

        !IdleTimer              = $0F0A|!base   ; this is only used when !ShowWhenIdle is set to 1
