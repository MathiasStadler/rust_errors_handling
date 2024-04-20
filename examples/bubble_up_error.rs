// FORM HERE
// https://www.sheshbabu.com/posts/rust-error-handling/

use std::collections::HashMap;

fn main() {
    match get_current_date() {
        Ok(year) => println!("We've time travelled to {}!!", year),
        Err(e) => eprintln!("Oh noes, we don't know which era we're in! :( \n  {}", e),
    }
}

fn get_current_date() -> Result<String, reqwest::Error> {
    // let url = "https://postman-echo.com/time/objectzzzz";
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

    let year = json["years"].to_string();

    Ok(year)
}

// cargo fmt -- --emit=files ./examples/bubble_up_error.rs
// cargo run --example bubble_up_error
