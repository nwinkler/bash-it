cite 'about-alias'
about-alias 'maven abbreviations'

# Helper function for automatically picking the correct
# Maven executable, either the global "mvn" one (fallback),
# or a local "./mvnw" script (preferred).
function _mvnw-detector() {
  # Default to the global "mvn" executable.
  local mvn_exe="mvn"

  # Check whether there is a local executable that we should run
  # instead of the global "mvn" command.
  if [[ -x "./mvnw" ]]; then
    mvn_exe="./mvnw"
  fi

  # Run the executable with any provided parameters
  "${mvn_exe}" "$@"
}

alias mci='_mvnw-detector clean install'
alias mi='_mvnw-detector install'
alias mcp='_mvnw-detector clean package'
alias mp='_mvnw-detector package'
alias mrprep='_mvnw-detector release:prepare'
alias mrperf='_mvnw-detector release:perform'
alias mrrb='_mvnw-detector release:rollback'
alias mdep='_mvnw-detector dependency:tree'
alias mpom='_mvnw-detector help:effective-pom'
alias mpro='_mvnw-detector help:active-profiles'
alias misk='mi -Dmaven.test.skip=true'
alias mcisk='mci -Dmaven.test.skip=true'
alias mjr='_mvnw-detector jetty:run'
alias mcpsk='mcp -Dmaven.test.skip=true'
