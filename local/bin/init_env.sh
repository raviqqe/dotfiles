#!/bin/sh

# constants

log_file=$(basename "$0.log")
vim_bundle_dir=$HOME/.vim/bundle
github_address=https://github.com


# functions

message() {
  echo "$@" >&2
}

fail() {
  message "$@"
  exit 1
}

git_clone_to_dir() {
  check_num_of_args "git_clone_to_dir" 2 $#
  address=$1
  dir=$2

  if ! is_git_repo "$dir"
  then
    mkdir -p "$dir" &&
    git clone "$address" "$dir"
  fi
}

install_linuxbrew() {
  git_clone_to_dir $github_address/Linuxbrew/linuxbrew.git $HOME/.linuxbrew
}

install_ghq() {
  go get github.com/motemen/ghq
}

install_peco() {
  go get github.com/peco/peco/cmd/peco
}

install_vundle() {
  git_clone_to_dir $github_address/VundleVim/Vundle.vim \
                   $vim_bundle_dir/Vundle.vim
}

install_youcompleteme() {
  ycm=YouCompleteMe
  ycm_dir=$vim_bundle_dir/$ycm

  git_clone_to_dir $github_address/Valloric/$ycm $ycm_dir &&
  (
    cd $ycm_dir &&
    git submodule update --init --recursive &&
    ./install.py
  )
}

install_vim_plugins() {
  install_vundle &&
  install_youcompleteme &&
  vim +PluginInstall +qall
}

install_antizen() {
  antigen_dir=$HOME/.antigen

  if ! [ -d "$antigen_dir" ]
  then
    git clone "$github_address/zsh-users/antigen.git" "$antigen_dir"
  fi
}

install_zsh_plugins() {
  install_antizen &&
  zsh $HOME/.local/bin/install_zsh_plugins.zsh
}

install_fzf() {
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
    install_linuxbrew
  fi

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
