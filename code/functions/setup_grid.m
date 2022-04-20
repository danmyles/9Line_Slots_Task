function [screenInfo] = setup_grid(screenInfo)
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
% Last update : 19th April 2022
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------
 
%% SET SIZE OF GRID SQUARES
% The coordinates gridInfo.Rect define the top left and bottom right 
% coordinates of our grid rectangles. [0, 0] refers to the top left corner 
% of the screen, from there we can move the rectangles to a new position. 
% [top-left-x top-left-y bottom-right-x bottom-right-y].
screenInfo.gridRect = screenInfo.windowRect;
screenInfo.gridRect(3) = screenInfo.gridRect(3) * (1/5); % proportion of total screen size
screenInfo.gridRect(4) = screenInfo.gridRect(4) * (1/4); % proportion of total screen size

screenInfo.gridRect = floor(screenInfo.gridRect); % Drop any pesky decimals

%% Width of the grid lines.
screenInfo.gridPenWidthPixel = floor(screenInfo.windowRect(4)/300);

% Scalar to adjust grid square locations across the x & y axes for the
% penWidth so that they do not double up. 

% This is proportional to the x/y dimension of the grid squares minus 
% penWidthline to prevent doubling up of edges.

% These values will be useful later for drawing objects to the screen and
% so I've saved them to screenInfo

screenInfo.X_adjust = screenInfo.gridRect(3) - screenInfo.gridPenWidthPixel;
screenInfo.Y_adjust = screenInfo.gridRect(4) - screenInfo.gridPenWidthPixel;

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
                   
% Drop any decimals
screenInfo.splitposX = floor(screenInfo.splitposX);
screenInfo.splitposY = floor(screenInfo.splitposY);
                    
% Some places to draw text:
screenInfo.cont = (screenInfo.screenYpixels - (screenInfo.yCenter/4));
screenInfo.ydot = (screenInfo.cont + screenInfo.screenYpixels)/2;
screenInfo.textaboveC = (screenInfo.yCenter - screenInfo.yCenter/5);
screenInfo.textbelowC = (screenInfo.yCenter + screenInfo.yCenter/5);

% And drop any decimals, again.
screenInfo.cont = floor(screenInfo.cont);
screenInfo.ydot = floor(screenInfo.ydot);
screenInfo.textaboveC = floor(screenInfo.textaboveC);
screenInfo.textbelowC = floor(screenInfo.textbelowC);

% Each of these central points are useful for a number of tasks so we will
% save them for later use

% Fill out a matrix with all X and Y values for drawin the grid

i = 1; % Use i to count through each row of the grid position matrix

for X = 1:3 % Enter X Position
    for Y = 1:3 % Enter Y Position
        screenInfo.splitpos(i, :) =  [screenInfo.splitposX(X); screenInfo.splitposY(Y)];
        screenInfo.gridPos(i, :) = CenterRectOnPointd(screenInfo.gridRect, screenInfo.splitposX(X), screenInfo.splitposY(Y));
        i = i + 1; % Increase i
    end
end

clear i;
    
end