// use aiken/transaction.{ScriptContext}

// Enum
type State {
  Locked
  Unlocked
}

validator {
  /// Unlocks the funds when `key` is equal to `lock`
  fn unlock(lock: Int, key: Int, _: Data) -> Bool {
    let process_state =
      fn(state) {
        when state is {
          Locked ->
            False
          Unlocked ->
            True
        }
      }
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

// aiken blueprint address -m when_is.unlock >> when_is.address
// aiken blueprint convert -m when_is.unlock >> when_is.plutus

// aiken check -m when_is
test when_is() {
  expect True =
    unlock(3, 3, 3)
  expect False =
    unlock(2, 1, 0)
  True
}
