#!/bin/bash

PROMPT_END_CLEAN="${green}→${reset_color}"
PROMPT_END_DIRTY="${red}→${reset_color}"

function prompt_end() {
  echo -e "$PROMPT_END"
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

SCM_THEME_PROMPT_DIRTY=" ✗"
SCM_THEME_PROMPT_CLEAN=" ✓"
SCM_THEME_PROMPT_PREFIX=" ("
SCM_THEME_PROMPT_SUFFIX=")"
RVM_THEME_PROMPT_PREFIX=" ("
RVM_THEME_PROMPT_SUFFIX=")"
