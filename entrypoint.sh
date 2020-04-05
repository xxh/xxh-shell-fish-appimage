#!/bin/bash

#
# Support arguments (this recommend but not required):
#   -f <file>               Execute file on host, print the result and exit
#   -c <command>            [Not recommended to use] Execute command on host, print the result and exit
#   -C <command in base64>  Execute command on host, print the result and exit
#   -v <level>              Verbose mode: 1 - verbose, 2 - super verbose
#   -e <NAME=B64> -e ...    Environement variables (B64 is base64 encoded string)
#   -b <BASE64> -b ...      Base64 encoded bash command
#   -H <HOME path>          HOME path. Will be $HOME on the host.
#   -X <XDG path>           XDG_* path (https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
#

while getopts f:c:C:v:e:b:H:X: option
do
case "${option}"
in
f) EXECUTE_FILE=${OPTARG};;
c) EXECUTE_COMMAND=${OPTARG};;
C) EXECUTE_COMMAND_B64=${OPTARG};;
v) VERBOSE=${OPTARG};;
e) ENV+=("$OPTARG");;
b) EBASH+=("$OPTARG");;
H) HOMEPATH=${OPTARG};;
X) XDGPATH=${OPTARG};;
esac
done

if [[ $VERBOSE != '' ]]; then
  export XXH_VERBOSE=$VERBOSE
fi

for eb in "${EBASH[@]}"; do
  bash_command=`echo $eb | base64 -d`

  if [[ $XXH_VERBOSE == '1' || $XXH_VERBOSE == '2' ]]; then
    echo Entrypoint bash execute: $bash_command
  fi
  eval $bash_command
done

if [[ $EXECUTE_COMMAND_B64 ]]; then
  EXECUTE_COMMAND=`echo $EXECUTE_COMMAND_B64 | base64 -d`
  if [[ $XXH_VERBOSE == '1' || $XXH_VERBOSE == '2' ]]; then
    echo Execute command base64: $EXECUTE_COMMAND_B64
    echo Execute command: $EXECUTE_COMMAND
  fi

  EXECUTE_COMMAND=(-c "${EXECUTE_COMMAND}")
fi

CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $CURRENT_DIR

export XXH_HOME=`readlink -f $CURRENT_DIR/../../../..`

if [[ $HOMEPATH != '' ]]; then
  homerealpath=`readlink -f $HOMEPATH`
  if [[ -d $homerealpath ]]; then
    export HOME=$homerealpath
  else
    echo "Home path not found: $homerealpath"
    echo "Set HOME to $XXH_HOME"
    export HOME=$XXH_HOME
  fi
else
  export HOME=$XXH_HOME
fi

if [[ $XDGPATH != '' ]]; then
  xdgrealpath=`readlink -f $XDGPATH`
  if [[ ! -d $xdgrealpath ]]; then
    echo "XDG path not found: $xdgrealpath"
    echo "Set XDG path to $XXH_HOME"
    export XDGPATH=$XXH_HOME
  fi
else
  export XDGPATH=$XXH_HOME
fi

export XDG_CONFIG_HOME=$XDGPATH/.config
export XDG_DATA_HOME=$XDGPATH/.local/share
export XDG_CACHE_HOME=$XDGPATH/.cache

# Check FUSE support
if [[ ! -f .entrypoint-check-done ]]; then
  check_result=`./fish --version 2>&1`
  if [[ $check_result != *"version"* ]]; then
    if ! command -v fusermount >/dev/null 2>&1 ; then
      if [[ $XXH_VERBOSE == '1' || $XXH_VERBOSE == '2' ]]; then
        echo "Extracting fish AppImage."
      fi

      ./fish --appimage-extract > /dev/null
      mv squashfs-root fish-squashfs
      mv fish fish-disabled
      ln -s ./fish-squashfs/usr/bin/fish fish
    fi
  fi
  echo $check_result > .entrypoint-check-done
fi

if [[ -d $XXH_HOME/.xxh/shells/xxh-shell-fish-appimage/build/fish-squashfs ]]; then
  export LD_LIBRARY_PATH=$XXH_HOME/.xxh/shells/xxh-shell-fish-appimage/build/fish-squashfs/lib64:$XXH_HOME/.xxh/shells/xxh-shell-fish-appimage/build/fish-squashfs/usr/lib64:$LD_LIBRARY_PATH
  if [[ $XXH_VERBOSE == '2' ]]; then
    echo "Added fish AppImage libs to LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
  fi
fi

for pluginrc_file in $(find $CURRENT_DIR/../../../plugins/xxh-plugin-*/build -type f -name '*pluginrc_prerun.sh' -printf '%f\t%p\n' 2>/dev/null | sort -k1 | cut -f2); do
  if [[ -f $pluginrc_file ]]; then
    if [[ $XXH_VERBOSE == '1' ]]; then
      echo Load plugin $pluginrc_file
    fi
    #cd $(dirname $pluginrc_file)
    source $pluginrc_file
  fi
done

./fish "${EXECUTE_COMMAND[@]}"  # TODO: $EXECUTE_FILE
