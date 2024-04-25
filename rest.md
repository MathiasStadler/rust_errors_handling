# rest -- good to known

## rest

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
