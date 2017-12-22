cite about-plugin
about-plugin 'maven helper functions'

maven-fuzzy-delete () {
  about 'Deletes directories from the local Maven repository using fuzzy search, requires fzf: https://github.com/junegunn/fzf'
  group 'maven'
  param '1: query parameter for fzf (optional)'
  example 'maven-fuzzy-delete log4j'

  # Only find directories
  # Run fzf in multi-select mode (TAB)
  # Use fzf preview defaults, e.g. with a preview window
  DIR_ARRAY=($(find "$HOME/.m2/repository" -type d | fzf --query="$1" -m))

  # Don't do anything if nothing was selected.
  if [ ${#DIR_ARRAY[@]} -gt 0 ]; then
    echo ${DIR_ARRAY[@]} | xargs rm -vrf
  fi
}

maven-fuzzy-find () {
  about 'Finds POM files in the local Maven repository using fuzzy search, requires fzf: https://github.com/junegunn/fzf'
  group 'maven'
  param '1: query parameter for fzf (optional)'
  example 'maven-fuzzy-find log4j'

  local SELECTED

  # Only find .pom files
  # Use fzf preview defaults, e.g. with a preview window
  SELECTED=$(find "$HOME/.m2/repository" -type f -name '*.pom' | fzf --query="$1")

  # Don't do anything if nothing was selected.
  if [ -n "${SELECTED}" ]; then
    echo ${SELECTED}
  fi
}

usemvn () {
  about 'Switches between available Maven versions for the current shell. Lists the available Maven versions if called without a parameter. The root directory for Maven installations can be defined using the variable MAVEN_INSTALL_ROOT. If this is not defined, /usr/local is assumed. The Maven directories under this directory are expected to be named apache-maven-*'
  group 'maven'
  param '1: Maven version to switch to'
  example 'usemvn 3.0.4'

  if [ -z "$MAVEN_INSTALL_ROOT" ]
  then
    local MAVEN_INSTALL_ROOT="/usr/local"
  fi

  if [ -z "$1" -o ! -x "$MAVEN_INSTALL_ROOT/apache-maven-$1/bin/mvn" ]
  then
    echo "Looking for Maven installations in $MAVEN_INSTALL_ROOT/apache-maven-*"
    local prefix="Syntax: usemvn "
    for i in $MAVEN_INSTALL_ROOT/apache-maven-*
    do
      if [ -x "$i/bin/mvn" ]; then
        echo -n "$prefix$(basename $i | sed 's/^apache-maven-//')"
        prefix=" | "
      fi
    done
    echo ""
  else
    # Undefine M2_HOME if it is defined, as it gets in the way. Use MAVEN_HOME instead, which works for both Maven 2 and 3.
    if [ -n "$M2_HOME" ]
  then
    unset M2_HOME
  fi

  if [ -z "$MAVEN_HOME" ]
    then
      export PATH=$MAVEN_INSTALL_ROOT/apache-maven-$1/bin:$PATH
    else
      export PATH=$(echo $PATH|sed -e "s:$MAVEN_HOME/bin:$MAVEN_INSTALL_ROOT/apache-maven-$1/bin:g")
    fi
    export MAVEN_HOME=$MAVEN_INSTALL_ROOT/apache-maven-$1
  fi
}

_usemvn-comp() {
  local cur
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"

  if [ -z "$MAVEN_INSTALL_ROOT" ]
  then
    local MAVEN_INSTALL_ROOT="/usr/local"
  fi

  local mvn_versions=$(for i in $MAVEN_INSTALL_ROOT/apache-maven-* ;
  do
    if [ -x "$i/bin/mvn" ]; then
      basename $i | sed 's/^apache-maven-//'
    fi
  done)

  COMPREPLY=( $(compgen -W "${mvn_versions}" -- ${cur}) )

  return 0
}

complete -F _usemvn-comp usemvn
