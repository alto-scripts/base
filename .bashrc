alias dl="cd Downloads/"
alias ll="ls -lisah"
alias ".."="cd .."
alias sc="cd ~/scripts/"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
