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
if [[ ! -f .entrypoint-check-done ]]; then
  check_result=`./fish --version 2>&1`
  if [[ $check_result != *"version"* ]]; then
    # TODO: Extract AppImage if FUSE is unsupported
    #./fish --appimage-extract > /dev/null
    #mv squashfs-root fish-squashfs
    #mv fish fish-disabled
    #ln -s ./fish-squashfs/usr/bin/fish fish
    echo "Something went wrong:"
    echo $check_result
  else
    echo $check_result > .entrypoint-check-done
  fi
fi

./fish # TODO: $EXECUTE_FILE $EXECUTE_COMMAND $VERBOSE
