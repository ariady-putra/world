use aiken/hash.{Blake2b_224, Hash}
use aiken/list
use aiken/transaction.{ScriptContext}
use aiken/transaction/credential.{VerificationKey}

/// `pub` keyword makes this function usable from other modules.
pub fn must_be_signed_by(
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
