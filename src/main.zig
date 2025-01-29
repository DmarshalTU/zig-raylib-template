const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
});
const print = @import("std").debug.print;

const player_run_texture_emb = @embedFile("assets/cat_run.png");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 1280;
    const screenHeight = 720;
    rl.InitWindow(screenWidth, screenHeight, "My First Game");
    defer rl.CloseWindow(); // Close window and OpenGL context

    var player_position = rl.Vector2{ .x = 640, .y = 320 };
    var player_velocity = rl.Vector2{ .x = 0, .y = 0 };
    var player_grounded = false;
    var player_flip = false;

    const player_run_texture_mem = rl.LoadImageFromMemory(".png", player_run_texture_emb, player_run_texture_emb.len);
    const player_run_texture = rl.LoadTextureFromImage(player_run_texture_mem);
    const player_run_num_frames = 4;
    var player_run_frame_timer: f32 = 0;
    var player_run_current_frame: i32 = 0;
    const player_run_frame_length: f32 = 0.1;

    rl.SetTargetFPS(60);

    // Main game loop
    while (!rl.WindowShouldClose()) {
        // Update
        //----------------------------------------------------------------------------------
        if (rl.IsKeyDown(rl.KEY_A)) {
            player_velocity.x = -400;
            player_flip = true;
        } else if (rl.IsKeyDown(rl.KEY_D)) {
            player_velocity.x = 400;
            player_flip = false;
        } else {
            player_velocity.x = 0;
        }

        player_velocity.y += 2000 * rl.GetFrameTime();

        if (player_grounded and rl.IsKeyPressed(rl.KEY_SPACE)) {
            player_velocity.y = -600;
            player_grounded = false;
        }

        player_position.x += player_velocity.x * rl.GetFrameTime();
        player_position.y += player_velocity.y * rl.GetFrameTime();

        if (player_position.y > @as(f32, @floatFromInt(rl.GetScreenHeight())) - 64) {
            player_position.y = @as(f32, @floatFromInt(rl.GetScreenHeight())) - 64;
            player_grounded = true;
        }

        if (player_position.x >= @as(f32, @floatFromInt(rl.GetScreenWidth())) - 64) {
            player_position.x = @as(f32, @floatFromInt(rl.GetScreenWidth())) - 64;
            player_grounded = true;
        }

        if (player_position.x <= 0) {
            player_position.x = 0;
            player_grounded = true;
        }

        player_run_frame_timer += rl.GetFrameTime();

        if (player_run_frame_timer > player_run_frame_length) {
            player_run_current_frame += 1;
            player_run_frame_timer = 0;

            if (player_run_current_frame == player_run_num_frames) {
                player_run_current_frame = 0;
            }
        }

        const player_run_width = @as(f32, @floatFromInt(player_run_texture.width));
        const player_run_height = @as(f32, @floatFromInt(player_run_texture.height));

        var player_source = rl.Rectangle{
            .x = @as(f32, @floatFromInt(player_run_current_frame)) * player_run_width / @as(f32, @floatFromInt(player_run_num_frames)),
            .y = 0,
            .width = player_run_width / @as(f32, @floatFromInt(player_run_num_frames)),
            .height = player_run_height,
        };

        // Flip player texture if moving left
        if (player_flip) {
            player_source.width = -player_source.width;
        }

        const player_dest = rl.Rectangle{
            .x = player_position.x,
            .y = player_position.y,
            .width = player_run_width * 4 / @as(f32, @floatFromInt(player_run_num_frames)),
            .height = player_run_height * 4,
        };

        // Draw
        //----------------------------------------------------------------------------------
        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.Color{ .r = 110, .g = 184, .b = 168, .a = 255 });

        rl.DrawTexturePro(player_run_texture, player_source, player_dest, .{ .x = 0, .y = 0 }, 0, rl.WHITE);

        rl.DrawFPS(10, 10);
    }

    rl.UnloadTexture(player_run_texture);
}
