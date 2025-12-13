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
ln -sf "${SETUP_DIR}/.vimrc" "$HOMEDIR/.vimrc"

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
ln -sf "${SETUP_DIR}/lib/tmux-config/.tmux.conf" "$HOMEDIR/.tmux.conf"

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
BASHRC="$HOMEDIR/.bashrc"
if ! grep -q "# Added by setup script" "$BASHRC" 2>/dev/null; then
  {
    echo ""
    echo "# Added by setup script"
    echo "export SETUP_DIR=\"$SETUP_DIR\""
    echo "[[ -f \"\$SETUP_DIR/.bash_andrew\" ]] && source \"\$SETUP_DIR/.bash_andrew\""
    echo "[[ -f \"\$SETUP_DIR/git_aliases.sh\" ]] && source \"\$SETUP_DIR/git_aliases.sh\""
    echo ""
    echo "# Long history configuration"
    echo "export HISTSIZE=100000"
    echo "export HISTFILESIZE=200000"
    echo "export HISTCONTROL=ignoreboth:erasedups"
    echo "export HISTIGNORE=\"ls:cd:cd -:pwd:exit:date:* --help\""
    echo "export HISTTIMEFORMAT=\"%F %T  \""
    echo "shopt -s histappend"
    echo "shopt -s cmdhist"
    echo "export PROMPT_COMMAND=\"history -a; history -c; history -r; \${PROMPT_COMMAND}\""
    # If you want to auto-activate the venv, add:
    # echo "source \"$VENV/bin/activate\""
  } >> "$BASHRC"
  echo "Added setup configuration to ~/.bashrc"
else
  echo "Setup configuration already present in ~/.bashrc, skipping..."
fi

#--------------------------------------------------#
# Ensure ~/.bash_profile sources ~/.bashrc          #
# (for login shells on macOS, etc.)                 #
#--------------------------------------------------#
echo "Updating ~/.bash_profile..."
BASH_PROFILE="$HOMEDIR/.bash_profile"
if ! grep -q "source.*\.bashrc" "$BASH_PROFILE" 2>/dev/null && \
   ! grep -q "\. .*\.bashrc" "$BASH_PROFILE" 2>/dev/null; then
  {
    echo ""
    echo "# Source .bashrc for login shells (added by setup script)"
    echo "[[ -f \"\$HOME/.bashrc\" ]] && source \"\$HOME/.bashrc\""
  } >> "$BASH_PROFILE"
  echo "Added .bashrc sourcing to ~/.bash_profile"
else
  echo ".bashrc is already sourced in ~/.bash_profile, skipping..."
fi

#--------------------------------------------------#
# Configure ~/.inputrc for readline settings        #
#--------------------------------------------------#
echo "Updating ~/.inputrc..."
INPUTRC="$HOMEDIR/.inputrc"
if ! grep -q "history-search-backward" "$INPUTRC" 2>/dev/null; then
  {
    echo ""
    echo "# Added by setup script"
    echo "\"\\e[A\": history-search-backward"
    echo "\"\\e[B\": history-search-forward"
    echo "set completion-ignore-case on"
  } >> "$INPUTRC"
  echo "Added readline configuration to ~/.inputrc"
else
  echo "Readline configuration already present in ~/.inputrc, skipping..."
fi

echo "Setup complete!"
