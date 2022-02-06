import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), 'helpers/python'))
import helper_gui


def main():
	helper_gui.run_helper_gui(os.path.join(os.path.dirname(__file__), 'patches'), os.path.join(os.path.dirname(__file__), 'tools'))
	

if __name__ == '__main__':
	main()
