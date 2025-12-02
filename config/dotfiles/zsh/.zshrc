# Fomarchy (Omarchy Fedora) configuració de Zsh
export ZDOTDIR="$HOME/.config/zsh"
export PATH="$HOME/.local/bin:$PATH"

# Història
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# Autocompletat
autoload -Uz compinit promptinit
compinit
promptinit

# Starship prompt
eval "$(starship init zsh)"

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

# Mode vi
bindkey -v

# Plugins
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# fzf
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif [ -f /usr/share/fzf/shell/key-bindings.zsh ]; then
  source /usr/share/fzf/shell/key-bindings.zsh
fi

# Funcions útils
mkcd() {
  mkdir -p "$1" && cd "$1"
}



