% screenInfo, reelInfo, outcomeData

% Randomly pick a side to draw each bet to
side = randsample(1:2, 2, false);

% ------------------------------------------------------------------------
% DRAW BET
% ------------------------------------------------------------------------

[rectR, rectL] = draw_Bet(screenInfo, reelInfo, side);

[~, StimulusOnsetTime] = Screen('Flip', screenInfo.window);

% Event Marker (show bet)

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
    [keyDown, KeyPressTime, keyCode] = KbCheck(-1);
    
    % Get keyCode
    keyCode = find(keyCode);
    
    if keyCode == leftKey | keyCode == rightKey
        
        keyWait = 1;
        
    elseif keyCode == escapeKey
        
        sca;
        return
        
    end
    
end

% Bet Choice Response Time
BetChoiceRT = KeyPressTime - StimulusOnsetTime;

% Get participant choice

% If side = [1, 2] then LOW  HIGH
% If side = [2, 1] then HIGH LOW

if keyCode == leftKey
    
    betChoice = reelInfo.lineBet(side(1));
    % Highlight choice with a red box
    Screen('FrameRect', screenInfo.window, reelInfo.colours(1, :), rectL, screenInfo.gridPenWidthPixel .* 3)
    
elseif keyCode == rightKey
    
    betChoice = reelInfo.lineBet(side(2));
    
    % Highlight choice with a red box
    Screen('FrameRect', screenInfo.window, reelInfo.colours(1, :), rectR, screenInfo.gridPenWidthPixel .* 3)
    
end

% Send event marker (Bet Choice)

% Highlight choice
draw_Bet(screenInfo, reelInfo, side); % Throw last screen.
Screen('Flip', screenInfo.window); % Flip

% Update outputData
% Index + 1 because the iterator tics over at the present trial script
% betChoice
% outputData.BetChoice(reelInfo.trialIndex + 1) = 

% totalBet

% payout

% netOutcome

% Betting page response time
% outputData.BetChoiceRT(reelInfo.trialIndex + 1) = BetChoiceRT;














