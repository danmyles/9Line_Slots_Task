function [rectR, rectL] = draw_Bet(screenInfo, reelInfo, outputData, side)
% ------------------------------------------------------------------------
% draw_Bet(screenInfo, reelInfo, outputData, side)
% ------------------------------------------------------------------------
% Goal of the function :
% Draws the text and FrameRects for the betChoice screen.
% ------------------------------------------------------------------------
% Input(s) :
% screenInfo, reelInfo, outputData
% side <- tells function which side to draw each bet to
% ------------------------------------------------------------------------
% Output(s):
% [rectR, rectL] -> useful for more drawing in nested function.
% ------------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : April 2022
% Project : 9_Line_Slots_Task
% Version : 2021a
% ------------------------------------------------------------------------

% Note I had to edit this script. 
% The lab monitor had issues with line spacing using \n with DFT2.
% So each line of text is now done seperately :/

% ------------------------------------------------------------------------
% SET UP DIMENSIONS
% ------------------------------------------------------------------------

screenL = screenInfo.windowRect;
screenL(3) = screenL(3)/2;
screenR = [screenL(3), 0, screenInfo.windowRect(3:4)];

% Left Rect
[x, y] = RectCenter(screenL);                     % Get centre of left side of screen
rectL = CenterRectOnPoint(screenL * (2/3), x, y); % Get rect coords for FrameRect (size at 65%)

% Right Rect (as above)
[x, y] = RectCenter(screenR);
rectR = CenterRectOnPoint(screenL * (2/3), x, y);

% Co-ords for colour coding.
colourBlock = {[rectL([1:3]), rectL(2) + rectL(2)]; [rectR([1:3]), rectR(2) + rectR(2)]};

% Position values to inside rect for text draws
inset = rectL(2) /2;

xL = ((rectL(3) - rectL(1)) / 2) + rectL(1);
xR = rectR(1) + (rectR(3) - rectR(1))/2;

xLR = [xL, xR];

% ------------------------------------------------------------------------
% BLUE GAME - A
% ------------------------------------------------------------------------

% If side = [1, 2] then BLUE GREEN
% If side = [2, 1] then GREEN BLUE

% Colour block
Screen('FillRect', screenInfo.window, reelInfo.colours(2, :), colourBlock{side(1)}, screenInfo.gridPenWidthPixel);

Screen('TextSize', screenInfo.window, 52);
Screen('TextFont', screenInfo.window, 'Courier');

% Subset draw positions using the random draw in side
DrawFormattedText2('BLUE GAME', ...
    'win', screenInfo.window, ...
    'sx', xLR(side(1)), 'sy', rectL(2) + inset, ...
    'xalign','center','yalign','center','xlayout','center');

Screen('TextSize', screenInfo.window, 32);

DrawFormattedText2([num2str(reelInfo.lineBet(1) * 9), ' CREDITS PER SPIN'], ...
    'win', screenInfo.window, ...
    'sx', xLR(side(1)), 'sy', rectL(2) * 2 + inset, ...
    'xalign','center','yalign','center','xlayout','center');

Screen('TextSize', screenInfo.window, 22);

DrawFormattedText2(['CHOSEN ', num2str(reelInfo.betAChoices), ' TIMES '], ...
    'win', screenInfo.window, ...
    'sx', xLR(side(1)), 'sy', rectL(2) * 4, ...
    'xalign','center','yalign','center','xlayout','center');

DrawFormattedText2([num2str(reelInfo.lineBet(1)), ' CREDITS x 9 LINES'], ...
    'win', screenInfo.window, ...
    'sx', xLR(side(1)), 'sy', 'center', ...
    'xalign','center','yalign','center','xlayout','center');

% ------------------------------------------------------------------------
% GREEN GAME - B
% ------------------------------------------------------------------------

% Colour block
Screen('FillRect', screenInfo.window, reelInfo.colours(4, :), colourBlock{side(2)}, screenInfo.gridPenWidthPixel);

Screen('TextSize', screenInfo.window, 52);

% Subset draw positions using the random draw in side
DrawFormattedText2(['GREEN GAME'], ...
    'win', screenInfo.window, ...
    'sx', xLR(side(2)), 'sy', rectL(2) + inset, ...
    'xalign','center','yalign','center','xlayout','center');

Screen('TextSize', screenInfo.window, 32);

DrawFormattedText2([num2str(reelInfo.lineBet(2) * 9), ' CREDITS PER SPIN'], ...
    'win', screenInfo.window, ...
    'sx', xLR(side(2)), 'sy', rectL(2) * 2 + inset, ...
    'xalign','center','yalign','center','xlayout','center');

Screen('TextSize', screenInfo.window, 22);

DrawFormattedText2(['CHOSEN ', num2str(reelInfo.betBChoices), ' TIMES '], ...
    'win', screenInfo.window, ...
    'sx', xLR(side(2)), 'sy', rectL(2) * 4, ...
    'xalign','center','yalign','center','xlayout','center');

DrawFormattedText2([num2str(reelInfo.lineBet(2)), ' CREDITS x 9 LINES'], ...
    'win', screenInfo.window, ...
    'sx', xLR(side(2)), 'sy', 'center', ...
    'xalign','center','yalign','center','xlayout','center');

% ------------------------------------------------------------------------
% DRAW RECTs
% ------------------------------------------------------------------------

% Left
Screen('FrameRect', screenInfo.window, screenInfo.black, rectL, screenInfo.gridPenWidthPixel);
DrawFormattedText2('PRESS LEFT', ...
    'win', screenInfo.window, ...
    'sx', xL, 'sy', rectL(2) * 4 + inset, ...
    'xalign','center','yalign','center','xlayout','center');

% Right
Screen('FrameRect', screenInfo.window, screenInfo.black, rectR, screenInfo.gridPenWidthPixel);
DrawFormattedText2('PRESS RIGHT', ...
    'win', screenInfo.window, ...
    'sx', xR, 'sy', rectL(2) * 4 + inset, ...
    'xalign','center','yalign','center','xlayout','center');

% ------------------------------------------------------------------------
% DISPLAY CREDITS
% ------------------------------------------------------------------------

if reelInfo.trialIndex == 0

    credits = reelInfo.credits;

else

    credits = outputData.credits(reelInfo.trialIndex);

end

DrawFormattedText2(['---'], ...
    'win', screenInfo.window, ...
    'winRect', screenInfo.windowRect, ...
    'sx', 'center', 'sy', 'center', ...
    'xalign','center','yalign','center','xlayout','center');

DrawFormattedText2(['TOTAL CREDITS:'], ...
    'win', screenInfo.window, ...
    'winRect', screenInfo.windowRect, ...
    'sx', 'center', 'sy', screenInfo.yCenter - 22, ...
    'xalign','center','yalign','center','xlayout','center');

DrawFormattedText2(num2str(credits), ...
    'win', screenInfo.window, ...
    'winRect', screenInfo.windowRect, ...
    'sx', 'center', 'sy', screenInfo.yCenter + 22, ...
    'xalign','center','yalign','center','xlayout','center');

Screen('TextSize', screenInfo.window, 20);

end