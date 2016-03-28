#!/bin/sh

# constants

log_file=$(basename "$0.log")


# functions

message() {
  echo "$@" >&2
}

fail() {
  message "$@"
  exit 1
}

install_ghq() {
  go get github.com/motemen/ghq
}

install_peco() {
  go get github.com/peco/peco/cmd/peco
}

install_youcompleteme() {
  ycm=YouCompleteMe
  ycm_dir="$HOME/.vim/bundle/$ycm"

  mkdir -p "$ycm_dir" &&
  (
    cd "$ycm_dir" &&
    if ! [ -d .git ]
    then
      git clone https://github.com/Valloric/$ycm .
    fi &&
    git submodule update --init --recursive &&
    ./install.py
  )
}

install_vim_plugins() {
  install_youcompleteme &&
  vim +PluginInstall +qall
}

install_antizen() {
  antigen_dir=$HOME/.antigen

  if ! [ -d "$antigen_dir" ]
  then
    git clone https://github.com/zsh-users/antigen.git "$antigen_dir"
  fi
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

  install_antizen &&
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
