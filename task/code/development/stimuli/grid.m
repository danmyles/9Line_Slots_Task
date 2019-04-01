%% Script to draw a simple grid on screen
% Based loosely on http://peterscarfe.com/ptbtutorials.html

% Call setup scripts
% setup_screen

% Width of the grid lines.
penWidthPixels = 5;

% Draw the rect to the screen
% Set Colour to black (0)
% Iterate through all positions
for i = 1:9
Screen('FrameRect', window, 0, reelInfo.grid_position{i}, penWidthPixels);
end

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;

% Clear the screen
% sca;