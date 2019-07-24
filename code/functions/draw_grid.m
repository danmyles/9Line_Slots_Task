function [] = draw_grid(screenInfo, gridInfo)
% ----------------------------------------------------------------------
% draw_grid(screenInfo, gridInfo)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a grid on screen to containg symbols
% ----------------------------------------------------------------------
% Input(s) :
% screenInfo, gridInfo
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : development
% ----------------------------------------------------------------------

% For loop to iterate through positions 1:9 but skip 4 and 6.
% Then draw a rectangle at each grid location

for i = 1:9
    if i ~= [4, 6]
        Screen('FrameRect', screenInfo.window, screenInfo.black, gridInfo.position{i}, gridInfo.penWidthPixels);
    end
end

% Now we draw two rects at the top and the bottom of the screen to obscure 
% symbols passing underneath during animations

% Top - Using relative positioning information from screenInfo & gridInfo
Screen('FillRect', screenInfo.window, screenInfo.white, [screenInfo.windowRect(1:3), gridInfo.position{1}(1,2)]); % CHANGE positions to use screenInfo relative positions.

% Bottom - Using relative positioning information from screenInfo &
% gridInfo
bottom_pos = screenInfo.windowRect;
bottom_pos(2) = gridInfo.position{3}(1,4);
Screen('FillRect', screenInfo.window, screenInfo.white, bottom_pos);
    
end