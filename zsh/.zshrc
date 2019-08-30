
# --------------------------------------------------------------------------------
# Zsh
# --------------------------------------------------------------------------------

# ----------------------------------------
# autotitle
# ----------------------------------------

## prepend second directory if working under jects, work, files, or randy
### ex: working in ~/jects/project/docs, window title `project‖docs`

precmd() {
  local prefix_dirs
  
  local term_prefix
  local term_suffix
  local term_title

  local pwd_rel_home
  local subdir

  prefix_dirs=(jects work files randy)

  term_prefix=""
  pwd_rel_home=${PWD#$HOME/}

  ### make sure we're at least 3 directories away from home
  if [[ "${#pwd_rel_home//[^\/]/}" > 1 ]]; then

    subdir=${pwd_rel_home%%/*}
    
    ### ensure subdir is in array
    if [[ "${prefix_dirs[(ie)$subdir]}" -le "${#prefix_dirs}" ]]; then
      
      ### get the sub-subdirectory (ex: project in ~/jects/project)
      term_prefix=${${pwd_rel_home#$subdir/}%%/*}

      ### limit to 8 characters
      if [ ${#term_prefix} -gt 8 ]; then
        term_prefix="${term_prefix:0:7}$(print '\xE2\x80\xA6')"
      fi

      term_prefix="$term_prefix$(print '\xE2\x80\x96')"
    fi
  fi

  term_suffix="$PWD:t"
  if [ ${#term_suffix} -gt 8 ]; then
    term_suffix="${term_suffix:0:7}$(print '\xE2\x80\xA6')"
  fi

  term_title="${term_prefix}${term_suffix}"

  case $TERM in
    screen)
      printf "\033k%s\033\\" "$term_title"
      ;;
  esac
}

# ----------------------------------------
# ssh autocompetion
# ----------------------------------------

## only pull from config, skip users in autocomplete
local ssh_config_hosts=()
local ssh_users=()

if [[ -r ~/.ssh/config ]]; then
  ssh_config_hosts=( $(grep -oP '(?<=^Host ).*' ~/.ssh/config | tr ' ' '\n' | sort -u) )
fi

zstyle ':completion:*:(ssh|scp|rsync):*' hosts $ssh_config_hosts
zstyle ':completion:*:(ssh|scp|rsync):*' users $ssh_users

## xssh with ssh aliases
xssh() {
  x-terminal-emulator -e ssh $@
}

compctl -k "($ssh_config_hosts)" xssh

# ----------------------------------------
# Bash-like
# ----------------------------------------

## C-u : delete until beginning of line (not whole line)
bindkey \^U backward-kill-line

## C-k :  delete until end of line
bindkey \^K kill-line

## zsh forward / backward words like bash (jump to end of word when moving forward)
autoload -U select-word-style
select-word-style bash

# ----------------------------------------
# Misc
# ----------------------------------------

## cd, cat, vim: sort by modification date
zstyle ':completion:*:(cd|cat|vim|subl):*' file-sort modification

## change color of auto suggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=4" # blue

# --------------------------------------------------------------------------------
# Oh My Zsh
# --------------------------------------------------------------------------------

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

ZSH_THEME="eastwood"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  aws
  docker
  docker-compose
  git
  pass
  systemd
  ufw
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# --------------------------------------------------------------------------------
# Aliases
# --------------------------------------------------------------------------------

# ----------------------------------------
# File operations
# ----------------------------------------

## Open file in its default program
alias opn='xdg-open'

# ----------------------------------------
# Misc
# ----------------------------------------

## Command line clipboard
alias clip='xclip -selection clipboard'

## Restart network manager
alias renet="sudo service network-manager restart"
