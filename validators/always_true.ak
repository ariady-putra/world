validator {
  fn spend(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    True
  }
}

// aiken blueprint address -m always_true.spend > always_true.address
// aiken blueprint convert -m always_true.spend > always_true.plutus

// aiken check -m always_true
test always_true() {
  1 + 1 == 2
}
