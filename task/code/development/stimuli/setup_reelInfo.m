%% SCRIPT TO SET UP THE reelInfo DATA STRUCTURE
% This script sets up a data structre that contains information about 
% the positions of each symbol determined by the spin, as well as
% information neccesary to draw the shapes the draw

%% SET UP reelInfo DATA STRUCTURE
reelInfo.reel_ID = cell(3); % Contains Reel ID Row x Reel
reelInfo.sym_position = cell(3); % Contains Screen Position in pixels
reelInfo.sym_shape = cell(3); % Will contain the symbol to display
reelInfo.sym_col = cell(3); % Contains the symbol RGB values
reelInfo.grid_position = cell(3);

%% ASSIGN REEL IDs
for i = 1:3
    for j = 1:3
        reelInfo.reel_ID{j, i} = [j, i];
    end
end

%% RANDOMLY ASSIGN SHAPES
% This is a place holder for the actual game script

reel_symbols = ["circ"; "tri"; "rect"; "diam"; "pent"];

% Randomly assign shapes to positions 1:9 excluding 4 and 6.
for i = 1:9
     if i ~= [4, 6]
         reelInfo.sym_shape{i} = randsample(reel_symbols,1,true);
     else
         reelInfo.sym_shape{i} = "empty_space";
     end
end

%% ASSIGN COLOURS
colours.circ = [238/255, 000/255, 001/255];
colours.tri  = [229/255, 211/255, 103/255];
colours.rect = [152/255, 230/255, 138/255];
colours.diam = [000/255, 162/255, 255/255];
colours.pent = [141/255, 038/255, 183/255];

for i = 1:9
    if i ~= [4, 6]
        switch(reelInfo.sym_shape{i})
            case "circ"
                reelInfo.sym_col{i} = colours.circ;
            case "tri"
                reelInfo.sym_col{i} = colours.tri;
            case "rect"
                reelInfo.sym_col{i} = colours.rect;
            case "diam"
                reelInfo.sym_col{i} = colours.diam;
            case "pent"
                reelInfo.sym_col{i} = colours.pent;
        end
    end
end

%% SETUP reelInfo.grid_position

setup_grid % See script

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

% Tell PTB that polygons should be convex (concave polygons require much
% more processing)
isConvex = 1;

% This next script computes the screen positions that each shape will be 
% drawn using. This was a little tricky as FillPoly uses different
% input to FillRect and FillOval. 

% The script uses two for loops. The i loop cycles through each reel, and 
% the j loop cycles through each row position on that reel.

% There are then a number of switch statments. These split the flow so that
% the output is prepared for FillPoly or, FillRect and Fill Oval.
% This is neccesary beucaase these take a different input for the position
% argument. I also used a switch statment to assign the number of sides 
% to each poly shape. The output of this results in a set of screen 
% positions the dimensions of which are appropriate for the shape selected 
% by the game script.

% The If statement determines whether the reel position should be left 
% blank or filled with a symbol

for i = 1:3
    for j = 1:3
        if ismember(reelInfo.sym_shape{2, 2}, reel_symbols)
            switch(reelInfo.sym_shape{j, i})
                case {"tri", "diam", "pent"}
                    switch(reelInfo.sym_shape{j, i})
                        case "tri"
                            numSides = 3;
                        case "diam"
                            numSides = 4;
                        case "pent"
                            numSides = 5;
                    end
                    anglesDeg = linspace(0, 360, numSides + 1 ) - 90;
                    anglesRad = anglesDeg * (pi / 180);
                    
                    yPosVector = sin(anglesRad) .* radius + splitYpos(j);
                    xPosVector = cos(anglesRad) .* radius + splitXpos(i);
                    
                    reelInfo.sym_position{j, i} = [xPosVector; yPosVector]';
                case {"circ", "rect"}
                    reelInfo.sym_position{j, i} = ...
                        CenterRectOnPointd(baseRect, splitXpos(i), splitYpos(j))';
            end
        end
    end
end

