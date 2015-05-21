#!/bin/bash

command_exists() {
  if type $1 >/dev/null 2>&1 ; then
    return 0
  else
    return 1
  fi
}

dir_exists() {
  if [ -d $1 ]; then
    return 0
  else
    return 1
  fi
}

file_exists() {
  if [ -f $1 ]; then
    return 0
  else
    return 1
  fi
}

is_mac() {
  if [ "$(uname)" == "Darwin" ]; then
    return 0
  else
    return 1
  fi
}
