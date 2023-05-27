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
    when key == lock is {
      True ->
        unlocked()
      False ->
        locked()
    }
      |> process_state
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
