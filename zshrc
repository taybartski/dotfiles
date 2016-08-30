# https://gitorious.org/topmenu/pages/Home
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. ~/.oh-my-zsh/themes/
#ZSH_THEME="robbyrussell"
#ZSH_THEME="gallifrey"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Check for platform
platform=$(uname)

source $ZSH/oh-my-zsh.sh
source $HOME/.dotfiles/zsh-prompt.zsh-theme

## Allow for functions in the prompt.
#setopt PROMPT_SUBST

## Autoload zsh functions.
#fpath=(~/.zsh/functions $fpath)
#autoload -U ~/.zsh/functions/*(:t)

## Enable auto-execution of functions.
#typeset -ga preexec_functions
#typeset -ga precmd_functions
#typeset -ga chpwd_functions

## Append git functions needed for prompt.
#preexec_functions+='preexec_update_git_vars'
#precmd_functions+='precmd_update_git_vars'
#chpwd_functions+='chpwd_update_git_vars'

#local ret_status="%(?:%{$fg[green]%}%m➜ :%{$fg[red]%}%m➜ %s)"
#PROMPT="${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(prompt_git_info)%{$fg_bold[blue]%} % %{$reset_color%}"
#PROMPT="${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c % %{$reset_color%}"
#PROMPT="${ret_status}%{$fg_bold[cyan]%}%c % %{$reset_color%}"

# Git Aliases
alias gs="git status"
alias gd="git diff --patience --ignore-space-change"
alias gcb="git checkout -b"
alias gb="git branch"
alias git-add-deleted="git ls-files --deleted -z | xargs -0 git rm"
alias ga="git add"
alias gh="git hist"
alias be="bundle exec"
alias gm="git checkout master"
alias gcm="git commit -m"
alias gitda="~/.dotfiles/gitda"
alias gitfixauth="git config user.name \"Taylor\" && git config user.email taylor.bartlett@mfactorengineering.com && git commit --amend --reset-author"

# Aliases
alias notes="vim ~/.notes"
alias ennotes="~/.dotfiles/notes"
alias v="vim"
alias q="exit"
alias :q="exit"
alias mpv="mpv -no-border"
alias zshrc="vim ~/.zshrc && . ~/.zshrc"
alias xup="xrdb ~/.Xresources"
alias hangups="hangups --col-scheme solarized-dark"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias genjstags="find . -type f -iregex \".*\.js$\" -not -path \"./node_modules/*\" -exec jsctags {} -f \; | sed '/^$/d' | sort > tags"
unalias ranger 2>/dev/null
alias ranger="if [ -z "$RANGER_LEVEL" ]
then
    $(which ranger)
else
    exit
fi
"

# Exports
export EDITOR=vim
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/opt/local/sbin:/opt/X11/bin:/Applications/Server.app/Contents/ServerRoot/usr/bin:/Applications/Server.app/Contents/ServerRoot/usr/sbin:/usr/local/msp430-toolchain/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/taylor/go/bin:/Users/taylor/.rvm/bin:/usr/games:$HOME/dotfiles:$PATH:/usr/local/LPCXpresso/tools/bin:$HOME/.rvm/bin"
export GREP_OPTIONS="-RIns --color --exclude=\"tags\""
export DISABLE_AUTO_TITLE=true

if [ "$platform" = "Darwin" ]
then
    export PATH="/Users/taylor/.google_depot_tools:/Users/taylor/Library/Android/sdk/tools:/Users/taylor/Library/Android/sdk/platform-tools:$PATH"
    export ANDROID_HOME=~/Library/Android/sdk
    plugins=(brew git osx sudo vagrant)
    alias ls="ls -G -l"
    alias lsusb="system_profiler SPUSBDataType"
    alias update="brew update && brew upgrade"
    alias newmac="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether"
    alias showhidden="defaults write com.apple.finder AppleShowAllFiles"
    function title {
        echo -ne "\033]0;"$*"\007"
    }
    function convid {
        if [ "$#" -ne 3 ]; then
            echo "Usage: convid name format_in format_out"
        fi
        avconv -i $1.$2 -codec copy $1.$3
    }
else
    plugins=(git sudo vi-mode vagrant)
    alias ls="ls -l --color --block-size=M"
    alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && sudo apt-get autoremove"
    alias check-update="sudo apt-get --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print \"PROGRAM: $1 INSTALLED: $2 AVAILABLE: $3\n\"}'"
    alias ccat="pygmentize -g"
    alias install="sudo apt-get install"
    alias remove="sudo apt-get autoremove"
    alias noise="play -n synth 60:00 brownnoise"
    alias reboot="sudo reboot"
    alias grep="grep"
    alias sa="mosquitto_sub -t '#'"
    alias attach="tmux attach -t"
    alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && sudo apt-get autoremove"
    alias uc="date ; sudo service ntp stop ; sudo ntpdate -s time.nist.gov ; sudo service ntp start ; date"
    xmodmap ~/.xmodmap > /dev/null 2>&1
    compton -b --backend glx --vsync opengl-swc > /dev/null 2>&1
    if [[ -n $SSH_CONNECTION && -z $TMUX ]] ; then
        echo -e "\n\nAvailable tmux sessions: "
        tmux ls
    fi
fi


# Local zshrc
if [ -f $HOME/.zshrc.local ]; then
    . $HOME/.zshrc.local
fi

###-begin-pm2-completion-###
### credits to npm for the completion file model
#
# Installation: pm2 completion >> ~/.bashrc  (or ~/.zshrc)
#

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _pm2_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           pm2 completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _pm2_completion pm2
elif type compctl &>/dev/null; then
  _pm2_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       pm2 completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _pm2_completion + -f + pm2
fi
###-end-pm2-completion-###
