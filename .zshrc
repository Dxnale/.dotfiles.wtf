# ~/.zshrc: executed by zsh for non-login shells.
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q


# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'

# Shell integrations
eval "$(zoxide init --cmd cd zsh)"


# Configuración adicional para fzf-tab
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' fzf-flags '--color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# Prompt
autoload -U colors && colors
PROMPT="%{$fg[green]%}%n@%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}$ "

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias webapp='~/scripts/buk'

# Funciones
hs() {
    if [ -z "$1" ]; then
        echo "Uso: hs <término de búsqueda>"
        return 1
    fi
    history | grep --color=auto "$1"
}

# Variables de entorno
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PNPM_HOME="/home/dan/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

export PATH="$PATH:$HOME/scripts"

# Alias específicos de Git
alias buk='git -c user.name="dandan-t" -c user.email="dtorrealba@buk.cl"'
alias personal='git -c user.name="dxnale" -c user.email="daniel.torrealba@amunos.ipleones.cl"'
alias dxnale='git config user.name "dxnale" && git config user.email "daniel.torrealba@amunos.ipleones.cl"'
alias dandan-t='git config user.name "dandan-t" && git config user.email "dtorrealba@buk.cl"'


# Habilitar Ctrl + Backspace para borrar una palabra completa
bindkey '^H' backward-kill-word

# Habilitar Ctrl + Flecha izquierda/derecha para moverse entre palabras
bindkey '^[[1;5D' backward-word  # Ctrl + Flecha izquierda
bindkey '^[[1;5C' forward-word   # Ctrl + Flecha derecha

# Habilitar Ctrl + Supr para borrar una palabra completa hacia adelante
bindkey '^[[3;5~' kill-word

# Habilitar selección de texto con Shift + Flechas
bindkey '^[[1;2A' beginning-of-line    # Shift + Flecha arriba (selecciona desde el cursor hasta el inicio de la línea)
bindkey '^[[1;2B' end-of-line          # Shift + Flecha abajo (selecciona desde el cursor hasta el final de la línea)

# Reasignar Ctrl + Z para deshacer cambios
bindkey '^Z' undo

# Opcional: Asignar Alt + Z para suspender procesos
bindkey '^[z' suspend



# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh