#!/bin/bash

# you may override any of the exported variables below in your .bash_profile

if [ -z "$TODOTXT_DEFAULT_ACTION" ]; then
    export TODOTXT_DEFAULT_ACTION=ls       # typing 't' by itself will list current todos
fi

# respect ENV var set in .bash_profile, default is 't'
alias t='todo.sh'

complete -F _todo t                # enable completion for 't' alias
