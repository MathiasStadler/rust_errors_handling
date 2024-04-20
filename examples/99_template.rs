
fn main(){

    println!("template");
}

/*
export FILE_NAME=99_template.rs
export FILE_DIR_NAME=examples/errors_handling
git add $FILE_DIR_NAME/$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => $FILE_DIR_NAME/$FILE_NAME"
git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files
git commit --all --message="-> Add AFTER housekeeping => $FILE_DIR_NAME/$FILE_NAME"
git push
cargo run --example $(echo $FILE_DIR_NAME/$FILE_NAME | cut -d . -f 1)
echo "ReturnCode => $?"
*/
