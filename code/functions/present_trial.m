function [reelInfo, outputData] = present_trial(s, eventInfo, pulseDuration, screenInfo, sessionInfo, reelInfo, outputData)
% ----------------------------------------------------------------------
% [reelInfo, outputData] = present_trial(reelInfo)
% ----------------------------------------------------------------------
% Goal of the function :
% To display the sequence of events that makes up each individual trial
% Loosely the following events:
% 
% Display betting screen
% Take participant betting choice
% Update reelInfo.trialIndex iterator
% Update outputData by partiticpant betting choice
% Display the spin
% Record timing information throughout
%
% This function uses the reelInfo iterator to draw out the next reel
% stop from the output file and present a trial.
% Reelstops are used to index reelstrip 1 and reelstrip 2 to select the
% symbols to be draw to the screen.
% Spin animation is handled seperately by the spin functions.
%
%
% This function then updates the reelInfo.sym_shape matrix with the symbol
% identities. This information is then passed back to the update_reelInfo
% function so that position information can be determined for each of the
% symbols relative to their grid position
%
%
% Symbol codes are loosely assigned by number of sides (exc diam)
%
%                       1 = circle
%                       2 = diamond
%                       3 = triangle
%                       4 = rectangle
%                       5 = pentagon
%
% ----------------------------------------------------------------------
% Input(s) :
% reelInfo: reelstrips, trialIndex
% outputData:
% ----------------------------------------------------------------------
% Output(s):
% reelInfo: provides updated symbol positions to sym_shape
% outputData: bet choice, payout, updates shown 0 -> 1, records timing info.
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : July 2021
% Project : 9_Line_Slots_Task
% Version : 2021a
% ----------------------------------------------------------------------

% ------------------------------------------------------------------------
% DRAW BETTING SCREEN
% ------------------------------------------------------------------------

% Randomly pick a side to draw each bet to
% side = randsample(["A", "B"], 2, false);
% If side = [1, 2] then BLUE GREEN
% If side = [2, 1] then GREEN BLUE
side = randsample(1:2, 2, false);

[rectR, rectL] = draw_Bet(screenInfo, reelInfo, outputData, side);

[~, BetChoiceSFT] = Screen('Flip', screenInfo.window);

% EVENT MARKER (DISPLAY BET)
send_trigger(s, eventInfo.displayBet, pulseDuration);

% ------------------------------------------------------------------------
% WAIT FOR PARTICIPANT INPUT (LEFT OR RIGHT)
% ------------------------------------------------------------------------

escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');

keyCode = 0;
keyWait = 0;
keyDown = 0;

% If side = [1, 2] then A B
% If side = [2, 1] then B A

% If we need to disable the left or right key if betB.n or betA.n have run out
% (i.e. the pariticpant has already chosen that option the max number of times)
% We can use this to set the left/right key value to -1, this will force subsequent 
% if statements to fail and not register the key press.

% Check Bet A has run out
if reelInfo.betA.n == 0
    if find(side == 1) == 2
        rightKey = -1;
    elseif find(side == 1) == 1
        leftKey  = -1;
    end
end

% Check Bet B has run out
if reelInfo.betB.n == 0
    if find(side == 2) == 2
        rightKey = -1;
    elseif find(side == 2) == 1
        leftKey  = -1;
    end
end

while ~keyWait

    % Get Key Press Code and Timing
    [~, KeyPressTime, keyCode] = KbCheck(-1);

    % Get keyCode
    keyCode = find(keyCode);

    if keyCode == leftKey | keyCode == rightKey

        % EVENT MARKER (Bet Choice)
        send_trigger(s, eventInfo.betChoice.Response, pulseDuration);
        
        keyWait = 1;
        
    elseif keyCode == escapeKey

        sca;
        return

    end

end

% ------------------------------------------------------------------------
% Set choice
% ------------------------------------------------------------------------

if keyCode == leftKey

    betSize = reelInfo.lineBet(side(1));
    
    betChoice = side(1);
    
    pressLeft = 1;
    
    highlight = rectL;
    
elseif keyCode == rightKey

    betSize = reelInfo.lineBet(side(2));
    
    betChoice = side(2);
    
    pressLeft = 0;
    
    highlight = rectR;
    
end

% ------------------------------------------------------------------------
% UPDATE reelInfo.trialIndex
% ------------------------------------------------------------------------

