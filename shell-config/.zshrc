if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc: executed by zsh for non-login shells.
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.


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

# Configuración de colores para syntax highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=#dad5cd'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#8773f8'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#8773f8'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#8773f8'
ZSH_HIGHLIGHT_STYLES[function]='fg=#8773f8'
ZSH_HIGHLIGHT_STYLES[command]='fg=#8773f8'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#7c90fa,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#7bd167,italic'
ZSH_HIGHLIGHT_STYLES[path]='fg=#dad5cd'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#dad5cd'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#7c90fa'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#7c90fa'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#dad5cd'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=#dad5cd'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#7bd167'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#7bd167'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#7bd167'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#7c90fa'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#dad5cd'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#8773f8'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6c7086'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#dad5cd'
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

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
zstyle ':fzf-tab:*' fzf-flags '--color=bg:#1b1926,bg+:#2a2838,fg:#dad5cd,fg+:#dad5cd,hl:#8773f8,hl+:#7c90fa,pointer:#ff9747,info:#7bd167,spinner:#7c90fa,header:#7bd167,prompt:#8773f8,marker:#ff9747'
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
alias efimero-c='~/scripts/efimero-conect.sh'
alias efimero-s='~/scripts/efimero-start.sh'
alias centra='~/scripts/centra-init'
alias master='git checkout master && git pull'

# Funciones
hs() {
    if [ -z "$1" ]; then
        echo "Uso: hs <término de búsqueda>"
        return 1
    fi
    history | grep --color=auto "$1"
    }

    # Función para hacer pull de master guardando temporalmente los cambios
    smartpull() {
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$current_branch" != "master" ]; then
        echo "Error: No estás en la rama master"
        return 1
    fi

    echo "Guardando cambios actuales..."
    git stash

    echo "Haciendo pull de master..."
    git pull origin master

    echo "Restaurando cambios guardados..."
    git stash pop
    }

    # Alias para la función
    alias gsp='smartpull'
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



# Función para activar automáticamente entornos virtuales de Python
function auto_venv() {
    if [[ -d ./venv ]] ; then
        source ./venv/bin/activate
    elif [[ -d ./.venv ]] ; then
        source ./.venv/bin/activate
    fi
}

# Cargar zsh-hook
autoload -Uz add-zsh-hook

# Ejecutar auto_venv cuando se cambie de directorio
add-zsh-hook chpwd auto_venv

# Ejecutar auto_venv al iniciar la terminal
auto_venv


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        # okteto setup
        export PATH="/usr/local/bin:$PATH"

# rbenv setup
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# nodenv setup
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"


# This alias runs the Cursor Setup Wizard, simplifying installation and configuration.
# For more details, visit: https://github.com/jorcelinojunior/cursor-setup-wizard
alias cursor-setup="/home/dan/cursor-setup-wizard/cursor_setup.sh"
