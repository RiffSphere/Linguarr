# Linguarr
Having a lot of video files, but not sure they are the correct language? Check them out now!

This script is created to be used in a docker container! It can run by itself, but you will need to edit it and pass the correct parameters.

The script will search for all video files in the "/media/" directory. Use docker to setup your media library to show up in "/media" inside the container. If not using docker, you can manually edit this location.

The first parameter needs to be a valid path, to save the results. The script will make the folder, and create 2 text files for each language. One file containing a list of files that have the language. Another file listing all files without the language.

The second parameter is the clean parameter. Options are "true", "only" or anything else for false. When running the script, it only adds text to the files. If you don't set the "true" option, you will have duplicate listings at best. At worst, if you changed the video but kept the same name, you might have wrong info.

Deleting is done based on your language settings. If you removed a language from the list, those files are not removed. Before changing the list, run the script with "only" as second parameter. Or, manually remove the output files.

The languages to check go in the /config/lang.conf file, 1 language per line.

The script makes use of /dev/shm for caching (ram). I could have stored the languages in variables, but I didn't. It does read the file for each video file. You can change /dev/shm with /config, or whatever. But it will probably run slower, and might keep your disks busy.

DISCLAIMER

This script comes as-is. It works for me, I can not guarantee it will work for you!
I tried to make it as secure as possible. By default nothing gets deleted, you have to tell it to do so. If your files get deleted (almost impossible) or corrupted, I can't help you.
This is my first real bash script. Be nice! This does what I wanted it to do. It's not pretty, not the most optimal code, but it works. For me at least.
