#!/bin/sh

go get github.com/motemen/ghq &&
go get github.com/peco/peco/cmd/peco &&
vim +PluginInstall +qall &&

antigen_dir=$HOME/.antigen

if ! [ -d "$antigen_dir" ]
then
  git clone https://github.com/zsh-users/antigen.git "$antigen_dir"
fi
