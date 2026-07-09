const std = @import("std");

fn readThing(alloc: std.mem.Allocator, fail: bool) ![]u8 {
    const buf = try alloc.alloc(u8, 16);
    errdefer alloc.free(buf);

    if (fail) return error.Boom;
    return buf;
}

test "leak em caminho de erro" {
    const alloc = std.testing.allocator;
    try std.testing.expectError(error.Boom, readThing(alloc, true));
}
