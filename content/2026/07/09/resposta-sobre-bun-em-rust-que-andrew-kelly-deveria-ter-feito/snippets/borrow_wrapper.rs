use std::os::raw::c_int;

#[repr(C)]
struct sockaddr_storage {
    bytes: [u8; 128],
}

struct PacketBuffer {
    peer: sockaddr_storage,
}

unsafe fn us_udp_packet_buffer_peer(
    buf: *mut PacketBuffer,
    _index: c_int,
) -> *mut sockaddr_storage {
    unsafe { &raw mut (*buf).peer }
}

impl PacketBuffer {
    pub fn get_peer(&mut self, index: c_int) -> &mut sockaddr_storage {
        // SAFETY: this harness owns `peer`; Bun's real code relies on uSockets.
        unsafe { &mut *us_udp_packet_buffer_peer(self, index) }
    }
}

fn main() {
    let mut buffer = PacketBuffer {
        peer: sockaddr_storage { bytes: [0; 128] },
    };
    let peer = buffer.get_peer(0);
    peer.bytes[0] = 1;
}
