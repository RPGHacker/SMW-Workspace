these patches will give you a minimalist black (by default) status bar, perfect for
solving layer 3 cutoff, or just looking c00l and out-of-bounds (on a CRT)

use asar to patch ONE. you can patch them over each other, just know that they wont stack.

status_top.asm will put the status bar at the top of the screen, like in smw
status_bottom.asm will put the status bar at the bottom of the screen, like in smb3
status_double.asm will put a status bar at the top and a different one at the bottom

top and bottom do not have space for the score, but double does.

all of them will act funky or crash with smw's bosses, so use saner bosses.

BIG FAT NOTE: you can NOT use the status bar editor to edit the status bars. you'll
have to dig into the patches. just ctrl+f for:

StatusTiles (32 tiles, 64 for top version)
StatusProps (32 properties, 64 for top version)
StatusPal (16-color palette)

they should all be located after one another

to move counters, edit the defines at the top.


credit to Roy for the original black status bar idea/patch, i just recoded+expanded.


if you're having trouble patching or something, commit sudoku. then ask for help on SMWC.


- Ladida