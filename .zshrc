# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/nato/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh

export EDITOR="nvim"
export SUDO_EDITOR="nvim"
export MANPAGER="nvim +Man!"

autoload -Uz add-zsh-hook

# Escape sequence magic to show working directory as title
function xterm_title_precmd () {
  print -Pn -- '\e]2;%~\a'
}

# Escape sequence magic to show running command as title
xterm_title_preexec() {
  print -Pn '\e]2;%~ ${(q)1}\a'
}

if [[ "$TERM" == (foot*|alacritty*|xterm*|gnome*|konsole*|kitty*) ]]; then
  add-zsh-hook -Uz precmd xterm_title_precmd
  add-zsh-hook -Uz preexec xterm_title_preexec
fi

alias gitdot='/usr/bin/git --git-dir=$HOME/.gitdot/ --work-tree=$HOME'

# Needed to stop starship from acting up when sourcing this file
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi

eval "$(starship init zsh)"

fastfetch
