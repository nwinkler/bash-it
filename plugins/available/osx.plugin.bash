cite about-plugin
about-plugin 'osx-specific functions'

# OS X: Open new tabs in same directory
if [ $(uname) = "Darwin" ]; then
  if type update_terminal_cwd > /dev/null 2>&1 ; then
    if ! [[ $PROMPT_COMMAND =~ (^|;)update_terminal_cwd($|;) ]] ; then
      PROMPT_COMMAND="${PROMPT_COMMAND%;};update_terminal_cwd"
      declared="$(declare -p PROMPT_COMMAND)"
      [[ "$declared" =~ \ -[aAilrtu]*x[aAilrtu]*\  ]] 2>/dev/null
      [[ $? -eq 0 ]] && export PROMPT_COMMAND
    fi
  fi
fi

function tab() {
  about 'opens a new terminal tab'
  group 'osx'

  osascript 2>/dev/null <<EOF
    tell application "System Events"
      tell process "Terminal" to keystroke "t" using command down
    end
    tell application "Terminal"
      activate
      do script with command " cd \"$PWD\"; $*" in window 0
    end tell
EOF
}

# renames the current os x terminal tab title
function tabname {
  printf "\e]1;$1\a"
}

# renames the current os x terminal window title
function winname {
  printf "\e]2;$1\a"
}

# this one switches your os x dock between 2d and 3d
# thanks to savier.zwetschge.org
function dock-switch() {
    about 'switch dock between 2d and 3d'
    param '1: "2d" or "3d"'
    example '$ dock-switch 2d'
    group 'osx'

    if [ $(uname) = "Darwin" ]; then

        if [ $1 = 3d ] ; then
            defaults write com.apple.dock no-glass -boolean NO
            killall Dock

        elif [ $1 = 2d ] ; then
            defaults write com.apple.dock no-glass -boolean YES
            killall Dock

        else
            echo "usage:"
            echo "dock-switch 2d"
            echo "dock-switch 3d."
        fi
    else
        echo "Sorry, this only works on Mac OS X"
    fi
}

function pman ()
{
    about 'view man documentation in Preview'
    param '1: man page to view'
    example '$ pman bash'
    group 'osx'
    man -t "${1}" | open -fa $PREVIEW
}

function pri ()
{
    about 'display information about Ruby classes, modules, or methods, in Preview'
    param '1: Ruby method, module, or class'
    example '$ pri Array'
    group 'osx'
    ri -T "${1}" | open -fa $PREVIEW
}

# Download a file and open it in Preview
function prevcurl() {
  about 'download a file and open it in Preview'
  param '1: url'
  group 'osx'

  if [ ! $(uname) = "Darwin" ]
  then
    echo "This function only works with Mac OS X"
    return 1
  fi
  curl "$*" | open -fa $PREVIEW
}

function refresh-launchpad() {
  about 'Reset launchpad layout in macOS'
  example '$ refresh-launchpad'
  group 'osx'

  if [ $(uname) = "Darwin" ];then
    defaults write com.apple.dock ResetLaunchPad -bool TRUE
    killall Dock
  else
    echo "Sorry, this only works on Mac OS X"
  fi
}

function list-jvms(){
  about 'List java virtual machines and their states in macOS'
  example 'list-jvms'
  group 'osx'

  JVMS_DIR="/Library/Java/JavaVirtualMachines"
  JVMS=( $(ls ${JVMS_DIR}) )
  JVMS_STATES=()

  # Map state of JVM
  for (( i = 0; i < ${#JVMS[@]}; i++ )); do
    if [[ -f "${JVMS_DIR}/${JVMS[$i]}/Contents/Info.plist" ]]; then
      JVMS_STATES[${i}]=enabled
    else
      JVMS_STATES[${i}]=disabled
    fi
      echo "${i} ${JVMS[$i]} ${JVMS_STATES[$i]}"
  done
}

function pick-default-jvm(){
  about 'Pick the default Java Virtual Machines in system-wide scope in macOS'
  example 'pick-default-jvm'

  # Call function for listing
  list-jvms

  # Declare variables
  local DEFAULT_JVM_DIR=""
  local DEFAULT_JVM=""
  local OPTION=""

  # OPTION for default jdk and set variables
  while [[ ! "$OPTION" =~ ^[0-9]+$ || OPTION -ge "${#JVMS[@]}" ]]; do
    read -p "Enter Default JVM: "  OPTION
      if [[ ! "$OPTION" =~ ^[0-9]+$  ]]; then
        echo "Please enter a number"
      fi

      if [[ OPTION -ge "${#JVMS[@]}" ]]; then
        echo "Please select one of the displayed JVMs"
      fi
  done

  DEFAULT_JVM_DIR="${JVMS_DIR}/${JVMS[$OPTION]}"
  DEFAULT_JVM="${JVMS[$OPTION]}"

  # Disable all jdk
  for (( i = 0; i < ${#JVMS[@]}; i++ )); do
    if [[ -f "${JVMS_DIR}/${JVMS[$i]}/Contents/Info.plist" ]]; then
      sudo mv "${JVMS_DIR}/${JVMS[$i]}/Contents/Info.plist" "${JVMS_DIR}/${JVMS[$i]}/Contents/Info.plist.disable"
    fi
  done

  # Enable default jdk
  if [[ -f "${DEFAULT_JVM_DIR}/Contents/Info.plist.disable" ]]; then
    sudo mv "${DEFAULT_JVM_DIR}/Contents/Info.plist.disable" "${DEFAULT_JVM_DIR}/Contents/Info.plist"
    echo "Enabled ${DEFAULT_JVM} as default JVM"
  fi
}

# Make this backwards compatible
alias pcurl='prevcurl'

function spotlight() {
  about 'Enables or disables Spotlight indexing, asks for sudo password'
  param '1: on/off'
  example 'spotlight on'
  group 'osx'

  if [ -z "$1" ] ; then
    echo "Usage: $0 [on | off]"
  elif [ $1 = "on" ] ; then
    sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
  elif [ $1 = "off" ] ; then
    sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
  fi
}

function set_java_home() {
  about 'Sets the Java Home variable to the specified version. The version needs to be specified in the form 1.*, e.g. 1.6. The second (optional) parameter "-silent" can be specified when calling the command from a script to avoid the output.'
  param '1: version'
  param '2: -silent'
  example 'set_java_home 1.6'
  group 'osx'

  if [ -z "$1" ] ; then
    local prefix="Usage: set_java_home "
    # Extract only the first two parts of the version number, e.g. '1.7', discard the rest of the lines
    # Then sort in ascending manner.
    for i in $(/usr/libexec/java_home -a x86_64 -V 2>&1 | sed -n 's/^[[:space:]]*\([[:digit:]]\.[[:digit:]]\).*/\1/p' | sort)
    do
      # Concatenate the prefix (either the beginning of the usage line, or a separator) and the current version number
      echo -n "$prefix$i"
      prefix=" | "
    done
    echo ""
    echo ""
    echo "Currently used: $JAVA_HOME"
  else
    local NEW_JAVA_HOME=$(/usr/libexec/java_home -v $1)

    if [ -z "$JAVA_HOME" ]
    then
      export PATH=$NEW_JAVA_HOME/bin:$PATH
    else
      export PATH=$(echo $PATH|sed -e "s:$JAVA_HOME/bin:$NEW_JAVA_HOME/bin:g")
    fi

    export JAVA_HOME=$NEW_JAVA_HOME

    if [ -z "$2" ] || [ $2 != "-silent" ] ; then
	  java -version
	fi
  fi
}
