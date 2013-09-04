cite about-plugin
about-plugin 'Audio Conversion Tools'

function mp3_to_wav() {
	about 'Convert an MP3 file to a WAV file. The WAV file will be created in the current directory'
	group 'audio'
	
	local orig_name=`basename "$1"`
	local file_name=$( echo ${orig_name} | awk -F. '{ print $1 }' ).wav
	
	echo "Decoding to ${file_name}" 
	
	lame --decode "${orig_name}" ./"${file_name}"
}

function aac_to_wav() {
	about 'Convert an AAC (MP4, m4a) file to a WAV file. The WAV file will be created in the current directory'
	group 'audio'
	
	local orig_name=`basename "$1"`
	local file_name=$( echo ${orig_name} | awk -F. '{ print $1 }' ).wav
	
	echo "Decoding to ${file_name}" 
	
	faad -o ./"${file_name}" "${orig_name}" 
}
