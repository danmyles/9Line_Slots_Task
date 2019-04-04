%% Script to draw a grid on screen

% Draw the rect to the screen.
% Set Colour to black (0).
% Iterate through positions 1:9 but skip 4 and 6.

for i = 1:9
    if i ~= [4, 6]
        Screen('FrameRect', window, 0, reelInfo.grid_position{i}, penWidthPixels);
    end
end
