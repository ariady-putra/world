// At times it may be useful to create a type and make the constructors and fields private
// so that users of this type can only use the type through publicly exported functions.
//
// For example we can create a `Counter type` which holds an int which can be incremented.
// We don't want the user to alter the `Int value` other than by incrementing it,
// so we can make the type opaque to prevent them from being able to do this.
use world/counter

validator {
  fn spend(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    True
  }
}

// aiken blueprint address -m opaque_type.spend > opaque_type.address
// aiken blueprint convert -m opaque_type.spend > opaque_type.plutus

// aiken check -m opaque_type
test opaque_type() {
  let value =
    counter.new()
      |> counter.increment
      |> counter.get_value
  value == 1
}
