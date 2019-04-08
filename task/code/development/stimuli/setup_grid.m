function [gridInfo] = setup_grid(screenInfo)
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
% gridInfo
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

% Scalar to align grid square locations across the x-axis.
% This is proportional to the x dimension of the grid squares - 
% penWidthline to prevent doubling up of edges.
X_adjust = gridInfo.Rect(3) - gridInfo.penWidthPixels;
Y_adjust = gridInfo.Rect(4) - gridInfo.penWidthPixels;

%% Adjust screen split co-ordinates for penWidth (else they over lap)

% This divides the screen at three points. The position is determined
% using the central point +/- the length (X) or width (Y) of the grid
% square

gridInfo.splitYpos = [screenInfo.yCenter - Y_adjust,...
                        screenInfo.yCenter, ... 
                        screenInfo.yCenter + Y_adjust];

gridInfo.splitXpos = [screenInfo.xCenter - X_adjust, ... 
                        screenInfo.xCenter, ... 
                        screenInfo.xCenter + X_adjust];

% SET UP gridInfo.position
for i = 1:3
    for j = 1:3
        gridInfo.position{j, i} = ...
            CenterRectOnPointd(gridInfo.Rect, gridInfo.splitXpos(i), gridInfo.splitYpos(j))';
    end
end 
end