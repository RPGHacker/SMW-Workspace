import tkinter
from tkinter import *
from tkinter import ttk, messagebox
import os
import glob
from importlib import abc
import importlib.util
import subprocess
import platform
from typing import Dict, List, cast
from types import ModuleType
import tempfile
from pathlib import Path
import stat
import shutil
import platformdirs
import pathlib
import configparser
import patching_utility


_config_dir_path = platformdirs.user_data_dir('Patch Manager', 'RPG Hacker')
_config_file_path = os.path.join(_config_dir_path, 'session.ini')

_config_section_main_name = 'Main'
_config_section_last_patch_name = 'Last Patch'
_config_key_last_patch_name = 'Last Patch'
_config_key_last_emulator_name = 'Last Emulator'

_default_start_command = 'xdg-open'
_default_start_is_shell_command = False

if platform.system() == 'Windows':
	_default_start_command = 'start'
	_default_start_is_shell_command = True


_sensible_terminal_path = os.path.normpath(os.path.join(os.path.dirname(__file__), '../shell/i3-sensible-terminal'))



class MainWindow(tkinter.Tk):
	class BetterComboBox(ttk.Combobox):
		def set(self, value):
			super(MainWindow.BetterComboBox, self).set(value)
			self.event_generate('<<ComboboxSelected>>')
			
		def current(self, newindex = None):
			ret_val = super(MainWindow.BetterComboBox, self).current(newindex)
			self.event_generate('<<ComboboxSelected>>')
			return ret_val

	def __init__(self, patches_path: str, tools_path: str) -> None:
		super().__init__()
		
		
		self._parse_tools(tools_path)
		self._parse_patches(patches_path)
		
		
		self.title('Patch Manager')
		self.geometry('500x400')
		
		self.rowconfigure(0, weight=1)
		self.columnconfigure(0, weight=1)
		
		
		self._patch_frame = ttk.LabelFrame(self, text='Patch')
		self._patch_frame.grid(column=0, row=0, sticky='news', padx=(10, 10), pady=(10, 5))
		
		self._patch_frame.rowconfigure(2, weight=1)
		self._patch_frame.columnconfigure(0, weight=1)
		
		self._patch_label = ttk.Label(self._patch_frame, text='Select patch:')
		self._patch_label.grid(column=0, row=0, sticky='w', padx=5, pady=5)
		
		self._patch_combo_box = MainWindow.BetterComboBox(self._patch_frame, state='readonly', values=self._patch_names)
		self._patch_combo_box.grid(column=0, row=1, sticky='ew', padx=5, pady=5)
		self._patch_combo_box.bind('<<ComboboxSelected>>', self._patch_combo_box_value_changed)
		
		self._browse_button = ttk.Button(self._patch_frame, text='Browse', command=self._browse_button_clicked)
		self._browse_button.grid(column=1, row=1, padx=5, pady=5)
		
		self._patch_button = ttk.Button(self._patch_frame, text='Create ROM', command=self._patch_button_clicked)
		self._patch_button.grid(column=2, row=1, padx=5, pady=5)
		
		
		self._options_outer_frame = ttk.LabelFrame(self._patch_frame, text='Options')
		self._options_outer_frame.grid(column=0, row=2, sticky='nesw', padx=5, pady=5, columnspan=3)
		
		self._options_middle_frame = tkinter.Frame(self._options_outer_frame, highlightbackground='#E0E0E0', highlightcolor='#E0E0E0', highlightthickness=1, bd=0)
		self._options_middle_frame.pack(side='left', fill='both', expand=True, padx=5, pady=5)
		
		self._options_canvas = tkinter.Canvas(self._options_middle_frame, borderwidth=0)
		
		self._options_inner_frame = ttk.Frame(self._options_canvas)
		self._options_inner_frame.columnconfigure(1, weight=1)
		self._options_inner_frame.bind("<Configure>", self._options_inner_frame_configure)
		
		self._options_scroll_bar = ttk.Scrollbar(self._options_middle_frame, orient='vertical', command=self._options_canvas.yview)
		self._options_canvas.configure(yscrollcommand=self._options_scroll_bar.set)

		self._options_scroll_bar.pack(side='right', fill='y')
		
		self._options_canvas.pack(side='left', fill='both', expand=True)
		self._options_canvas_frame = self._options_canvas.create_window((4,4), window=self._options_inner_frame, anchor='nw')
		self._options_canvas.bind("<Configure>", self._options_canvas_configure)
		
		self._current_option_widgets: Dict[str, List[tkinter.Widget]] = {}
		
		
		self._run_frame = ttk.LabelFrame(self, text='Run')
		self._run_frame.grid(column=0, row=1, sticky='ews', padx=(10, 10), pady=(5, 10))
		
		self._run_frame.rowconfigure(0, weight=1)
		self._run_frame.columnconfigure(0, weight=1)
		
		self._run_label = ttk.Label(self._run_frame, text='Select emulator:')
		self._run_label.grid(column=0, row=0, sticky='w', padx=5, pady=5)
		
		self._run_combo_box = MainWindow.BetterComboBox(self._run_frame, state='readonly', values=self._emulator_names)
		self._run_combo_box.grid(column=0, row=1, sticky='ew', padx=5, pady=5)
		self._run_combo_box.bind('<<ComboboxSelected>>', self._emulator_combo_box_value_changed)
		
		self._run_button = ttk.Button(self._run_frame, text='Run', command=self._run_button_clicked)
		self._run_button.grid(column=1, row=1, padx=5, pady=5)
		
		self._init_conifg_file()
		
		# Need to retrieve settings before updating combo boxes, because otherwise they'll get overwritten.
		last_patch: str = self._config_section_main.get(_config_key_last_patch_name, '')
		last_emulator: str = self._config_section_main.get(_config_key_last_emulator_name, '')
		
		# We only initialize combo boxes at the end. This is to assure that all dependent widgets already exist,
		# since changing some of those values will affect contents of other widgets.
		self._patch_combo_box.current(0)
		self._run_combo_box.current(0)
		
		if last_patch != '':
			for index, patch_name in enumerate(self._patch_names):
				if patch_name == last_patch:
					self._patch_combo_box.current(index)
					break
		
		if last_emulator != '':
			for index, emulator_name in enumerate(self._emulator_names):
				if emulator_name == last_emulator:
					self._run_combo_box.current(index)
					break
		
	def _init_conifg_file(self):
		pathlib.Path(_config_dir_path).mkdir(parents = True, exist_ok = True)

		self._config_parser = configparser.ConfigParser()
		self._config_parser.read(_config_file_path)
		if not self._config_parser.has_section(_config_section_main_name):
			self._config_parser.add_section(_config_section_main_name)
		if not self._config_parser.has_section(_config_section_last_patch_name):
			self._config_parser.add_section(_config_section_last_patch_name)
		
		self._config_section_main = self._config_parser[_config_section_main_name]
		self._config_section_last_patch = self._config_parser[_config_section_last_patch_name]
		
	
	def _update_config_file(self):
		with open(_config_file_path, 'w') as config_file:
			self._config_parser.write(config_file)
		
	def _patch_combo_box_value_changed(self, event):
		self._rebuild_options()
		self._config_section_main[_config_key_last_patch_name] = self._patch_combo_box.get()
		self._update_config_file()
		
	def _emulator_combo_box_value_changed(self, event):
		self._config_section_main[_config_key_last_emulator_name] = self._run_combo_box.get()
		self._update_config_file()
		
	def _options_inner_frame_configure(self, event):
		self._options_canvas.configure(scrollregion=self._options_canvas.bbox('all'))
		
	def _options_canvas_configure(self, event):
		self._options_canvas.itemconfig(self._options_canvas_frame, width = event.width)
		
	def _browse_button_clicked(self) -> None:
		subprocess_args = [ _default_start_command ]
	
		# Append patch path
		subprocess_args.append(os.path.abspath(os.path.dirname(self._patch_paths[self._patch_combo_box.get()])))
		
		print('Opening explorer window.\nCommand line:\n{command_line}'.format(command_line=patching_utility.format_command_line(subprocess_args)))
		subprocess.run(subprocess_args, shell=_default_start_is_shell_command)
		
	def _patch_button_clicked(self) -> None:
		# We already have the loaded patch modules, so we could just run the patcher function directly.
		# However, that would print any output in the GUI applications terminal window (or not at all).
		# Or we would have to implement our own simple terminal and capture output.
		# It's simpler to just relay the patching to another terminal application.
		subprocess_args: List[str] = []

		if platform.system() == 'Windows':
			subprocess_args.extend([ _default_start_command, 'cmd', '/K', 'python.exe' ])
		else:
			subprocess_args.extend([ 'python' ])
	
		# Append patch path
		subprocess_args.append(os.path.abspath(self._patch_paths[self._patch_combo_box.get()]))
		
		# Append any options
		for option_name, widgets in self._current_option_widgets.items():		
			subprocess_args.append(option_name)
			for widget in widgets:
				if isinstance(widget, MainWindow.BetterComboBox):
					subprocess_args.append(widget.get())
		
		print('Running patcher in separate terminal.\nCommand line:\n{command_line}'.format(command_line=patching_utility.format_command_line(subprocess_args)))

		if platform.system() == 'Windows':
			subprocess.run(subprocess_args, shell=_default_start_is_shell_command)
		else:
			# On Linux, there is no simple way of creating a new instance
			# of the default terminal. My solution here is to create a temp
			# .sh file and pass it to i3-sensible-terminal.
			with tempfile.NamedTemporaryFile(suffix='.sh', delete=False) as f:
				f.write(patching_utility.format_command_line(subprocess_args).encode('utf-8'))
				f.write(b'\nexec $SHELL')

				p = Path(f.name)
				p.chmod(p.stat().st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)

				sh_subprocess_args: List[str] = [ _sensible_terminal_path, '-e', 'bash', f.name ]

				print('Via helper process:\n{command_line}'.format(command_line=patching_utility.format_command_line(sh_subprocess_args)))

				subprocess.Popen(sh_subprocess_args)

		
	def _run_button_clicked(self) -> None:
		subprocess_args: List[str] = []

		if platform.system() == 'Windows':
			subprocess_args.extend([ _default_start_command ])
		else:
			subprocess_args.extend([ _sensible_terminal_path, '-e' ])
		
		# Build emulator command line
		emulator_args = [self._emulator_paths[self._run_combo_box.get()]]
		
		# Get options into a hash
		options = []
		for option_name, widgets in self._current_option_widgets.items():
			for widget in widgets:
				if isinstance(widget, MainWindow.BetterComboBox):
					options.append(option_name)
					options.append(widget.get())
		
		# Get full ROM path, using current options
		patch_config = self._patch_modules[self._patch_combo_box.get()].patch_config
		patcher = self._patch_modules[self._patch_combo_box.get()].patcher
		
		# We don't want the GUI to exit from failing to parse options, so we catch SystemExit.
		try:
			parsed_options = patcher.parse_options(options)
		except SystemExit:
			print('Failed to parse options for generating output ROM name.\nOptions:\n{command_line}'.format(command_line=patching_utility.format_command_line(options)))
			return
		
		rom_name: str = patcher.construct_output_rom_name(patch_config, parsed_options)
		rom_path: str = os.path.join(patch_config.output_dir, rom_name)
		
		if os.path.exists(rom_path):
			emulator_args.append(os.path.abspath(rom_path))

			emulator_args = patching_utility.turn_into_wine_command_line_if_needed(emulator_args)
			subprocess_args.extend(emulator_args)
			
			print('Starting ROM in emulator.\nCommand line:\n{command_line}'.format(command_line=patching_utility.format_command_line(subprocess_args)))
			subprocess.run(subprocess_args, shell=_default_start_is_shell_command)
		else:
			messagebox.showerror('Error', 'ROM not found:\n\n{rom}\n\nPlease make sure to create the ROM before attempting to start it in an emulator.'.format(rom=os.path.normpath(os.path.abspath(rom_path))))
		
	def _rebuild_options(self) -> None:
		for name, widgets in self._current_option_widgets.items():
			for widget in widgets:
				widget.destroy()
			
		self._current_option_widgets.clear()
		
		current_module = self._patch_modules[self._patch_combo_box.get()]
		
		for index, (option_name, values) in enumerate(current_module.patcher.get_option_values().items()):
			self._current_option_widgets[option_name] = []
			
			option_label = ttk.Label(self._options_inner_frame, text=option_name)
			option_label.grid(column=0, row=index, sticky='nw', padx=5, pady=5)
			
			self._current_option_widgets[option_name].append(option_label)
			
			option_combobox = MainWindow.BetterComboBox(self._options_inner_frame, state='readonly', values=values)
			option_combobox.grid(column=1, row=index, sticky='new', padx=5, pady=5)	
			
			self._current_option_widgets[option_name].append(option_combobox)
			
			last_value: str = self._config_section_last_patch.get(option_name, '')
			
			option_combobox.bind('<<ComboboxSelected>>', self._option_combo_box_value_changed)
			option_combobox.current(current_module.patcher.get_option_default_index(option_name))
			
			if last_value != '':
				for index, value_name in enumerate(values):
					if value_name == last_value:
						option_combobox.current(index)
						break						
		
	def _option_combo_box_value_changed(self, event):
		for option_name, widgets in self._current_option_widgets.items():
			combo_box = widgets[1]
			if combo_box == event.widget:
				self._config_section_last_patch[option_name] = combo_box.get()
				self._update_config_file()
				break
			
	def _parse_tools(self, tools_path: str) -> None:
		executables: List[str] = glob.glob(os.path.join(tools_path, '**/*.exe'), recursive = True)
		
		known_emulator_names: List[str] = ['bsnes', 'higan', 'snes9x', 'zsnes', 'zsnesw', 'lucia', 'ares', 'mesen', 'mesen-s', 'mesen-sx']

		self._emulator_paths: Dict[str, str] = {}
		self._emulator_names: List[str] = []

		for name in known_emulator_names:
			path: str = shutil.which(name)
			if path != None:
				list_name: str = 'native {name}'.format(name=name)
				self._emulator_paths[list_name] = path
				self._emulator_names.append(list_name)
		
		for executable in executables:
			if any([substring in os.path.basename(executable).lower() for substring in known_emulator_names]):
				emulator_name: str = os.path.relpath(executable, tools_path)
				self._emulator_paths[emulator_name] = executable
				self._emulator_names.append(emulator_name)
				
	def _parse_patches(self, patches_path: str) -> None:
		patch_configs = glob.glob(os.path.join(patches_path, '**/patch_config.py'), recursive = True)
		
		self._patch_modules: Dict[str, ModuleType] = {}
		self._patch_paths: Dict[str, str] = {}
		self._patch_names: List[str] = []
		
		for patch_no, patch_config_path in enumerate(patch_configs):
			# This code currently just assumes that that the .py file contains a valid module spec.
			# No error checking is done here.
			patch_config_spec = cast(importlib.machinery.ModuleSpec, importlib.util.spec_from_file_location('patch_config_{num}'.format(num=patch_no), patch_config_path))
			patch_config_module = importlib.util.module_from_spec(patch_config_spec)
			cast(importlib.abc.Loader, patch_config_spec.loader).exec_module(patch_config_module)
		
			patch_name: str = os.path.dirname(os.path.relpath(patch_config_path, patches_path))
			self._patch_modules[patch_name] = patch_config_module
			self._patch_paths[patch_name] = patch_config_path
			self._patch_names.append(patch_name)
				

def run_helper_gui(patches_path: str, tools_path: str) -> None:
	main_window = MainWindow(patches_path, tools_path)
	main_window.mainloop()
	
	
def main() -> None:
	run_helper_gui(os.path.join(os.path.dirname(__file__), '../../patches'), os.path.join(os.path.dirname(__file__), '../../tools'))
	

if __name__ == '__main__':
	main()
	