reelInfo.trialIndex = (reelInfo.trialIndex + 1);

% ------------------------------------------------------------------------
% UPDATE outputData
% ------------------------------------------------------------------------
% Get participant choice:
% If side = [1, 2] then A B
% If side = [2, 1] then B A

% get betting amount
totalBet = betSize * 9;

% Update credits
if reelInfo.trialIndex == 1
    outputData.credits(reelInfo.trialIndex) = reelInfo.credits - totalBet;
else
    outputData.credits(reelInfo.trialIndex) = outputData.credits(reelInfo.trialIndex - 1) - totalBet;
end

% Index column names in sessionInfo Table that need to be replaced in outputData
replace = ismember(outputData.Properties.VariableNames, sessionInfo.betA.Properties.VariableNames);

% Get outcome data from appropriate outcome table
if betChoice == 1
    
    % Count choices
    reelInfo.betAChoices = (reelInfo.betAChoices + 1);
    
    % Add outcome to output table
    outputData(reelInfo.trialIndex, replace) = sessionInfo.betA(reelInfo.betAChoices, :);
    
    % Remove 1 choice from pile
    reelInfo.betA.n = reelInfo.betA.n - 1;
    
elseif betChoice == 2
    
    % Count choices
    reelInfo.betBChoices = (reelInfo.betBChoices + 1);
    
    % Add outcome to output table
    outputData(reelInfo.trialIndex, replace) = sessionInfo.betB(reelInfo.betBChoices, :);
    
    % Remove 1 choice from pile
    reelInfo.betB.n = reelInfo.betB.n - 1;
    
end

% ------------------------------------------------------------------------
% Highlight the choice and update credits:
% ------------------------------------------------------------------------

% Highlight left choice with a red box
draw_Bet(screenInfo, reelInfo, outputData, side); % Throw last screen.
Screen('FrameRect', screenInfo.window, reelInfo.colours(1, :), highlight, screenInfo.gridPenWidthPixel .* 3) % Red frame highlight
Screen('Flip', screenInfo.window); % Flip

% ------------------------------------------------------------------------
% MORE UPDATING
% ------------------------------------------------------------------------

% EXTRA EVENT MARKERS (BET TYPE)
% These need to be paired with the Response marker for accuracy if used
send_trigger(s, eventInfo.betChoice.GAME(betChoice), pulseDuration);
send_trigger(s, eventInfo.betChoice.LR(pressLeft * -1 + 2), pulseDuration);

WaitSecs(0.2); % Additional pause for red box display

% Update remaining betting information.
outputData.betChoice(reelInfo.trialIndex) = betChoice;
outputData.betBlue(reelInfo.trialIndex) = (betChoice == 1); % A little clearer for data processing
outputData.pressLeft(reelInfo.trialIndex) = pressLeft;
outputData.betSize(reelInfo.trialIndex) = betSize;
outputData.totalBet(reelInfo.trialIndex) = totalBet;
outputData.payout(reelInfo.trialIndex) = outputData.multiplier(reelInfo.trialIndex) .* outputData.betSize(reelInfo.trialIndex);
outputData.netOutcome(reelInfo.trialIndex) = outputData.payout(reelInfo.trialIndex) - outputData.totalBet(reelInfo.trialIndex);

% Add timing data to output
outputData.BetChoiceSFT(reelInfo.trialIndex) = BetChoiceSFT - sessionInfo.start;
outputData.BetChoiceRT(reelInfo.trialIndex) = KeyPressTime - BetChoiceSFT;

% ------------------------------------------------------------------------
% END BET SCREEN BEGIN REEL SPIN SEQUENCE
% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
% CUE UP NEXT REELINFO INFO...
% ------------------------------------------------------------------------

% Bump previous reelInfo.outcome to reelInfo.previous
reelInfo.previous = reelInfo.outcome;

% Get payout amount (if win occurs)
reelInfo.outcome.payout = outputData.payout(reelInfo.trialIndex);

% Get reel position to for each reelstrip
reelInfo.outcome.stops(1) = outputData.LStop(reelInfo.trialIndex);
reelInfo.outcome.stops(2) = outputData.RStop(reelInfo.trialIndex);

% Get centre symbol
reelInfo.outcome.centre = outputData.CS(reelInfo.trialIndex);

% Get win/match T/F value
reelInfo.outcome.match = outputData.match(reelInfo.trialIndex);

