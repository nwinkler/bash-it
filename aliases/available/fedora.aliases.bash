alias ycu="yum check-update"
alias yu="sudo yum --skip-broken --changelog -y update"
alias yi="sudo yum install"
alias yr="sudo yum remove"
 
alias rpmg="rpm -qa|grep"
alias rpmq="rpm -q --qf '%{name}-%{version}-%{release}.%{arch}\n'"

alias sag="keychain -q ~/.ssh/id_dsa; . ~/.keychain/$(hostname)-sh"
alias sagk="keychain --stop all"

