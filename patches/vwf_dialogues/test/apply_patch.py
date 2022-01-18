import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../../../helpers/python'))

from patching_utility import *


patcher = PatchingUtility()

patcher.add_option('--bit_mode', values=['8-bit', '16-bit'], default='8-bit')

options = patcher.parse_options()

	
patches = [
	PatchingUtility.Patch(
		os.path.join(os.path.dirname(__file__), '../vwf_dialogues.asm'),
		include_paths = [
			os.path.join(os.path.dirname(__file__), '../builds/tests'),
			os.path.join(os.path.dirname(__file__), '../..'),
		],
		defines = [],
	),
	PatchingUtility.Patch(
		os.path.join(os.path.dirname(__file__), 'uberasm/asar_patch.asm'),
		include_paths = [
			os.path.join(os.path.dirname(__file__), '../code/external'),
		],
		defines = [],
	),
]

rom_name = 'vwf_dialogues'

if options.bit_mode == '16-bit':
	patches[0].defines.append('bitmode=BitMode.16Bit')
	rom_name += '_16bit'


patcher.apply_patches(os.path.dirname(__file__), rom_name, patches, options)