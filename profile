#!/bin/sh

export BLOCKSIZE=K
export EDITOR=nvim
export LC_ALL=en_US.UTF-8
export MANWIDTH=tty
export PAGER=less

export PATH=$HOME/.local/bin:$PATH

# Homebrew

export HOMEBREW_NO_EMOJI=1
export PATH=$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$HOME/.homebrew/opt/ruby/bin:$PATH

# Languages

## Haskell

export PATH=$HOME/.cabal/bin:$PATH

## OCaml

export PATH=$HOME/.opam/default/bin:$PATH

## Go

export GOPATH=$HOME/.go
export GO111MODULE=on
export PATH=$GOPATH/bin:$PATH

## Rust

export PATH=$HOME/.cargo/bin:$PATH

if which sccache >/dev/null; then
  export RUSTC_WRAPPER=sccache
fi

## Python

export PATH=$(python3 -m site --user-base)/bin:$PATH

## Ruby

if which gem >/dev/null; then
  export PATH=$(gem environment gempath | sed 's/\(:\|$\)/\/bin\1/g'):$PATH
fi

## Node.js

export NODE_OPTIONS=--max-old-space-size=4096

## Java

export JAVA_HOME=$HOME/.homebrew/opt/openjdk
export PATH=$JAVA_HOME/bin:$PATH

## Pen

export PEN_ROOT=$HOME/src/github.com/pen-lang/pen

# Tools

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

# Local profile

local_profile=$HOME/.local/etc/profile

if [ -r $local_profile ]; then
  . $local_profile
fi
