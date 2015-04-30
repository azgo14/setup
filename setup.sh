#!/bin/bash -e

source bash_util.sh

SETUP_DIR=$(dirname $(readlink -f $0))
cd $SETUP_DIR

HOMEDIR=`readlink -f ~/`
SETUP_FLAG=$HOMEDIR/.setup_done

if file_exists $SETUP_FLAG ; then
  exit 0
fi

# setup vimrc
OLD_VIMRC=$HOMEDIR/.vimrc
if file_exists $OLD_VIMRC ; then
  rm $OLD_VIMRC
fi

ln -s `readlink -f .vimrc` $HOMEDIR

# setup virtualenv
if ! command_exists virtualenv ; then
  pip install virtualenv
fi


VENV=$HOMEDIR/.venv

if ! dir_exists $VENV ; then
  cd $HOMEDIR
  virtualenv .venv
fi

echo "source $SETUP_DIR/.bash_andrew" >> ~/.bashrc

touch $SETUP_FLAG

