cite 'about-alias'
about-alias 'todo.txt-cli abbreviations'

if [ -z "$TODO" ] ; then
  TODO="todo.sh"
fi

alias tls="$TODO ls"
alias ta="$TODO a"
alias trm="$TODO rm"
alias tdo="$TODO do"
alias tpri="$TODO pri"
alias tpv="$TODO projectview"
alias te="$TODO edit"
