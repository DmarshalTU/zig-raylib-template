const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
});
const print = @import("std").debug.print;

// Embedded
const player_texture = @embedFile("assets/cat_run.png");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    var player_position = rl.Vector2{ .x = 640, .y = 320 };
    //const player_size = rl.Vector2{ .x = 64, .y = 64 };
    var player_velocity = rl.Vector2{ .x = 0, .y = 0 };
    var player_grounded: bool = false;
    //const frames = 4;

    rl.InitWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.CloseWindow(); // Close window and OpenGL context

    // Assets
    //--------------------------------------------------------------------------------------
    const player_run_texture_mem = rl.LoadImageFromMemory(".png", player_texture, player_texture.len);
    const p_texture = rl.LoadTextureFromImage(player_run_texture_mem);
    const player_source = rl.Rectangle{ .x = 0, .y = 0, .width = 16, .height = 16 };

    print("PH: {}\nPW: {}\n", .{ p_texture.height, p_texture.width });
    defer rl.UnloadTexture(p_texture);

    rl.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

    // Main game loop
    while (!rl.WindowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        if (rl.IsKeyDown(rl.KEY_A)) {
            player_velocity.x -= 400 * rl.GetFrameTime();
        } else if (rl.IsKeyDown(rl.KEY_D)) {
            player_velocity.x += 400 * rl.GetFrameTime();
        } else {
            player_velocity.x = 0;
        }

        player_velocity.y += 2000 * rl.GetFrameTime();

        if (rl.IsKeyPressed(rl.KEY_SPACE) and player_grounded) {
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

        rl.DrawText("Congrats! You created your first window!", 190, 200, 20, rl.BLACK);
        rl.DrawTextureRec(p_texture, player_source, player_position, rl.BLACK);
        //rl.DrawTextureV(p_texture, player_position, rl.BLACK);
        //----------------------------------------------------------------------------------

        rl.DrawFPS(10, 10);
    }
}
