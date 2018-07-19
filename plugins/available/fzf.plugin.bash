# Load after the system completion to make sure that the fzf completions are working
# BASH_IT_LOAD_PRIORITY: 375

cite about-plugin
about-plugin 'load fzf, if you are using it'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -z ${FZF_DEFAULT_COMMAND+x}  ]; then
  command -v fd &> /dev/null && export FZF_DEFAULT_COMMAND='fd --type f'
fi

fe() {
  about "Open the selected file in the default editor"
  group "fzf"
  param "1: Search term"
  example "fe foo"

  local IFS=$'\n'
  local files
  files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

fcd() {
  about "cd to the selected directory"
  group "fzf"
  param "1: Directory to browse, or . if omitted"
  example "fcd aliases"

  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

vf() {
  about "Use fasd to search the file to open in vim"
  group "fzf"
  param "1: Search term for fasd"
  example "vf xml"

  local file
  file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && vi "${file}" || return 1
}

# fbr - checkout git branch (including remote branches)
fbr() {
  about "Use fzf to switch between Git branches"
  group "fzf"
  param "1: Search term for fzf"
  example "fbr feature"

  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux --query="$1" --preview="" -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

fvag() {
  about "Use fzf to browse matches from ag while searching in file. The selected result is opened in vim."
  group "fzf"
  param "Any params you want to provide to ag"
  example "fvag -G '.*.xml' foo"

  local ffile

  ffile="$(ag --nobreak --noheading $@ | fzf -0 -1 --preview='' | awk -F: '{print $1 " +" $2}')"

  if [[ -n $ffile ]]; then
    vim $ffile
  fi
}
