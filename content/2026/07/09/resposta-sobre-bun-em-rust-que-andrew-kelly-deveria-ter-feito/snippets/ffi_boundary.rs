#[derive(Copy, Clone)]
#[repr(C)]
struct JSValue(u64);

unsafe extern "C" {
    /// By-value `JSValue`; C++ side null-checks and reads its own heap state.
    /// No caller-side preconditions -> `safe fn`.
    safe fn JSC__JSValue__unpinArrayBuffer(v: JSValue);
}

fn main() {
    // The declaration type-checks. A real program would link the C++ symbol.
}
