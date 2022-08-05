const std = @import("std");
const Pkg = std.build.Pkg;

pub const pkgs = struct {
    pub const string = Pkg{
        .name = "string",
        .source = std.build.FileSource.relative("lib/zig-string/zig-string.zig"),
    };

    pub const progressbar = Pkg{
        .name = "progressbar",
        .source = .{ .path = "src/main.zig" },
        .dependencies = &[_]Pkg{
            string,
        },
    };
};

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("zig-progressbar", "src/main.zig");
    lib.setBuildMode(mode);
    lib.addPackage(pkgs.progressbar);
    lib.install();

    const main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);
    main_tests.addPackage(pkgs.string);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
