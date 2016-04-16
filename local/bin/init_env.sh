#!/bin/sh

# constants

log_file=$(basename "$0.log")
vim_bundle_dir=$HOME/.vim/bundle
github_address=https://github.com


# functions

info() {
  echo "$@" >&2
}

fail() {
  info "$@"
  exit 1
}

git_clone_to_dir() {
  check_num_of_args "git_clone_to_dir" 2 $#
  address=$1
  dir=$2

  if is_git_repo "$dir"
  then
    git -C "$dir" pull
  else
    mkdir -p "$dir" &&
    git clone "$address" "$dir"
  fi
}

install_linuxbrew() {
  info "Installing linuxbrew..." &&
  git_clone_to_dir $github_address/Linuxbrew/linuxbrew.git $HOME/.linuxbrew
}

install_linuxbrew_packages() {
  info "Installing linuxbrew packages..." &&

  brew update &&

  brew tap thoughtbot/formulae &&
  brew install rcm &&

  brew install git tmux the_silver_searcher &&

  brew install perl &&
  brew install vim --with-python3 --with-lua &&

  brew install unzip &&
  brew install neovim/neovim/neovim
}

install_ghq() {
  info "Installing ghq..." &&
  go get github.com/motemen/ghq
}

install_peco() {
  info "Installing peco..." &&
  go get github.com/peco/peco/cmd/peco
}

install_vundle() {
  info "Installing vundle..." &&
  git_clone_to_dir $github_address/VundleVim/Vundle.vim \
                   $vim_bundle_dir/Vundle.vim
}

install_youcompleteme() {
  info "Installing YouCompleteMe..." &&

  ycm=YouCompleteMe
  ycm_dir=$vim_bundle_dir/$ycm

  git_clone_to_dir $github_address/Valloric/$ycm $ycm_dir &&
  (
    cd $ycm_dir &&
    git submodule update --init --recursive &&
    ./install.py
  )
}

compile_vimproc() {
  (
    cd $HOME/.vim/bundle/vimproc.vim &&
    make
  )
}

install_vim_plugins() {
  install_vundle &&
  info "Installing vim plugins..." &&
  #install_youcompleteme &&
  vim +PluginInstall +qall &&
  compile_vimproc
}

install_antizen() {
  info "Installing antigen..." &&
  git_clone_to_dir $github_address/zsh-users/antigen.git $HOME/.antigen
}

install_zplug() {
  info "Installing zplug..." &&
  git_clone_to_dir https://github.com/b4b4r07/zplug $HOME/.zplug
}

install_zsh_plugins() {
  install_zplug &&
  info "Installing zsh plugins..." &&
  zsh -ic ". $HOME/.zprofile && . $HOME/.zshrc"
}

install_fzf() {
  info "Installing fzf..." &&

  fzf_repo=junegunn/fzf

  ghq get $fzf_repo &&
  yes | ${GHQ_ROOT:-$HOME/.ghq}/github.com/$fzf_repo/install --no-update-rc
}

check_args() {
  if [ $# -ne 0 ]
  then
    fail "usage: $(basename $0)"
  fi
}

check_old_log_file() {
  if [ -f "$log_file" ]
  then
    fail "Log file, \"$log_file\" already exists. Delete it and rerun me."
  fi
}


# main routine

check_args "$@"
check_old_log_file

(
  . $HOME/.profile &&

  if on_linux
  then
    install_linuxbrew &&
    install_linuxbrew_packages
  fi &&

  install_zsh_plugins &&
  install_ghq &&
  install_peco &&
  install_fzf &&
  install_vim_plugins
) 2> $log_file

if [ $? -ne 0 ]
then
  fail "Failed to initialize dotfiles environment." \
       "See $log_file for troubleshooting."
else
  rm $log_file
fi
