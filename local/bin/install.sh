#!/bin/sh

# constants

log_file=$(basename "$0.log")
vim_bundle_dir=$HOME/.vim/bundle
github_address=https://github.com


# functions

info() {
  echo "$@" >&2
}

fail() {
  info "$@"
  exit 1
}

message_installing() {
  info "Installing" "$@" "..."
}

git_clone_to_dir() {
  check_num_of_args "git_clone_to_dir" 2 $#
  address=$1
  dir=$2

  if is_git_repo "$dir"
  then
    git -C "$dir" pull
  else
    mkdir -p "$dir" &&
    git clone "$address" "$dir"
  fi
}

install_linuxbrew() {
  message_installing "linuxbrew" &&
  git_clone_to_dir $github_address/Linuxbrew/linuxbrew.git $HOME/.linuxbrew
}

install_linuxbrew_packages() {
  message_installing "linuxbrew packages" &&

  brew update &&

  brew tap thoughtbot/formulae &&
  brew install rcm &&

  brew install git tmux &&

  brew install perl &&
  brew install vim --with-python3 --with-lua &&

  brew install unzip &&
  brew install neovim/neovim/neovim
}

install_freebsd_pkg() {
  if ! pkg -N
  then
    sudo pkg bootstrap
  fi
}

install_freebsd_packages() {
  yes | sudo pkg install \
      sudo nmap arping \
      portmaster portlint \
      zsh vim-lite tmux lynx irssi \
      git subversion fossil \
      python ruby go rust nasm gmake \
      qemu \
      bsdtris bsdgames \
      xorg-minimal xorg-docs xsetroot xset xlsfonts xfontsel xrdb xsm \
      xrandr xrefresh \
      dwm xdm rxvt-unicode surf-browser feh \
      firefox thunderbird chromium pcmanfm inkscape gimp \
      terminus-font ja-font-ipa ubuntu-font
}

install_go_packages() {
  message_installing "go packages" &&
  go get github.com/motemen/ghq &&
  go get github.com/peco/peco/cmd/peco &&
  go get github.com/monochromegane/the_platinum_searcher/...
}

install_vim_plug() {
  message_installing "vim-plug" &&
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_vim_plugins() {
  install_vim_plug &&
  message_installing "vim plugins" &&
  vim +PlugInstall +qall
}

install_zplug() {
  message_installing "zplug" &&
  git_clone_to_dir https://github.com/b4b4r07/zplug $HOME/.zplug
}

install_zsh_plugins() {
  install_zplug &&
  message_installing "zsh plugins" &&
  zsh -ic ". $HOME/.zprofile && . $HOME/.zshrc"
}

install_fzf() {
  message_installing "fzf" &&

  fzf_dir=$HOME/.fzf

  git_clone_to_dir "$github_address/junegunn/fzf" "$fzf_dir" &&
  yes | "$fzf_dir/install" --no-update-rc
}

install_tpm() {
  message_installing "tpm" &&
  git_clone_to_dir "$github_address/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
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
    install_linuxbrew &&
    install_linuxbrew_packages
  fi &&

  if on_freebsd
  then
    install_freebsd_pkg &&
    install_freebsd_packages
  fi &&

  install_zsh_plugins &&
  install_go_packages &&
  install_fzf &&
  install_tpm &&
  install_vim_plugins
) 2> $log_file

if [ $? -ne 0 ]
then
  fail "Failed to initialize dotfiles environment." \
       "See $log_file for troubleshooting."
else
  rm $log_file
fi
