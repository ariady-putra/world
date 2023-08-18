//// You may add user-facing documentation at the head of modules with a module documentation comment
//// `quadruple slash` per line. Markdown is supported and this text block will be included with the
//// module's entry in generated HTML documentation.

validator {
  fn document(datum: Int, redeemer: Int, _context: Data) -> Bool {
    let even_datum =
      datum
        |> is_even
    let odd_redeemer =
      redeemer
        |> is_odd
    odd_redeemer? && even_datum?
  }
}

fn is_odd(n: Int) -> Bool {
  trace @"is `n` odd?"
  n % 2 != 0
}

fn is_even(n: Int) -> Bool {
  trace @"is `n` even?"
  n % 2 == 0
}

// aiken blueprint address -m documentation_trace.document > doc_trace.address
// aiken blueprint convert -m documentation_trace.document > doc_trace.plutus

// aiken check -m dt

/// │ PASS [mem:   2035, cpu:   1064852] dt_doc
/// │ ↳ This is a trace: testing documentation!
test dt_doc() {
  trace @"This is a trace: testing documentation!"
  1 + 1 == 2
}

/// │ PASS [mem:   1232, cpu:    465442] dt_trace
/// │ ↳ This is a trace too: testing trace...
test dt_trace() {
  trace @"This is a trace too: testing trace..."
  True
}

/// `aiken check -m dt_valid`
/// ```
/// │ PASS [mem:   3836, cpu:   1886947] dt_valid
/// │ ↳ is `n` odd?
/// ```
/// Only the trace from `is_odd` was captured,
/// because `is_even` was in fact `NEVER` evaluated
/// (there's no need because the left-hand side
/// already returned `True`).
test dt_valid() {
  is_odd(1) || is_even(2)
}
// NOTE that TRACES are:
// - REMOVED BY DEFAULT when building the project with `aiken build`. They can be preserved using `--keep-traces`;
// - KEPT BY DEFAULT when checking the project with `aiken check`. They can be left out using `--no-traces`.
// This is because tracing makes compiled code bigger and can add an extra overhead which is often undesired
// for final production-ready validators. Yet, they are useful for development and when testing. The command-
// line is thus geared towards those use-cases. Beware that while enabling or disabling traces doesn't change
// the semantic of the program, it effectively changes its hash value, and thus its associated addresses.
