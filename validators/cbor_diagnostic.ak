//// Sometimes, you need to inspect the value of some specific object _at runtime_.
//// This is harder than it seems because a compiled Aiken program has erased any
//// context and any notion of types. Even functions and variable names are replaced
//// by compact indices which makes it relatively hard to inspect programs and values
//// at runtime.
////
//// For example, this is what a compiled function may look like in UPLC:
//// ```
//// (lam i_31
////   (lam i_32
////     (lam i_33
////       (force
////         [ [ [ i_2 i_32 ] (delay (con unit ())) ]
////           (delay
////             [ [ i_4 [ i_33 [ i_1 i_32 ] ] ]
////               [ [ [ i_31 i_31 ] [ i_0 i_32 ] ] i_33
////               ]
////             ]
////           )
////         ]
////       )
////     )
////   )
//// )
//// ```
//// Aiken's standard library provides a convenient method to inspect any value at
//// runtime and obtain a `String` representation of them. The syntax used for this
//// representation is called a `CBOR diagnostic`:
//// https://www.rfc-editor.org/rfc/rfc8949#name-diagnostic-notation
//// ```
//// ┍━ cbor_diagnostic ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: ####, cpu: ######] cbor_diagnostic
//// │ ↳ @test cbor_diagnostic()
//// │ ↳ diagnose_data(Bool):
//// │ ↳ 122([])
//// │ ↳ 
//// ┕━━━━━━━━━━━━━━━━ 1 tests | 1 passed | 0 failed
//// ```
//// Why use CBOR diagnostics you may ask? https://aiken-lang.org/language-tour/troubleshooting#cbor-diagnostic

use aiken/cbor
use aiken/list

type MyDatum {
  foo: Int,
  bar: ByteArray,
}

validator {
  fn diagnose(datum: Data, _redeemer: Data, _context: Data) -> Bool {
    trace @"@cbor_diagnostic.validator.diagnose(..)"
    // `expect` is a special keyword which works like `let`, but allows to perform some potentially unsafe conversions.
    expect MyDatum { foo, bar }: MyDatum = datum
    // Often, we do expect a specific structure for some given datum, and so being able to safely relay those assumptions in the validators comes in handy.
    trace @"cbor.diagnostic(MyDatum.foo):"
    trace cbor.diagnostic(foo)
    trace @""
    //
    trace @"cbor.diagnostic(MyDatum.bar):"
    trace cbor.diagnostic(bar)
    trace @""
    //
    (foo == 42)? && (bar == "Hello, World!")?
  }
}

fn diagnose_data(data: Data) -> String {
  cbor.diagnostic(data)
}

// aiken blueprint address -m cbor_diagnostic.diagnose > cbor_diagnostic.address
// aiken blueprint convert -m cbor_diagnostic.diagnose > cbor_diagnostic.plutus

// aiken check -m cbor
test cbor_diagnostic() {
  trace @"@test cbor_diagnostic()"
  //
  let expr = 1 + 1 == 2
  //
  trace @"diagnose_data(Bool):"
  trace diagnose_data(expr)
  // 122([])
  trace @""
  //
  expr
}

/// `aiken check -m cbor_diagnostics`
/// ```
/// ┍━ cbor_diagnostic ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// │ PASS [mem: ####, cpu: ######] cbor_diagnostics
/// │ ↳ 42
/// │ ↳ h'666F6F'
/// │ ↳ [_ 1, 2, 3]
/// │ ↳ [_ 1, 2]
/// │ ↳ {_ 1: h'FF' }
/// │ ↳ 121([_ 42])
/// │ ↳ 122([])
/// ┕━━━━━━━━━━━━━━━━━ 1 tests | 1 passed | 0 failed
/// ```
test cbor_diagnostics() {
  // An Int becomes a CBOR int
  let cbor_int = cbor.diagnostic(42)
  // 42
  //
  // A ByteArray becomes a CBOR bytestring
  let cbor_bytearray = cbor.diagnostic("foo")
  // h'666F6F'
  //
  // A List becomes a CBOR array
  let cbor_list = cbor.diagnostic([1, 2, 3])
  // [_ 1, 2, 3]
  //
  // A Tuple becomes a CBOR array
  let cbor_tuple = cbor.diagnostic((1, 2))
  // [_ 1, 2]
  //
  // A List of 2-tuples becomes a CBOR map
  let cbor_list_tuple = cbor.diagnostic([(1, #"ff")])
  // {_ 1: h'FF' }
  //
  // 'Some' is the first constructor of Option → tagged as 121
  let cbor_some = cbor.diagnostic(Some(42))
  // 121([_ 42])
  //
  // 'None' is the second constructor of Option → tagged as 122
  let cbor_none = cbor.diagnostic(None)
  // 122([])
  //
  [
    cbor_int,
    cbor_bytearray,
    cbor_list,
    cbor_tuple,
    cbor_list_tuple,
    cbor_some,
    cbor_none,
  ]
    |> list.all(
         fn(cbor) {
           trace cbor
           True
         },
       )
}

/// `aiken check -m cbor_of_mydatum`
/// ```
/// ┍━ cbor_diagnostic ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// │ PASS [mem: ####, cpu: ######] cbor_of_mydatum
/// │ ↳ @test cbor_of_mydatum()
/// │ ↳ cbor.diagnostic(type):
/// │ ↳ 121([_ 42, h'48656C6C6F2C20576F726C6421'])
/// │ ↳ 
/// ┕━━━━━━━━━━━━━━━━ 1 tests | 1 passed | 0 failed
/// ```
test cbor_of_mydatum() {
  trace @"@test cbor_of_mydatum()"
  //
  let datum = MyDatum { foo: 42, bar: "Hello, World!" }
  //
  trace @"cbor.diagnostic(type):"
  trace cbor.diagnostic(datum)
  // 121([_ 42, h'48656C6C6F2C20576F726C6421'])
  trace @""
  //
  True
}
