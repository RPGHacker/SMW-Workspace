import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), 'helpers/python'))
import helper_gui

helper_gui.run_helper_gui(os.path.join(os.path.dirname(__file__), 'patches'), os.path.join(os.path.dirname(__file__), 'tools'))
