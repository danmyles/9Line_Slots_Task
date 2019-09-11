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
% Version : 2019a
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
gridInfo.penWidthPixels = floor(screenInfo.windowRect(4)/300);

% Scalar to adjust grid square locations across the x & y axes for the
% penWidth so that they do not double up. 

% This is proportional to the x/y dimension of the grid squares minus 
% penWidthline to prevent doubling up of edges.

% These values will be useful later for drawing objects to the screen and
% so I've saved them to screenInfo

screenInfo.X_adjust = gridInfo.Rect(3) - gridInfo.penWidthPixels;
screenInfo.Y_adjust = gridInfo.Rect(4) - gridInfo.penWidthPixels;

%% Adjust screen split co-ordinates for penWidth (else they over lap)

% This divides the screen at three points. The position is determined
% using the central point +/- the length (X) or width (Y) of the grid
% square.

screenInfo.splitposX = [screenInfo.xCenter - screenInfo.X_adjust, ... 
                        screenInfo.xCenter, ... 
                        screenInfo.xCenter + screenInfo.X_adjust];

screenInfo.splitposY = [screenInfo.yCenter - screenInfo.Y_adjust,...
                        screenInfo.yCenter, ... 
                        screenInfo.yCenter + screenInfo.Y_adjust];
                   

% Each of these central points are useful for a number of tasks so we will
% save them for later use

% Fill out a matrix with all X and Y values for drawin the grid

i = 1; % Use i to count through each row of the grid position matrix

for X = 1:3 % Enter X Position
    for Y = 1:3 % Enter Y Position
        screenInfo.splitpos(i, :) =  [screenInfo.splitposX(X); screenInfo.splitposY(Y)];
        gridInfo.position(i, :) = CenterRectOnPointd(gridInfo.Rect, screenInfo.splitposX(X), screenInfo.splitposY(Y));
        i = i + 1; % Increase i
    end
end

clear i;
    
end