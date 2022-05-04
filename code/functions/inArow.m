function [] = inArow(screenInfo, reelInfo)
% ----------------------------------------------------------------------
% inArow(screenInfo)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw five symbols in a row at screen centre
% ----------------------------------------------------------------------
% Input(s) :
% screenInfo
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : July 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------

% Set x positions
inArow = [
    screenInfo.xCenter-screenInfo.X_adjust; 
    screenInfo.xCenter-(screenInfo.X_adjust/2); 
    screenInfo.xCenter; 
    screenInfo.xCenter+(screenInfo.X_adjust/2); 
    screenInfo.xCenter+(screenInfo.X_adjust)
    ];

% Set y positions
inArow(:, 2) = screenInfo.yCenter;


% The triangle is drawn from the centre so is raised above the square in
% the row. It will look nicer if we adjust this as we did in the loading
% screen:
triangle = get_dimensions(screenInfo, inArow(3, :), 3);
square = get_dimensions(screenInfo, inArow(4, :), 4);

inArow(3, 2) = inArow(3, 2) + (square(4) - triangle(2, 2));

draw_shapes(screenInfo, reelInfo, inArow, [1, 2, 3, 4, 5]);

end
