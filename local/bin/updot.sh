#!/bin/sh

# constants

log_file=$(basename "$0.log")
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
  info "$(basename $0): Installing" "$@" "..."
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
  brew update &&

  brew tap thoughtbot/formulae &&
  brew install rcm &&

  brew install git tmux lynx links hub irssi rust &&
  brew install gawk && # for zplug

  brew install vim --with-python3 --with-lua --with-luajit --with-ruby &&
  brew install neovim/neovim/neovim
}

install_freebsd_pkg() {
  message_installing "freebsd pkg command" &&
  if ! pkg -N > /dev/null 2>&1
  then
    sudo pkg bootstrap
  fi
}

install_freebsd_packages() {
  while getopts dx option
  do
    case $option in
    d)
      desktop_mode=true
      ;;
    x)
      extra_mode=true
      ;;
    esac
  done
  shift $(expr $OPTIND - 1)

  local portmaster="sudo -E portmaster -Gdy --no-confirm"
  local pkg_install="sudo pkg install -y"

  message_installing "freebsd packages" &&
  message_installing "freebsd base packages" &&
  $pkg_install \
      sudo nmap arping \
      portmaster portlint \
      zsh neovim tmux lynx ii simpleirc \
      git subversion fossil hub \
      go rust nasm gmake ninja \
      qemu rcm \
      bsdtris bsdgames &&
  $portmaster editors/vim lang/python devel/py-pip lang/ruby22 \
              devel/ruby-gems ghc hs-cabal-install &&

  if [ -n "$desktop_mode" ]
  then
    message_installing "freebsd desktop packages" &&
    $pkg_install \
        xorg-minimal xorg-docs xsetroot xset xlsfonts xfontsel xrdb xsm \
        xrandr xrefresh fontconfig xautolock \
        dwm xdm rxvt-unicode surf-browser feh scrot slock \
        firefox thunderbird chromium pcmanfm inkscape gimp libreoffice mupdf \
        terminus-font terminus-ttf ja-font-ipa ubuntu-font \
        ja-ibus-mozc poppler-utils &&
    DWM_CONF=$HOME/.dotfiles/local/etc/dwm/config.h $portmaster dwm &&
    fc-cache -f
  fi &&

  if [ -n "$extra_mode" ]
  then
    message_installing "freebsd extra packages" &&
    $pkg_install texlive-full
  fi
}

install_rust_packages() {
  message_installing "rust packages" &&

  for crate in racer
  do
    cargo install $crate | :
  done
}

install_go_packages() {
  message_installing "go packages" &&
  go_get="go get -u" &&
  $go_get github.com/motemen/ghq &&
  $go_get github.com/peco/peco/cmd/peco &&
  $go_get github.com/monochromegane/the_platinum_searcher/...
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

install_neovim_plugins() {
  message_installing "vim-plug for neovim" &&
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &&

  message_installing "neovim plugins" &&
  pip3 install --upgrade neovim &&
  nvim +PlugInstall +qall
}

install_zplug() {
  message_installing "zplug" &&
  git_clone_to_dir https://github.com/zplug/zplug $HOME/.zplug
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

install_wallpapers() {
  message_installing "wallpapers" &&
  git_clone_to_dir git://git.raviqqe.com/wallpapers.git "$HOME/.wallpapers"
}

install_haskell_stack() {
  message_installing "haskell stack" &&

  if [ -z "$(which stack)" ]
  then
    curl -sSL https://get.haskellstack.org/ | sh &&
    return
  fi

  stack upgrade
}

check_args() {
  if [ $# -ne 0 ]
  then
    fail "usage: $(basename $0) [-b] [-d]"
  fi
}

check_old_log_file() {
  if [ -f "$log_file" ]
  then
    fail "Log file, \"$log_file\" already exists. Delete it and rerun me."
  fi
}


# main routine

main() {
  while getopts bdx option
  do
    case $option in
    b)
      batch_mode=true
      ;;
    d)
      desktop_mode=true
      ;;
    x)
      extra_mode=true
      ;;
    esac
  done
  shift $(expr $OPTIND - 1)

  check_args "$@"
  check_old_log_file

  (
    . $HOME/.profile &&
    success_file=$(basename "$0").first_step_completed.tmp

    {
      if on_linux
      then
        install_linuxbrew &&
        install_linuxbrew_packages
      fi &&

      if on_freebsd
      then
        install_freebsd_pkg &&
        install_freebsd_packages ${desktop_mode:+-d} ${extra_mode:+-x}
      fi &&

      install_zsh_plugins &&
      install_tpm &&
      install_rust_packages &&
      install_go_packages &&
      install_haskell_stack &&
      install_fzf &&

      if [ -n "$desktop_mode" ]
      then
        install_wallpapers
      fi &&

      : > "$success_file"
    } 2>&1 | tee -a "$log_file"

    last_status=$([ -f "$success_file" ]; echo $?) &&
    rm -f "$success_file" &&
    (exit $last_status) &&

    if [ -z "$batch_mode" ]
    then
      install_vim_plugins 2>> "$log_file" &&
      install_neovim_plugins 2>> "$log_file"
    fi
  )

  if [ $? -ne 0 ]
  then
    fail "Failed to initialize dotfiles environment." \
         "See $log_file for troubleshooting."
  else
    rm $log_file
  fi
}

main "$@"
