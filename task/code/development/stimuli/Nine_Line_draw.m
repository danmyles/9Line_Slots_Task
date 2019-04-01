%% Script to draw a number of squares onscreen
% source/citation:
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

% Draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen. When only one screen is attached to the monitor we will draw to
% this.
% For help see: help max
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

% Make a base Rect of 200 by 200 pixels. This is the rect which defines the
% size of our square in pixels. Rects are rectangles, so the
% sides do not have to be the same length. The coordinates define the top
% left and bottom right coordinates of our rect [top-left-x top-left-y
% bottom-right-x bottom-right-y]. The easiest thing to do is set the first
% two coordinates to 0, then the last two numbers define the length of the
% rect in X and Y. The next line of code then centers the rect on a
% particular location of the screen .
baseRect = [0 0 100 100];

% Use pythagorean theorem to find lenth of the diagonals of the baseRect.
% This will be used later to draw polygons of appropriate sizes when using
% the Fill Poly command, which takes a radius input.
% This will create a polygon in which the angles or corners are positioned
% along the raidus of a circle that is half the diagonal of our square.
radius = (sqrt(2 .* max(baseRect)^2))/2; 

% You may prefer to set the size to the same, in which case sub out:
% radius = max(baseRect)/2;

% Or 1.5 in the event you want to go for what "looks" even.
% radius = max(baseRect)/1.5;


% Call the colours of our shapes. These are defined at presnet in
% shape_colours.m. I will probably end up moving this.
shape_colours;
colour_vessel = nan(3, 9);
for i = 1:length(colour_vessel)
    colour_vessel(:, i) = all_colours(:, randsample(5, 1));
end

% Set up screen positions for our shapes
splitXpos = [screenXpixels * 0.25 screenXpixels * 0.5 screenXpixels * 0.75];
splitYpos = [screenYpixels * 0.75 screenYpixels * 0.5 screenYpixels * 0.25];

%% CURRENTLY WORKING FROM HERE

% Make our coordinates

% I am trying to construct a vector full of the seven co-ordinate points
% at each of the positions in the H design layout of my slot machine.

% Create a cell array a 3 x 3 cell array.
reelPositions = cell(3);

% Place the four rect dimensions in each of the 9 corresponding positions

for i = 1:3 % i being each of the three x positions
    for j = 1:3 % j being each of the three y positions
        for k = 1:4
            reelPositions{j, i} = CenterRectOnPointd(baseRect, splitXpos(i), splitYpos(j));
        end
    end
end

%%

%% Get reel positions

for i = 1:9
list_reelpos(i, :) = reelPositions{i};
end

% Draw shape to position 1
Screen('FillOval', window, colour_vessel, list_reelpos');

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;