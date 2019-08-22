function [reelInfo] = update_reelInfo(reelInfo, screenInfo, selectReels, reset)
% ----------------------------------------------------------------------
% update_reelInfo(reelInfo, gridInfo)
% ----------------------------------------------------------------------
% Goal of the function :
% Update reelInfo with values from last spin
% ----------------------------------------------------------------------
% Input(s) :
% reelInfo, gridInfo
% ----------------------------------------------------------------------
% Output(s):
% reelInfo - overwrites and updates reelInfo values in the base workspace 
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% ----------------------------------------------------------------------    

%% RANDOMLY ASSIGN SHAPES
% This is a place holder for the actual game script which will eventually
% be it's own function

% Randomly assign shapes to positions 1:9 excluding 4 and 6.

if reset == 1
    for i = selectReels
        if i ~= [4, 6]
            reelInfo.sym_shape(i) = randsample(1:5,1,true);
        else
            reelInfo.sym_shape(i) = 0;
        end
    end
end

%% ASSIGN SCREEN DIMENSIONS TO EACH REEL POSITION

% Set some base dimensions in pixels for our shapes
% commands. These are done relative to the screen information so that the
% shapes are proportional accross monitors. 
% See setup_reelInfo for gridRect (also defined using scree dimensions).

baseRect = screenInfo.windowRect;
baseRect(3:4) = screenInfo.windowRect(4) / 9;

% The FillPoly command takes a radius input to determine the size of the
% shapes. The corners of the polygon are positioned at this radius value
% from the central point. It is also neccesary to define the angle of each
% corner from this central point. This is done below as we require the
% number of sides in order to compute the angle.

% Three options for polygon size:

% 1) Use pythagorean theorem to find lenth of the diagonals of the baseRect.
% This can be used to create a polygon in which uses a radius length that
% is half the diagonal of our baseRect.
%radius = (sqrt(2 .* max(baseRect)^2))/2; 

% 2) You may prefer to radius to be the same as the edge of the baseRect
%radius = max(baseRect)/2;

% 3) Or 1.5 in the event you want to go for what "looks" about even.
radius = max(baseRect)/1.5;

% This next script computes the screen positions that each shape will be 
% drawn using. This was a little tricky as FillPoly takes a different
% input format to FillRect and FillOval. 

% To get around this I've used a number of switch statments. These split 
% the flow so that the output is prepared as appropriate for
% FillPoly/Rect/Oval.

% I also used a switch statment to assign the number of sides 
% to each poly shape. This can then be used to assign the appropriate 
% set of positions/dimensions.

% The script also uses a for loop that takes the function selectReels as
% input to allow for resetting of a subset of the reels 
% (e.g. just reels 7:9). 

for i = selectReels
     switch(reelInfo.sym_shape(i))
            case {3, 2, 5} % tri, diam, pent
                
                switch(reelInfo.sym_shape(i))
                    case 3 % tri
                        numSides = 3;
                    case 2 % diam
                        numSides = 4;
                    case 5 % pent
                        numSides = 5;
                end
                
                anglesDeg = linspace(0, 360, numSides + 1 ) - 90;
                anglesRad = anglesDeg * (pi / 180);
                
                xPosVector = cos(anglesRad) .* radius + screenInfo.splitpos{i}(1);
                yPosVector = sin(anglesRad) .* radius + screenInfo.splitpos{i}(2);
                
                reelInfo.sym_position{i} = [xPosVector; yPosVector]';
                
            case {1, 4} % circ or rect
                reelInfo.sym_position{i} = ...
                    CenterRectOnPointd(baseRect, ...
                    screenInfo.splitpos{i}(1), ... 
                    screenInfo.splitpos{i}(2))';
        end
end    
end