function [] = draw_fixation(screenInfo)
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
fixCrossDimPix = Screen('Rect', 0); % ~22
fixCrossDimPix = fixCrossDimPix(4)/45;

% Set the line width for our fixation cross
lineWidthPix = 1;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix, fixCrossDimPix, 0, 0];
yCoords = [0, 0, -fixCrossDimPix, fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Draw a fixation cross in black at the centre of the screen
Screen('DrawLines', screenInfo.window, allCoords,...
    lineWidthPix, screenInfo.black, screenInfo.screenCenter, 2);
end