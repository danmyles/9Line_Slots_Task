function [] = draw_fixation(screenInfo)
% Set the size of the fixation cross arms
fixCrossDimPix = 22;

% Set the line width for our fixation cross
lineWidthPix = 1;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix, fixCrossDimPix, 0, 0];
yCoords = [0, 0, -fixCrossDimPix, fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Draw a fixation cross in white at the centre of the screen
Screen('DrawLines', screenInfo.window, allCoords,...
    lineWidthPix, screenInfo.black, screenInfo.screenCenter, 2);
end