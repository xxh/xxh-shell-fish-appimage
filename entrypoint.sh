#!/bin/bash

#while getopts f:c:v: option
#do
#case "${option}"
#in
#f) EXECUTE_FILE=${OPTARG};;
#c) EXECUTE_COMMAND=${OPTARG};;
#v) VERBOSE=${OPTARG};;
#esac
#done

CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $CURRENT_DIR

# Check FUSE support
check_result=`./fish --version 2>&1`
if [[ ! -f .fish-check-done ]]; then
  if [[ $check_result == *"FUSE"* ]]; then
    # TODO: Extract AppImage if FUSE is unsupported
    #./fish --appimage-extract > /dev/null
    #mv squashfs-root fish-squashfs
    #mv fish fish-disabled
    #ln -s ./fish-squashfs/usr/bin/fish fish
    echo "AppImage is unsupported on host"
  fi
  echo $check_result > .fish-check-done
fi

./fish # TODO: $EXECUTE_FILE $EXECUTE_COMMAND $VERBOSE
