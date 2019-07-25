function [gridInfo, screenInfo] = setup_grid(screenInfo)
% ----------------------------------------------------------------------
% setup_grid(screenInfo)
% ----------------------------------------------------------------------
% Goal of the function :
% Set grid squares positions and dimensions.
% ----------------------------------------------------------------------
% Input(s) :
% screenInfo
% ----------------------------------------------------------------------
% Output(s):
% gridInfo, screenInfo
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : development
% ----------------------------------------------------------------------

%% SET SIZE OF GRID SQUARES
% The coordinates gridInfo.Rect define the top left and bottom right 
% coordinates of our grid rectangles. [0, 0] refers to the top left corner 
% of the screen, from there we can move the rectangles to a new position. 
% [top-left-x top-left-y bottom-right-x bottom-right-y].
gridInfo.Rect = screenInfo.windowRect;
gridInfo.Rect(3) = gridInfo.Rect(3) * .20; % proportion of total screen size
gridInfo.Rect(4) = gridInfo.Rect(4) * .24; % proportion of total screen size

%% Width of the grid lines.
gridInfo.penWidthPixels = 3;

% Scalar to adjust grid square locations across the x & y axes for the
% penWidth so that they do not double up. 
% This is proportional to the x/y dimension of the grid squares minus 
% penWidthline to prevent doubling up of edges.
X_adjust = gridInfo.Rect(3) - gridInfo.penWidthPixels;
Y_adjust = gridInfo.Rect(4) - gridInfo.penWidthPixels;

%% Adjust screen split co-ordinates for penWidth (else they over lap)

% This divides the screen at three points. The position is determined
% using the central point +/- the length (X) or width (Y) of the grid
% square

splitYpos = [screenInfo.yCenter - Y_adjust,...
                        screenInfo.yCenter, ... 
                        screenInfo.yCenter + Y_adjust];

splitXpos = [screenInfo.xCenter - X_adjust, ... 
                        screenInfo.xCenter, ... 
                        screenInfo.xCenter + X_adjust];
                    
% Each of these central points are useful for a number of tasks so we will
% add them screenInfo as a 3x3 cell array, each cell will be placed in the
% cell as per their corresponding grid+symbol position.

for X_select = 1:3
    for Y_select = 1:3
        screenInfo.splitpos{Y_select, X_select} = [splitXpos(X_select), splitYpos(Y_select)];
    end 
end

%% Set all positions for the grid

for column_select = 1:3
    for row_select = 1:3
        
        grid_X = screenInfo.splitpos{row_select, column_select}(1); % Go to column, row. Subset 1st in cell (X value)
        grid_Y = screenInfo.splitpos{row_select, column_select}(2); % Go to column, row. Subset 2nd in cell (Y value)
        
        gridInfo.position{row_select, column_select} = ... 
            CenterRectOnPointd(gridInfo.Rect, grid_X, grid_Y);
    end
end 
end