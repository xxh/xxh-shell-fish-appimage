#!/usr/bin/env xonsh

import sys, argparse
from sys import exit
from shutil import which

parser = argparse.ArgumentParser(description='build')
parser.add_argument('-q', '--quiet', action='store_true', help=f"Quiet mode")
opt = parser.parse_args()

appimage_url = 'https://download.opensuse.org/repositories/shells:/fish:/nightly:/master/AppImage/fish-latest-x86_64.AppImage'

def eprint(*args, **kwargs):
    if not opt.quiet:
        print(*args, file=sys.stderr, **kwargs)

script_dir = pf"{__file__}".absolute().parent
build_dir = script_dir / 'build'
rm -rf @(build_dir)/
mkdir -p @(build_dir)

cp @(script_dir / 'entrypoint.sh') @(build_dir)/

cd @(build_dir)
appimage_name='fish'
if not p'fish'.is_file():
    arg_q = ['-q'] if opt.quiet else []
    arg_s = ['-s'] if opt.quiet else []
    arg_progress = [] if opt.quiet else ['--show-progress']
    eprint(f'Download fish AppImage from {appimage_url}')
    if which('wget'):
        r =![wget @(arg_q) @(arg_progress) @(appimage_url) -O @(appimage_name)]
        if r.returncode != 0:
            eprint(f'Error while download appimage using wget: {r}')
            exit(1)
    elif which('curl'):
        r =![curl @(arg_s) -L @(appimage_url) -o @(appimage_name)]
        if r.returncode != 0:
            eprint(f'Error while download appimage using curl: {r}')
            exit(1)
    else:
        eprint('Please install wget or curl and try again. Howto: https://duckduckgo.com/?q=how+to+install+wget+in+linux')
        exit(1)

    chmod +x @(appimage_name)
else:
    eprint(f'File {appimage_name} exists. Skip downloading')
