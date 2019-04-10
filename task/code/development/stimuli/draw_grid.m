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

end