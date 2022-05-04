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
inset = rectL(2) /2 + 4;

xL = rectL(1) + (rectL(3) - rectL(1))/2;
xR = rectR(1) + (rectR(3) - rectR(1))/2;

xLR = [xL, xR];

% ------------------------------------------------------------------------
% BLUE GAME - A
% ------------------------------------------------------------------------

% If side = [1, 2] then BLUE GREEN
% If side = [2, 1] then GREEN BLUE

% Colour block
Screen('FillRect', screenInfo.window, reelInfo.colours(2, :), colourBlock{side(1)}, screenInfo.gridPenWidthPixel);


textSize = reelInfo.TextSize + 30;
Screen('TextSize', screenInfo.window, textSize);
Screen('TextFont', screenInfo.window, reelInfo.Font);

% Subset draw positions using the random draw in side

DrawFormattedText(screenInfo.window, 'BLUE GAME', 'center', 'center', ...
    [],[],[],[],[],[],CenterRectOnPoint([0, 0, rectL(4) - rectL(2), textSize], xLR(side(1)), rectL(2) + inset));

textSize = reelInfo.TextSize + 10;
Screen('TextSize', screenInfo.window, textSize);

DrawFormattedText(screenInfo.window, [num2str(reelInfo.lineBet(1) * 9), ' CREDITS PER SPIN '], 'center', 'center', ...
    [],[],[],[],[],[],CenterRectOnPoint([0, 0, rectL(4) - rectL(2), textSize], xLR(side(1)), rectL(2) * 2 + inset));

Screen('TextSize', screenInfo.window, reelInfo.TextSize);

DrawFormattedText(screenInfo.window, ['CHOSEN ', num2str(reelInfo.betAChoices), ' TIMES '], 'center', 'center', ...
    [],[],[],[],[],[],CenterRectOnPoint([0, 0, rectL(4) - rectL(2), reelInfo.TextSize], xLR(side(1)), rectL(2) * 4));

DrawFormattedText(screenInfo.window, [num2str(reelInfo.lineBet(1)), ' CREDITS x 9 LINES'], 'center', 'center', ...
    [],[],[],[],[],[],CenterRectOnPoint([0, 0, rectL(4) - rectL(2), reelInfo.TextSize], xLR(side(1)), screenInfo.yCenter));

% ------------------------------------------------------------------------
% GREEN GAME - B
% ------------------------------------------------------------------------

% Colour block
Screen('FillRect', screenInfo.window, reelInfo.colours(4, :), colourBlock{side(2)}, screenInfo.gridPenWidthPixel);

textSize = reelInfo.TextSize + 30;
Screen('TextSize', screenInfo.window, textSize);

DrawFormattedText(screenInfo.window, 'GREEN GAME', 'center', 'center', ...
    [],[],[],[],[],[],CenterRectOnPoint([0, 0, rectL(4) - rectL(2), textSize], xLR(side(2)), rectL(2) + inset));

textSize = reelInfo.TextSize + 10;
Screen('TextSize', screenInfo.window, textSize);

DrawFormattedText(screenInfo.window, [num2str(reelInfo.lineBet(1) * 9), ' CREDITS PER SPIN '], 'center', 'center', ...
    [],[],[],[],[],[],CenterRectOnPoint([0, 0, rectL(4) - rectL(2), textSize], xLR(side(2)), rectL(2) * 2 + inset));

Screen('TextSize', screenInfo.window, reelInfo.TextSize);

DrawFormattedText(screenInfo.window, ['CHOSEN ', num2str(reelInfo.betBChoices), ' TIMES '], 'center', 'center', ...
    [],[],[],[],[],[],CenterRectOnPoint([0, 0, rectL(4) - rectL(2), reelInfo.TextSize], xLR(side(2)), rectL(2) * 4));

DrawFormattedText(screenInfo.window, [num2str(reelInfo.lineBet(1)), ' CREDITS x 9 LINES'], 'center', 'center', ...
    [],[],[],[],[],[],CenterRectOnPoint([0, 0, rectL(4) - rectL(2), reelInfo.TextSize], xLR(side(2)), screenInfo.yCenter));

% ------------------------------------------------------------------------
% DRAW RECTs
% ------------------------------------------------------------------------

% Left
Screen('FrameRect', screenInfo.window, screenInfo.black, rectL, screenInfo.gridPenWidthPixel);

DrawFormattedText(screenInfo.window, 'PRESS LEFT', 'center', 'center', ...
    [],[],[],[],[],[],CenterRectOnPoint([0, 0, rectL(4) - rectL(2), reelInfo.TextSize], xL, rectL(2) * 4 + inset));

% Right
Screen('FrameRect', screenInfo.window, screenInfo.black, rectR, screenInfo.gridPenWidthPixel);

DrawFormattedText(screenInfo.window, 'PRESS RIGHT', 'center', 'center', ...
    [],[],[],[],[],[],CenterRectOnPoint([0, 0, rectL(4) - rectL(2), reelInfo.TextSize], xR, rectL(2) * 4 + inset));

% ------------------------------------------------------------------------
% DISPLAY CREDITS
% ------------------------------------------------------------------------

if reelInfo.trialIndex == 0

    credits = reelInfo.credits;

else

    credits = outputData.credits(reelInfo.trialIndex);

end

DrawFormattedText(screenInfo.window, ['TOTAL CREDITS:\n---\n', num2str(credits)], 'center', 'center');

Screen('TextSize', screenInfo.window, reelInfo.TextSize);
Screen('TextFont', screenInfo.window, reelInfo.Font);

end