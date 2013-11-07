if [[ $BASH_PREVIEW ]];
then 
  unset BASH_PREVIEW #Prevent infinite looping
  echo "

  Previewing Bash-it Themes

  "

  THEMES="$BASH_IT/themes/*/*.theme.bash"
  for theme in $THEMES
  do
    BASH_IT_THEME=$(basename $theme | sed "s/.theme.bash//")
    echo "
    $BASH_IT_THEME"
    echo "" | bash --init-file $BASH_IT/bash_it.sh -i
  done
fi
