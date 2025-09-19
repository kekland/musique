#!/usr/bin/env python3
from _common import exec_cmd

cmd = f'fvm dart run build_runner build --delete-conflicting-outputs'
exec_cmd(cmd)
