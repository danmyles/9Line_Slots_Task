%% Script to draw a pentagon
% source: http://peterscarfe.com/ptbtutorials.html

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

% Draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen. When only one screen is attached to the monitor we will draw to
% this.
% For help see: help max
screenNumber = min(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open the main window with multi-sampling for anti-aliasing
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [], [], [], [], 6, []);

 % Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Number of sides for our polygon
numSides = 5;

% Angles at which our polygon vertices endpoints will be. We start at zero
% and then equally space vertex endpoints around the edge of a circle. The
% polygon is then defined by sequentially joining these end points.
% -90 to rotate shape 90 degrees left
anglesDeg = linspace(0, 360, numSides + 1 ) - 90; 
anglesRad = anglesDeg * (pi / 180);
radius = 75;

% X and Y coordinates of the points defining out polygon, centred on the
% centre of the screen
yPosVector = sin(anglesRad) .* radius + yCenter;
xPosVector = cos(anglesRad) .* radius + xCenter;

%% Test: 
% % Drawing Coloured Dots at Each Angle of the Polygon to determine
% % where the pent starts drawing
% 
% circ_colour = [238/255, 000/255, 001/255];
% tri_colour  = [229/255, 211/255, 103/255];
% rect_colour = [152/255, 230/255, 138/255];
% diam_colour = [000/255, 162/255, 255/255];
% pent_colour = [141/255, 038/255, 183/255];
% dot_colours = [circ_colour; tri_colour; rect_colour; diam_colour; pent_colour]
% 
%  for i = 1:numSides
%     dotXpos = xPosVector(i);
%     dotYpos = yPosVector(i);
%     dotSizePix = 20;
%     Screen('DrawDots', window, [dotXpos dotYpos], dotSizePix, dot_colours(i, :), [], 2);
%  end 
%%
 
% Set the color of the rect
pent_colour = [141/255, 038/255, 183/255];

% Cue to tell PTB that the polygon is convex (concave polygons require much
% more processing)
isConvex = 1; 

% Draw the rect to the screen
Screen('FillPoly', window, pent_colour, [xPosVector; yPosVector]', isConvex);

% Flip to the screen
Screen('Flip', window);

%% Take an image of the screen
% % GetImage call. Alter the rect argument to change the location of the screen shot
% imageArray = Screen('GetImage', window);
%   
% % imwrite is a Matlab function, not a PTB-3 function
% imwrite(imageArray, 'test.jpg')
%%

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;