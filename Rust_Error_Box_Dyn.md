# FROM HERE

- [FROM HERE](https://www.sheshbabu.com/posts/rust-error-handling/)
- - [GITHUB REPO](https://github.com/sheshbabu/rust-error-handling-examples/tree/master)
- [good tut rust basic](http://saidvandeklundert.net/learn/)

## Beginner's guide to Error Handling in Rust

## first step - extract all rust code block from markdown file

```bash
# set -x
export MD_SCRIPT="/home/trapapa/rust_errors_handling/Rust_Error_Box_Dyn.md"
export SCRIPTS_OUTPUT="/tmp/markdown_rust_codeblock.sh"
export DIRECTORY_OUTPUT="/tmp/examples"

echo "DIRECTORY_OUTPUT => $DIRECTORY_OUTPUT"
[ -d $DIRECTORY_OUTPUT ] && rm -rf $DIRECTORY_OUTPUT/*
[ -f $SCRIPTS_OUTPUT ] && rm $SCRIPTS_OUTPUT
sed -n '/^```rust/,/^```/ p'  \
<"$MD_SCRIPT"| \
sed '/^```/ d' > $SCRIPTS_OUTPUT
ls -l $SCRIPTS_OUTPUT
/bin/ls -ls $SCRIPTS_OUTPUT | awk '{print "",$10,$7,$8,$9}'
date +"%B %d %H:%M"
```

## next step - generate example script

```bash
# change to PROJECT_FOLDER
sh +x /tmp/markdown_rust_codeblock.sh
```

## next step - extract build script

> create script with shebang - stupid method
>
> ```bash
> #!/usr/bin/env bash
> FILE="/tmp/shebang_insert.sh";
> printf "\n" >$FILE && sed -i '1 i\#\!\/usr\/bin\/env bash' $FILE && cat $FILE;
> ```

## create starter scripts for each example

```bash
#!/bin/env bash
FILES_DIRECTORY="examples";
for FILE_NAME in $FILES_DIRECTORY/*;
   do  
   echo "Processing $FILE_NAME file...";
   if [[ $FILE_NAME == *rs ]]; then
   SCRIPT_FILE="./$(echo $FILE_NAME | cut -d . -f 1).sh"
   echo "SCRIPT_FILE => $SCRIPT_FILE";
   echo "generate SCRIPT_FILE => $SCRIPT_FILE";
   printf "\n" >$SCRIPT_FILE && sed -i '1 i\#\!\/usr\/bin\/env bash' $SCRIPT_FILE
   sed -n '/^\/\*/,/^\*\// p' <"$FILE_NAME"|sed '/^\/\*/ d'|sed '/^\*\// d' >>$SCRIPT_FILE;
   else
   echo "NOT *.rs script => $FILE_NAME ";
   echo "next file ";
   fi
done

```

## script starter for scripts inside folder examples

```bash
#!/bin/env bash
FILES_DIRECTORY="examples";
for FILE_NAME in $FILES_DIRECTORY/*;
   do  
   echo "Processing $FILE_NAME file...";
   # SCRIPT_FILE="./$(echo $FILE_NAME | cut -d . -f 1).sh"
   # echo " => $SCRIPT_FILE";
   if [[ $FILE_NAME == *sh ]]; then
    echo "";
    echo "#################";
    echo "start ..";
    echo "sh script execute $FILE_NAME";
    echo "#################";
    echo "";
    source "$FILE_NAME";
    echo "";
    echo "#################";
    echo "finished ..";
    printf "ExitCode => $? <= $FILE_NAME\n";
    echo "#################";
    echo "";
   else
    echo "NOT *.sh script => $FILE_NAME ";
    echo "next file ";
   fi
done

```

## run rust script with Cargo.toml from another path

```bash
cd && \
cd /tmp && \
cargo run \
--manifest-path /home/trapapa/rust_errors_handling/Cargo.toml \
--example 03_err_use_fallback_value
```

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
export EXAMPLE_SCRIPT_FILE="01_ok_ignore_error.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE

use std::fs;

fn main() {
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
export EXAMPLE_SCRIPT_FILE="01_err_ignore_error.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE

use std::fs;

fn main() {
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
cargo run --example \$(echo \$FILE_NAME | cut -d . -f 1)
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
it’s better to fail fast by terminating the program.
> We can use unwrap as before or use expect -
it’s same as unwrap but lets us add extra error message.

### Ok MatchArms

```rust
export EXAMPLE_SCRIPT_FILE="02_ok_terminate_the_program.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE

use std::fs;

fn main() {
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
cargo run --example \$(echo \$FILE_NAME | cut -d . -f 1)
echo "ReturnCode => \$?"
*/
EoF
```

### Err MatchArms

```rust
export EXAMPLE_SCRIPT_FILE="02_err_terminate_the_program.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE
use std::fs;

fn main() {
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
cargo run --example \$(echo \$FILE_NAME | cut -d . -f 1)
echo "ReturnCode => \$?"
*/
EoF
```

### output

```bash
Running `target/debug/examples/04_terminate_the_program_err`
thread 'main' panicked at examples/04_terminate_the_program_err.rs:5:55:
Can't read ./Not_Exists_Cargo.toml: Os { code: 2, kind: NotFound, 
    message: "No such file or directory" }
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
ReturnCode => 101
```

## 03 - Use a fallback value

> In some cases, you can handle the error by falling back to a default value.

### Ok MatchArms

- set env for positive run => OK

```bash
#!/bin/sh
export PORT="01234"
echo $PORT
```

```rust
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
cargo run --example \$(echo \$FILE_NAME | cut -d . -f 1)
echo "ReturnCode => \$?"
*/
EoF
```

### Err MatchArms

- unset env for negative run => Err

```bash
#!/bin/sh
unset PORT
echo $PORT
```

- create program

```rust
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
cargo run --example \$(echo \$FILE_NAME | cut -d . -f 1)
echo "ReturnCode => \$?"
*/
EoF
```

## Bubble up the error

## rust script template

```rust
export EXAMPLE_SCRIPT_FILE="99_template.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE

fn main(){

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
cargo run --example \$(echo \$FILE_NAME | cut -d . -f 1)
echo "ReturnCode => \$?"
*/
EoF
```

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
