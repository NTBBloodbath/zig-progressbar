const std = @import("std");
const string = @import("zigstr");

const term = @import("term.zig");

/// Progressbar struct
pub const ProgressBar = struct {
    /// Max length
    max: u64,
    /// Current progress. Default is `0`
    value: u64 = 0,
    /// Start timestamp
    start: std.time.Instant,
    /// Label message
    label: []const u8,
    /// Start character
    begin: u8,
    /// Fill character
    fill: u8,
    /// End character
    end: u8,
};

const ProgressBarTime = struct {
    sec: i32,
    min: i32,
    hours: i32,
};

/// Return the difference between current time and an earlier timestamp
fn diffTime(before: std.time.Instant) !u64 {
    var now = try std.time.Instant.now();
    var elapsed_time = now.since(before);
    return ((elapsed_time / std.time.ns_per_min) + (elapsed_time / std.time.ns_per_s));
}

/// Initialize a new progress bar
pub fn newWithFormat(comptime label: []const u8, max: u64, comptime format: []const u8) !ProgressBar {
    return ProgressBar{
        .max = max,
        .start = try std.time.Instant.now(),
        .label = label,
        .begin = format[0],
        .fill = format[1],
        .end = format[2],
    };
}

/// This is just a dummy function to test library and its dependencies work as expected.
///
/// NOTE: delete this function once everything is working
pub fn foo(allocator: std.mem.Allocator, stdout: anytype) !void {
    var pb = try newWithFormat("Converting Linux Kernel to Zig ...", 100, "[=]");

    var fill_char = std.ArrayList(u8).init(allocator);
    try fill_char.append(pb.fill);

    var fill = try string.fromOwnedBytes(allocator, fill_char.items);
    defer fill.deinit();

    try fill.repeat(pb.label.len + 1);
    try stdout.print("{s}  {c}{s}{c}\n", .{pb.label, pb.begin, fill, pb.end});
}

test "New progress bar with format" {
    var allocator = std.testing.allocator;

    var pb = try newWithFormat("Converting Linux Kernel to Zig ...", 100, "[=]");

    // NOTE: we do not need to deinit here as zigstr already frees it
    var fill_char = std.ArrayList(u8).init(allocator);
    try fill_char.append(pb.fill);

    var fill = try string.fromOwnedBytes(allocator, fill_char.items);
    defer fill.deinit();

    try fill.repeat(pb.label.len + 1);
    try std.io.getStdOut().writer().print("{s}\n", .{fill});
}
