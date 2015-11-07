#!/bin/sh
# ~/.profile

# environment variables

export BLOCKSIZE=K
#export DESTDIR=$LOCAL
export EDITOR=vi
export LC_ALL=en_US.UTF-8
export MANWIDTH=tty
export PAGER=less
export TZ=Asia/Tokyo

LOCAL=$HOME/.local

export PATH=$HOME/bin:$LOCAL/bin:$LOCAL/usr/bin:$LOCAL/usr/local/bin:$PATH
export MANPATH=/usr/share/man:/usr/local/man:$MANPATH
export MANPATH=$LOCAL/usr/share/man:$LOCAL/usr/local/man:$MANPATH

## c language

export CC=clang
export CXX=clang++
export C_INCLUDE_PATH=$LOCAL/include:$LOCAL/usr/include
export C_INCLUDE_PATH=$LOCAL/usr/local/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$C_INCLUDE_PATH
export LIBRARY_PATH=$LOCAL/lib64:$LOCAL/lib:$LOCAL/usr/lib64:$LOCAL/usr/lib
export LIBRARY_PATH=$LOCAL/usr/local/lib64:$LOCAL/usr/local/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=$LIBRARY_PATH

## cuda

if [ "$(uname)" = Linux ]
then
  export PATH=$PATH:/usr/local/cuda/bin
  export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda/lib64
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
fi

## cmake configuration

export CMAKE_INCLUDE_PATH=$C_INCLUDE_PATH
export CMAKE_LIBRARY_PATH=$LIBRARY_PATH
export CMAKE_PREFIX_PATH=$LOCAL
