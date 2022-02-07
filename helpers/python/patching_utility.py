import argparse
import os
import shutil
import subprocess
import re
import pathlib
import dataclasses
from dataclasses import dataclass
from typing import List, Dict, Optional, cast, Match, Pattern


_asar_paths: Dict[str, str] = {
	'1.81': os.path.join(os.path.dirname(__file__), '../../tools/asar181/asar.exe'),
	'1.9': os.path.join(os.path.dirname(__file__), '../../tools/asar19/asar.exe'),
	'2.0': os.path.join(os.path.dirname(__file__), '../../tools/asar20/asar.exe'),
}

_clean_rom_path: str = os.path.join(os.path.dirname(__file__), '../../baserom')


rom_extension: str = '.smc'



@dataclass
class ActionOutput:
	output_symbols_path: Optional[str] = None
	
	
@dataclass
class Action:
	def run(self, patch_config: 'PatchConfig', options: argparse.Namespace, output_rom_path: str) -> ActionOutput:
		raise NotImplementedError()
	
	
@dataclass
class PatchConfig:
	module_path: dataclasses.InitVar[str]
	output_dir: str = ''
	rom_base_name: str = ''
	actions: List[Action] = dataclasses.field(default_factory=lambda: [])
	
	# Pass in the directory of the calling patch_config.py module here.
	# This is only used to initialize some variables with reasonable defaults.
	def __post_init__(self, module_path: str) -> None:
		self.output_dir = os.path.join(module_path, 'builds')	
		self.rom_base_name = os.path.basename(os.path.abspath(module_path))
		

@dataclass
class Patch(Action):
	path: str
	include_paths: List[str]
	defines: List[str]
	
	def run(self, patch_config: PatchConfig, options: argparse.Namespace, output_rom_path: str) -> ActionOutput:
		output = ActionOutput()		
		
		patch_symbols_path: str = os.path.join(patch_config.output_dir, os.path.basename(self.path) + '.cpu.sym')
		
		command_line: List[str] = [os.path.normpath(_asar_paths[options.asar_ver])]
		
		for include_path in self.include_paths:
			command_line.append('-I{path}'.format(path=os.path.normpath(include_path)))
			
		for define in self.defines:
			command_line.append('-D{define}'.format(define=define))
			
		command_line.append('--symbols=wla')
			
		command_line.append('--symbols-path={path}'.format(path=os.path.normpath(patch_symbols_path)))
			
		command_line.append(os.path.normpath(self.path))
		
		command_line.append(os.path.normpath(output_rom_path))
		
		print('')
		print('Patching: \n{command_line}'.format(command_line=' '.join(f'"{arg}"' if ' ' in arg else f'{arg}' for arg in command_line)))
				
		print('')			
		print('Output:')
		
		ret_val = subprocess.run(command_line)
		
		print('')
		
		if ret_val.returncode != 0:
			raise RuntimeError("Patching failed! Please check Asar's error output above.")
			
		output.output_symbols_path = patch_symbols_path
		
		return output

	
