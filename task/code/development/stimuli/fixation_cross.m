%% Script to draw a fixation cross
% source: http://peterscarfe.com/fixationcrossdemo.html

% Clear the workshop and the screen
sca;
close all;
clearvars;

% Call some default settings for Pychotoolbox
PsychDefaultSetup(2);

% Skip the sync test while testing on latop
Screen('Preference', 'SkipSyncTests', 1);

% Get the screen numbers
screens = Screen('Screens');

% Draw to laptop screen while testing
screenNumber = 0; % max(screens) or 1 for external

% Define black and white values
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

% Get and save the maximum height and width of the 'active' screen 
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Setup the text type for the window
Screen('TextFont', window, 'Ariel');
Screen('TextSize', window, 36);

% Get the centre coordinate of your window
[xCenter, yCenter] = RectCenter(windowRect);
screenCenter = [xCenter, yCenter];

% Set the size of the fixation cross arms
fixCrossDimPix = 22;

% Set the line width for our fixation cross
lineWidthPix = 2;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix, fixCrossDimPix, 0, 0];
yCoords = [0, 0, -fixCrossDimPix, fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Draw a fixation cross in white at the centre of the screen
Screen('DrawLines', window, allCoords,...
    lineWidthPix, black, screenCenter, 2);

% Flip cross the the screen
Screen('Flip', window);

% Wait for any key press
KbStrokeWait;

% Clear the screen
sca;

