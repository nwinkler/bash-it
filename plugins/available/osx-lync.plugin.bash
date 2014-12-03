cite about-plugin
about-plugin 'osx-specific functions for Microsoft Lync'

# Running this for the first time will cause a prompt asking you to allow Terminal
# to use the assistive services of OS X. You need to allow to this use these functions.
# This is due to the fact that Lync does not offer a real AppleScript interface, the only
# interaction is through the UI (the menu in this case).

function lync-away() {
  about 'Sets Lync status to "Appear Away"'
  group 'osx-lync'

  _lync-status "Appear Away"
}

function lync-busy() {
  about 'Sets Lync status to "Busy"'
  group 'osx-lync'

  _lync-status "Busy"
}

function lync-available() {
  about 'Sets Lync status to "Available"'
  group 'osx-lync'

  _lync-status "Available"
}

function lync-dnd() {
  about 'Sets Lync status to "Do Not Disturb"'
  group 'osx-lync'

  _lync-status "Do Not Disturb"
}

function _lync-status() {
  osascript 2>/dev/null <<EOF
  -- Save your current application
  tell application "System Events"
    set currentApp to name of 1st process whose frontmost is true
  end tell

  -- Bring Lync to the front so we can use the menu
  tell application "Microsoft Lync"
    activate
  end tell

  -- Set your status to 'Available'
  tell application "System Events"
    tell process "Microsoft Lync"
      tell menu bar 1
        tell menu bar item "Status"
          tell menu "Status"
            click menu item "$1"
          end tell
        end tell
      end tell
    end tell
  end tell

  -- Return to your previous application
  tell application currentApp
    activate
  end tell
EOF
}
