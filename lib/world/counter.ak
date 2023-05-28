// The type is defined with the opaque keyword
pub opaque type Counter {
  value: Int,
}

pub fn new() {
  Counter(0)
}

pub fn increment(counter: Counter) {
  Counter(counter.value + 1)
}

pub fn get_value(counter: Counter) {
  counter.value
}
