cite about-plugin
about-plugin 'Helpers to get Docker setup correctly for docker-machine'

[ -z ${BASH_IT_DOCKER_MACHINE+x} ] && BASH_IT_DOCKER_MACHINE='dev'

if [[ `uname -s` == "Darwin" ]]; then
  function docker-machine-eval {
    group "docker-machine"
    about "Reloads and sets the Docker Machine settings in the local shell session. Set the machine name using the BASH_IT_DOCKER_MACHINE variable (default: dev)"

    # check if dev machine is running
    docker-machine ls | grep --quiet "$BASH_IT_DOCKER_MACHINE.*Running"
    if [[ "$?" = "0" ]]; then
      eval "$(docker-machine env $BASH_IT_DOCKER_MACHINE)"
    fi
  }

  # Run it rightaway
  docker-machine-eval
fi
