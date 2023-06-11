use aiken/hash.{Blake2b_224, Hash}
use aiken/transaction.{ScriptContext}
use aiken/transaction/credential.{VerificationKey}
//
// use world/module
// .. module.must_be_signed_by(..)
//
// Unqualified Import
use world/module.{must_be_signed_by}

// use world/module as txn
// .. txn.must_be_signed_by(..)

// use world/module.{must_be_signed_by} as txn
// .. must_be_signed_by(..)
// OR
// .. txn.must_be_signed_by(..)

type Datum {
  owner: Hash<Blake2b_224, VerificationKey>,
}

type Redeemer {
  msg: ByteArray,
}

// Module constants
//
// Let-bindings aren't allowed in a top-level Aiken module.
// Yet, Aiken provides module constants as a way to use certain fixed values in multiple places of a Aiken project.
//
// Note that you can only declare module constants for the following Aiken types: `Int`, `ByteArray` and `String`
//
const hello_world_msg: ByteArray = "Hello, World!"

/// A simple validator which replicates a basic public/private signature lock.
///
/// - The key (hash) is set as datum when the funds are sent to the script address.
/// - The spender is expected to provide a signature, and the string 'Hello, World!' as message
/// - The signature is implicitly verified by the ledger, and included as 'extra_signatories'
///
/// Validators themselves can take parameters, which represent configuration elements that must be provided to create an instance of the validator.
/// Once provided, parameters are embedded within the compiled validator and part of the generated code.
/// Hence they must be provided before any address can be calculated for the corresponding validator.
///
/// validator(parameter: ParameterType) {
validator {
  // Functions present in a validator block must abide by the following rules:
  // - They must have exactly 2 or 3 arguments.
  // - They must be named
  // - There may be one or two functions, in a single block, but no more.
  fn spend(datum: Datum, redeemer: Redeemer, txn: ScriptContext) -> Bool {
    let must_say_hello =
      //must_say_hello(msg: redeemer.msg) // Labeled argument (`msg:`)
      redeemer.msg |> must_say_hello

    let must_be_signed =
      //must_be_signed_by(datum.owner, txn)
      txn |> must_be_signed_by(pkh: datum.owner)

    // The `?` operator (reads as `trace-if-false operator`)
    // This postfix operator can be appended to any boolean expression and will trace the expression only if it evaluates to `False`
    // This is useful to trace an entire evaluation path that led to a final expression being `False`
    must_say_hello? && must_be_signed?
    // The `?` operator works like `trace` and is therefore affected by the `--keep-traces` and `--no-traces` options.
    // When compiling for production, it has therefore no effect on the program and behaves as if it wasn't there at all.
  }
}

fn must_say_hello(msg: ByteArray) -> Bool {
  // Anonymous function
  let eq =
    fn(a, b) { a == b }
  //
  // Function capturing
  //
  // There is a shorthand syntax for creating anonymous functions that take one argument and call another function.
  // The `_` is used to indicate where the argument should be passed.
  let equals_to_hello_world =
    eq(hello_world_msg, _)

  msg |> equals_to_hello_world
}

// aiken blueprint address -m hello_world.spend > hello_world.address
// aiken blueprint convert -m hello_world.spend > hello_world.plutus

// aiken check -m hello_world
test hello_world() {
  1 + 1 == 2
}
