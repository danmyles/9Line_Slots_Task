function [] = draw_grid(screenInfo)
% ----------------------------------------------------------------------
% draw_grid(screenInfo)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a grid on screen to containg symbols
% ----------------------------------------------------------------------
% Input(s) :
% screenInfo
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% ----------------------------------------------------------------------

% For loop to iterate through positions 1:9 but skip 4 and 6.
% Then draw a rectangle at each grid location

for i = [1:3, 5, 7:9]
    Screen('FrameRect', screenInfo.window, screenInfo.black, screenInfo.gridPos(i, :), screenInfo.gridPenWidthPixel);
end

% Now we draw two rects at the top and the bottom of the screen to obscure 
% symbols passing underneath during animations

% Top - Using relative positioning information from screenInfo
Screen('FillRect', screenInfo.window, screenInfo.white, [screenInfo.windowRect(1:3), screenInfo.gridPos(1, 2)]);

% Bottom - Using relative positioning information from screenInfo

bottom_pos = screenInfo.windowRect;
bottom_pos(2) = screenInfo.gridPos(3,4);
Screen('FillRect', screenInfo.window, screenInfo.white, bottom_pos);
    
end