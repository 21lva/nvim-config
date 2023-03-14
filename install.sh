#!/usr/bin/sh
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_BEGINNER=$DIR/nvim-beginner
echo $NVIM_BEGINNER

export NVIM_BEGINNER

rm -rf $NVIM_BEGINNER

mkdir -p $NVIM_BEGINNER/share
mkdir -p $NVIM_BEGINNER/nvim

stow --restow --target=$NVIM_BEGINNER/nvim .

alias nvb='XDG_DATA_HOME=$NVIM_BEGINNER/share XDG_CONFIG_HOME=$NVIM_BEGINNER nvim' 

export nvb
