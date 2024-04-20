// FROM HERE
// https://docs.rs/serde_json/latest/serde_json/error/struct.Error.html#method.line

use serde_json::Value;
use std::io::{self, ErrorKind, Read};
use std::process;

struct ReaderThatWillTimeOut<'a>(&'a [u8]);

impl<'a> Read for ReaderThatWillTimeOut<'a> {
    fn read(&mut self, buf: &mut [u8]) -> io::Result<usize> {
        if self.0.is_empty() {
            Err(io::Error::new(ErrorKind::TimedOut, "timed out"))
        } else {
            self.0.read(buf)
        }
    }
}

fn main() {
    let reader = ReaderThatWillTimeOut(br#" {"k": "#);

    let _: Value = match serde_json::from_reader(reader) {
        Ok(value) => value,
        Err(error) => {
            eprintln!("error: {}", error);
            process::exit(1);
        }
    };
}
