cite 'about-alias'
about-alias 'osx-specific aliases'

# Desktop Programs
alias preview="open -a '$PREVIEW'"
alias xcode="open -a '/Developer/Applications/Xcode.app'"
alias safari="open -a safari"
alias firefox="open -a firefox"
alias chrome="open -a google\ chrome"
alias f='open -a Finder '
alias fh='open -a Finder .'
alias textedit='open -a TextEdit'

if [ -s /usr/bin/firefox ] ; then
  unalias firefox
fi

# Requires growlnotify, which can be found in the Growl DMG under "Extras"
alias grnot='growlnotify -s -t Terminal -m "Done"'

# Get rid of those pesky .DS_Store files recursively
alias dsclean='find . -type f -name .DS_Store -print0 | xargs -0 rm'

# Track who is listening to your iTunes music
alias whotunes='lsof -r 2 -n -P -F n -c iTunes -a -i TCP@`hostname`:3689'

# Flush your dns cache
alias flush='dscacheutil -flushcache'

alias termnot='/Applications/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Terminal" -message "Done"'

# From http://apple.stackexchange.com/questions/110343/copy-last-command-in-terminal
alias copyLastCmd='fc -ln -1 | awk '\''{$1=$1}1'\'' ORS='\'''\'' | pbcopy'
