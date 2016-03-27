#!/bin/sh

go get github.com/motemen/ghq &&
go get github.com/peco/peco/cmd/peco &&
vim +PluginInstall +qall

git clone https://github.com/zsh-users/antigen.git $HOME/.antigen
