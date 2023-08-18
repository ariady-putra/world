//// There are two modules that are built into the language,
//// the first is the `aiken prelude` module. The second one is
//// `aiken/builtin`, see `aiken_builtin` module.
////
//// By default `prelude` types and values are automatically
//// imported into every module you write, but you can still
//// chose to import it the regular way.
////
//// This may be useful if you have created a type or value
//// with the same name as an item from the prelude.
////
//// ```
//// ┍━ world/prelude ━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 114124, cpu:  53519991] prelude
//// │ ↳ @test prelude()
//// │ ↳ cbor.diagnostic(aiken.Option<Int>):
//// │ ↳ 121([_ 1])
//// │ ↳ 
//// │ ↳ cbor.diagnostic(aiken.None):
//// │ ↳ 122([])
//// │ ↳ 
//// │ ↳ cbor.diagnostic(enum):
//// │ ↳ 121([])
//// │ ↳ 
//// ┕━━━━━━━━━━━━━ 1 tests | 1 passed | 0 failed
//// ```

use aiken
use aiken/cbor

/// This definition locally overrides the `Option` type
/// and the `Some` constructor.
pub type Option {
  Some
}

/// The original `Option` and `Some` can still be used.
pub fn go() -> aiken.Option<Int> {
  aiken.Some(1)
}

// The content of the Prelude module is documented in
// https://aiken-lang.github.io/prelude/aiken.html

// aiken check -m prelude
test prelude() {
  trace @"@test prelude()"

  let go = go()

  trace @"cbor.diagnostic(aiken.Option<Int>):"
  trace cbor.diagnostic(go)
  // 121([_ 1])
  trace @""

  trace @"cbor.diagnostic(aiken.None):"
  trace cbor.diagnostic(aiken.None)
  // 122([])
  trace @""

  trace @"cbor.diagnostic(enum):"
  trace cbor.diagnostic(Some)
  // 121([])
  trace @""

  when go is {
    aiken.Some(go) -> go == 1
    _ -> False
  }
}
