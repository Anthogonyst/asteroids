const std = @import("std");
const Shared = @import("../Shared.zig").Shared;
const raylib = @import("raylib");
const raymath = @import("raylib-math");
const CameraBase = @import("Camera.zig").Camera;

pub const Cam2D = CameraBase.Camera.Create(
    struct {
        pub const cam = raylib.Camera.init {
            raylib.Vector2.init { 0, 0 },
            raylib.Vector2.init { 0, 0 },
            0,
            1
        };

        cam.modifyCamera(orientation, zoom);
    },
    .{},
    .{ 1 },
    .{
        .ModifyCamera = modifyCamera,
    },
);

fn modifyCamera(mat: raylib.Matrix, zoom: f32) void {
    UpdateCamera(
        CamOrtho.GetCamera().*,
        raylib.Vector3.init {
            mat.m12, mat.m13, mat.m14
        },
        raymath.quaternionToEuler(raymath.quaternionFromMatrix(mat)),
        zoom
    );
}
