#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
unset SHELL_WELCOME


# Added by Antigravity CLI installer
export PATH="/home/metalwoopa/.local/bin:$PATH"

# Clear Cache
alias fastfetch='rm -rf ~/.cache/fastfetch/images && fastfetch'
alias fastfetch="clear && fastfetch"
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'


echo "alias dots='/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> ~/.bashrc
