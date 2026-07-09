#[derive(Copy, Clone)]
struct JSValue(u8);

impl JSValue {
    fn is_empty(&self) -> bool {
        self.0 == 0
    }
}

struct Bytes {
    slice: Vec<u8>,
    pinned: JSValue,
}

fn jsc_jsvalue_unpin_array_buffer(_value: JSValue) {}

impl Drop for Bytes {
    fn drop(&mut self) {
        if !self.pinned.is_empty() {
            jsc_jsvalue_unpin_array_buffer(self.pinned);
        }
        // self.slice dropped automatically
    }
}

fn main() {
    let _bytes = Bytes {
        slice: vec![1, 2, 3],
        pinned: JSValue(1),
    };
}
