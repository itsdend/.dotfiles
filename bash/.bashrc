

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs



if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/976mhk906ckhsn5a25c196cngbk5k8d4-bash-completion-2.13.0/etc/profile.d/bash_completion.sh"
fi

eval "$(oh-my-posh init bash --config ~/.dotfiles/ohmyposh/larserikfinhold.omp.josn)"
