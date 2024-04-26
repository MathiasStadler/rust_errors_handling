#!/usr/bin/env bash
set -eux
STARTER_FILES_DIR="run_examples";
# test STARTER_FILES_DIR exits if not create
[ ! -d $STARTER_FILES_DIR ] && mkdir $STARTER_FILES_DIR
# loop
for FILE_NAME in examples/*;
   do
   echo "";
   echo "START => Processing $FILE_NAME file...";
   if [[ $FILE_NAME == *rs ]]; then
   SCRIPT_FILE="./examples/README.sh"
   echo "SCRIPT_FILE => $SCRIPT_FILE";
   SCRIPT_FILE_NAME="$STARTER_FILES_DIR/$(basename $SCRIPT_FILE).sh";
   echo "generate SCRIPT_FILE => $STARTER_FILES_DIR/$(basename $SCRIPT_FILE)";
   echo "script_file_name => $SCRIPT_FILE_NAME";
   printf "\n" >"$SCRIPT_FILE_NAME" &&     sed -i '1 i\#\!\/usr\/bin\/env bash' "$SCRIPT_FILE_NAME";
   sed -n '/^\/\*/,/^\*\// p' <"$FILE_NAME"|sed '/^\/\*/ d'|sed '/^\*\// d' >>"$SCRIPT_FILE_NAME";
   else
   echo "NOT *.rs script => $FILE_NAME ";
   echo "next file ";
   fi
   echo "FINISH => Processing $SCRIPT_FILE_NAME file...";
   echo "";
done