class PatchingUtility:
	def __init__(self) -> None:
		self._parser = argparse.ArgumentParser(description='Applies this patch and all dependencies to a clean SMW ROM to create a patched output ROM.')
		
		self._option_values: Dict[str, List[str]] = {}
		self._option_default_indices: Dict[str, int] = {}
		
		self.add_option('--asar_ver', values=['1.81', '1.9', '2.0'], default_index=1)
		self.add_option('--rom_type', values=['normal', 'sa-1'], default_index=0)
		self.add_option('--rom_size', values=['1mb', '2mb', '3mb', '4mb', '6mb', '8mb'], default_index=1)
		
	def add_option(self, name: str, values: List[str], default_index: int = 0) -> None:
		self._option_values[name] = values
		self._option_default_indices[name] = default_index
		self._parser.add_argument(name, choices=values, default=values[default_index])
		
	def get_option_values(self) -> Dict[str, List[str]]:
		return self._option_values
		
	def get_option_default_value(self, name: str) -> int:
		return self._option_default_indices[name]
		
	def parse_options(self, args: List[str] = None, exit_on_error: bool = True) -> argparse.Namespace:
		options = self._parser.parse_args(args)
		
		if options.rom_type == 'normal' and options.rom_size not in ['1mb', '2mb', '3mb', '4mb']:
			raise ValueError('Non-SA-1 ROMs only support sizes up to 4 MB.')
		elif options.rom_type == 'sa-1' and options.rom_size == '1mb':
			raise ValueError('SA-1 ROMs require a size of a at least 2 MB.')
		
		return options
		
	def construct_output_file_name(self, patch_config: PatchConfig, options: argparse.Namespace, ext: Optional[str] = None) -> str:
		rom_name: str = patch_config.rom_base_name
		
		string_options = vars(options)
		
		for option_name, value in string_options.items():
			rom_name += '_{sanitized_value}'.format(sanitized_value=re.sub(r"[^a-zA-Z0-9_]", '', value))
			
		if ext != None:
			ext = cast(str, ext)
			if ext[0] != '.':
				rom_name += '.'
			rom_name += ext
			
		return rom_name
		
	def construct_output_rom_name(self, patch_config: PatchConfig, options: argparse.Namespace) -> str:
		return self.construct_output_file_name(patch_config, options, rom_extension)
		
	def get_base_rom_path(self, options):
		rom_name: str = 'lm' + options.rom_size
		
		if options.rom_type == 'sa-1':
			rom_name += '_sa1'
			
		rom_name += '.smc'
		
		return os.path.join(_clean_rom_path, rom_name)
		
	def apply_patches(self, patch_config: PatchConfig, options: argparse.Namespace) -> None:
		pathlib.Path(patch_config.output_dir).mkdir(parents = True, exist_ok = True)
	
		rom_name: str = self.construct_output_file_name(patch_config, options)
		
		base_rom_path: str = self.get_base_rom_path(options)
		output_rom_path: str = os.path.join(patch_config.output_dir, rom_name + rom_extension)
		output_symbols_path: str = os.path.join(patch_config.output_dir, rom_name + '.cpu.sym')
		output_sa1_symbols_path: str = os.path.join(patch_config.output_dir, rom_name + '.sa1.sym')
		
		symbols_output: Dict[str, List[str]] = {}				
		source_file_base_id: int = 0
		
		shutil.copyfile(base_rom_path, output_rom_path)
	
		for action in patch_config.actions:			
			output = action.run(patch_config, options, output_rom_path)
			
			# Do some processing on symbol files, so that we can merge outputs of symbol files further below
			# and also so that we can get rid of stuff we don't really want.
			if output.output_symbols_path != None:
				output.output_symbols_path = cast(str, output.output_symbols_path)
				with open(output.output_symbols_path) as symbols_file:
					group_re: Pattern[str] = re.compile(r"^\s*\[([^\]]+)\]\s*$")
					label_re: Pattern[str] = re.compile(r"^\s*([0-9a-fA-F]{2})\:([0-9a-fA-F]{4})\s+(\S+)\s*$")
					source_file_re: Pattern[str] = re.compile(r"^\s*([0-9a-fA-F]{4})\s+([0-9a-fA-F]{8})\s+(\S+)\s*$")
					addr_to_line_re: Pattern[str] = re.compile(r"^\s*([0-9a-fA-F]{2})\:([0-9a-fA-F]{4})\s+([0-9a-fA-F]{4})\:([0-9a-fA-F]{8})\s*$")
					
					parsing_labels: bool = False
					parsing_source_files: bool = False
					parsing_add_to_line: bool = False
					current_group: Optional[str] = None
					
					num_source_files_in_symbols_file: int = 0
					
					for line in symbols_file:
						group_match: Optional[Match[str]] = group_re.match(line)
						
						if group_match:
							current_group = group_match.group(1)
							parsing_labels = (current_group == 'labels')
							parsing_source_files = (current_group == 'source files')
							parsing_add_to_line = (current_group == 'addr-to-line mapping')
						elif current_group:
							reject_line: bool = False
							
							if parsing_labels:
								label_match: Optional[Match[str]] = label_re.match(line)
								if label_match:
									# RPG Hacker: Reject labels in the range 00:0000 to 00:7FFF.
									# We occasionally use labels as enums or constants, which will usually be in that range,
									# but it's very annoying in the debugger when it applies these mappings to stuff like "lda $00".
									reject_line = (int(label_match.group(1), 16) == 0x00 and int(label_match.group(2), 16) < 0x8000)
									# We also prefix label names with the patch name. Not only because multiple patches might use identical names,
									# but also because pos/neg labels in particular would conflict between them.
									line = '{bank}:{address} {prefix}.{label}'.format(bank=label_match.group(1), address=label_match.group(2), prefix=os.path.basename(output.output_symbols_path), label=label_match.group(3))
									
							if parsing_source_files:
								source_file_match: Optional[Match[str]] = source_file_re.match(line)
								if source_file_match:
									new_file_id = int(source_file_match.group(1), 16) + source_file_base_id
									line = '{file_id:04x} {checksum} {path}'.format(file_id=new_file_id, checksum=source_file_match.group(2), path=source_file_match.group(3))
									num_source_files_in_symbols_file += 1
								
							if parsing_add_to_line:
								addr_to_line_match: Optional[Match[str]] = addr_to_line_re.match(line)
								if addr_to_line_match:
									new_file_id = int(addr_to_line_match.group(3), 16) + source_file_base_id
									line = '{snes_bank}:{snes_address} {source_bank:04x}:{source_address}'.format(snes_bank=addr_to_line_match.group(1), snes_address=addr_to_line_match.group(2), source_bank=new_file_id, source_address=addr_to_line_match.group(4))
							
							# Reject lines that are only whitespace.
							reject_line = reject_line or (re.search(r"^\s*$", line) != None)
								
							if not reject_line:
								symbols_output.setdefault(current_group, []).append(line.strip())
					
				os.remove(output.output_symbols_path)
							
			source_file_base_id += num_source_files_in_symbols_file
		
		# Output new merged symbols file.
		with open(output_symbols_path, 'w') as symbols_file:
			for group_name, lines in symbols_output.items():
				symbols_file.write('[{group_name}]\n'.format(group_name=group_name))
				
				if group_name == 'rom checksum':
					# We only write the last line for the ROM checksum group, since a ROM can't have multiple checksums,
					# and the last checksum is likely to be the most up-to-date one.
					symbols_file.write('{line}\n'.format(line=lines[-1]))
				else:
					for line in lines:
						symbols_file.write('{line}\n'.format(line=line))
						
				symbols_file.write('\n')				
			
		if options.rom_type == 'sa-1':
			shutil.copyfile(output_symbols_path, output_sa1_symbols_path)
				
		print("All patches applied successfully!")
		