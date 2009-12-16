#!/bin/bash
 
find /home/kenglish/NetBeansProjects/mest/public/javascripts/ext-3.0.0/ -type f | grep images | while read FILE; do

  echo $FILE 
  #if [[ "$DIR" =~ \([0-9]{4}\)$ ]]; then
  #  NEW_DIR=`echo $DIR | sed 's/(\([0-9][0-9][0-9][0-9]\))$/[\1]/'`
  #  echo "$DIR    -->    $NEW_DIR" 
   ` cp "$FILE" . `
  #fi
done
