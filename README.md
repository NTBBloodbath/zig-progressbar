# zig-progressbar

This is a small library to create progress bars in your terminal. Pretty much vaporwave right now.

## Basic Usage

To use `zig-progressbar` in your project add it as a submodule then include it in your `build.zig`:

```zig
const progressbar = @import("/path/to/zig-progressbar/build.zig");

pub fn build(b: *std.build.Builder) void {
    // ...
    exe.addPackage(progressbar.pkgs.progressbar);
    // ...
}
```

After that you should be able to use it in your executable by importing `progressbar`.
```zig
const progressbar = @import("progressbar");
```

## License

`zig-progressbar` is licensed under [GPLv3](./LICENSE) License.
