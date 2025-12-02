# Fomarchy Bash profile
export PATH="$HOME/.local/bin:$PATH"

# Història
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize

# Aliases
alias ls='eza --icons=auto'
alias ll='ls -lah'
alias la='ls -a'
alias l='ls'
alias cat='bat'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias vi='nvim'
alias vim='nvim'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Editor
export EDITOR=nvim
export VISUAL=nvim

# Starship prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# Bash completion
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# fzf
if [ -f ~/.fzf.bash ]; then
  source ~/.fzf.bash
elif [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
  source /usr/share/fzf/shell/key-bindings.bash
fi

# Funcions útils
mkcd() {
  mkdir -p "$1" && cd "$1"
}



