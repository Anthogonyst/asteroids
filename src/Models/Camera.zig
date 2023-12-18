const std = @import("std");
const Shared = @import("../Shared.zig").Shared;
const raylib = @import("raylib");

pub const Camera = struct {
    Init: *const fn () void = undefined,
    DeInit: *const fn () void = undefined,
    Get: *const fn () void,
    BypassDeinit: *const bool = undefined,
    ModifyCamera: *const fn (mat: raylib.Matrix, zoom: f32) void = undefined,

    pub inline fn Create(
        comptime cam: type,
        orientation: raylib.Matrix,
        zoom: f32,
        modifyCamFUN: fn,
        options: ?CameraCreationOptions
    ) Camera {
        const Inner = struct {
            fn func() type {
                return cam;
            }
        };

        if (options != null) {
            const init = options.?.Init;
            const deinit = options.?.DeInit;
            const bypassDeinit = &options.?.BypassDeinit;
            return Camera {
                .Get = @constCast(@ptrCast(&Inner.func)),
                .ModifyCamera = modifyCamFUN,
                .Init = init,
                .DeInit = deinit,
                .BypassDeinit = bypassDeinit,
            };
        }

        return Camera {
            .Get = @constCast(@ptrCast(&Inner.func)),
            .ModifyCamera = modifyCamFUN,
        };
    }

    pub inline fn GetCamera(comptime self: Camera) type {
        const vm: *const fn () type = @ptrCast(self.Get);
        return vm.*();
    }
};

pub const CameraCreationOptions = struct {
    Init: *const fn () void = undefined,
    DeInit: *const fn () void = undefined,
    BypassDeinit: bool = false,
};
