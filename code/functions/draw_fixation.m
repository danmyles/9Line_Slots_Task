function [] = draw_fixation(screenInfo, reelInfo)
% ----------------------------------------------------------------------
% draw_fixation(screenInfo)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a fixation cross at the centre of the screen
% ----------------------------------------------------------------------
% Input(s) :
% screenInfo
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% ----------------------------------------------------------------------

% Set the size of the fixation cross arms in pixels
fixCrossDimPix = floor(screenInfo.gridRect(4)/8);

% Set the line width for our fixation cross
lineWidthPix = 3;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix, fixCrossDimPix, 0, 0];
yCoords = [0, 0, -fixCrossDimPix, fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Draw a fixation cross at the centre of the screen

% Citation: 

Screen('FillOval', screenInfo.window, screenInfo.black, CenterRectOnPoint([0, 0, fixCrossDimPix, fixCrossDimPix], screenInfo.xCenter, screenInfo.yCenter), 600)

Screen('DrawLines', screenInfo.window, allCoords, ...
    lineWidthPix, screenInfo.white, screenInfo.screenCenter, 2);

Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), CenterRectOnPoint([0, 0, 6, 6], screenInfo.xCenter, screenInfo.yCenter), 60)

end
