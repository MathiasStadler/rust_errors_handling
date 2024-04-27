#!/bin/env bash
FILES_DIRECTORY="run_examples";
for FILE_NAME in "$FILES_DIRECTORY"/*;
   do
   echo "Processing $FILE_NAME file...";
   # SCRIPT_FILE="./$FILE_NAME.sh"
   # echo " => $SCRIPT_FILE";
   if echo ""| grep -q 'sh' ;then
    echo "";
    echo "#################";
    echo "start => $FILE_NAME";
    echo "#################";
    echo "";
    # shellcheck source=/dev/null
    EXIT_CODE=source "$FILE_NAME";
    echo "";
    echo "#################";
    echo "finished ..";
    printf "ExitCode => %s  <= %s \n" "$EXIT_CODE" "$FILE_NAME";
    echo "#################";
    echo "";
   else
    echo "NOT *.sh script => $FILE_NAME ";
    echo "next file ";
   fi
done

