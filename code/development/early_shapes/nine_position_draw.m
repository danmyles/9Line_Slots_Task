%% Script to draw a 9 random symbols onscreen
% Bibiliography:
% http://peterscarfe.com/ptbtutorials.html

% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);  

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
% For help see: Screen Screens?
screens = Screen('Screens');

% We select the minimum of these numbers if we plan to draw to our laptop or main screen. 
% If we choose maximum this will set up a situation where when
% have two screens attached to our monitor we will draw to the external
% screen.
% screenNumber = max(screens);
screenNumber = min(screens);

% Define white (white will be 1 and black 0). This is because
% luminace values are (in general) defined between 0 and 1.
% For help see: help BlackIndex
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);

% For help see: Screen OpenWindow?
% Open the main window with multi-sampling for anti-aliasing
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [], [], [], [], 6, []);

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

%% SET UP reelInfo DATA STRUCTURE
reelInfo.reel_position = cell(3); % Contains Symbol ID Row x Reel
reelInfo.screen_position = cell(3); % Contains Screen Position in pixels
reelInfo.sym_shape = cell(3); % Will contain the symbol to display
reelInfo.sym_col = cell(3); % Contains the symbol RGB values

%% RANDOMLY ASSIGN SHAPES
% This is a place holder for the actual game script
% will hopefully be able to keep output

reel_symbols = ["circ"; "tri"; "rect"; "diam"; "pent"];

for i = 1:9
reelInfo.sym_shape{i} = randsample(reel_symbols,1,true);
end

%% ASSIGN COLOURS
colours.circ = [238/255, 000/255, 001/255];
colours.tri  = [229/255, 211/255, 103/255];
colours.rect = [152/255, 230/255, 138/255];
colours.diam = [000/255, 162/255, 255/255];
colours.pent = [141/255, 038/255, 183/255];

for i = 1:9
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

%% ASSIGN SCREEN DIMENSIONS TO EACH REEL POSITION

% Divide both the X and Y dimensions of the screen into 3 equal points
splitXpos = [screenXpixels * 0.25 screenXpixels * 0.5 screenXpixels * 0.75];
splitYpos = [screenYpixels * 0.75 screenYpixels * 0.5 screenYpixels * 0.25];

% Set some base dimensions in pixels, this is used to define the size of 
% our rect and oval shapes. The coordinates define the top left and bottom 
% right coordinates of our rect.
% [top-left-x top-left-y bottom-right-x bottom-right-y].
baseRect = [0 0 100 100];

% The FillPoly command takes a radius input to determine the size of the
% shapes. The corners of the polygon are positioned at this radius value
% from the central point. It is also neccesary to define the angle of each
% corner from this central point. This is done below as we require the
% number of sides in order to compute the angle.

% Three options for polygon size:

% ONE
% Use pythagorean theorem to find lenth of the diagonals of the baseRect.
% This can be used to create a polygon in which uses a radius length that
% is half the diagonal of our baseRect.
%radius = (sqrt(2 .* max(baseRect)^2))/2; 

% You may prefer to radius to be the same as the edge of the baseRect
%radius = max(baseRect)/2;

% Or 1.5 in the event you want to go for what "looks" about even.
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
% FillPoly is treated seperately to FillRect and Fill Oval. I also used a
% switch statment to assign the number of sides to each poly shape. The
% output of this results in dimensions that are appropriate for the shape
% selected by the game script.

for i = 1:3
    for j = 1:3
        reelInfo.reel_position{j, i} = [j, i];
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
                
                reelInfo.screen_position{j, i} = [xPosVector; yPosVector]';
            case {"circ", "rect"}
                reelInfo.screen_position{j, i} = ... 
                    CenterRectOnPointd(baseRect, splitXpos(i), splitYpos(j))';
        end
    end
end


% Draw shapes to position 1:9
for i = 1:9
   switch(reelInfo.sym_shape{i})
        case "circ"
            Screen('FillOval', window, reelInfo.sym_col{i}, reelInfo.screen_position{i});
        case "tri"
            Screen('FillPoly', window, reelInfo.sym_col{i}, reelInfo.screen_position{i}, isConvex);
        case "rect"
            Screen('FillRect', window, reelInfo.sym_col{i}, reelInfo.screen_position{i});
        case "diam"
            Screen('FillPoly', window, reelInfo.sym_col{i}, reelInfo.screen_position{i}, isConvex);
        case "pent"
            Screen('FillPoly', window, reelInfo.sym_col{i}, reelInfo.screen_position{i}, isConvex);
    end   
end

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;

