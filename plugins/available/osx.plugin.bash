cite about-plugin
about-plugin 'osx-specific functions'

function tab() {
  about 'opens a new terminal tab'
  group 'osx'

  osascript 2>/dev/null <<EOF
    tell application "System Events"
      tell process "Terminal" to keystroke "t" using command down
    end
    tell application "Terminal"
      activate
      do script with command "cd \"$PWD\"; $*" in window 1
    end tell
EOF
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
  curl "$*" | open -fa "Preview"
}

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
    echo "Usage: set_java_home <version>"
    echo "To use 1.6, run: java_home 1.6"
    echo "To use 1.7, run: java_home 1.7"
    echo ""
    echo "Currently used: $JAVA_HOME"
    echo ""
    
    /usr/libexec/java_home -a x86_64 -V >/dev/null
  else
    local NEW_JAVA_HOME=$(/usr/libexec/java_home -v $1)
  
    if [ -z "$JAVA_HOME" ]
    then
      export PATH=$NEW_JAVA_HOME/bin:$PATH
    else
      export PATH=$(echo $PATH|sed -e "s:$JAVA_HOME/bin:$NEW_JAVA_HOME/bin:g")
    fi
      
    export JAVA_HOME=$NEW_JAVA_HOME
        
    if [ $2 != "-silent" ] ; then    
	  java -version
	fi
  fi
}
