#!/usr/bin/env bash
export MD_SCRIPT="./Rust_Error_Box_Dyn.md";
export SCRIPTS_OUTPUT="./utilities/02_extract_rust_codeblocks_from_markdown.sh";
export DIRECTORY_OUTPUT="./examples";
# test markdown file exits
if [ -f ./$MD_SCRIPT ]; then
    echo "MD_SCRIPT exists => $MD_SCRIPT.";
else
    echo "File does not exist => $MD_SCRIPT";
    return;
fi
echo "DIRECTORY_OUTPUT directory => $DIRECTORY_OUTPUT";
echo "cleanup => $DIRECTORY_OUTPUT";
[ -d $DIRECTORY_OUTPUT ] && rm -fr "$DIRECTORY_OUTPUT";
echo "create new: mkdir   => $DIRECTORY_OUTPUT";
[ -d $DIRECTORY_OUTPUT ] || mkdir "$DIRECTORY_OUTPUT";
echo "cleanup => $SCRIPTS_OUTPUT";
[ -f $SCRIPTS_OUTPUT ] && rm "$SCRIPTS_OUTPUT";
echo "create script_output =>$SCRIPTS_OUTPUT";
printf "\n" >$SCRIPTS_OUTPUT && sed -i '1 i\#\!\/usr\/bin\/env bash' $SCRIPTS_OUTPUT;
sed -n '/^```rust/,/^```/ p' <"$MD_SCRIPT"| sed '\/^```/ d' >> $SCRIPTS_OUTPUT;
ls -l $SCRIPTS_OUTPUT;
/bin/ls -ls "$SCRIPTS_OUTPUT" | awk '{print "",$10,$7,$8,$9}';
date +"%B %d %H:%M";
