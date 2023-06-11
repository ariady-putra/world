//// The `aiken/builtin` module exposes useful builtin functions from Plutus core.
//// Most underlying platform functions are available here using a `snake_case` name.
//// Much of Aiken's syntax ends up compiling to combinations of certain bultins but
//// many aren't `exposed` through the syntax and need to be used directly.
//// The standard library wraps these in a more Aiken-friendly interface so you
//// will probably never need to use these directly unless you're making your own
//// standard library.

use aiken/builtin

validator {
  fn unlock(datum: Int, redeemer: Int, _context: Data) -> Bool {
    redeemer |> int_equals_to(datum)
  }
}

fn int_equals_to(a: Int, b: Int) -> Bool {
  builtin.equals_integer(a, b)
}

// aiken blueprint address -m aiken_builtin.spend > aiken_builtin.address
// aiken blueprint convert -m aiken_builtin.spend > aiken_builtin.plutus

// aiken check -m aiken_builtin
test aiken_builtin() {
  let a: Int = 1
  let b: Int = 1
  a |> int_equals_to(b)
}
