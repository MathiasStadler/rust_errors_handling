#!/usr/bin/sh
set -x
FILES_DIR="examples";
SCRIPT_TARGET_DIR="run_examples";
# test SCRIPT_TARGET_DIR exits if MOT create it
[ ! -d $SCRIPT_TARGET_DIR ] && mkdir $SCRIPT_TARGET_DIR
# loop
for FILE_NAME in "$FILES_DIR"/*.rs;
do
    echo "";
    echo "START => Processing $FILE_NAME file...";
    if echo "$FILE_NAME"| grep -q 'rs' ;then
        
        # echo "FILE_NAME => $FILE_NAME";
        # SCRIPT_FILE_NAME="$FILE_NAME";
        # echo "generate SCRIPT_FILE => $STARTER_FILES_DIR/$(basename "$FILE_NAME")";
        # echo "script_file_name => $SCRIPT_FILE_NAME";
        
        PLAIN_NAME="$(echo "$(basename "$FILE_NAME")" | cut -d . -f 1)"
        echo "PLAIN_NAME => $PLAIN_NAME";
        
        SCRIPT_FILE_NAME="$PLAIN_NAME.sh";
        echo "SCRIPT_FILE_NAME => $SCRIPT_FILE_NAME"

        echo "path/script_name => => ./$SCRIPT_TARGET_DIR/$SCRIPT_FILE_NAME";
        
        # generate new file
        printf "\n" >"./$SCRIPT_TARGET_DIR/$SCRIPT_FILE_NAME";
        
        # add shebang
        sed -i '1 i\#\!\/usr\/bin\/env bash' "./$SCRIPT_TARGET_DIR/$SCRIPT_FILE_NAME";
        # add codeblock 
        sed -n '/^\/\*/,/^\*\// p' <"$FILE_NAME" >>"./$SCRIPT_TARGET_DIR/$SCRIPT_FILE_NAME";
        
        # remove codeblock marker
        # before code block
        sed -i 's/^\/\*//' "./$SCRIPT_TARGET_DIR/$SCRIPT_FILE_NAME";
        # after codeblock
        sed -i 's/^\*\///' "./$SCRIPT_TARGET_DIR/$SCRIPT_FILE_NAME";
    else
        echo "NOT *.rs script => $FILE_NAME";
        echo "next file ";
    fi
    #FINISHED
    echo "FINISH => Processing $SCRIPT_FILE_NAME file...";
    echo "";
done
# start root project folder
# sh +x ./utilities/03_generate_starter_script.sh

