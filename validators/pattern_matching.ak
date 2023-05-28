validator {
  fn spend(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    True
  }
}

// aiken blueprint address -m pattern_matching.spend >> pattern_matching.address
// aiken blueprint convert -m pattern_matching.spend >> pattern_matching.plutus

// aiken check -m pattern_matching
test pattern_matching() {
  //
  // let
  let (a, b, c) =
    (1, 2, 3)
  //
  // as
  let xs =
    when [[a], [b, b], [c, c, c]] is {
      [_, [_, ..] as inner_list, ..] ->
        inner_list
      _ ->
        []
    }
  // inner_list == [b, b]
  //
  // Clause Guards
  when xs is {
    [a, b] if a == b && b != c ->
      True
    _ ->
      False
  }
}
