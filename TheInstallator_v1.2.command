#!/bin/bash


#===========================================================================================================|
# Script Name: TheInstallator.command																																				|
#																																																						|
# Author: Alex Fouquet & Siegfried Oblinger																																	|
# Date : 06.01.2020																																													|
#	Version:1.2																																																|
# Description: The following script installs files .dmg that are in the same directory as this script!			|
# This is usfull for installing lots of .dmg files at once.																									|
#																																																						|
# Run Information: this is a .command script and can be run from finder!																		|
#										authenticate once to start install																																												|
#																																																						|
# Error Log: Any errors or output associated with the script will be displayed in termianl									|
#===========================================================================================================|

#responsible for placing the shell session in the same directory as this script
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  TARGET="$(readlink "$SOURCE")"
  if [[ $TARGET == /* ]]; then
    echo "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'"
    SOURCE="$TARGET"
  else
    DIR="$( dirname "$SOURCE" )"
    echo "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')"
    SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  fi
done
echo "SOURCE is '$SOURCE'"
RDIR="$( dirname "$SOURCE" )"
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
if [ "$DIR" != "$RDIR" ]; then
  echo "DIR '$RDIR' resolves to '$DIR'"
fi
echo "DIR is '$DIR'"

cd "$DIR" #shell session is now where this script is



#declaration of array for holding the path to .dmg files
declare -a my_array

    while read -r -d ''; do
      my_array+=("$REPLY")
    done < <(find "${PWD%/*}" -name '*.dmg' -print0 2>/dev/null)

    for i in "${my_array[@]}" #here we iterate through our .dmg files stored in my_array

    do
	     :
       echo "filepath is: $i"

	      unusablepath=$(hdiutil mount "$i" | grep /Volumes  | sed "s/.*\(Volumes\/\)/\1/")
	       #Manipulate String: Search for Spaces and replace with "\ ".
	        var1=$(echo ${unusablepath//\ /\\\ })
	         var1=$(echo ${var1/Volumes/\/Volumes})
	          var1="$var1 /"
	           var1=$(echo ${var1/\ \//\/})
	            var1="$(echo ${var1//\ /?})"
	             var2="$(echo ${var1//\\/})"
	              #dublle and single quotes are important!!

	var_unmount="$var2" # var2 is copied here to be used as the unmount path for the hdiutil

	cd "$var2"

	#ls musst later be substitutet with find!
	pkg=$(ls | grep pkg)

	sudo installer -package "$pkg" -target / #installing pkg files

	#this is why var2 was copied
	detach=$(hdiutil detach -verbose "$var_unmount" )


#rm -h $toinstall / Deleting the first .dmg so the loop can take the next from array-> my_array
#echo "I will wait 3 seconds"

done

  echo "We are done!"
  #shutdown now!  goes here!
