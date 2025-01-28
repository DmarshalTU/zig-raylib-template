const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
});
const print = @import("std").debug.print;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    var player_position = rl.Vector2{ .x = 640, .y = 320 };
    const player_size = rl.Vector2{ .x = 64, .y = 64 };
    var player_velocity = rl.Vector2{ .x = 0, .y = 0 };
    var player_grounded: bool = false;

    // Assets
    //--------------------------------------------------------------------------------------
    // const player_run_texture = rl.loadTexture("assets/cat_run.png");
    // defer rl.unloadTexture(player_run_texture);

    rl.InitWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.CloseWindow(); // Close window and OpenGL context

    rl.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.WindowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        if (rl.IsKeyDown(rl.KEY_A)) {
            print("A pressed\n", .{});
            player_velocity.x -= 400 * rl.GetFrameTime();
        } else if (rl.IsKeyDown(rl.KEY_D)) {
            print("D pressed\n", .{});
            player_velocity.x += 400 * rl.GetFrameTime();
        } else {
            player_velocity.x = 0;
        }

        player_velocity.y += 2000 * rl.GetFrameTime();

        if (rl.IsKeyPressed(rl.KEY_SPACE) and player_grounded) {
            print("SPACE pressed\n", .{});
            player_velocity.y = -600;
            player_grounded = false;
        }

        player_position.x += player_velocity.x * rl.GetFrameTime();
        player_position.y += player_velocity.y * rl.GetFrameTime();

        if (player_position.y > @as(f32, @floatFromInt(rl.GetScreenHeight())) - 64) {
            player_position.y = @as(f32, @floatFromInt(rl.GetScreenHeight())) - 64;
            player_grounded = true;
        }

        if (player_position.x > @as(f32, @floatFromInt(rl.GetScreenWidth())) - 64) {
            player_position.x = @as(f32, @floatFromInt(rl.GetScreenWidth())) - 64;
            player_grounded = true;
        } else if (player_position.x <= 0) {
            player_position.x = 0;
        }

        // Draw
        //----------------------------------------------------------------------------------
        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.WHITE);

        rl.DrawText("Congrats! You created your first window!", 190, 200, 20, rl.WHITE);
        // rl.drawTextureV(player_texture, 100, 100);
        rl.DrawRectangleV(player_position, player_size, rl.GREEN);
        // rl.drawTextureV(player_run_texture, player_position, rl.WHITE);
        //----------------------------------------------------------------------------------

        rl.DrawFPS(10, 10);
    }
}
