#!/bin/sh

local=$HOME/.local

export BLOCKSIZE=K
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export MANWIDTH=tty
export PAGER=less

export PATH=$HOME/bin:$local/bin:$PATH

## C

include_path=$local/include
library_path=$local/lib64:$local/lib

## CUDA

export PATH=$PATH:/usr/local/cuda/bin
library_path=$library_path:/usr/local/cuda/lib64

## Homebrew

export HOMEBREW_NO_EMOJI=1

if [ -d ~/.homebrew ]
then
  eval $(~/.homebrew/bin/brew shellenv)
fi

### OpenSSL

export SSL_CERT_FILE=~/.homebrew/etc/openssl/cert.pem

## Haskell

export PATH=$HOME/.cabal/bin:$PATH

## OCaml

export PATH=$HOME/.opam/default/bin:$PATH

## Go

export GOPATH=$HOME
export PATH=$GOPATH/bin:$HOME/.local/go/bin:$PATH
export GO111MODULE=on

## Rust

export PATH=$HOME/.cargo/bin:$PATH
export LD_LIBRARY_PATH=$(rustc --print sysroot 2> /dev/null)/lib:$LD_LIBRARY_PATH

## Ruby

if [ -d ~/.homebrew/Cellar/ruby ]
then
  export PATH=$(echo ~/.homebrew/Cellar/ruby/*/bin):$PATH
fi

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

export ZPLUG_HOME=$HOME/.homebrew/opt/zplug

## Google Cloud SDK

export PATH=$HOME/.google/google-cloud-sdk/bin:$PATH
