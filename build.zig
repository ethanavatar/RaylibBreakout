const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const raylib_prebuild = b.addSystemCommand(&.{
        "cmake",
        "-S", "deps/raylib",
        "-B", "deps/raylib/build",
    });

    const raylib_build = b.addSystemCommand(&.{
        "cmake",
        "--build", "deps/raylib/build",
        "--config", "Release",
        "-j",
    });

    raylib_build.step.dependOn(&raylib_prebuild.step);

    const exe = b.addExecutable(.{
        .name = "raylib-platformer",
        .target = target,
        .optimize = optimize,
    });

    exe.addIncludePath(.{ .path = "include" });
    exe.addIncludePath(.{ .path = "deps/raylib/build/raylib/include" });
    exe.addCSourceFiles(
        &.{
            "src/main.c",
        },
        &.{
            "-std=c99",
            "-pedantic",
            "-Wall",
            "-Wextra",
        }
    );

    exe.linkLibC();
    exe.addLibraryPath(.{ .path = "deps/raylib/build/raylib/Release" });
    exe.linkSystemLibrary("raylib");

    exe.linkSystemLibrary("opengl32");
    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("gdi32");
    exe.linkSystemLibrary("shell32");
    exe.linkSystemLibrary("winmm");

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const raylib_clean = b.step("raylib", "Raylib build");
    raylib_clean.dependOn(&raylib_build.step);
}
