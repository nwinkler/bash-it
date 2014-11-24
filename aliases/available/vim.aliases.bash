cite 'about-alias'
about-alias 'vim abbreviations'

alias v=vim
alias vv=/usr/bin/vim

VLESS=$(find /usr/share/vim -name 'less.sh')
if [ ! -z $VLESS ]; then
    alias vless=$VLESS
fi
