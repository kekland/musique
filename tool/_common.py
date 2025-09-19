import subprocess
import shlex
import pathlib
import sys

root = pathlib.Path(__file__).parent.parent

def exec_cmd(cmd):
  try:
    subprocess.run(shlex.split(cmd), check=True, cwd=root)
  except subprocess.CalledProcessError as e:
    print(f'Error running command: {cmd}')
    print(e)
    raise
