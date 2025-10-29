# History
HISTSIZE=1000000
SAVEHIST=1000000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INTERACTIVE_COMMENTS
setopt HIST_IGNORE_ALL_DUPS

# History search
hist() {
  local cmd
  cmd=$(awk -F';' '{print $2}' ~/.zsh_history | sort -u | fzy) || return
  eval "$cmd"
}

# Saner compdump
ZSH_COMPDUMP="$HOME/.cache/zsh/zcompcache"
[[ -d $ZSH_COMPDUMP ]] || mkdir -p $ZSH_COMPDUMP
_comp_files=($ZSH_COMPDUMP/zcompdump(Nm-20))
if (( $#_comp_files )); then
    autoload -Uz compinit -C -d "$ZSH_COMPDUMP/.zcompdump-${ZSH_VERSION}"
else
    autoload -Uz compinit -d "$ZSH_COMPDUMP/.zcompdump-${ZSH_VERSION}"
fi

# Prompt
setopt prompt_subst
autoload -Uz promptinit && promptinit
prompt_basename_setup() {
  if [[ -e /tmp/kobbalt ]]; then
    PS1=$'\e[6 q\n%F{green}kobbalt%f(); '
  else
    PS1=$'\n%F{green}$( basename "$PWD" )%f(); '
  fi
}
prompt_themes+=( basename )
prompt basename

# Plugins
PLUGINS_DIR="$HOME/.zsh/plugins/"
mkdir -p "$PLUGINS_DIR"
source "$PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$PLUGINS_DIR/zsh-vi-mode/zsh-vi-mode.zsh"
source /nix/store/*-grc-*/etc/grc.zsh

# Pager
export LESS='-R'
LESS_TERMCAP_md=$'\e[01;36m' \
LESS_TERMCAP_me=$'\e[0m' \
LESS_TERMCAP_se=$'\e[0m' \
LESS_TERMCAP_so=$'\e[38;5;15;48;5;17m' \
LESS_TERMCAP_ue=$'\e[0m' \
LESS_TERMCAP_us=$'\e[01;32m' \

# Env variables
COMPOSE_CACHE_DIR="$HOME/.cache/docker/compose"
export GNUPGHOME="$HOME/dotsecrets/.gnupg"
export PASSWORD_STORE_DIR="$HOME/dotsecrets/.pass-store"
VIRTUAL_ENV_DISABLE_PROMPT=1
EDITOR="$HOME/.local/share/bob/nightly/bin/nvim"

# NPM global prefix
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
export PATH="$HOME/.npm-global/bin:$PATH"

# Disable flow control (freeze shortcut)
stty ixon

# Editor
EDITOR="$HOME/.local/share/bob/nightly/bin/nvim"
alias v="$EDITOR"
alias nvim="$EDITOR"

alias s="/hub/include/bin/sessionizer"

# System aliases
alias ls="ls --color -x"
alias ne="sudoedit /etc/nixos/configuration.nix"
alias ns="nix-shell"
alias nr="sudo nixos-rebuild switch"
alias sp="systemctl poweroff"
alias ss="systemctl suspend"
alias sr="systemctl reboot"
alias zr="reset && source  ~/.zshrc"

# Utilities
fcl() {
  fc-list :family | awk -F: '{print $2}' | sed 's/^ *//;s/ *$//' \
    | tr ',' '\n' | sed 's/^ *//;s/ *$//' | sort -u
}


cdhub() {
  BUFFER="cd /hub/"
  CURSOR=${#BUFFER}
  zle expand-or-complete
}
zle -N cdhub
bindkey '^h' cdhub

cb() { "$@" | xclip -selection clipboard }

bs() { brightnessctl s $(( $1 * 100 ))% }

kobbalt() {
  onoff=$1
  if [[ $onoff == "on" ]]; then
    touch /tmp/kobbalt
  elif [[ $onoff == "off" ]]; then
    rm /tmp/kobbalt
  fi
  source ~/.zshrc
}
