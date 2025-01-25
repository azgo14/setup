#!/usr/bin/env bash
set -euo pipefail

#--------------------------------------------------#
# Sourcing your existing utility functions, etc.    #
#--------------------------------------------------#
source bash_util.sh
shopt -s expand_aliases

#--------------------------------------------------#
# macOS vs. Linux "readlink" / "coreutils" handling #
#--------------------------------------------------#
if is_mac; then
  if ! command_exists greadlink; then
    echo "Installing coreutils (for greadlink)..."
    brew install coreutils
  fi
  alias readlink=greadlink
else
  if ! command_exists readlink; then
    echo "Installing coreutils..."
    if command_exists apt-get; then
      sudo apt-get update
      sudo apt-get install -y coreutils
    elif command_exists yum; then
      sudo yum install -y coreutils
    else
      echo "No recognized package manager found to install coreutils. Please install manually."
      exit 1
    fi
  fi
fi

#--------------------------------------------------#
# Helper function: install_package                  #
#--------------------------------------------------#
install_package() {
  local pkg="$1"
  if is_mac; then
    if ! command_exists brew; then
      echo "Homebrew not found. Installing now..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo "Installing $pkg via Homebrew..."
    brew install "$pkg"
  else
    if command_exists apt-get; then
      sudo apt-get update
      sudo apt-get install -y "$pkg"
    elif command_exists yum; then
      sudo yum install -y "$pkg"
    else
      echo "No recognized package manager found to install $pkg. Please install manually."
      exit 1
    fi
  fi
}

#--------------------------------------------------#
# Dependency checks: git, python3, virtualenv, etc. #
#--------------------------------------------------#

# 1. Git
if ! command_exists git; then
  install_package git
fi

# 2. Python3
if ! command_exists python3; then
  install_package python3
fi

# 3. Virtualenv (handle macOS vs. Linux carefully to avoid PEP 668 errors)
if ! command_exists virtualenv; then
  if is_mac; then
    # Prefer brew or pipx for virtualenv on macOS
    if ! command_exists pipx; then
      echo "Installing pipx..."
      brew install pipx
      # pipx typically installs scripts into ~/.local/bin or similar
      export PATH="$HOME/.local/bin:$PATH"
    fi
    echo "Installing virtualenv via pipx..."
    pipx install virtualenv --force
    pipx ensurepath
    
    if ! command_exists virtualenv; then
      echo "virtualenv still not found on PATH after pipx installation."
      echo "Please restart your shell and try again, or consider an alternative approach (e.g., brew install pyenv-virtualenv)."
      exit 1
    fi
  else
    # Linux
    if command_exists apt-get; then
      sudo apt-get update
      sudo apt-get install -y python3-virtualenv || sudo apt-get install -y virtualenv
    elif command_exists yum; then
      sudo yum install -y python3-virtualenv || sudo yum install -y virtualenv
    else
      echo "No recognized package manager found. Please install virtualenv manually."
      exit 1
    fi
  fi
fi

#--------------------------------------------------#
# Start the main setup actions                      #
#--------------------------------------------------#
SETUP_DIR="$(dirname "$(readlink -f "$0")")"
cd "$SETUP_DIR"

HOMEDIR="$(readlink -f ~)"
SETUP_FLAG="$HOMEDIR/.setup_done"

# If we've already run this once, skip
if file_exists "$SETUP_FLAG"; then
  echo "Setup has already been completed. Exiting."
  exit 0
fi

#--------------------------------------------------#
# Initialize Git submodules if your repo has them   #
#--------------------------------------------------#
echo "Initializing git submodules..."
git submodule init
git submodule update

#--------------------------------------------------#
# Symlink your .vimrc to ~/.vimrc                  #
#--------------------------------------------------#
echo "Setting up vimrc..."
OLD_VIMRC="$HOMEDIR/.vimrc"
if file_exists "$OLD_VIMRC"; then
  rm "$OLD_VIMRC"
fi
ln -s "${SETUP_DIR}/.vimrc" "$HOMEDIR/.vimrc"

#--------------------------------------------------#
# Install Vundle (Vim plugin manager)              #
#--------------------------------------------------#
echo "Installing Vundle..."
# The official Vundle installation path is ~/.vim/bundle/Vundle.vim
VUNDLE_DIR="$HOMEDIR/.vim/bundle/Vundle.vim"
if ! dir_exists "$VUNDLE_DIR"; then
  echo "Cloning VundleVim/Vundle.vim repository..."
  git clone https://github.com/VundleVim/Vundle.vim.git "$VUNDLE_DIR"
else
  echo "Vundle is already installed at $VUNDLE_DIR"
fi

# Optionally, run plugin install to automatically fetch all plugins declared in .vimrc:
echo "Installing Vim plugins via Vundle..."
vim +PluginInstall +qall || true

#--------------------------------------------------#
# Tmux configuration                               #
#--------------------------------------------------#
echo "Setting up tmux configuration..."
if file_exists "$HOMEDIR/.tmux.conf"; then
  rm "$HOMEDIR/.tmux.conf"
fi
ln -s "${SETUP_DIR}/lib/tmux-config/.tmux.conf" "$HOMEDIR/.tmux.conf"

#--------------------------------------------------#
# Create local Python virtual environment (if none) #
#--------------------------------------------------#
VENV="$HOMEDIR/.venv"
echo "Setting up user's virtualenv at $VENV..."
if ! dir_exists "$VENV"; then
  python3 -m venv "$VENV"
fi

#--------------------------------------------------#
# Update user's ~/.bashrc to source your extras     #
#--------------------------------------------------#
echo "Updating ~/.bashrc..."
{
  echo ""
  echo "# Added by setup script"
  echo "export SETUP_DIR=\"$SETUP_DIR\""
  echo "[[ -f \"\$SETUP_DIR/.bash_andrew\" ]] && source \"\$SETUP_DIR/.bash_andrew\""
  # If you want to auto-activate the venv, add:
  # echo "source \"$VENV/bin/activate\""
} >> "$HOMEDIR/.bashrc"

#--------------------------------------------------#
# Create the setup flag file; final message         #
#--------------------------------------------------#
touch "$SETUP_FLAG"
echo "Setup complete!"
