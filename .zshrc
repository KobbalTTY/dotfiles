# zshrc

HISTSIZE=1000000
SAVEHIST=1000000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt INTERACTIVE_COMMENTS
setopt HIST_IGNORE_ALL_DUPS
hist() {
  local cmd
  cmd=$(history | awk '{$1=""; sub(/^ /,""); print}' | fzy) || return
  eval "$cmd"
}

# Sane caching locations
COMPOSE_CACHE_DIR="$HOME/.cache/docker/compose"
ZSH_COMPDUMP="$HOME/.cache/zsh/zcompcache"
[[ -d $ZSH_COMPDUMP ]] || mkdir -p $ZSH_COMPDUMP
_comp_files=($ZSH_COMPDUMP/zcompdump(Nm-20))
if (( $#_comp_files )); then
    autoload -Uz compinit -C -d "$ZSH_COMPDUMP/.zcompdump-${ZSH_VERSION}"
else
    autoload -Uz compinit -d "$ZSH_COMPDUMP/.zcompdump-${ZSH_VERSION}"
fi

setopt prompt_subst
autoload -Uz promptinit && promptinit
prompt_basename_setup() {
  if [[ -e /tmp/kobbalt ]]; then
    PS1=$'\e[6 q\n%F{114}kobbalt%f(); '
  else
    PS1=$'\e[6 q\n%F{114}$( basename "$PWD" )%f(); '
  fi
}
prompt_themes+=( basename )
prompt basename

PLUGINS_DIR="$HOME/.zsh/plugins/"
mkdir -p "$PLUGINS_DIR"
source "$PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
#source "$PLUGINS_DIR/zsh-vi-mode/zsh-vi-mode.zsh"
source /nix/store/*-grc-*/etc/grc.zsh

export LESS='-R'
LESS_TERMCAP_md=$'\e[01;36m' \
LESS_TERMCAP_me=$'\e[0m' \
LESS_TERMCAP_se=$'\e[0m' \
LESS_TERMCAP_so=$'\e[38;5;15;48;5;17m' \
LESS_TERMCAP_ue=$'\e[0m' \
LESS_TERMCAP_us=$'\e[01;32m' \

mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
export PATH="$HOME/.npm-global/bin:$PATH"

export GNUPGHOME="$HOME/dotsecrets/.gnupg"
export PASSWORD_STORE_DIR="$HOME/dotsecrets/.pass-store"

VIRTUAL_ENV_DISABLE_PROMPT=1

eds() {
  typeset -gA EDIT_FILES=(
    zsh    "$HOME/dotfiles/.zshrc"
    tmux   "$HOME/dotfiles/.config/tmux/tmux.conf"
    i3     "$HOME/dotfiles/.config/i3/config"
    nvim   "$HOME/dotfiles/.config/nvim/init.lua"
    kanata "$HOME/dotfiles/.config/kanata.kbd"
    nixos  "/etc/nixos/configuration.nix"
  )
  local key file
  key=$(printf '%s\n' "${(@k)EDIT_FILES}" | fzy --prompt='Edit file> ') || return
  file=${EDIT_FILES[$key]}
  if [[ -e $file && ! -w $file ]]; then
    sudoedit "$file"
  else
    ${EDITOR:-nvim} "$file"
  fi
}

EDITOR="$HOME/.local/share/bob/nightly/bin/nvim"
alias v="$EDITOR"
alias vi="$EDITOR"
alias vim="$EDITOR"
alias nvim="$EDITOR"

alias flowon="stty -ixon"
alias flowoff="stty ixon"
flowoff

alias ls="ls --color -x"

alias nxs="nix-shell"
alias nxr="sudo nixos-rebuild switch"

alias scp="systemctl poweroff"
alias scs="systemctl suspend"
alias scr="systemctl reboot"

alias ffr="fastfetch"
alias zsr="reset && source  ~/.zshrc"

cps() { "$@" | xclip -selection clipboard }
bcs() { brightnessctl s $(( $1 * 100 ))% }
kobbalt() {
  onoff=$1
  if [[ $onoff == "on" ]]; then
    touch /tmp/kobbalt
  elif [[ $onoff == "off" ]]; then
    rm /tmp/kobbalt
  fi
  source ~/.zshrc
}

SPLASH=0
SPLASH_DIR="$HOME/personal/media/terminal-splash/"
SPLASH_BRIGHTNESS=100
SPLASH_SATURATION=100
if [[ $SPLASH -eq 1 ]]; then
  random_file=$(find "$SPLASH_DIR" -type f | shuf -n1)
  magick "$random_file" \
    -modulate "$SPLASH_BRIGHTNESS","$SPLASH_SATURATION",100 \
    -resize 256x256 \
    jpg:- | wezterm imgcat
fi
