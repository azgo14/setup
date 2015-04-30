#!/bin/bash

command_exists() {
  return hash $1 2>/dev/null
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