% Find all indices for above and below the stops on reel 1 & 2
% Then update reel information
for icol = [1, 2]
    reelInfo.outcome.allstops(:, icol) = expandStopINDEX(reelInfo, reelInfo.outcome.stops(icol), 1, 1);
end

% Fill out sym_shape from reel w/ allstops
reelInfo.outcome.dspSymbols(:, 1) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 1), 1);
reelInfo.outcome.dspSymbols(2, 2) = reelInfo.outcome.centre;
reelInfo.outcome.dspSymbols(:, 3) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 2), 2);

% ----------------------------------------------------------------------
% SPIN REELS
% ----------------------------------------------------------------------

% EVENT MARKER (Spin Animation Start)
send_trigger(s, eventInfo.spinStart, pulseDuration);

% Add timing info to outputData
outputData.ReelSFT(reelInfo.trialIndex) = GetSecs - sessionInfo.start;

% Spin reels
[reelInfo, outputData] = spin(screenInfo, reelInfo, outputData);

% EVENTMARKER (Spin Animation End)
send_trigger(s, eventInfo.spinEnd, pulseDuration);

% Wait ISI
WaitSecs(reelInfo.timing.highlight);

% ----------------------------------------------------------------------
% HIGHLIGHT ACTIVE REELS
% ----------------------------------------------------------------------

% I have some old code in a function called "highlight reels" if you
% want this done simultaneously.

