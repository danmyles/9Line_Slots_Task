function [] = draw_shapes(screenInfo, reelInfo, selectReels)
% ----------------------------------------------------------------------
% draw_shapes(screenInfo, reelInfo, selectReels)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a grid on screen
% ----------------------------------------------------------------------
% Input(s) :
% screenInfo, gridInfo
%
% selectReels - any set of numbers between 1 and 9. 
%
% Position Numbers:
%   1   4   7
%   2   5   8
%   3   6   9
%
% NOTE: Functions designed to leave positions 4 and 6 blank
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% ----------------------------------------------------------------------
    
% Tell PTB that polygons should be convex (concave polygons require much
% more processing)
isConvex = 1;

% This for loop uses the selectReels variable to draw a shape to each reel
% position. The loop also skips the 4th and 6th position to avoid filling
% these.

% Colour information is derived from the colours defined in
% reelInfo.colours during the setup_reelInfo function

for i = selectReels
    if i ~= [4, 6]
        switch(reelInfo.sym_shape(i))
            case 1 % circ
                Screen('FillOval', screenInfo.window, reelInfo.colours(1, 1:3), reelInfo.sym_position{i});
            case 2 % diam
                Screen('FillPoly', screenInfo.window, reelInfo.colours(2, 1:3), reelInfo.sym_position{i}, isConvex);
            case 3 % tri
                Screen('FillPoly', screenInfo.window, reelInfo.colours(3, 1:3), reelInfo.sym_position{i}, isConvex);
            case 4 % rect
                Screen('FillRect', screenInfo.window, reelInfo.colours(4, 1:3), reelInfo.sym_position{i});
            case 5 % pent
                Screen('FillPoly', screenInfo.window, reelInfo.colours(5, 1:3), reelInfo.sym_position{i}, isConvex);
        end
    end
end

end
