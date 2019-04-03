%% Script to draw a 9 random symbols onscreen
% Slimmed down draw script
% Bibiliography:
% http://peterscarfe.com/ptbtutorials.html

% Call setup scripts
setup_screen
setup_reelInfo
setup_grid
 
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

%% Assign Screen Positions for new Shapes
% This next script computes the screen positions that each shape will be 
% drawn using. This was a little tricky as FillPoly uses different
% input to FillRect and FillOval. 

% The script uses two for loops. The i loop cycles through each reel, and 
% the j loop cycles through each row position on that reel.

% There are then a number of switch statments. These split the flow so that
% FillPoly is treated seperately to FillRect and Fill Oval. I also used a
% switch statment to assign the number of sides to each poly shape. The
% output of this results in dimensions that are appropriate for the shape
% selected by the game script.

for i = 1:3
    for j = 1:3
        reelInfo.reel_ID{j, i} = [j, i];
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

%% DRAW ALL SHAPES TO SCREEN
% Draw shapes to position 1:9
for i = 1:9
   switch(reelInfo.sym_shape{i})
        case "circ"
            Screen('FillOval', window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
        case "tri"
            Screen('FillPoly', window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
        case "rect"
            Screen('FillRect', window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
        case "diam"
            Screen('FillPoly', window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
        case "pent"
            Screen('FillPoly', window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
    end   
end

% Draw a grid
for i = 1:9
    if i ~= [4, 6]
        Screen('FrameRect', window, 0, reelInfo.grid_position{i}, penWidthPixels);
    end
end

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;