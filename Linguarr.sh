#!/bin/bash

# Parameters
# OUTPUT: Folder where output files will be stored.
#         If not provided, /config/results/ is used.
#         $1 - Provided as first parameter
# CLEAN: If set to true, will delete the old output.
#        If not set true, will just append to old output.
#        $2 - Provided as second parameter

echo "**************************"
echo "* Setting up environment *"
echo "**************************"
echo
OUTPUT=$1
CLEAN=$2

if [[ ! ${OUTPUT: -1} == "/" ]]; then
	OUTPUT="$OUTPUT/"
fi

if [[ -f "/config/lang.conf" ]]; then
	echo "******************************"
	echo "* Loading languages to check *"
	echo "******************************"
	echo
	cp /config/lang.conf /dev/shm
else
	echo "************************************"
	echo "* Please create a lang.conf file   *"
	echo "* in your config folder            *"
	echo "* Put 1 language to check per line *"
	echo "************************************"
	exit 1
fi

if  [[ $CLEAN == "true" ]]; then
	echo "************************"
	echo "* Removing old results *"
	echo "************************"
	echo
	while read -r languages; do
		found="${OUTPUT}found_${languages}.txt"
		notfound="${OUTPUT}not_found_${languages}.txt"
		rm $found
		rm $notfound
	done < /dev/shm/lang.conf
elif [[ $CLEAN == "only" ]]; then
	echo "************************"
	echo "* Removing old results *"
	echo "************************"
	echo
	while read -r languages; do
		found="${OUTPUT}found_${languages}.txt"
		notfound="${OUTPUT}not_found_${languages}.txt"
		rm $found
		rm $notfound
	done < /dev/shm/lang.conf
	exit 0
else
	echo "**********************************"
	echo "* Not removing old results       *"
	echo "* Results might not be reliable! *"
	echo "**********************************"
	echo
fi

mkdir -p "$OUTPUT"
if [[ ! -d "${OUTPUT}" ]]; then
	echo "****************************************"
	echo "* Please provide a correct output path *"
	echo "****************************************"
	exit 1
fi

echo "*********************************"
echo "* Searching for all video files *"
echo "* Depending on your collection  *"
echo "* This might take a long time   *"
echo "*********************************"
echo
ls /mnt > /config/test.txt
find /mnt/media/ -type f -exec file -N -i -- {} + | sed -n 's!: video/[^:]*$!!p' > /dev/shm/videofiles
echo "******************************************"
echo "* Checking all video files for languages *"
echo "* This can take a long time!             *"
echo "******************************************"
echo
while read -r file; do
	lang="$(ffprobe -show_entries stream=codec_type:stream_tags=language -of compact -select_streams a "$file")"
	lang=${lang//stream|codec_type=audio/a}
	while read -r languages; do
		found="${OUTPUT}found_${languages}.txt"
		notfound="${OUTPUT}not_found_${languages}.txt"
		if [[ $lang == *$languages* ]]; then
			echo $file | tee -a "$found"
		else
			echo $file | tee -a "$notfound"
		fi
	done < /dev/shm/lang.conf
done < /dev/shm/videofiles
echo
echo "* Results can be found in: $OUTPUT *"
echo
exit 0

