struct Pipe;

impl Pipe {
    fn close(&mut self, _callback: fn(*mut Pipe)) {}
}

struct Subprocess;

impl Subprocess {
    fn on_pipe_close(_pipe: *mut Pipe) {}
}

enum WindowsStdioResult {
    Buffer(Box<Pipe>),
    Unavailable,
}

fn close_stdio(r: WindowsStdioResult) {
    match r {
        WindowsStdioResult::Buffer(pipe) => {
            Box::leak(pipe).close(Subprocess::on_pipe_close)
        }
        WindowsStdioResult::Unavailable => {}
    }
}

fn main() {
    close_stdio(WindowsStdioResult::Buffer(Box::new(Pipe)));
}
