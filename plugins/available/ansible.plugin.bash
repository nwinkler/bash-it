cite about-plugin
about-plugin 'Ansible Helper Functions'

if [[ $(uname -s) == "Darwin" ]]; then

  function ansible-add-vault-password-to-macOS-keychain() {
    about 'Adds the provided password for the current directory''s Ansible vault to the macOS keychain'
    group 'ansible'
    param '1: The password to use for the current directory'
    example 'ansible-add-macOS-keychain F00L'
    # Reference: https://coderwall.com/p/cjiljw/use-macos-keychain-for-ansible-vault-passwords

    if [ -n "$1" ]; then
      security add-generic-password -a ansible_vault_$(basename "$PWD" | sed -e 's/ /-/g') -s ansible -w $1
    else
        reference ansible-add-macOS-keychain
    fi
  }

fi
