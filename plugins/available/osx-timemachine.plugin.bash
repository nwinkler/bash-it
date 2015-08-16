cite about-plugin
about-plugin 'OS X Time Machine functions'

function time-machine-destination() {
  group "osx-timemachine"
  about "Shows the OS X Time Machine destination/mount point"

  echo $(tmutil destinationinfo | grep "Mount Point" | sed -e 's/Mount Point   : \(.*\)/\1/g')
}

function time-machine-list-machines() {
  group "osx-timemachine"
  about "Lists the OS X Time Machine machines on the backup volume"

  local tmdest="$(time-machine-destination)/Backups.backupdb"

  find "$tmdest" -maxdepth 1 -mindepth 1 -type d | grep -v "/\." | while read line ; do
    echo "$(basename "$line")"
  done
}

function time-machine-list-all-backups() {
  group "osx-timemachine"
  about "Shows all of the backups for the specified machine"
  param "1: Machine name"
  example "time-machine-list-all-backups my-laptop"

  # TODO Use the local hostname if none provided
  local COMPUTERNAME=$1
  local BACKUP_LOCATION="$(time-machine-destination)/Backups.backupdb/$COMPUTERNAME"

  find "$BACKUP_LOCATION" -maxdepth 1 -mindepth 1 -type d | while read line ; do
    echo "$line"
  done
}

function time-machine-list-old-backups() {
  group "osx-timemachine"
  about "Shows all of the backups for the specified machine, except for the most recent backup"
  param "1: Machine name"
  example "time-machine-list-old-backups my-laptop"

  # TODO Use the local hostname if none provided
  local COMPUTERNAME=$1
  local BACKUP_LOCATION="$(time-machine-destination)/Backups.backupdb/$COMPUTERNAME"

  # List all but the most recent one
  find "$BACKUP_LOCATION" -maxdepth 1 -mindepth 1 -type d -name 2\* | sed \$d | while read line ; do
    echo "$line"
  done
}

function time-machine-delete-old-backups() {
  group "osx-timemachine"
  about "Deletes all of the backups for the specified machine, with the exception of the most recent one"
  param "1: Machine name"
  example "time-machine-delete-old-backups my-laptop"

  # TODO Use the local hostname if none provided
  local COMPUTERNAME=$1

  # TODO Ask for sudo credentials only once
  echo "$(time-machine-list-old-backups "$COMPUTERNAME")" | while read i ; do
    echo "Deleting: $i"
    # TODO Delete the backups
    #sudo tmutil delete "$i"
  done
}
