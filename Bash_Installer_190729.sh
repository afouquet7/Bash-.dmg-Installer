#!/bin bash
#
# Script Name: Bash_Installer.sh
#
# Author: Alex Fouquet & Siegfried Oblinger
# Date : 29.07.2019
#	Version:0.4
# Description: The following script installs .dmg files from a pre determinated folder
# set in the variable my_array / This script should make the installation of Pro Tools plugins faster.
#
# Run Information: this script musst be run with sh in terminal
#
#
# Error Log: Any errors or output associated with the script will be displayed in termianl
#

#path to install folder is an array with I
my_array=(find /Volumes/MrSmith/06_Bash_project/zz_watchFolder/*.dmg) #OSX path

#my_array=(find /d/06_Bash_project/zz_watchFolder/*.dmg) #windows path

echo $my_array

for i in "${my_array[@]}"

do
	:
 echo "filepath is: $i"

	unusablepath=$(hdiutil mount "$i" | grep /Volumes  | sed "s/.*\(Volumes\/\)/\1/")
	#Manipulate String: Search for Spaces and replace with "\ ".
	var1=$(echo ${unusablepath//\ /\\\ })
	#Not in use bc there was a cd append in almostpath: Take the first Space - between "cd/" and "/Volumes" and delete it by repalcing it with nothing
	var1=$(echo ${var1/Volumes/\/Volumes})
	var1="$var1 /"
	var1=$(echo ${var1/\ \//\/})
	#replace whitespace with *
	var1="$(echo ${var1//\ /?})"
	var2="$(echo ${var1//\\/})"
	#dublle and single quotes are fucking important!!
	#String manipulation has to be rewritten with sed other wise it will only work for a specific number of lines!

	var_unmount="$var2"

	cd "$var2"
	#echo "after mount var_unmount is holding:$var_unmount"
	#echo "pwd here before install"
	#pwd

	#ls musst later be substitutet with find!
	pkg=$(ls | grep pkg)
	echo $pkg

	sudo installer -package "$pkg" -target /

	#path to origin watch folder
	cd ~
	echo"I will sleep for 8 seconds in order to unmount"
	sleep $8

	echo "after install var1 is holding:$var_unmount"
	detach=$(hdiutil detach -verbose "$var_unmount" )
	#hdiutil unmount -verbose $var_unmount


	#pwd
	#rm -h $toinstall / Deleting the first .dmg so the loop can take the next from array-> my_array
	#echo "I will wait 3 seconds"

done
	#echo "Install complete good night!"
	#shutdown now!  goes here!

echo "End of File.sh"