% Check if active
if reelInfo.highlight == 2 || reelInfo.highlight == 3

    % This required a fair bit a messing about. Easier if we had some extra
    % variables I could toy with

    % Reel 1
    A = reelInfo.outcome.dspSymbols(1:3, 1);

    % Reel 2
    B = reelInfo.outcome.dspSymbols(1:3, 3);

    % C contains the identities of the matched elements, in our case the
    % symbol or shape code.
    % intersect() finds the locations in which the values of the two
    % vectors are the same.

    [C] = intersect(A, B, 'stable');

    % 1st arg contains indices for where these matches occur in argument A .
    % 2nd arg the same for argument B.
    % 'stable' returns the indices in IA and IB in the order that they
    % occur in argument A

    % Print highlighted squares to screen one match at a time
    % Uses intersect output to select colour (C = colour) (IA/IB to index grid posistion)

    for ih = 1:numel(C)

        Ai = ismember(A, C(ih));
        Bi = ismember(B, C(ih));

        % Reel 1 Highlights:
        highlight_pos = screenInfo.gridPos(1:3, :);
        Screen('FrameRect', screenInfo.window, reelInfo.colours(C(ih), :)', highlight_pos(Ai, :)', screenInfo.gridPenWidthPixel.*3);
        % Place another square on the inside of the highlight square (looks nice)
        highlight_pos = [highlight_pos(Ai, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(Ai, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos', screenInfo.gridPenWidthPixel)

        % Reel 2 Highlights:
        highlight_pos = screenInfo.gridPos(7:9, :);
        Screen('FrameRect', screenInfo.window, reelInfo.colours(C(ih), :)', highlight_pos(Bi, :)', screenInfo.gridPenWidthPixel.*3);
        % Place another square on the inside of the highlight square (looks nice)
        highlight_pos = [highlight_pos(Bi, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(Bi, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos', screenInfo.gridPenWidthPixel)

        draw_grid(screenInfo);
        draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));

        % Flip to the screen
        Screen('Flip', screenInfo.window);

        % EVENT MARKER - (Highlight onset)
        send_trigger(s, eventInfo.HL.start, pulseDuration);
        
        % Wait time between highlighted reels
        WaitSecs(reelInfo.timing.highlight);

    end

    % Re-draw without highlights
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));

    % Flip to the screen
    [~, HLendTime] = Screen('Flip', screenInfo.window);

    % EVENT MARKER (Highlight Sequence Complete)
    send_trigger(s, eventInfo.HL.end, pulseDuration);
    
    % update outputData
    outputData.HighlightEnd(reelInfo.trialIndex) = HLendTime - sessionInfo.start;
    
end

% Wait ISI
WaitSecs(reelInfo.timing.highlight);

% ----------------------------------------------------------------------
% FIXATION CROSS
% ----------------------------------------------------------------------

% Draw a fixation cross
draw_grid(screenInfo);
draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
draw_fixation(screenInfo, reelInfo);

% Flip to the screen
[~, FixationOnsetTime] = Screen('Flip', screenInfo.window);

% EVENT MARKER (Fixation Cross)
send_trigger(s, eventInfo.FC, pulseDuration);

% Get FC Timing
outputData.FCTime(reelInfo.trialIndex) = FixationOnsetTime - sessionInfo.start;

% Wait ISI
WaitSecs(reelInfo.timing.fixationCross + (rand .* reelInfo.timing.jitter));

% ----------------------------------------------------------------------
% OUTCOME STIMULUS
% ----------------------------------------------------------------------

% Draw grid
draw_grid(screenInfo);

% Draw shapes
draw_shapes(screenInfo, reelInfo, reelInfo.pos.All, nonzeros(reelInfo.outcome.dspSymbols));

% Check if win
if outputData.match(reelInfo.trialIndex) == 1

    % Win

    if reelInfo.highlight == 1 || reelInfo.highlight == 2
        % Highlight winning grid positions and show payout amount
        highlight_win(screenInfo, reelInfo);
    end

    % Display payout
    draw_payout(screenInfo, reelInfo, 1);

else

    % Loss

    % Display payout shape, but not text
    draw_payout(screenInfo, reelInfo, 0);

end

% Draw Rectangle to bottom right to check/debug timing
Screen('FillRect', screenInfo.window, 0, [screenInfo.screenXpixels - 100, screenInfo.screenYpixels - 100, screenInfo.screenXpixels, screenInfo.screenYpixels]);

% Flip to the screen (outcome stimulus, payout, win highlights)
[~, StimulusOnsetTime] = Screen('Flip', screenInfo.window);

% EVENT MARKER (Display Outcome Stimulus)
send_trigger(s, eventInfo.outcome.SF, pulseDuration);

keyDown = 0;
KeyPressTime = 0;

% Wait for key press
while(~keyDown)

    [keyDown, KeyPressTime] = KbCheck(-1);
    WaitSecs(0.001); % delay to prevent CPU hogging

end

% Get PRP time
PRP = KeyPressTime - StimulusOnsetTime;
outputData.PRP(reelInfo.trialIndex) = PRP;

% BET INFO EVENT MARKERS (will need to be adjusted to match above)
% Centre Symbol
send_trigger(s, eventInfo.outcome.symbol(outputData.CS(reelInfo.trialIndex)), pulseDuration);
% Highlighted Quantity
send_trigger(s, eventInfo.HL.n(outputData.cueLines(reelInfo.trialIndex)), pulseDuration);

% Payout
% Get row vector of multipliers by Bet choice
whichPay = [0, reelInfo.multipliers(outputData.betChoice(reelInfo.trialIndex), :)];
% Find match
whichPay = whichPay == outputData.multiplier(reelInfo.trialIndex);
% Get index
whichPay = find(whichPay);
% Send appropriate trigger
send_trigger(s, eventInfo.outcome.payout(whichPay), pulseDuration);

% Update outputData w/ 'shown'
outputData.shown(reelInfo.trialIndex) = 1;

% Outcome Stimulus Onset Time
outputData.CSTime(reelInfo.trialIndex) = StimulusOnsetTime - sessionInfo.start;

% Baseline L stop and R stop with session start time
outputData.LStopSF(reelInfo.trialIndex) = outputData.LStopSF(reelInfo.trialIndex) - sessionInfo.start;
outputData.RStopSF(reelInfo.trialIndex) = outputData.RStopSF(reelInfo.trialIndex) - sessionInfo.start;

% Resolve payout (total Bet credits already subtracted above)
outputData.credits(reelInfo.trialIndex) = ...
    outputData.credits(reelInfo.trialIndex) + outputData.payout(reelInfo.trialIndex);

% Wait minimum trial time if neccesary (likely already elapsed)
while (GetSecs - StimulusOnsetTime) < reelInfo.timing.outcome
    WaitSecs(0.001); % delay to prevent CPU hogging
end

% Wait until key comes back up before starting next trial
while keyDown
    [keyDown, KeyUpTime] = KbCheck(-1);
     WaitSecs(0.001); % delay to prevent CPU hogging
end

% Trial End Time to outputData
outputData.TrialEnd(reelInfo.trialIndex) = KeyUpTime - sessionInfo.start;

end



