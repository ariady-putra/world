// There are two modules that are built into the language,
// the first is the aiken prelude module.
//
// By default its types and values are automatically imported into every module you write,
// but you can still chose to import it the regular way.
//
// This may be useful if you have created a type or value with the same name as an item from the prelude.
use aiken

/// This definition locally overrides the `Option` type
/// and the `Some` constructor.
pub type Option {
  Some
}
/// The original `Option` and `Some` can still be used
// pub fn go() -> aiken.Option<Int> {
//   aiken.Some(1)
// }

// The content of the Prelude module is documented in
// https://aiken-lang.github.io/prelude/aiken.html
