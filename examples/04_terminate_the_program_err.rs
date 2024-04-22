use std::fs;

fn main() {
    let content = fs::read_to_string("./Err_Cargo.toml").expect("Can't read Err_Cargo.toml");
    println!("{}", content)
}

/*
export FILE_NAME=04_terminate_the_program_err.rs
export FILE_DIR_NAME=examples/
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
cargo run --example $(echo $FILE_NAME | cut -d . -f 1)
echo "ReturnCode => $?"
*/
