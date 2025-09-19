#!/usr/bin/env python3
from _common import exec_cmd, root
import shlex
import subprocess
import sys

def compile_darwin_objc_headers():
  classes_location = root / 'darwin' / 'Classes'
  output_file = root / 'build' / 'ffigen' / 'musique_darwin-Swift.h'
  ignored_files = []


  files = list(classes_location.glob('**/*.swift'))
  files = [file for file in files if file.name not in ignored_files]
  joined_files = ' '.join([file.as_posix() for file in files])

  p = subprocess.Popen(shlex.split(f'swiftc -c {joined_files} -module-name watchcrunch_native_video -emit-objc-header-path {output_file}'), cwd=classes_location.as_posix())
  p.wait()

  for file in classes_location.glob('**/*.o'):
    file.unlink()

def run_ffigen():
  exec_cmd('fvm dart run ffigen --config ffigen.yaml')

if __name__ == '__main__':
  compile_darwin_objc_headers()
  run_ffigen()
