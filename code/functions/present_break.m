function [] = present_break(screenInfo, reelInfo, outputData)
% ----------------------------------------------------------------------
% [] = present_break(screenInfo, reelInfo)
% ------------------------------------------------------------------------
% Goal of this function:
% Draw and flip break display to screen
% ----------------------------------------------------------------------
% Input(s) :
% reelInfo, screenInfo
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : July 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% THROW TEXT TO SCREEN
% ----------------------------------------------------------------------

% 'Please take a moment to rest your eyes and get comfortable'
DrawFormattedText2(['Please take a moment to rest your eyes and get comfortable'], ...
    'win', screenInfo.window, ...
    'sx', screenInfo.xCenter, 'sy', screenInfo.textbelowC, ...
    'xalign','center','yalign','center','xlayout','center');

% Draw any key text: 'When you''re ready, press the 9 key to continue'
DrawFormattedText(screenInfo.window, 'Press the 9 key \nwhen you''re ready to continue', 'center', screenInfo.cont);

% Draw a little red dot :)
Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), ...
    get_dimensions(screenInfo, [screenInfo.xCenter, screenInfo.ydot], 1, [0, 0, 15, 15]));

% ----------------------------------------------------------------------
% SET UP SHAPE DIMENSIONS
% ----------------------------------------------------------------------
baseRect = [0 0 50 50];
radius = round(max(baseRect)/1.5);

% X Coordinates

% Use the x dimensions of the base shape size to adjust from the center.
% This will give use five sets of x dimensions

adjustX = baseRect(3)*1.35;

splitXpos = [screenInfo.xCenter - 2*adjustX, ...
    screenInfo.xCenter - adjustX, ...
    screenInfo.xCenter, ...
    screenInfo.xCenter + adjustX, ...
    screenInfo.xCenter + 2*adjustX];

% Fill in X,Y cordinates for loading screen symbols

for i = 1:5
    loadScreen.sym_position(i, :) = [splitXpos(i), screenInfo.yCenter];
end

% Triangle dims need some tweaking:

triangle_dim = get_dimensions(screenInfo, loadScreen.sym_position(3, :), 3, baseRect);

% Bump triangle base down to square position:
replace = get_dimensions(screenInfo, loadScreen.sym_position(3, :), 4, baseRect);
triangle_dim([2, 3], 2) = replace(4);

% Widen base out to diamond width to compensate for increased height:
replace = get_dimensions(screenInfo, loadScreen.sym_position(3, :), 2, baseRect);
triangle_dim([2, 3], 1) = replace([2, 4], 1);

% ----------------------------------------------------------------------
% DRAW SHAPES
% ----------------------------------------------------------------------

% Draw our shapes:
Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), get_dimensions(screenInfo, loadScreen.sym_position(1, :), 1, baseRect));
Screen('FillPoly', screenInfo.window, reelInfo.colours(2, :), get_dimensions(screenInfo, loadScreen.sym_position(2, :), 2, baseRect), 1);
Screen('FillPoly', screenInfo.window, reelInfo.colours(3, :), triangle_dim, 1);
Screen('FillRect', screenInfo.window, reelInfo.colours(4, :), get_dimensions(screenInfo, loadScreen.sym_position(4, :), 4, baseRect));
Screen('FillPoly', screenInfo.window, reelInfo.colours(5, :), get_dimensions(screenInfo, loadScreen.sym_position(5, :), 5, baseRect), 1);

% ----------------------------------------------------------------------
% DRAW LETTERS INSIDE SHAPES: 'B R E A K'
% ----------------------------------------------------------------------

DrawFormattedText2(['<color=1.><size=22><b>B'], ...
    'win', screenInfo.window, ...
    'sx', loadScreen.sym_position(1), 'sy', screenInfo.yCenter, ...
    'xalign','center','yalign','center','xlayout','center');

DrawFormattedText2(['<color=1.><size=22><b>R'], ...
    'win', screenInfo.window, ...
    'sx', loadScreen.sym_position(2), 'sy', screenInfo.yCenter, ...
    'xalign','center','yalign','center','xlayout','center');

DrawFormattedText2(['<color=1.><size=22><b>E'], ...
    'win', screenInfo.window, ...
    'sx', loadScreen.sym_position(3), 'sy', screenInfo.yCenter, ...
    'xalign','center','yalign','center','xlayout','center');

DrawFormattedText2(['<color=1.><size=22><b>A'], ...
    'win', screenInfo.window, ...
    'sx', loadScreen.sym_position(4), 'sy', screenInfo.yCenter, ...
    'xalign','center','yalign','center','xlayout','center');

DrawFormattedText2(['<color=1.><size=22><b>K'], ...
    'win', screenInfo.window, ...
    'sx', loadScreen.sym_position(5), 'sy', screenInfo.yCenter, ...
    'xalign','center','yalign','center','xlayout','center');

% ----------------------------------------------------------------------
% DISPLAY CREDITS TO USER
% ----------------------------------------------------------------------

credits = outputData.credits(reelInfo.trialIndex);

DrawFormattedText2(['<size=20>CREDITS: ' num2str(credits)], ...
    'win', screenInfo.window, ...
    'winRect', screenInfo.windowRect, ...
    'sx', 'center', 'sy', screenInfo.screenYpixels - screenInfo.ydot, ...
    'xalign','center','yalign','center','xlayout','center');

% ----------------------------------------------------------------------
% DISPLAY TRIALS REMAINING TO USER
% ----------------------------------------------------------------------

trialRemain = reelInfo.nTrials - reelInfo.trialIndex;

DrawFormattedText2(['<size=20>REMAINING BETS: ' num2str(trialRemain)], ...
    'win', screenInfo.window, ...
    'winRect', screenInfo.windowRect, ...
    'sx', 'center', 'sy', screenInfo.screenYpixels - screenInfo.ydot + 30, ...
    'xalign','center','yalign','center','xlayout','center');

% Flip screen
Screen('Flip', screenInfo.window);

% ----------------------------------------------------------------------
% WAIT FOR USER INPUT
% ----------------------------------------------------------------------

% Wait for 9 Key or terminate on ESCAPE.
keyCode = 0;
nineKey = KbName('9(');
escapeKey = KbName('ESCAPE');

% Wait until 9 key before starting first trial
while keyCode ~= nineKey

    [keyDown, ~, keyCode] = KbCheck(-1); % Check keyboard
    keyCode = find(keyCode);             % Get keycode

    if keyDown == 0
        keyCode = 0;
    end

    % Exit experiment on ESCAPE
    if keyCode == escapeKey
        sca;
        return
    end

    WaitSecs(0.001); % slight delay to prevent CPU hogging

end

end
