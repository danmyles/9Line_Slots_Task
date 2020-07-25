function [rectR, rectL] = draw_Bet(screenInfo, reelInfo, outputData, side)
% ------------------------------------------------------------------------
% draw_Bet(screenInfo, reelInfo, side)
% ------------------------------------------------------------------------
% Goal of the function :
% Draws the text and FrameRects for the betChoice screen.
% ------------------------------------------------------------------------
% Input(s) :
% screenInfo, reelInfo
% side <- tells function which side to draw the HIGH/LOW bet to
% ------------------------------------------------------------------------
% Output(s):
% [rectR, rectL] -> useful for more drawing in nested function.
% ------------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : July 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
% SET UP DIMENSIONS
% ------------------------------------------------------------------------

screenL = screenInfo.windowRect;
screenL(3) = screenL(3)/2;
screenR = [screenL(3), 0, screenInfo.windowRect(3:4)];

% Left Rect
[x, y] = RectCenter(screenL);                     % Get centre of left side of screen
rectL = CenterRectOnPoint(screenL * 0.65, x, y);  % Get rect coords for FrameRect (size at 65%)

% Right Rect (as above)
[x, y] = RectCenter(screenR);
rectR = CenterRectOnPoint(screenL * 0.65, x, y);

% Smaller box to inset inside rect for text draws
textBox = {InsetRect(rectL, 75, 75); InsetRect(rectR, 75, 75)};

% ------------------------------------------------------------------------
% DRAW RECTs
% ------------------------------------------------------------------------

% Left
Screen('FrameRect', screenInfo.window, screenInfo.black, rectL, screenInfo.gridPenWidthPixel);
% 'Press Left'
DrawFormattedText2(['<size=20>PRESS LEFT'], ...
    'win', screenInfo.window, ...
    'winRect', textBox{1}, ...
    'sx', 'center', 'sy', 'bottom', ...
    'xalign','center','yalign','center','xlayout','center');

% Right
Screen('FrameRect', screenInfo.window, screenInfo.black, rectR, screenInfo.gridPenWidthPixel);
% 'Press Left'
DrawFormattedText2(['<size=20>PRESS RIGHT'], ...
    'win', screenInfo.window, ...
    'winRect', textBox{2}, ...
    'sx', 'center', 'sy', 'bottom', ...
    'xalign','center','yalign','center','xlayout','center');

% ------------------------------------------------------------------------
% BET LOW
% ------------------------------------------------------------------------

DrawFormattedText2(['<size=52>' '<b>BET LOW'], ...
    'win', screenInfo.window, ...
    'winRect', textBox{side(1)}, ... % Subset the text box using the first random draw in side
    'sx', 'center', 'sy', 'top', ...
    'xalign','center','yalign','center','xlayout','center');

DrawFormattedText2(['<size=32>9 CREDITS PER SPIN<size=20>', ...
    '\n\n\n\n', '1 CREDIT PER LINE x 9 LINES', ...
    '\n\n\n\n', num2str(reelInfo.nBetLow), ' REMAINING'], ...
    'win', screenInfo.window, ...
    'winRect', textBox{side(1)}, ...
    'sx', 'center', 'sy', 'center', ...
    'xalign','center','yalign','center','xlayout','center');

% ------------------------------------------------------------------------
% BET HIGH
% ------------------------------------------------------------------------

DrawFormattedText2(['<size=52>' '<b>BET HIGH'], ...
    'win', screenInfo.window, ...
    'winRect', textBox{side(2)}, ... % Subset the text box using the second random draw in side
    'sx', 'center', 'sy', 'top', ...
    'xalign','center','yalign','center','xlayout','center');

DrawFormattedText2(['<size=32>90 CREDITS PER SPIN<size=20>', ...
    '\n\n\n\n', '10 CREDITS PER LINE x 9 LINES', ...
    '\n\n\n\n', num2str(reelInfo.nBetHigh), ' REMAINING'], ...
    'win', screenInfo.window, ...
    'winRect', textBox{side(2)}, ...
    'sx', 'center', 'sy', 'center', ...
    'xalign','center','yalign','center','xlayout','center');

% ------------------------------------------------------------------------
% DISPLAY CREDITS
% ------------------------------------------------------------------------

if reelInfo.trialIndex == 0

    credits = reelInfo.credits;

else

    credits = outputData.credits(reelInfo.trialIndex);

end

DrawFormattedText2(['<size=20>TOTAL CREDITS:\n---\n' num2str(credits)], ...
    'win', screenInfo.window, ...
    'winRect', screenInfo.windowRect, ...
    'sx', 'center', 'sy', 'center', ...
    'xalign','center','yalign','center','xlayout','center');

end