@include
;GENERAL INFORMATION
;
;use !status_tile to reference the tilemap
;use !status_prop to reference the properties (or !status_tile+$80)
;use !status_palette to reference the palette
;use !status_OAM to reference the OAM
;
;!status_tile
;  $0C00-$0C1F = 1st row
;  $0C20-$0C3F = 2nd row
;  $0C40-$0C5F = 3rd row
;  $0C60-$0C7F = 4th row
;!status_prop (YXPCCCTT)
;  $0C80-$0C9F = 1st row
;  $0CA0-$0CBF = 2nd row
;  $0CC0-$0CDF = 3rd row
;  $0CE0-$0CFF = 4th row
;!status_palette (4 COLORS EACH)
;  $0D00-$0D07 = palette 0
;  $0D08-$0D0F = palette 1
;  $0D10-$0D17 = palette 2
;  $0D18-$0D1F = palette 3
;  $0D20-$0D27 = palette 4
;  $0D28-$0D2F = palette 5
;  $0D30-$0D37 = palette 6
;  $0D38-$0D3F = palette 7
;!status_oam
;  $0EFC-$0EFF = item box item, or extra sprite 0
;  $0F00-$0F03 = extra sprite 1
;  $0F04-$0F07 = extra sprite 2
;  $0F08-$0F0B = extra sprite 3
;  $0F0C-$0F0F = extra sprite 4
;  $0F10-$0F2F = high table (NOTE: STATUS BAR SPRITES ARE THE LAST 5 SPRITES)
;
;LIMITATIONS
;  the left 8 pixels of the status bar mask sprites; dont put any there
;  DMA channel 0 is used for layer 3 X/Y, so dont use DMA or HDMA on it



Counters:
PHB : PHK : PLB

;custom code goes here

PLB : RTL

;and any tables go here