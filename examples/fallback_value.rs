// FORM HERE
// https://www.sheshbabu.com/posts/rust-error-handling/
use std::env;

fn main() {
    let port = env::var("PORT").unwrap_or("4711".to_string());
    println!("{}", port);
}

// cargo fmt -- --emit=files ./examples/fallback_value.rs
// cargo run --example fallback_value
