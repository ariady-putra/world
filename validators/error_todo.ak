validator {
  fn spend(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    True
  }
}

fn favourite_number() -> Int {
  // In Aiken text strings can be written as text surrounded by double quotes, prefixed with `@`
  todo @"favourite_number() must return an Int but we have not implemented it yet"
  // They can also span multiple lines
}

fn expect_some_value(opt: Option<a>) -> a {
  when opt is {
    Some(a) ->
      a
    None ->
      // Under the hood text strings are UTF-8 encoded binaries and can contain any valid unicode
      error @"`Option` has no value"
  }
}

// aiken blueprint address -m error_todo.spend >> error_todo.address
// aiken blueprint convert -m error_todo.spend >> error_todo.plutus

// aiken check -m error_todo
test error_todo() {
  1 + 1 == 2
}
