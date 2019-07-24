function [t2, t1, t0, duration] = test_time(duration, jitter, screenInfo, gridInfo, reelInfo)
% ----------------------------------------------------------------------
% test_time(ISI)
% ----------------------------------------------------------------------
% Goal of the function :
% Simple function to control timing of reel presentation
% using two types of programming versions.
% ----------------------------------------------------------------------
% Input(s) :
% ISI: interstimulus interval provided in ms
% type : type of control of timing
% if type = 1 : frame control
% if type = 2 : vbl control
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : development
% ----------------------------------------------------------------------

% Sample one value unformily from a range of -ISIrange to +ISI range.
% Subtract this value from the ISI
ISI = duration + randsample(-jitter:jitter, 1);

% Convert ISI to seconds
ISI = ISI/1000;

% Convert ISI to number of frames to display and round to nearest whole
numFrames = round(ISI/screenInfo.ifi);

t0 = GetSecs;

for timeFlipT1 = 1:numFrames
    % Draw a grid
    draw_grid(screenInfo, gridInfo);
    
    % Draw shapes
    selectReels = [1:3];
    draw_shapes(screenInfo, reelInfo, selectReels);
    
    % Flip to the screen
    t1 = Screen('Flip', screenInfo.window);
end

for timeFlipT2 = 1:numFrames
    % Draw a grid
    draw_grid(screenInfo, gridInfo);
    
    % Draw shapes
    selectReels = [1:3, 7:9];
    draw_shapes(screenInfo, reelInfo, selectReels);
    
    % Flip to the screen
    t2 = Screen('Flip', screenInfo.window);
end

end


