#!/bin/bash -e

source bash_util.sh
shopt -s expand_aliases

if is_mac; then
  if ! command_exists greadlink; then
    brew install coreutils
  fi
  alias readlink=greadlink
fi

SETUP_DIR=$(dirname $(readlink -f $0))
cd "$SETUP_DIR"

HOMEDIR=$(readlink -f ~/)
SETUP_FLAG="$HOMEDIR/.setup_done"

if file_exists "$SETUP_FLAG"; then
  exit 0
fi

# Setup git
echo "Setting up git submodules..."
git submodule init
git submodule update

# Setup vimrc
echo "Setting up vimrc..."
OLD_VIMRC="$HOMEDIR/.vimrc"
if file_exists "$OLD_VIMRC"; then
  rm "$OLD_VIMRC"
fi

ln -s "$(readlink -f .vimrc)" "$HOMEDIR"

# Setup tmux
echo "Setting up tmux configuration..."
if file_exists ~/.tmux.conf; then
  rm ~/.tmux.conf
fi
ln -s "$SETUP_DIR/lib/tmux-config/.tmux.conf" ~/.tmux.conf

# Setup tmux config
echo "Setting up tmux config..."
if file_exists ~/.tmux.conf; then
  rm ~/.tmux.conf
fi
ln -s "$SETUP_DIR/.tmux.conf" ~/.tmux.conf

# Setup virtualenv
echo "Setting up virtualenv..."
if ! command_exists virtualenv; then
  pip install virtualenv
fi

VENV="$HOMEDIR/.venv"

if ! dir_exists "$VENV"; then
  cd "$HOMEDIR"
  virtualenv .venv
fi

# Bashrc changes
echo "export SETUP_DIR=$SETUP_DIR" >> ~/.bashrc
echo "source \$SETUP_DIR/.bash_andrew" >> ~/.bashrc

touch "$SETUP_FLAG"