cite about-plugin
about-plugin 'helper functions for Apple Logic Pro X'

export LOGIC_DIR=~/Music/Logic
export LOGIC_BACKUP_DIR=~/Dropbox/audio/backup/Logic

logic-backup () {
  about 'backs up a Logic file to Dropbox using rsync'
  group 'logic-pro-x'

  local track=$1

  if [ -n "$1" ]; then
    mkdir -p "$LOGIC_BACKUP_DIR"

    cd "$LOGIC_DIR"

    rsync -avrKL --progress -d --delete-excluded "$track/" "$LOGIC_BACKUP_DIR/$track/"

    zip -FS -r "$LOGIC_BACKUP_DIR/$track.zip" "$track"

    cd -
  else
    echo "Track name required"
    return 1
  fi
}

logic-show () {
  about 'shows all local Logic files'
  group 'logic-pro-x'

  ls -daltr "$LOGIC_DIR"/*.logicx
}

_logic-backup-comp()
{
	COMPREPLY=()
	local cur="${COMP_WORDS[COMP_CWORD]}"
  local IFS=$'\n'

  local logic_files=$(for f in "$LOGIC_DIR"/*.logicx;
    do
      basename "${f}"
    done)

  COMPREPLY=( $(compgen -W "${logic_files[*]}" -- ${cur}) )
}

complete -o filenames -F _logic-backup-comp logic-backup
