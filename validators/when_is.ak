//// `aiken check -m when`
//// ```
//// ┍━ when_is ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem:    200, cpu:     23100] when_is
//// │ PASS [mem:  34455, cpu:  16957353] when_locked_is_locked
//// │ ↳ @test when_locked_is_locked()
//// │ ↳ cbor.diagnostic(enum):
//// │ ↳ 121([])
//// │ ↳ 
//// │ PASS [mem:  34455, cpu:  16957353] when_unlocked_is_unlocked
//// │ ↳ @test when_unlocked_is_unlocked()
//// │ ↳ cbor.diagnostic(enum):
//// │ ↳ 122([])
//// │ ↳ 
//// │ PASS [mem:  35056, cpu:  17175909] when_locked_is_not_unlocked
//// │ ↳ @test when_locked_is_not_unlocked()
//// │ ↳ cbor.diagnostic(enum):
//// │ ↳ 121([])
//// │ ↳ 
//// │ PASS [mem:  35056, cpu:  17175909] when_unlocked_is_not_locked
//// │ ↳ @test when_unlocked_is_not_locked()
//// │ ↳ cbor.diagnostic(enum):
//// │ ↳ 122([])
//// │ ↳ 
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 5 tests | 5 passed | 0 failed
//// ```
//// Aiken's test runner is (trying to be) intelligent and helpful,
//// especially on test failures. If a test fails,
//// the test runner will do its best to provide some information about what went wrong.
//// This is particularly efficient if you write your tests as assertions using a binary
//// operator (`==`, `>=`, `!=`, etc...).

use aiken/cbor

// Enum
type State {
  Locked
  Unlocked
}

validator {
  /// Unlocks the funds when `key` is equal to `lock`
  fn unlock(lock: Int, key: Int, _: Data) -> Bool {
    // `when-is` expression can also be used to destructure values that contain other values
    // such as tuples and lists
    let process_state =
      fn(state) {
        when state is {
          Locked -> False
          Unlocked -> True
        }
      }
    // and it's not just the top level data structure that can be pattern matched, contained values can also be matched.
    // This gives when the ability to concisely express flow control that might be verbose without pattern matching.
    //
    // Pattern matching on a `Bool` value is discouraged and `if-else` expressions should be use instead
    if key == lock {
      unlocked()
    } else {
      locked()
    }
      |> process_state
    // Note that, while it may look like an imperative instruction:
    // `if this then do that or else do that` is in fact 1 single expression.
    // This means, in particular, that the return types of both branches have to match.
    //
    // Incidentally, you can have as many conditional `else-if` branches as you need:
    // if condition1 { .. } else if condition2 { .. } else { .. }
  }
}

// Inferred Identity
//
// The Aiken compiler can infer all the types of Aiken code without annotations and both annotated and unannotated code is equally safe.
// It's considered a best practice to always write type annotations for your functions as they provide useful documentation,
// and they encourage thinking about types as code is being written.
//
// fn locked() -> State {
fn locked() {
  Locked
}

// fn unlocked() -> State {
fn unlocked() {
  Unlocked
}

// aiken blueprint address -m when_is.unlock > when_is.address
// aiken blueprint convert -m when_is.unlock > when_is.plutus

// aiken check -m when_is
/// Tests cannot call other tests!  If you need to re-use code between tests, create a function.
test when_is() {
  //   expect True = unlock(3, 3, 3)
  //   expect False = unlock(2, 1, 0)
  True
}

// One exciting thing about tests is that they use the same virtual machine as the one for executing contracts on-chain.
// Said differently, they are actual snippets of on-chain code you can run and reason about in the same context as your
// production code.

// aiken check -m when

test when_locked_is_locked() {
  trace @"@test when_locked_is_locked()"
  //
  let is_locked = locked()
  //
  trace @"cbor.diagnostic(enum):"
  trace cbor.diagnostic(is_locked)
  // 121([])
  trace @""
  //
  is_locked == Locked
}

test when_unlocked_is_unlocked() {
  trace @"@test when_unlocked_is_unlocked()"
  //
  let is_unlocked = unlocked()
  //
  trace @"cbor.diagnostic(enum):"
  trace cbor.diagnostic(is_unlocked)
  // 122([])
  trace @""
  //
  is_unlocked == Unlocked
}

test when_locked_is_not_unlocked() {
  trace @"@test when_locked_is_not_unlocked()"
  //
  let is_locked = locked()
  //
  trace @"cbor.diagnostic(enum):"
  trace cbor.diagnostic(is_locked)
  // 121([])
  trace @""
  //
  is_locked != Unlocked
}

test when_unlocked_is_not_locked() {
  trace @"@test when_unlocked_is_not_locked()"
  //
  let is_unlocked = unlocked()
  //
  trace @"cbor.diagnostic(enum):"
  trace cbor.diagnostic(is_unlocked)
  // 122([])
  trace @""
  //
  is_unlocked != Locked
}
