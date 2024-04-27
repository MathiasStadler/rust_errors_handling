#!/usr/bin/env bash

#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="01_ok_ignore_error.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE

use std::fs;

pub fn main() {
  let content = fs::read_to_string("./Cargo.toml").unwrap();
  println!("{}", content)
}

/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
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
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="01_err_ignore_error.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE

use std::fs;

pub fn main() {
  let content = fs::read_to_string("./Not_Exists_Cargo.toml").unwrap();
  println!("{}", content)
}

/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
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
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="02_ok_terminate_the_program.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE

use std::fs;

pub fn main() {
  let content = fs::read_to_string("./Cargo.toml").expect("Can't read Cargo.toml");
  println!("{}", content)
}

/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
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
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="02_err_terminate_the_program.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
use std::fs;

pub fn main() {
  let content = fs::read_to_string("./Not_Exists_Cargo.toml")
    .expect("Can't read ./Not_Exists_Cargo.toml");
  println!("{}", content)
}

/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
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
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="03_ok_use_fallback_value.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
use std::env;

pub fn main() {
  let port = env::var("PORT").unwrap_or("3000".to_string());
  println!("{}", port);
}

/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
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
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="03_err_use_fallback_value.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
use std::env;

pub fn main() {
  let port = env::var("PORT").unwrap_or("3000".to_string());
  println!("{}", port);
}

/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
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
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="04_ok_bubble_up_the_error.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
// FORM HERE
// https://www.sheshbabu.com/posts/rust-error-handling/

use std::collections::HashMap;

fn get_current_date() -> Result<String, reqwest::Error> {
  let url = "https://postman-echo.com/time/object";
  let result = reqwest::blocking::get(url);

  let response = match result {
    Ok(res) => res,
    Err(err) => return Err(err),
  };

  let body = response.json::<HashMap<String, i32>>();

  let json = match body {
    Ok(json) => json,
    Err(err) => return Err(err),
  };

  let date = json["years"].to_string();

  Ok(date)
}  

pub fn main() {
  match get_current_date() {
    Ok(date) => println!("We've time travelled to {}!!", date),
    Err(e) => eprintln!("Oh noes, we don't know which era we're in! :( \n  {}", e),
  }
}

/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
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
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="99_template.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
pub fn main(){

    println!("template");
}

/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
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
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
