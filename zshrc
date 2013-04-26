# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
export ZSH_THEME="whitney"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# export DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
watch=(notme)

# eval $( perl -Mlocal::lib )

export EDITOR=vim
export PERL5LIB=$PERL5LIB:$( echo $HOME/git/*/lib | tr -s " " ":" )

# fixes perldoc output problems
export LESS=-R

alias dtt="ls -lt | head"
alias q='rlwrap q'
alias qcon='rlwrap qcon'
alias pp='python -mjson.tool'

function where_pm() {
    MODULE=$1
    REL_PATH=`echo ${MODULE} | sed -e 's|::|/|g'`.pm
    perl -M${MODULE} -E "say \$INC{'${REL_PATH}'};"
}

unset LS_COLORS

# enable ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# rxvt-unicode-256color works better for me under tmux
if [ $TERM = 'screen-256color' ]; then
    TERM=rxvt-unicode-256color
fi

unsetopt correctall
setopt no_prompt_cr
