# FROM HERE

- [FROM HERE](https://www.sheshbabu.com/posts/rust-error-handling/)
- - [GITHUB REPO](https://github.com/sheshbabu/rust-error-handling-examples/tree/master)
- [good tut rust basic](http://saidvandeklundert.net/learn/)

## Beginner's guide to Error Handling in Rust

## basic

- The Result<T, E> type is an enum that has two variants
- - Ok(T) for successful value or
- - Err(E) for error value

```rust
 enum Result<T, E> {
   Ok(T),
   Err(E),
}
```

## 01 - ignore the error - NOT nice error handling

```rust
export EXAMPLE_SCRIPT_FILE="01_ignore_error.rs"
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
cargo run --example \$(echo \$FILE_NAME | cut -d . -f 1)
echo "ReturnCode => \$?"
*/
EoF
```

## 02 - Terminate the program

> Some errors cannot be handled or recovered from. In these cases, it’s better to fail fast by terminating the program.
> We can use unwrap as before or use expect - it’s same as unwrap but lets us add extra error message.

### Ok

```rust
export EXAMPLE_SCRIPT_FILE="02_terminate_the_program_ok.rs"
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

### Err

```rust
export EXAMPLE_SCRIPT_FILE="03_terminate_the_program_err.rs"
export EXAMPLE_SCRIPT_DIR="examples/"
cat << EoF > ./$EXAMPLE_SCRIPT_DIR/$EXAMPLE_SCRIPT_FILE

use std::fs;

fn main() {
  let content = fs::read_to_string("./Err_Cargo.toml").expect("Can't read Err_Cargo.toml");
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


## Use a fallback value - works

```bash
cat << EoF > ./examples/fallback_value.rs

// FORM HERE
// https://www.sheshbabu.com/posts/rust-error-handling/
use std::env;

fn main() {
  let port = env::var("PORT").unwrap_or("4711".to_string());
  println!("{}", port);
}

// cargo fmt -- --emit=files ./examples/fallback_value.rs
// cargo run --example fallback_value
EoF
```

## Bubble up the error- return number

> for this examples need we the crate reqwest with features = ["blocking","json"]

```bash
cargo add reqwest
# with features
# FROM HERE - https://doc.rust-lang.org/beta/cargo/commands/cargo-add.html
cargo add reqwest --features blocking,json
```

```rust
cat << EoF > ./examples/bubble_up_error.rs
// FORM HERE
// https://www.sheshbabu.com/posts/rust-error-handling/
use std::collections::HashMap;

fn main() {
  match get_current_date() {
    Ok(date) => println!("We've time travelled to {}!!", date),
    Err(e) => eprintln!("Oh noes, we don't know which era we're in! :( \n  {}", e),
  }
}

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


// cargo fmt -- --emit=files ./examples/bubble_up_error.rs
// cargo run --example bubble_up_error

EoF
```

## Bubble up the error- return str

> for this examples need we the crate chrono

```bash
cargo add chrono
```

```rust
cat << EoF > ./examples/bubble-up-multiple-errors.rs
// FORM HERE
// https://www.sheshbabu.com/posts/rust-error-handling/

use chrono::NaiveDate;
use std::collections::HashMap;

fn main() {
    match get_current_date() {
        Ok(date) => println!("We've time travelled to {}!!", date),
        Err(e) => eprintln!("Oh noes, we don't know which era we're in! :( \n  {}", e),
    }
}

// fn with multiple errors
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



// cargo fmt -- --emit=files ./examples/bubble-up-multiple-errors.rs
// cargo run --example bubble-up-multiple-errors
EoF
```

## match-boxed-errors

```rust
cat << EoF > ./examples/match-boxed-errors.rs
/* FROM HERE
https://github.com/sheshbabu/rust-error-handling-examples/blob/master/06-match-boxed-errors/src/main.rs
*/
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

// cargo fmt -- --emit=files ./examples/match-boxed-errors.rs
// cargo run --example match-boxed-errors

EoF
```

## Create custom errors

> Let’s start by creating an enum to hold our two error variants

```rust
cat << EoF > ./examples/error.rs
// FROM HERE
// https://github.com/sheshbabu/rust-error-handling-examples/blob/master/07-create-custom-errors/src/error.rs

use std::fmt;

#[derive(Debug)]
pub enum MyCustomError {
    HttpError,
    ParseError,
}

impl std::error::Error for MyCustomError {}

impl fmt::Display for MyCustomError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            MyCustomError::HttpError => write!(f, "HTTP Error"),
            MyCustomError::ParseError => write!(f, "Parse Error"),
        }
    }
}
EoF
```

> create create-custom-errors.rs inside use we MyCustomError

```rust
cat <<EoF > ./examples/my-custom-error.rs
/*
FROM HERE
https://github.com/sheshbabu/rust-error-handling-examples/blob/master/07-create-custom-errors/src/main.rs
*/

mod error;

use chrono::NaiveDate;
use error::MyCustomError;
use std::collections::HashMap;

fn main() {
    match get_current_date() {
        Ok(date) => println!("We've time travelled to {}!!", date),
        Err(e) => {
            eprintln!("Oh noes, we don't know which era we're in! :(");
            match e {
                MyCustomError::HttpError => eprintln!("Request Error: {}", e),
                MyCustomError::ParseError => eprintln!("Parse Error: {}", e),
            }
        }
    }
}

fn get_current_date() -> Result<String, MyCustomError> {
    // Try changing the url to "https://postman-echo.com/time/objectzzzz"
    let url = "https://postman-echo.com/time/object";
    let res = reqwest::blocking::get(url)
        .map_err(|_| MyCustomError::HttpError)?
        .json::<HashMap<String, i32>>()
        .map_err(|_| MyCustomError::HttpError)?;

    // Try changing the format to "{}-{}-{}z"
    let formatted_date = format!("{}-{}-{}", res["years"], res["months"] + 1, res["date"]);
    let parsed_date = NaiveDate::parse_from_str(formatted_date.as_str(), "%Y-%m-%d")
        .map_err(|_| MyCustomError::ParseError)?;
    let date = parsed_date.format("%Y %B %d").to_string();

    Ok(date)
}

// cargo fmt -- --emit=files ./examples/my-custom-error.rs
// cargo run --example my-custom-error

EoF

```

## We’ve removed map_err and the code looks much cleaner

```rust
cat << EoF > ./examples/error.rs
use std::fmt;

#[derive(Debug)]
pub enum MyCustomError {
    HttpError,
    ParseError,
}

impl std::error::Error for MyCustomError {}

impl fmt::Display for MyCustomError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            MyCustomError::HttpError => write!(f, "HTTP Error"),
            MyCustomError::ParseError => write!(f, "Parse Error"),
        }
    }
}

impl From<reqwest::Error> for MyCustomError {
    fn from(_: reqwest::Error) -> Self {
        MyCustomError::HttpError
    }
}

impl From<chrono::format::ParseError> for MyCustomError {
    fn from(_: chrono::format::ParseError) -> Self {
        MyCustomError::ParseError
    }
}
EoF
```

## bubble-up-custom-errors

```rust
cat << EoF > ./examples/bubble-up-custom-errors.rs

mod error;

use chrono::NaiveDate;
use error::MyCustomError;
use std::collections::HashMap;

fn main() {
    match get_current_date() {
        Ok(date) => println!("We've time travelled to {}!!", date),
        Err(e) => {
            eprintln!("Oh noes, we don't know which era we're in! :(");
            match e {
                MyCustomError::HttpError => eprintln!("Request Error: {}", e),
                MyCustomError::ParseError => eprintln!("Parse Error: {}", e),
            }
        }
    }
}

fn get_current_date() -> Result<String, MyCustomError> {
    // Try changing the url to "https://postman-echo.com/time/objectzzzz"
    let url = "https://postman-echo.com/time/object";
    let res = reqwest::blocking::get(url)?.json::<HashMap<String, i32>>()?;

    // Try changing the format to "{}-{}-{}z"
    let formatted_date = format!("{}-{}-{}", res["years"], res["months"] + 1, res["date"]);
    let parsed_date = NaiveDate::parse_from_str(formatted_date.as_str(), "%Y-%m-%d")?;
    let date = parsed_date.format("%Y %B %d").to_string();

    Ok(date)
}

// cargo fmt -- --emit=files ./examples/bubble-up-custom-errors.rs
// cargo run --example bubble-up-custom-errors

EoF
```

## rust script template

```rust
export EXAMPLE_SCRIPT_FILE="99_template.rs"
export EXAMPLE_SCRIPT_DIR="examples/errors_handling/"
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
