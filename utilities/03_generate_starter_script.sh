#!/usr/bin/sh
set -x
FILES_DIR="examples";
STARTER_FILES_DIR="run_examples";
# test STARTER_FILES_DIR exits if not create
[ ! -d $STARTER_FILES_DIR ] && mkdir $STARTER_FILES_DIR
# loop
for FILE_NAME in "$FILES_DIR"/*.rs;
do
    echo "";
    echo "START => Processing $FILE_NAME file...";
    if echo "$FILE_NAME"| grep -q 'rs' ;then
        echo "FILE_NAME => $FILE_NAME";
        
        
        SCRIPT_FILE_NAME="$(basename "$FILE_NAME")";
        #      echo "generate SCRIPT_FILE => $STARTER_FILES_DIR/$(basename "$FILE_NAME")";
        echo "script_file_name => $SCRIPT_FILE_NAME";

        PLAIN_NAME="$(echo "$SCRIPT_FILE_NAME" | cut -d . -f 1)"
        
        echo "PLAIN_NAME => $PLAIN_NAME"
    fi
    
    #      # printf "\n" >"$SCRIPT_FILE_NAME" &&  S   sed -i '1 i\#\!\/usr\/bin\/env bash' "$SCRIPT_FILE_NAME";
    #      # sed -n '/^\/\*/,/^\*\// p' <"$FILE_NAME"|sed '/^\/\*/ d'|sed '/^\*\// d' >>"$SCRIPT_FILE_NAME";
    #  else
    #      echo "NOT *.rs script => $FILE_NAME ";
    #      echo "next file ";
    #  fi
    #FINISHED
    echo "FINISH => Processing $SCRIPT_FILE_NAME file...";
    echo "";
done
