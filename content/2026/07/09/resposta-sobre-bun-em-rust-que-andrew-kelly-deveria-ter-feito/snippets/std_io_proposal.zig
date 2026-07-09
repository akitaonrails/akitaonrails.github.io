const std = @import("std");
const Io = std.Io;

fn saveData(io: Io, data: []const u8) !void {
    const file = try Io.Dir.cwd().createFile(io, "save.txt", .{});
    defer file.close(io);

    try file.writeAll(io, data);

    const out: Io.File = .stdout();
    try out.writeAll(io, "save complete");
}

test "proposal snippet type-checks" {
    _ = saveData;
}
