//// You may add user-facing documentation at the head of modules with a module documentation comment
//// `quadruple slash` per line. Markdown is supported and this text block will be included with the
//// module's entry in generated HTML documentation.

validator {
  fn document(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    True
  }
}

// aiken blueprint address -m documentation.spend > documentation.address
// aiken blueprint convert -m documentation.spend > documentation.plutus

// aiken check -m documentation
test documentation() {
  1 + 1 == 2
}
