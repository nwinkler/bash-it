alias pse="ps -ef"
alias psg="ps -ef|grep"
alias eg="env | grep -i"

alias ff="find . -name"

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Misc :)
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort

alias k9='kill -9'
alias pk9='pkill -9'

alias pd='pushd'


# https://github.com/nvbn/thefuck
alias fuck='$(thefuck $(fc -ln -1))'
alias please='fuck'
