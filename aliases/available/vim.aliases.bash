cite 'about-alias'
about-alias 'vim abbreviations'

alias v='mvim --remote-tab'

VLESS=$(find /usr/share/vim -name 'less.sh')
if [ ! -z $VLESS ]; then
    alias vless=$VLESS
fi

