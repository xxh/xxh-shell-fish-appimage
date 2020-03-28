#!/bin/bash

while getopts f:c:C:v:e:b: option
do
case "${option}"
in
f) EXECUTE_FILE=${OPTARG};;
c) EXECUTE_COMMAND=${OPTARG};;
C) EXECUTE_COMMAND_B64=${OPTARG};;
v) VERBOSE=${OPTARG};;
e) ENV+=("$OPTARG");;
b) EBASH+=("$OPTARG");;
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
export XDG_CONFIG_HOME=$XXH_HOME/.config

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

if [[ -d $XXH_HOME/xxh/shells/xxh-shell-fish-appimage/build/fish-squashfs ]]; then
  export LD_LIBRARY_PATH=$XXH_HOME/xxh/shells/xxh-shell-fish-appimage/build/fish-squashfs/lib64:$XXH_HOME/xxh/shells/xxh-shell-fish-appimage/build/fish-squashfs/usr/lib64:$LD_LIBRARY_PATH
  if [[ $XXH_VERBOSE == '2' ]]; then
    echo "Added fish AppImage libs to LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
  fi
fi

./fish "${EXECUTE_COMMAND[@]}"  # TODO: $EXECUTE_FILE
