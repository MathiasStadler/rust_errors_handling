# FROM HERE

- [FROM HERE](https://www.sheshbabu.com/posts/rust-error-handling/)
- - [GITHUB REPO](https://github.com/sheshbabu/rust-error-handling-examples/tree/master)
- [good tut rust basic](http://saidvandeklundert.net/learn/)

## Beginner's guide to Error Handling in Rust

<details>
    <summary>Generate scripts from markdown</summary>

## first step - extract all rust code block from markdown file

```bash
#!/usr/bin/env bash
set -e
#xuo
export SCRIPT_FILE="01_generate_extract_rust_codeblock_from_md.sh"
export SCRIPT_DIR="utilities"
cat << EoF > ./$SCRIPT_DIR/$SCRIPT_FILE
#!/usr/bin/env bash
export MD_SCRIPT="./Rust_Error_Box_Dyn.md";
export SCRIPTS_OUTPUT="./utilities/02_extract_rust_codeblocks_from_markdown.sh";
export DIRECTORY_OUTPUT="./examples";
# test markdown file exits
if [ -f ./\$MD_SCRIPT ]; then
    echo "MD_SCRIPT exists => \$MD_SCRIPT.";
else
    echo "File does not exist => \$MD_SCRIPT";
    return;
fi
echo "DIRECTORY_OUTPUT directory => \$DIRECTORY_OUTPUT";
echo "cleanup => \$DIRECTORY_OUTPUT";
[ -d \$DIRECTORY_OUTPUT ] && rm -fr "\$DIRECTORY_OUTPUT";
echo "create new: mkdir   => \$DIRECTORY_OUTPUT";
[ -d \$DIRECTORY_OUTPUT ] || mkdir "\$DIRECTORY_OUTPUT";
echo "cleanup => \$SCRIPTS_OUTPUT";
[ -f \$SCRIPTS_OUTPUT ] && rm "\$SCRIPTS_OUTPUT";
echo "create script_output =>\$SCRIPTS_OUTPUT";
printf "\n" >\$SCRIPTS_OUTPUT && sed -i '1 i\#\!\/usr\/bin\/env bash' \$SCRIPTS_OUTPUT;
sed -n '/^\`\`\`rust/,/^\`\`\`/ p' <"\$MD_SCRIPT"| \
sed '\/^\`\`\`/ d' >> \$SCRIPTS_OUTPUT;
ls -l \$SCRIPTS_OUTPUT;
# /bin/ls -ls "\$SCRIPTS_OUTPUT" | awk '{print "",\$10,\$7,\$8,\$9}';
# date +"%B %d %H:%M";
EoF
```

## next step - run generate script

```bash
#!/usr/bin/env bash
# change to PROJECT_FOLDER
sh +x ./utilities/01_generate_extract_rust_codeblock_from_md.sh
```

```bash
.
.
create script_output =>./utilities/02_extract_rust_codeblocks_from_markdown.sh
.
.

```

## next step - run generated example script

```bash
#!/usr/bin/env bash
# change to PROJECT_FOLDER
sh +x ./utilities/02_extract_rust_codeblocks_from_markdown.sh
```

## next step - extract generate starter scripts from each example

```bash
export SCRIPT_FILE="03_generate_starter_script.sh"
export SCRIPT_DIR="utilities"
cat << EoF > ./$SCRIPT_DIR/$SCRIPT_FILE
#!/usr/bin/env bash
#show command line
# set -x
FILES_DIR="examples";
SCRIPT_TARGET_DIR="run_examples";
# test SCRIPT_TARGET_DIR exits if MOT create it
[ ! -d \$SCRIPT_TARGET_DIR ] && mkdir \$SCRIPT_TARGET_DIR
# loop
for FILE_NAME in "\$FILES_DIR"/*.rs;
do
    echo "";
    echo "START => Processing \$FILE_NAME file...";
    if echo "\$FILE_NAME"| grep -q 'rs' ;then

        # echo "FILE_NAME => \$FILE_NAME";
        # SCRIPT_FILE_NAME="$(basename "\$FILE_NAME")";
        # echo "generate SCRIPT_FILE => \$STARTER_FILES_DIR/\$(basename "\$FILE_NAME")";
        # echo "script_file_name => \$SCRIPT_FILE_NAME";

        PLAIN_NAME="\$(echo "\$(basename "\$FILE_NAME")" | cut -d . -f 1)"
        echo "PLAIN_NAME => \$PLAIN_NAME";

        SCRIPT_FILE_NAME="\$PLAIN_NAME.sh";
        echo "SCRIPT_FILE_NAME => \$SCRIPT_FILE_NAME"

        echo "path/script_name => => ./\$SCRIPT_TARGET_DIR/\$SCRIPT_FILE_NAME";

        # generate new file
        printf "\n" >"./\$SCRIPT_TARGET_DIR/\$SCRIPT_FILE_NAME";

        # add shebang
        sed -i '1 i\#\!\/usr\/bin\/env bash' "./\$SCRIPT_TARGET_DIR/\$SCRIPT_FILE_NAME";
        # add codeblock
        sed -n '/^\/\*/,/^\*\// p' <"\$FILE_NAME" >>"./\$SCRIPT_TARGET_DIR/\$SCRIPT_FILE_NAME";

        # remove
        # codeblock marker
        # before code block
        sed -i 's/^\/\*//' "./\$SCRIPT_TARGET_DIR/\$SCRIPT_FILE_NAME";
        # after codeblock
        sed -i 's/^\*\///' "./\$SCRIPT_TARGET_DIR/\$SCRIPT_FILE_NAME";
        # git push - minimize from too many git push during run
        sed -i 's/git push//' "./\$SCRIPT_TARGET_DIR/\$SCRIPT_FILE_NAME";
    else
        echo "NOT *.rs script => \$FILE_NAME";
        echo "next file ";
    fi
    #FINISHED
    echo "FINISH => Processing \$SCRIPT_FILE_NAME file...";
    echo "";
done
echo "check return code !!!"
echo "echo \\\$?";

EoF
```

## next step - run generate starter script

```bash
#!/usr/bin/env bash
# change to PROJECT_FOLDER
sh +x ./utilities/03_generate_starter_script.sh
```

## next step - run all generated starter script for each examples

```bash
#!/usr/bin/env bash
export SCRIPT_FILE="04_run_all_generate_starter_script.sh"
export SCRIPT_DIR="utilities"
cat << EoF > ./$SCRIPT_DIR/$SCRIPT_FILE
#!/usr/bin/env bash
FILES_DIRECTORY="run_examples";
FILES_DIRECTORY_ALL="run_all_examples";
# copy starter files and modify
# cp -a ./run_examples/ ./run_all_examples
cp -a ./"\$FILES_DIRECTORY"/* ./"\$FILES_DIRECTORY_ALL"

# build all example
cargo build;

for FILE_NAME in "\$FILES_DIRECTORY_ALL"/*;
   do
   # comment cargo check for each starter script
   # avoid double/multiple run cargo check
   sed -i 's/^cargo check/# cargo check/' "./\$FILE_NAME";
   # remove/comment cargo clippy , cargo check for each starter script
   # avoid double/multiple run cargo clippy
   sed -i 's/^cargo clippy/# cargo clippy/' "./\$FILE_NAME";
   # remove/comment cargo fmt for each starter script
   # avoid unnecessary fmt not save any change
   sed -i 's/^cargo fmt/# cargo fmt/' "./\$FILE_NAME";
   # avoid unnecessary git action script already save inside md file
   sed -i 's/^git/# git/' "./\$FILE_NAME";
   echo "Processing \$FILE_NAME file...";
   if echo "\$FILE_NAME"| grep -q 'sh' ;then
    echo "";
    echo "#################";
    echo "start => \$FILE_NAME";
    echo "#################";
    echo "";
    # shellcheck source=/dev/null
    EXIT_CODE=source sh +x "\$FILE_NAME";
    echo "";
    echo "#################";
    echo "finished ..";
    printf "ExitCode => %s  <= %s \n" "\$EXIT_CODE" "\$FILE_NAME";
    echo "#################";
    echo "";
   else
    echo "NOT *.sh script => \$FILE_NAME ";
    echo "next file ";
   fi
done;
echo "finished ..";


EoF
```

## next step - run starter script

```bash
#!/usr/bin/env bash
# change to PROJECT_FOLDER
sh +x ./utilities/04_run_all_generate_starter_script.sh
```

## next step - project cleanup

```bash
#!/usr/bin/env bash
export SCRIPT_FILE="99_project_cleanup.sh"
export SCRIPT_DIR="utilities"
cat << EoF > ./$SCRIPT_DIR/$SCRIPT_FILE
#!/usr/bin/env bash
echo "Do you want cleanup this project ? Type => yes";
read -r  clean_up;
if [ "$clean_up" = "yes" ];then
  echo "cleanup" && \
  cargo clean && \
  cargo clean --release
  ls -l ./target
else
  echo "Do nothing. By :-)";
fi

EoF
```

## next step - run cleanup script

```bash
#!/usr/bin/env bash
# change to PROJECT_FOLDER
sh +x ./utilities/99_project_cleanup.sh
```

## nice knowing - run rust script with Cargo.toml from [another](https://www.nativespeakeronline.com/confusing-words/the-difference-between-another-other-and-different) / different path

```bash
#!/usr/bin/env bash
cd && \
cd /tmp && \
cargo run \
--manifest-path /home/trapapa/rust_errors_handling/Cargo.toml \
--example 03_err_use_fallback_value
```

## nice knowing - create new script with shebang

```bash
#!/usr/bin/env bash
FILE="/tmp/shebang_insert.sh";
printf "\n" >$FILE && sed -i '1 i\#\!\/usr\/bin\/env bash' $FILE && \
cat $FILE;
```

</details>

## basic

- The Result<T, E> type is an enum that has two variants
- - Ok(T) for successful value or
- - Err(E) for error value

```bash
 enum Result<T, E> {
   Ok(T),
   Err(E),
}
```

## 01 - ignore the error - NOT nice error handling

- Let’s start with the simplest scenario where we just ignore the error.
  - This sounds careless but has a couple of legitimate use cases:
    - We’re prototyping our code and don’t want to spend time on error handling.
    - We’re confident that the error won’t occur.

### Ok - MatchArms

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="01_ok_use_unwrap_ignore_error.rs"
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
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

- output

```bash
Running `target/debug/examples/01_ok_ignore_error`
[package]
name = "rust_errors_handling"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]

ReturnCode => 0
```

### Error - MatchArms

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="01_err_use_unwrap_ignore_error.rs"
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
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

- output

```bash
Running `target/debug/examples/01_err_ignore_error`
thread 'main' panicked at examples/01_err_ignore_error.rs:4:65:
called `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound,
    message: "No such file or directory" }
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
ReturnCode => 101
```

## 02 - Terminate the program

> Some errors cannot be handled or recovered from. In these cases,
> it’s better to fail fast by terminating the program.
> We can use unwrap as before or use expect -
> it’s same as unwrap but lets us add extra error message.

### Ok MatchArms

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="02_ok_error_handling_expect.rs"
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
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

- output

```bash
Running `target/debug/examples/02_ok_error_handling_expect`
[package]
name = "rust_errors_handling"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
chrono = "0.4.38"
reqwest = "0.12.4"

ReturnCode => 0
```

### Err MatchArms

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="02_err_error_handling_expect.rs"
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
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

- output
  -- bash: sh +x run_examples/02_err_error_handling_expect.rs

```bash
Finished dev [unoptimized + debuginfo] target(s) in 0.08s
     Running `target/debug/examples/02_err_terminate_the_program`
thread 'main' panicked at examples/02_err_terminate_the_program.rs:5:55:
Can't read ./Not_Exists_Cargo.toml: Os { code: 2, kind: NotFound, message: "No such file or directory" }
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
ReturnCode => 101
```

## 03 - Use a fallback value

> In some cases, you can handle the error by falling back to a default value.

### Ok MatchArms

- set env PORT for positive run => OK

```bash
#!/usr/bin/env bash
export PORT="01234"
echo $PORT
```

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="03_ok_unwrap_or_to_fallback_value.rs"
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
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

- output
  -- cmd: sh +x run_examples/03_ok_unwrap_or_to_fallback_value.rs

```bash
 Finished dev [unoptimized + debuginfo] target(s) in 0.08s
     Running `target/debug/examples/03_ok_use_fallback_value`
3000
ReturnCode => 0
```

### Err - MatchArms

- unset env for negative run => Err

```bash
#!/usr/bin/env bash
unset PORT
echo $PORT
```

- create program

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="03_err_unwrap_or_to_fallback_value.rs"
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
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

- output
  -- cmd: sh +x run_examples/03_err_unwrap_or_to_fallback_value.rs

```bash
Compiling rust_errors_handling v0.1.0 (/home/trapapa/rust_errors_handling)
    Finished dev [unoptimized + debuginfo] target(s) in 0.40s
     Running `target/debug/examples/03_err_use_fallback_value`
ENV PORT variable not set => unwrap_or with 0815
0815
ReturnCode => 0
```

## 04 - Bubble up the error

- When you don’t have enough context to handle the error, you can bubble up (propagate) the error to the caller function

> for this examples need we the crate reqwest with features = ["blocking","json"]

```bash
#!/usr/bin/env bash
# only request w/o features
# cargo add reqwest
# with features
# FROM HERE - https://doc.rust-lang.org/beta/cargo/commands/cargo-add.html
cargo add reqwest --features blocking,json
```

### Ok - MatchArms

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="04_ok_bubble_up_error.rs"
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
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

### Err - MatchArms

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="04_err_bubble_up_error.rs"
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

  // Expected Err =>  No entry found for key
  let date = json["ERROR_HERE"].to_string();

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
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

## 05 Bubble up multiple errors

- In the previous example, the get and json functions return a reqwest::Error
  error which we’ve propagated using the ? operator. But what if we’ve another
  function call that returned a different error value?

### Ok - MatchArms

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="05_01_ok_bubble_up_multiple_errors_does_not_work.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
// FROM HERE
// https://github.com/sheshbabu/rust-error-handling-examples/blob/master/05-bubble-up-multiple-errors/src/main.rs


// WARNING
// The follow code won’t compile as parse_from_str returns a chrono::format::ParseError error and NOT reqwest::Error
use chrono::NaiveDate;
use std::collections::HashMap;

#[allow(clippy::all)]
fn main() {
    match get_current_date() {
        Ok(date) => println!("We've time travelled to {}!!", date),
        Err(e) => eprintln!("Oh noes, we don't know which era we're in! :( \n  {}", e),
    }
}

#[allow(clippy::all)]
fn get_current_date() -> Result<String, reqwest::Error> {
    // Try changing the url to "https://postman-echo.com/time/objectzzzz"
    let url = "https://postman-echo.com/time/object";
    let res = reqwest::blocking::get(url)?.json::<HashMap<String, i32>>()?;

    // Try changing the format to "{}-{}-{}z"
    let formatted_date = format!("{}-{}-{}", res["years"], res["months"] + 1, res["date"]);
    // Error here = wrong Result
    let parsed_date = NaiveDate::parse_from_str(formatted_date.as_str(), "%Y-%m-%d")?;
    let date = parsed_date.format("%Y %B %d").to_string();

    Ok(date)
}

/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

> [!WARNING] Code not to compile
> The above code won’t compile as parse_from_str returns a chrono::format::ParseError error and not reqwest::Error
> We can fix this by Boxing the errors

### Ok - without any error - MatchArms /w Box

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="05_02_ok_with_box_bubble_up_multiple_errors_.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
use chrono::NaiveDate;
use std::collections::HashMap;

fn main() {
    match get_current_date() {
        Ok(date) => println!("We've time travelled to {}!!", date),
        Err(e) => eprintln!("Oh noes, we don't know which era we're in! :( \n  {}", e),
    }
}

fn get_current_date() -> Result<String, Box<dyn std::error::Error>> {
    // Try changing the url to "https://postman-echo.com/time/objectzzzz"
    let url = "https://postman-echo.com/time/object";
    let res = reqwest::blocking::get(url)?.json::<HashMap<String, i32>>()?;

    // Try changing the format to "{}-{}-{}z"
    let formatted_date = format!("{}-{}-{}", res["years"], res["months"] + 1, res["date"]);
    let parsed_date = NaiveDate::parse_from_str(formatted_date.as_str(), "%Y-%m-%d")?;
    let date = parsed_date.format("%Y %B %d").to_string();

    Ok(date)
}


/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

### Err - with second error - the same err handling- MatchArms /w Box

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="05_03_err_with_box_bubble_up_multiple_errors_first_error.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
use chrono::NaiveDate;
use std::collections::HashMap;

fn main() {
    match get_current_date() {
        Ok(date) => println!("We've time travelled to {}!!", date),
        Err(e) => eprintln!("Oh noes, we don't know which era we're in! :( \n  {}", e),
    }
}

fn get_current_date() -> Result<String, Box<dyn std::error::Error>> {
    // First error with change
    // Try changing the url to "https://postman-echo.com/time/objectzzzz"
    let url = "https://postman-echo.com/time/objectzzzz";
    let res = reqwest::blocking::get(url)?.json::<HashMap<String, i32>>()?;

    // Second error WITHOUT change
    // Try changing the format to "{}-{}-{}z"
    let formatted_date = format!("{}-{}-{}", res["years"], res["months"] + 1, res["date"]);
    let parsed_date = NaiveDate::parse_from_str(formatted_date.as_str(), "%Y-%m-%d")?;
    let date = parsed_date.format("%Y %B %d").to_string();

    Ok(date)
}


/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

### Err - with second error - the same err handling- MatchArms /w Box

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="05_04_err_with_box_bubble_up_multiple_errors_second_error.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
use chrono::NaiveDate;
use std::collections::HashMap;

fn main() {
    match get_current_date() {
        Ok(date) => println!("We've time travelled to {}!!", date),
        Err(e) => eprintln!("Oh noes, we don't know which era we're in! :( \n  {}", e),
    }
}

fn get_current_date() -> Result<String, Box<dyn std::error::Error>> {
    // First error  WITHOUT change
    // Try changing the url to "https://postman-echo.com/time/objectzzzz"
    let url = "https://postman-echo.com/time/object";
    let res = reqwest::blocking::get(url)?.json::<HashMap<String, i32>>()?;

    // Second error with change
    // Try changing the format to "{}-{}-{}z"
    let formatted_date = format!("{}-{}-{}z", res["years"], res["months"] + 1, res["date"]);
    let parsed_date = NaiveDate::parse_from_str(formatted_date.as_str(), "%Y-%m-%d")?;
    let date = parsed_date.format("%Y %B %d").to_string();

    Ok(date)
}


/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

## Match boxed errors

- So far, we’ve only printed the errors in the main function but not handled them.
  If we want to handle and recover from boxed errors, we need to “downcast” them
- Notice how we need to be aware of the implementation details (different errors inside)
  of get_current_date to be able to downcast them inside main

### Ok - match arm

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="05_05_ok_match_boxed_errors_in_fn_main.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
//FROM HERE
//https://github.com/sheshbabu/rust-error-handling-examples/blob/master/06-match-boxed-errors/src/main.rs
use chrono::NaiveDate;
use std::collections::HashMap;

fn main() {
    match get_current_date() {
        Ok(date) => println!("We've time travelled to {}!!", date),
        Err(e) => {
            eprintln!("Oh noes, we don't know which era we're in! :(");
            if let Some(err) = e.downcast_ref::<reqwest::Error>() {
                eprintln!("Request Error: {}", err)
            } else if let Some(err) = e.downcast_ref::<chrono::format::ParseError>() {
                eprintln!("Parse Error: {}", err)
            }
        }
    }
}

fn get_current_date() -> Result<String, Box<dyn std::error::Error>> {
    // Try changing the url to "https://postman-echo.com/time/objectzzzz"
    let url = "https://postman-echo.com/time/object";
    let res = reqwest::blocking::get(url)?.json::<HashMap<String, i32>>()?;

    // Try changing the format to "{}-{}-{}z"
    let formatted_date = format!("{}-{}-{}", res["years"], res["months"] + 1, res["date"]);
    let parsed_date = NaiveDate::parse_from_str(formatted_date.as_str(), "%Y-%m-%d")?;
    let date = parsed_date.format("%Y %B %d").to_string();

    Ok(date)
}

/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

### Err - match arm /w err reqwest::Error

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="05_06_err_request_match_boxed_errors_in_fn_main.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
//FROM HERE
//https://github.com/sheshbabu/rust-error-handling-examples/blob/master/06-match-boxed-errors/src/main.rs
use chrono::NaiveDate;
use std::collections::HashMap;

fn main() {
    match get_current_date() {
        Ok(date) => println!("We've time travelled to {}!!", date),
        Err(e) => {
            eprintln!("Oh noes, we don't know which era we're in! :(");
            if let Some(err) = e.downcast_ref::<reqwest::Error>() {
                eprintln!("Request Error: {}", err)
            } else if let Some(err) = e.downcast_ref::<chrono::format::ParseError>() {
                eprintln!("Parse Error: {}", err)
            }
        }
    }
}

fn get_current_date() -> Result<String, Box<dyn std::error::Error>> {
    // /w err reqwest::Error - wrong url
    // Try changing the url to "https://postman-echo.com/time/objectzzzz"
    let url = "https://postman-echo.com/time/objectzzzz";
    let res = reqwest::blocking::get(url)?.json::<HashMap<String, i32>>()?;

    // Try changing the format to "{}-{}-{}z"
    let formatted_date = format!("{}-{}-{}", res["years"], res["months"] + 1, res["date"]);
    let parsed_date = NaiveDate::parse_from_str(formatted_date.as_str(), "%Y-%m-%d")?;
    let date = parsed_date.format("%Y %B %d").to_string();

    Ok(date)
}

/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

### Err - match arm /w err chrono::format::ParseError

```rust
#!/usr/bin/env bash
export EXAMPLE_SCRIPT_FILE="06_err_parse_match_boxed_errors_in_fn_main.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
//FROM HERE
//https://github.com/sheshbabu/rust-error-handling-examples/blob/master/06-match-boxed-errors/src/main.rs
use chrono::NaiveDate;
use std::collections::HashMap;

fn main() {
    match get_current_date() {
        Ok(date) => println!("We've time travelled to {}!!", date),
        Err(e) => {
            eprintln!("Oh noes, we don't know which era we're in! :(");
            if let Some(err) = e.downcast_ref::<reqwest::Error>() {
                eprintln!("Request Error: {}", err)
            } else if let Some(err) = e.downcast_ref::<chrono::format::ParseError>() {
                eprintln!("Parse Error: {}", err)
            }
        }
    }
}

fn get_current_date() -> Result<String, Box<dyn std::error::Error>> {
    // Try changing the url to "https://postman-echo.com/time/objectzzzz"
    let url = "https://postman-echo.com/time/object";
    let res = reqwest::blocking::get(url)?.json::<HashMap<String, i32>>()?;

    // /w err chrono::format::ParseError - wrong format pattern
    // Try changing the format to "{}-{}-{}z"
    let formatted_date = format!("{}-{}-{}z", res["years"], res["months"] + 1, res["date"]);
    let parsed_date = NaiveDate::parse_from_str(formatted_date.as_str(), "%Y-%m-%d")?;
    let date = parsed_date.format("%Y %B %d").to_string();

    Ok(date)
}



/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

## rust script template

```rust
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
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
EoF
```

> [!NOTE]
> Returning a trait object Box<dyn std::error::Error> is very convenient when we want to return multiple errors!

## [to highlight a "Note" and "Warning" using blockquote](https://github.com/orgs/community/discussions/16925)

- note

> [!NOTE]  
> Highlights information that users should take into account, even when skimming.

- tip

> [!TIP]
> Optional information to help a user be more successful.

- important

> [!IMPORTANT]  
> Crucial information necessary for users to succeed.

- warning

> [!WARNING]  
> Critical content demanding immediate user attention due to potential risks.

- caution

> [!CAUTION]
> Negative potential consequences of an action.

## default script block

```rust
/*
export FILE_NAME=$EXAMPLE_SCRIPT_FILE
export FILE_DIR_NAME=$EXAMPLE_SCRIPT_DIR
git add \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add BEFORE housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
# git push
# cargo install --list
# cargo update --workspace
cargo clippy --fix
cargo clippy --fix --examples
# cargo check --verbose
# cargo check --verbose --examples
cargo check
cargo check --examples
cargo fmt -- --emit=files \$FILE_DIR_NAME/\$FILE_NAME
git commit --all --message="-> Add AFTER housekeeping => \$FILE_DIR_NAME/\$FILE_NAME"
git push
cargo run --example "\$(echo \$FILE_NAME | cut -d . -f 1)"
echo "ReturnCode => \$?"
*/
```

## test rust script

```rust
extra_rust:
#default-script-block
:ex_doc
```

### [stl model](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams)

```stl
solid cube_corner
  facet normal 0.0 -1.0 0.0
    outer loop
      vertex 0.0 0.0 0.0
      vertex 1.0 0.0 0.0
      vertex 0.0 0.0 1.0
    endloop
  endfacet
  facet normal 0.0 0.0 -1.0
    outer loop
      vertex 0.0 0.0 0.0
      vertex 0.0 1.0 0.0
      vertex 1.0 0.0 0.0
    endloop
  endfacet
  facet normal -1.0 0.0 0.0
    outer loop
      vertex 0.0 0.0 0.0
      vertex 0.0 0.0 1.0
      vertex 0.0 1.0 0.0
    endloop
  endfacet
  facet normal 0.577 0.577 0.577
    outer loop
      vertex 1.0 0.0 0.0
      vertex 0.0 1.0 0.0
      vertex 0.0 0.0 1.0
    endloop
  endfacet
endsolid
```

## change
