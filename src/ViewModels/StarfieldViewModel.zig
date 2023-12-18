const std = @import("std");
const Shared = @import("../Shared.zig").Shared;
const raylib = @import("raylib");
const raymath = @import("raylib-math");
//const RndGen = std.rand.DefaultPrng;
const SettingsManager = @import("../Settings.zig").Settings;

pub const StarfieldViewModel = Shared.View.ViewModel.Create(
    struct {
        // Define Constants
        pub const STARS_COUNT: i32 = 800;
        const randomSeeded = false;
        const fixedSeed: f32 = 42;

        // Variables
        pub var screenSize: raylib.Rectangle = undefined;
        pub var starfield: [STARS_COUNT]raylib.Matrix = undefined;

        // Mapping 1:1 to starfield for drawing functions that use Vector2
        pub var starsPosition: [STARS_COUNT]raylib.Vector2 = undefined;

        //const rand = undefined;
        //const rand = RndGen.init(@as(u64, @intFromFloat(fixedSeed)));

        // Initialize game variables
        pub inline fn init() void {
            //const width = SettingsManager.Resolution.Width;
            //const height = SettingsManager.Resolution.Height;
            screenSize = Shared.Helpers.GetCurrentScreenSize();

//            if (randomSeeded) {
//                rand.* = &Shared.Random.Get();
//            } else {
//                var rnd = RndGen.init(@as(u64, @intFromFloat(fixedSeed)));
//                rand.* = &rnd;
//           }

            // Initialization shoot
            for (0..STARS_COUNT) |i| {
                starfield[i] = raymath.matrixIdentity();
                starfield[i] = raymath.matrixMultiply(
                    starfield[i],
                    raymath.matrixTranslate(
                        // TODO: Incorporate Resolution targets in View instead
                        Shared.Random.Get().float(f32) * 2000 - 1000,
                        Shared.Random.Get().float(f32) * 2000 - 1000,
                        Shared.Random.Get().float(f32)
                    )
                );

                starsPosition[i] = raylib.Vector2.init(
                    starfield[i].m12,
                    starfield[i].m13
                );
            }
        }
    },
    .{
        .Init = init,
    },
);

fn init() void {
    StarfieldViewModel.GetVM().init();
}
