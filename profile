#!/bin/sh

export BLOCKSIZE=K
export EDITOR=nvim
export LC_ALL=en_US.UTF-8
export MANWIDTH=tty
export PAGER=less

export PATH=$HOME/.local/bin:$PATH

## Homebrew

export HOMEBREW_NO_EMOJI=1
export PATH=$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH

## Haskell

export PATH=$HOME/.cabal/bin:$PATH

## OCaml

export PATH=$HOME/.opam/default/bin:$PATH

## Ein

export EIN_ROOT=$HOME/src/github.com/ein-lang/ein

## Go

export GOPATH=$HOME/.go
export GO111MODULE=on
export PATH=$GOPATH/bin:$PATH

## Rust

export PATH=$HOME/.cargo/bin:$PATH
export RUST_MIN_STACK=8388608

## Ruby

export PATH=$HOME/.homebrew/opt/ruby/bin:$PATH

if which gem >/dev/null; then
  export PATH=$(gem environment gempath | sed 's/\(:\|$\)/\/bin\1/g'):$PATH
fi

## Node.js

export NODE_OPTIONS=--max-old-space-size=4096

## Java

export PATH=$HOME/.homebrew/opt/openjdk/bin:$PATH

## git

unset SSH_ASKPASS

## ghq

export GHQ_ROOT=$HOME/src

## fzf

export FZF_DEFAULT_OPTS='--exit-0 --select-1'

## zsh

export PURE_PROMPT_SYMBOL='>'
export PURE_PROMPT_VICMD_SYMBOL='<'
export PURE_GIT_DOWN_ARROW=v
export PURE_GIT_UP_ARROW=^
export PURE_GIT_STASH_SYMBOL==

export NVM_AUTO_USE=true # for zsh-nvm

## Google Cloud SDK

export PATH=$HOME/.google/google-cloud-sdk/bin:$PATH
