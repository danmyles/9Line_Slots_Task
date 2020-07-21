function [] = draw_text(screenInfo, reelInfo, instructions, text)
% ----------------------------------------------------------------------
% draw_text(screenInfo, instructions)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw instruction text to the screen
% ----------------------------------------------------------------------
% Input(s) :
% screenInfo
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 20th July 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------

% Set up text size etc.
% Screen('TextSize', screenInfo.window, 26);
% Screen('TextFont', screenInfo.window, 'Courier');
% Screen('TextColor', screenInfo.window, screenInfo.black);

% Set up text for final text display

% Note the hacky workaround for annoying psychtoolbox textbounds behaviour.
% The | character sets the height (y dim) of every line to be the same
% The spaces (repmat) drive the | outside of the window.

DrawFormattedText2(['|' repmat(' ', 1, 200) text repmat(' ', 1, 200) '|'], ...
    'win', screenInfo.window, ...
    'sx', screenInfo.xCenter, 'sy', screenInfo.yCenter, ...
    'xalign','center','yalign','center','xlayout','center');

% Draw any key text
DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.cont);

% Draw a little red dot :)
Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), ...
    get_dimensions(screenInfo, [screenInfo.xCenter, screenInfo.ydot], 1, [0, 0, 15, 15]));

end