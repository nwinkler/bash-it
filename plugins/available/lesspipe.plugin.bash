cite about-plugin
about-plugin 'Configuration for lesspipe'

# Based on this: https://apple.stackexchange.com/a/364711/24130
# On macOS, install lesspipe with brew:
# brew install lesspipe

if _command_exists lesspipe.sh; then
  LESSPIPE_LOCATION=$(which lesspipe.sh)
  export LESSOPEN="|$LESSPIPE_LOCATION %s"
  export LESS_ADVANCED_PREPROCESSOR=1
fi
