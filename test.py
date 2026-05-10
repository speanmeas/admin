import os
import re
import time

# from tqdm import tqdm


import subprocess

# subprocess.run(["xcopy", "build\\local", "..\\server\\service\\admin\\local", "/E", "/I", "/Y"], shell=True)
os.system("xcopy build\\local\\* ..\\server\\service\\admin\\local\\ /E /I /Y")
