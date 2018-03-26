#!/bin/sh

LOCAL=$HOME/.local


export BLOCKSIZE=K
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export MANWIDTH=tty
export PAGER=less
export TZ=Asia/Tokyo

export PATH=$HOME/bin:$LOCAL/bin:$PATH
export MANPATH=$LOCAL/share/man:/usr/share/man:/usr/local/man

## c language

export c_include_path=$LOCAL/include
export library_path=$LOCAL/lib64:$LOCAL/lib

## cuda

export PATH=$PATH:/usr/local/cuda/bin
export library_path=$library_path:/usr/local/cuda/lib64

## linuxbrew

linuxbrew_dir=$HOME/.linuxbrew
export PATH=$linuxbrew_dir/bin:$linuxbrew_dir/sbin:$PATH
export MANPATH=$linuxbrew_dir/share/man:$MANPATH
export library_path=$linuxbrew_dir/lib64:$linuxbrew_dir/lib:$library_path
export HOMEBREW_NO_EMOJI=1

if type nproc > /dev/null 2>&1
then
  export HOMEBREW_MAKE_JOBS=$(nproc)
else
  export HOMEBREW_MAKE_JOBS=2
fi

## haskell

export PATH=$HOME/.cabal/bin:$PATH

## go

export GOPATH=$HOME
export PATH=$GOPATH/bin:$HOME/.local/go/bin:$PATH

## rust

export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH=$HOME/.cache/racer/rust/src
export LD_LIBRARY_PATH=$(rustc --print sysroot)/lib:$LD_LIBRARY_PATH

## python

export MYPYPATH=$LOCAL/lib/python3.6/site-packages

## git

unset SSH_ASKPASS

## ghq

export GHQ_ROOT=$HOME/src

## android

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

## fzf

export FZF_DEFAULT_OPTS='--exit-0 --select-1'

## LD_LIBRARY_PATH

export LIBRARY_PATH=$library_path
ld_library_path=$library_path

## pkg-config

export PKG_CONFIG_PATH=$(/usr/bin/pkg-config --variable pc_path pkg-config)
