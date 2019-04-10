function [reelInfo] = update_reelInfo(reelInfo, screenInfo, selectReels)
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
% Version : development
% ----------------------------------------------------------------------    

%% RANDOMLY ASSIGN SHAPES
% This is a place holder for the actual game script which will eventually
% be it's own function

reelSymbols = ["circ"; "tri"; "rect"; "diam"; "pent"];

% Randomly assign shapes to positions 1:9 excluding 4 and 6.
for i = selectReels
     if i ~= [4, 6]
         reelInfo.sym_shape{i} = randsample(reelSymbols,1,true);
     else
         reelInfo.sym_shape{i} = "empty_space";
     end
end

%% ASSIGN COLOURS
% Assign the appropriate colour values for each shape
for i =  selectReels
    if i ~= [4, 6]
        switch(reelInfo.sym_shape{i})
            case "circ"
                reelInfo.sym_col{i} = reelInfo.colours.circ;
            case "tri"
                reelInfo.sym_col{i} = reelInfo.colours.tri;
            case "rect"
                reelInfo.sym_col{i} = reelInfo.colours.rect;
            case "diam"
                reelInfo.sym_col{i} = reelInfo.colours.diam;
            case "pent"
                reelInfo.sym_col{i} = reelInfo.colours.pent;
        end
    end
end

%% ASSIGN SCREEN DIMENSIONS TO EACH REEL POSITION

% Set some base dimensions in pixels for our FillOval and FillRect
% commands. See the details in setup_reelInfo for gridRect.
baseRect = [0 0 100 100];

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

% The script also uses a for loop that takes the function input selectReels
% to allow for resetting of a subset of the reels (e.g. just reels 7:9). 

for i = selectReels
     switch(reelInfo.sym_shape{i})
            case {"tri", "diam", "pent"}
                
                switch(reelInfo.sym_shape{i})
                    case "tri"
                        numSides = 3;
                    case "diam"
                        numSides = 4;
                    case "pent"
                        numSides = 5;
                end
                
                anglesDeg = linspace(0, 360, numSides + 1 ) - 90;
                anglesRad = anglesDeg * (pi / 180);
                
                xPosVector = cos(anglesRad) .* radius + screenInfo.splitpos{i}(1);
                yPosVector = sin(anglesRad) .* radius + screenInfo.splitpos{i}(2);
                
                reelInfo.sym_position{i} = [xPosVector; yPosVector]';
                
            case {"circ", "rect"}
                reelInfo.sym_position{i} = ...
                    CenterRectOnPointd(baseRect, ...
                    screenInfo.splitpos{i}(1), ... 
                    screenInfo.splitpos{i}(2))';
        end
end    
end