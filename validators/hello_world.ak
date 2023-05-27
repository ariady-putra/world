use aiken/hash.{Blake2b_224, Hash}
use aiken/list
use aiken/transaction.{ScriptContext}
use aiken/transaction/credential.{VerificationKey}

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
const hello_world_msg: ByteArray =
  "Hello, World!"

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

    must_say_hello? && must_be_signed?
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

fn must_be_signed_by(
  pkh: Hash<Blake2b_224, VerificationKey>,
  //
  // Overriding default labels
  //
  // Note that, when defining a function, it is possible to override the default label to use different names (e.g. a shorter name) in the function body.
  // For example:
  context ctx: ScriptContext,
) -> Bool {
  // Externally, the function can still be called using `context` as labelled, but in the function body, they are `ctx` for conciseness.
  ctx.transaction.extra_signatories
    |> list.any(fn(vkh: ByteArray) { vkh == pkh })
  // Pipe Operator
  //
  // Aiken provides syntax for passing the result of one function to the arguments of another function, the pipe operator `|>`
  // This is similar in functionality to the same operator in Elixir or F#
  //
  // The pipe operator allows you to chain function calls without using a lot of parenthesis and nesting.
  // For a simple example, consider the following implementation of an imaginary `string.reverse` in Aiken:
  // ```
  // string_builder.to_string(string_builder.reverse(string_builder.from_string(string)))
  // ```
  // This can be expressed more naturally using the pipe operator, eliminating the need to track parenthesis closure.
  // ```
  // string
  //   |> string_builder.from_string
  //   |> string_builder.reverse
  //   |> string_builder.to_string
  // ```
  // Each line of this expression applies the function to the result of the previous line.
  // This works easily because each of these functions takes only one argument.
  // Syntax is available to substitute specific arguments of functions that take more than one argument.
  //
  // So,
  // ```
  // ctx.transaction.extra_signatories
  //   |> list.any(fn(vkh: ByteArray) { vkh == pkh })
  // ```
  // is equivalent to:
  // ```
  // list.any(ctx.transaction.extra_signatories, fn(vkh: ByteArray) { vkh == pkh })
  // ```
}

// aiken blueprint address -m hello_world.spend >> hello_world.address
// aiken blueprint convert -m hello_world.spend >> hello_world.plutus

// aiken check -m hello_world
test hello_world() {
  1 + 1 == 2
}
