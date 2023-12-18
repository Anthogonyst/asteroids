const std = @import("std");
const raylib = @import("raylib");
const raymath = @import("raylib-math");
const raygui = @import("raygui");
const Shared = @import("../Shared.zig").Shared;
const StarfieldViewModel = @import("../ViewModels/StarfieldViewModel.zig").StarfieldViewModel;

const vm: type = StarfieldViewModel.GetVM();

fn DrawFunction() Shared.View.Views {
    raylib.clearBackground(Shared.Color.Tone.Dark);

    // Draw meteors
    for (0..vm.STARS_COUNT) |i| {
        if (vm.starfield[i].m14 < 0.5) {
            raylib.drawPixelV(
            	vm.starsPosition[i],
                Shared.Color.Gray.Dark
            );
        } else {
            raylib.drawPixelV(
            	vm.starsPosition[i],
                Shared.Color.Gray.Light
	        );
	    }
    }

    if (Shared.Input.Start_Pressed()) {
        return Shared.View.Pause(.Starfield);
    }

    return .Starfield;
}

pub const StarfieldView = Shared.View.View{
    .DrawRoutine = &DrawFunction,
    .VM = &StarfieldViewModel,
};
