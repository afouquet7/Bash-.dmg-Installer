#!/usr/bin/env bash


#===========================================================================================================|
# Script Name: watcher.sh																															            					|
#																																																						|
# Author: Alex Fouquet                    																																	|
# Date : 18.02.2020																																													|
#	Version:1.0																																																|
# Description: The following script runs an infit loop with inotifywait, in the inputDir it waits for .mov 	|
#              files and converts them to .mxf files. The converted files are than moved to the converted		|
#							 directory and the new .mxf files are placed in the outpudirectory.                       		|
# Run Information: this script needs to be run in bash 		                                                  |
#              the script works with the following directory structure:  watchfolder/input     							|
#									                                      									watchfolder/output								|
#																																					watchfolder/converted							|
# Error Log: Any errors or output associated with the script will be displayed in termianl									|
#===========================================================================================================

inputDir="/home/arrisound/Desktop/watchfolder/input" #path of watchdir
convertedDir="/home/arrisound/Desktop/watchfolder/converted" #path of converted dir

inotifywait -e close_write -m --format '%w%f' "${inputDir}" | while read inputFile #watches dir for file changes
do

#inotifywait waits checks for changes in directory
# -e close_write ẃaits for files to be wirten (finished copy)
# -m to monitor the directory indefinitely (so script can run in loop alway waiting for new files)
#--format '%w%f' will print out the file in the complete path with file name
#${inputDir} is the path of the input directory

#  echo $inputFile #shows path of inputFile

    outputArray="$inputFile" #copied path of inputFile
    outputArray="${outputArray//.mov/}" #modified the file extension taking .mov out
    outputArray="${outputArray//input/output}" #changed the path of outputfile to ouputdir
    convertedArray="$inputFile" #copied path of InputFile so it can be moved after conversion

#ffmpeg porsion -> here the file gets converted
    ffmpeg -i $inputFile -c:v dnxhd -vf "scale=1920:1080, format=yuv422p" -b:v 36M -an $outputArray.mxf


    mv $convertedArray $convertedDir #moving converted file to convertedDir

    echo "I will loop again!"

done
