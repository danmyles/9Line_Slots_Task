%% Script to draw a grid on screen
% Based loosely on http://peterscarfe.com/ptbtutorials.html

% Draw the rect to the screen
% Set Colour to black (0)
% Iterate through all positions
for i = 1:9
    if i ~= [4, 6]
        Screen('FrameRect', window, 0, reelInfo.grid_position{i}, penWidthPixels);
    end
end
