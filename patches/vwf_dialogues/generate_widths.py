import argparse
import os
import sys

# In Python 2, a bytes is really just a str, so to get the value of one we need to use ord
if sys.version_info[0] == 2:
    byte_val = ord
    input = raw_input
else:
    byte_val = lambda x: x

def single_tile_width(tile):
    # tile is bytes of length 16
    highest_width = 0
    # There's 8 rows in a tile
    for row in range(8):
        # There's 2 bitplanes for each row, but we don't really care
        # which plane the bit was set in, only that it was set
        # To ignore color 1 in width-counting, skip counting the 2nd bitplane
        for plane in range(2):
            byte = byte_val(tile[row*2+plane])
            for bit in range(8):
                if byte & (1 << bit):
                    width = 8 - bit
                    highest_width = max(highest_width, width)
                    # we iterate from most important bit to least so
                    # no point checking on after we found a set bit
                    break
    return highest_width

def calc_width(char):
    # char is bytes of len 64
    # the arrangement of 8x8 tiles to 16x16 is:
    # top left, bottom left, top right, bottom right
    left_width = max(single_tile_width(char[0:16]),single_tile_width(char[16:32]))
    right_width = max(single_tile_width(char[32:48]),single_tile_width(char[48:64]))
    if right_width > 0:
        return right_width + 8
    return left_width

def calc_all_widths(file):
    tile_widths = []
    for x in range(0, len(file), 64):
        if x + 64 > len(file):
            print("Warning: An incomplete tile was not parsed.")
            break
        tile_widths.append(calc_width(file[x:x+64]))
    return tile_widths

def format_as_table(widths, fname):
    out = "; Automatically-generated character widths table for " + fname + "\n\n"
    for row_start in range(0, len(widths), 16):
        out += "; Characters %02X to %02X\n" % (row_start, row_start+15)
        out += "db " + ",".join(["$%02X" % x for x in widths[row_start:row_start+16]]) + "\n"
    return out

def format_fixed_table(width, fname):
    out = "; Automatically-generated character widths table for " + fname + "\n"
    out += "!wd = $%02X\n\n" % width
    for row_start in range(0, 256, 16):
        out += "; Characters %02X to %02X\n" % (row_start, row_start+15)
        out += "db " + ",".join(["!wd"] * 16) + "\n"
    return out

def main():
    parser = argparse.ArgumentParser(description="Generate a width table for a given VWF font file.",
                                     epilog="For fixed width fonts, the widest character is used as the width.")
    parser.add_argument("file", help="Source font file (.bin, 2bpp GB graphics)")
    parser.add_argument("-f", "--fixed", help="Generate a fixed width table", action="store_true")
    args = parser.parse_args()
    with open(args.file, 'rb') as f:
        font_data = f.read()
    widths = calc_all_widths(font_data)
    if args.fixed:
        # For a fixed width table, use the widest character as the width
        tbl = format_fixed_table(max(widths), os.path.basename(args.file))
    else:
        tbl = format_as_table(widths, os.path.basename(args.file))
    if args.file.endswith(".bin"):
        outfilename = args.file[:-4] + ".asm"
    else:
        outfilename = args.file + ".asm"
    if os.path.exists(outfilename):
        if not input("Output file already exists! Overwrite? [y/N] ").lower().startswith("y"):
            return
    with open(outfilename, 'w') as f:
        f.write(tbl)

if __name__ == '__main__':
    main()
