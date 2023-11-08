validator {
  fn spend(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    True
  }

  fn mint(_redeemer: Data, _context: Data) -> Bool {
    True
  }
}

validator(_: Data) {
  fn spend_arg(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    True
  }

  fn mint_arg(_redeemer: Data, _context: Data) -> Bool {
    True
  }
}

// aiken blueprint address -m always_true.spend > always_true.spend.address
// aiken blueprint convert -m always_true.spend > always_true.spend.plutus

// aiken blueprint address -m always_true.spend_arg > always_true.spend_arg.address
// aiken blueprint convert -m always_true.spend_arg > always_true.spend_arg.plutus

// aiken blueprint address -m always_true.mint > always_true.mint.address
// aiken blueprint convert -m always_true.mint > always_true.mint.plutus

// aiken blueprint address -m always_true.mint_arg > always_true.mint_arg.address
// aiken blueprint convert -m always_true.mint_arg > always_true.mint_arg.plutus

// aiken check -m always_true
test always_true() {
  1 + 1 == 2
}
