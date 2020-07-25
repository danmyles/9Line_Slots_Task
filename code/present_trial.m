function [reelInfo, outputData] = present_trial(screenInfo, sessionInfo, reelInfo, outputData)
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
% Last update : July 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------

% ------------------------------------------------------------------------
% DRAW BETTING SCREEN
% ------------------------------------------------------------------------

% Randomly pick a side to draw each bet to
side = randsample(1:2, 2, false);

[rectR, rectL] = draw_Bet(screenInfo, reelInfo, outputData, side);

[~, BetChoiceSFT] = Screen('Flip', screenInfo.window);

% EVENT MARKER (BET SCREEN FLIP)

% ------------------------------------------------------------------------
% WAIT FOR PARTICIPANT INPUT (LEFT OR RIGHT)
% ------------------------------------------------------------------------

escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');

keyCode = 0;
keyWait = 0;

while ~keyWait

    % Get Key Press Code and Timing
    [~, KeyPressTime, keyCode] = KbCheck(-1);

    % Get keyCode
    keyCode = find(keyCode);

    if keyCode == leftKey | keyCode == rightKey

        keyWait = 1;

        % EVENT MARKER (Bet Choice)

    elseif keyCode == escapeKey

        sca;
        return

    end

end

% ------------------------------------------------------------------------
% UPDATE reelInfo.trialIndex
% ------------------------------------------------------------------------

reelInfo.trialIndex = (reelInfo.trialIndex + 1);

% ------------------------------------------------------------------------
% UPDATE outputData
% ------------------------------------------------------------------------

% Get participant choice:
% If side = [1, 2] then LOW  HIGH
% If side = [2, 1] then HIGH LOW

if keyCode == leftKey

    betChoice = reelInfo.lineBet(side(1));
    % Highlight left choice with a red box
    Screen('FrameRect', screenInfo.window, reelInfo.colours(1, :), rectL, screenInfo.gridPenWidthPixel .* 3)

elseif keyCode == rightKey

    betChoice = reelInfo.lineBet(side(2));

    % Highlight right choice with a red box
    Screen('FrameRect', screenInfo.window, reelInfo.colours(1, :), rectR, screenInfo.gridPenWidthPixel .* 3)

end

% get betting amount
totalBet = betChoice * 9;

% Update credits
if reelInfo.trialIndex == 1
    outputData.credits(reelInfo.trialIndex) = reelInfo.credits - totalBet;
else
    outputData.credits(reelInfo.trialIndex) = outputData.credits(reelInfo.trialIndex - 1) - totalBet;
end

% Flip screen with choice highlighted and credits updated
draw_Bet(screenInfo, reelInfo, outputData, side); % Throw last screen.
Screen('Flip', screenInfo.window); % Flip

% Update remaining betting information.
outputData.betChoice(reelInfo.trialIndex) = betChoice;
outputData.totalBet(reelInfo.trialIndex) = totalBet;
outputData.payout(reelInfo.trialIndex) = outputData.multiplier(reelInfo.trialIndex) .* outputData.betChoice(reelInfo.trialIndex);
outputData.netOutcome(reelInfo.trialIndex) = outputData.payout(reelInfo.trialIndex) - outputData.totalBet(reelInfo.trialIndex);

% Add timing data to output
outputData.BetChoiceSFT(reelInfo.trialIndex) = BetChoiceSFT - sessionInfo.start;
outputData.BetChoiceRT(reelInfo.trialIndex) = KeyPressTime - BetChoiceSFT;

% Allow long enough to view change to screen (highlight and counter)
WaitSecs(reelInfo.timing.highlight);

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
for i = [1, 2]
    reelInfo.outcome.allstops(:, i) = expandStopINDEX(reelInfo, reelInfo.outcome.stops(i), 1, 1);
end

% Fill out sym_shape from reel w/ allstops
reelInfo.outcome.dspSymbols(:, 1) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 1), 1);
reelInfo.outcome.dspSymbols(2, 2) = reelInfo.outcome.centre;
reelInfo.outcome.dspSymbols(:, 3) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 2), 2);

% ----------------------------------------------------------------------
% SPIN REELS
% ----------------------------------------------------------------------

% EVENT MARKER (Spin Animation Begin)

% Add timing info to outputData
outputData.ReelSFT(reelInfo.trialIndex) = GetSecs - sessionInfo.start;

% Spin reels
[reelInfo, outputData] = spin(screenInfo, reelInfo, outputData);

% EVENTMARKER (Spin Animation Complete)

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

    for i = 1:numel(C)

        Ai = ismember(A, C(i));
        Bi = ismember(B, C(i));

        % Reel 1 Highlights:
        highlight_pos = screenInfo.gridPos(1:3, :);
        Screen('FrameRect', screenInfo.window, reelInfo.colours(C(i), :)', highlight_pos(Ai, :)', screenInfo.gridPenWidthPixel.*3);
        % Place another square on the inside of the highlight square (looks nice)
        highlight_pos = [highlight_pos(Ai, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(Ai, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos', screenInfo.gridPenWidthPixel)

        % Reel 2 Highlights:
        highlight_pos = screenInfo.gridPos(7:9, :);
        Screen('FrameRect', screenInfo.window, reelInfo.colours(C(i), :)', highlight_pos(Bi, :)', screenInfo.gridPenWidthPixel.*3);
        % Place another square on the inside of the highlight square (looks nice)
        highlight_pos = [highlight_pos(Bi, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(Bi, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos', screenInfo.gridPenWidthPixel)

        draw_grid(screenInfo);
        draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));

        % Flip to the screen
        Screen('Flip', screenInfo.window);

        % EVENT MARKER - (Highlight Appears)

        % Wait time between highlighted reels
        WaitSecs(reelInfo.timing.highlight);

    end

    % Re-draw without highlights
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));

    % Flip to the screen
    Screen('Flip', screenInfo.window);

    % EVENT MARKER (Highlighting Complete)
    
    % update outputData
    outputData.HighlightEnd(reelInfo.trialIndex) = GetSecs - sessionInfo.start;
    
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

% Flip to the screen (outcome stimulus, payout, win highlights)
[~, StimulusOnsetTime] = Screen('Flip', screenInfo.window);

% EVENT MARKER (Outcome Stimulus)

keyDown = 0;

while(~keyDown)

    [keyDown, KeyPressTime] = KbCheck(-1);
    WaitSecs(0.001); % delay to prevent CPU hogging

end

% Get PRP time
PRP = KeyPressTime - StimulusOnsetTime;
outputData.PRP(reelInfo.trialIndex) = PRP;

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

% EVENT MARKER – TRIAL END

% Trial End Time to outputData
outputData.TrialEnd(reelInfo.trialIndex) = GetSecs - sessionInfo.start;

end







