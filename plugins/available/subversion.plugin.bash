cite about-plugin
about-plugin 'svn helper functions'

rm_svn(){
  about 'remove ".svn" files from directory'
  param '1: directory to search for files'
  group 'svn'

  if [ -z "$1" ]; then
      reference rm_svn
      return
  fi
  find $1 -name .svn -print0 | xargs -0 rm -rf
}

svn_add(){
    about 'add to svn repo'
    group 'svn'

    svn status | grep '^\?' | sed -e 's/? *//' | sed -e 's/ /\ /g' | xargs svn add
}

svn_url() {
	about 'print the SVN URL of the specified file'
	param '1: file to print the URL for'
	group 'svn'
	
	if [ -z "$1" ]; then
		local SVN_FILE="."
	else
		local SVN_FILE=$1
	fi
	
	svn info "$SVN_FILE" | grep "^URL:" | sed -e 's/^URL: //g'
}
