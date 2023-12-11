const std = @import("std");
const raylib = @import("raylib");
const raymath = @import("raylib-math");
const Shared = @import("../Shared.zig").Shared;

const camera: raylib.camera2D = { 0 }

pub const CameraController = struct {
    Init: *const fn () void = undefined,
    DeInit: *const fn () void = undefined,
    Get: *const fn () void,
    BypassDeinit: *const bool = undefined,

    pub inline fn Create(comptime view_model: type, options: ?VMCreationOptions) CameraController {
        const Inner = struct {
            fn func() type {
                return view_model;
            }
        };

        if (options != null) {
            const init = options.?.Init;
            const deinit = options.?.DeInit;
            const bypassDeinit = &options.?.BypassDeinit;
            return CameraController{
                .Get = @constCast(@ptrCast(&Inner.func)),
                .Init = init,
                .DeInit = deinit,
                .BypassDeinit = bypassDeinit,
            };
        }

        return CameraController{
            .Get = @constCast(@ptrCast(&Inner.func)),
        };
    }

    pub inline fn GetCamera(comptime self: CameraController) type {
        const camControl: *const fn () type = @ptrCast(self.Get);
        return camControl.*();
    }
};
