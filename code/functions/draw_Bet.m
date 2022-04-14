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
% Last update : July 2021
% Project : 9_Line_Slots_Task
% Version : 2021a
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

% Co-ords for colour coding.
colourBlock = {[rectL([1:3]), rectL(2) + 150]; [rectR([1:3]), rectR(2) + 150]};

% ------------------------------------------------------------------------
% BLUE GAME - A
% ------------------------------------------------------------------------

% Colour block
Screen('FillRect', screenInfo.window, reelInfo.colours(2, :), colourBlock{side(1)}, screenInfo.gridPenWidthPixel);

DrawFormattedText2(['<size=52>' '<b>BLUE GAME'], ...
    'win', screenInfo.window, ...
    'winRect', textBox{side(1)}, ... % Subset the text box using the second random draw in side
    'sx', 'center', 'sy', 'top', ...
    'xalign','center','yalign','center','xlayout','center');

DrawFormattedText2(['<size=32>', num2str(reelInfo.lineBet(1) * 9), ' CREDITS PER SPIN<size=20>', ...
    '\n\n\n\n', num2str(reelInfo.lineBet(1)), ' CREDITS PER LINE x 9 LINES', ...
    '\n\n\n\n CHOSEN ', num2str(reelInfo.betAChoices), ' TIMES'], ...
    'win', screenInfo.window, ...
    'winRect', textBox{side(1)}, ...
    'sx', 'center', 'sy', 'center', ...
    'xalign','center','yalign','center','xlayout','center');

% ------------------------------------------------------------------------
% GREEN GAME - B
% ------------------------------------------------------------------------

% Colour block
Screen('FillRect', screenInfo.window, reelInfo.colours(4, :), colourBlock{side(2)}, screenInfo.gridPenWidthPixel);    

DrawFormattedText2(['<size=52>' '<b>GREEN GAME'], ...
    'win', screenInfo.window, ...
    'winRect', textBox{side(2)}, ... % Subset the text box using the first random draw in side
    'sx', 'center', 'sy', 'top', ...
    'xalign','center','yalign','center','xlayout','center');

DrawFormattedText2(['<size=32>', num2str(reelInfo.lineBet(2) * 9), ' CREDITS PER SPIN<size=20>', ...
    '\n\n\n\n', num2str(reelInfo.lineBet(2)), ' CREDITS PER LINE x 9 LINES', ...
    '\n\n\n\n CHOSEN ', num2str(reelInfo.betBChoices), ' TIMES'], ...
    'win', screenInfo.window, ...
    'winRect', textBox{side(2)}, ...
    'sx', 'center', 'sy', 'center', ...
    'xalign','center','yalign','center','xlayout','center');

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
% 'Press Right'
DrawFormattedText2(['<size=20>PRESS RIGHT'], ...
    'win', screenInfo.window, ...
    'winRect', textBox{2}, ...
    'sx', 'center', 'sy', 'bottom', ...
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