%% Script to draw a grid on screen
% Based loosely on http://peterscarfe.com/ptbtutorials.html

% Width of the grid lines.
penWidthPixels = 5;

% Set Colour to black (0)
% Iterate through all grid positions and draw a FrameRect
for i = 1:9
Screen('FrameRect', window, 0, reelInfo.grid_position{i}, penWidthPixels);
end

% Flip to the screen
Screen('Flip', window);