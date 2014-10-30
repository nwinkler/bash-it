cite 'about-alias'
about-alias 'vim abbreviations'

alias vim='gvim -b --remote-tab'
alias v=vim
alias vv=/usr/bin/vim

case $ostype in
  darwin*)
    alias vim="mvim --remote-tab"
    ;;
  *)
    ;;
esac

VLESS=$(find /usr/share/vim -name 'less.sh')
if [ ! -z $VLESS ]; then
    alias vless=$VLESS
fi

