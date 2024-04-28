#!/usr/bin/env bash
set -x
export MD_SCRIPT="./Rust_Error_Box_Dyn.md"
# export SCRIPTS_OUTPUT="./utilities/02_extract_rust_codeblocks_from_markdown.sh"
export DIRECTORY_OUTPUT="./examples"
# test markdown file exits
if [ -f ./$MD_SCRIPT ]; then
    echo "MD_SCRIPT exists => $MD_SCRIPT."
else
    echo "File does not exist => $MD_SCRIPT"
    return
fi
echo "DIRECTORY_OUTPUT => $DIRECTORY_OUTPUT"
echo "cleanup => $DIRECTORY_OUTPUT";
[ -d $DIRECTORY_OUTPUT ] && rmdir -fr "$DIRECTORY_OUTPUT"
echo "mkdir   => $DIRECTORY_OUTPUT";
[ ! -d $DIRECTORY_OUTPUT ] && mkdir "$DIRECTORY_OUTPUT"
# [ -f $SCRIPTS_OUTPUT ] && rm "$SCRIPTS_OUTPUT"
printf "\n" >$DIRECTORY_OUTPUT && sed -i '1 i\#\!\/usr\/bin\/env bash' $DIRECTORY_OUTPUT;
sed -n '/^```rust/,/^```/ p' <"$MD_SCRIPT"| sed '\/^```/ d' >> $DIRECTORY_OUTPUT
ls -l $DIRECTORY_OUTPUT
/bin/ls -ls "$SCRIPTS_OUTPUT" | awk '{print "",$10,$7,$8,$9}'
date +"%B %d %H:%M"
