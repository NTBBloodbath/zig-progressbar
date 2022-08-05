//! This module adds some terminal-related utilities, mainly extracted from ziglibs/ansi-term
const std = @import("std");

const esc = "\x1B";
const csi = esc ++ "[";

/// Terminal size (columns and rows)
pub const TermSize = struct { cols: u16, rows: u16 };

/// Call ioctl to get terminal sizes
fn ioctl_TIOCGWINSZ(fd: std.os.fd_t, ws: *std.os.system.winsize) !void {
    while (true) {
        switch (std.os.errno(std.os.system.ioctl(fd, std.os.system.T.IOCGWINSZ, @ptrToInt(ws)))) {
            .SUCCESS => return,
            .INTR => continue,
            .INVAL => unreachable, // invalid request or argument
            .BADF => unreachable, // fd is not a file descriptor
            .FAULT => unreachable, // invalid argument
            .NOTTY => return std.os.TermiosGetError.NotATerminal, //  fd is not a tty
            else => |err| return std.os.unexpectedErrno(err),
        }
    }
}

/// Get current terminal size
///
/// **Example**:
/// ```
/// var size = try term.getSize(std.os.STDOUT_FILENO);
/// std.debug.print("Columns: {any}, Rows: {any}\n", .{size.cols, size.rows});
/// ```
pub fn getSize(handle: std.os.fd_t) !TermSize {
    var size: std.os.system.winsize = undefined;
    try ioctl_TIOCGWINSZ(handle, &size);

    return TermSize{ .cols = size.ws_col, .rows = size.ws_row };
}

/// Get screen width (terminal columns)
pub fn getScreenWidth() !u16 {
    var size = try getSize(std.os.STDOUT_FILENO);
    return size.cols;
}

/// Clear current terminal line
pub fn clearCurrentLine(writer: anytype) !void {
    try writer.writeAll(csi ++ "2K");
}

/// Hide cursor
pub fn hideCursor(writer: anytype) !void {
    try writer.writeAll(csi ++ "?25l");
}

/// Show cursor
pub fn showCursor(writer: anytype) !void {
    try writer.writeAll(csi ++ "?25h");
}
