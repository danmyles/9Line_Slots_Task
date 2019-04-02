%% Script to draw a simple grid on screen
% Based loosely on http://peterscarfe.com/ptbtutorials.html

% Call setup scripts
setup_screen
setup_reelInfo
setup_grid

% Draw the rect to the screen
% Set Colour to black (0)
% Iterate through all positions
%% This should be converted to a function called call_grid
for i = 1:9
    if i ~= [4, 6]
        Screen('FrameRect', window, 0, reelInfo.grid_position{i}, penWidthPixels);
    end
end

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca; 
