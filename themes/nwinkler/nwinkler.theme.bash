#!/bin/bash

# Two line prompt showing the following information:
# (time) SCM [username@hostname] pwd (SCM branch SCM status)
# →
#
# Example:
# (14:00:26) ± [foo@bar] ~/.bash_it (master ✓)
# →
#
# The arrow on the second line is showing the exit status of the last command:
# * Green: 0 exit status
# * Red: non-zero exit status
#
# The exit code functionality currently doesn't work if you are using the 'fasd' plugin,
# since 'fasd' is messing with the $PROMPT_COMMAND


PROMPT_END_CLEAN="${green}→${reset_color}"
PROMPT_END_DIRTY="${red}→${reset_color}"

SCM_GIT_BEHIND_CHAR="↓"
SCM_GIT_AHEAD_CHAR="↑"
SCM_GIT_UNTRACKED_CHAR="?:"
SCM_GIT_UNSTAGED_CHAR="U:"
SCM_GIT_STAGED_CHAR="S:"

function prompt_end() {
  echo -e "$PROMPT_END"
}

function git_prompt_info {
  git_prompt_vars

  SCM_PROMPT+=" ${SCM_PREFIX}${SCM_BRANCH} "
  [[ -n "${SCM_GIT_AHEAD}" ]] && SCM_PROMPT+="${SCM_GIT_AHEAD} "
  [[ -n "${SCM_GIT_BEHIND}" ]] && SCM_PROMPT+="${SCM_GIT_BEHIND} "
  [[ -n "${SCM_GIT_STAGED}" ]] && SCM_PROMPT+="${SCM_GIT_STAGED} "
  [[ -n "${SCM_GIT_UNSTAGED}" ]] && SCM_PROMPT+="${SCM_GIT_UNSTAGED} "
  [[ -n "${SCM_GIT_UNTRACKED}" ]] && SCM_PROMPT+="${SCM_GIT_UNTRACKED} "
  [[ -n "${SCM_GIT_STASH}" ]] && SCM_PROMPT+="${SCM_GIT_STASH} "
  SCM_PROMPT+="${SCM_STATE}${SCM_SUFFIX}"

  echo -e "$SCM_PROMPT"
  #echo -e "$SCM_PREFIX$SCM_BRANCH$SCM_STATE$SCM_SUFFIX"
}

prompt_setter() {
  local exit_status=$?
  if [[ $exit_status -eq 0 ]]; then PROMPT_END=$PROMPT_END_CLEAN
    else PROMPT_END=$PROMPT_END_DIRTY
  fi
  # Save history
  history -a
  history -c
  history -r
  PS1="(\t) $(scm_char) [${blue}\u${reset_color}@${green}\H${reset_color}] ${yellow}\w${reset_color}$(scm_prompt_info) ${reset_color}\n$(prompt_end) "
  PS2='> '
  PS4='+ '
}

PROMPT_COMMAND=prompt_setter

SCM_THEME_PROMPT_DIRTY="${bold_red}✗${normal}"
SCM_THEME_PROMPT_CLEAN="${bold_green}✓${normal}"
SCM_THEME_PROMPT_PREFIX="("
SCM_THEME_PROMPT_SUFFIX=")"
