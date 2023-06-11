//// The type is defined with the `opaque` keyword.

use aiken/cbor

/// An `Int` value newtype.
pub opaque type Counter {
  value: Int,
}

/// Initializes a new instance of `Counter`
/// with the value of `0` (zero).
pub fn new() {
  Counter(0)
}

/// Increments the value of a `Counter`.
pub fn increment(counter: Counter) {
  Counter(counter.value + 1)
}

/// Retrieves the value of a `Counter`.
pub fn get_value(counter: Counter) {
  trace @"@counter.get_value(counter: Counter)"
  //
  trace @"cbor.diagnostic(counter):"
  trace cbor.diagnostic(counter)
  // 1
  trace @""
  //
  counter.value
}
