% ----------------------------------------------------------------------
% RUN SETUP SCRIPTS
% ----------------------------------------------------------------------

% Start experiment and run all setup functions
[screenInfo, reelInfo, fileInfo, outputData, ID, sessionInfo, eventInfo] = boot_exp();

side = randsample(1:2, 2, false);

Screen('Flip', screenInfo.window);

Screen('FillOval', screenInfo.window, 0, CenterRectOnPoint([0,0,90,90], screenInfo.xCenter, screenInfo.yCenter));
Screen('FillOval', screenInfo.window, 1, CenterRectOnPoint([0,0,72,72], screenInfo.xCenter, screenInfo.yCenter));

[~, BetChoiceSFT] = Screen('Flip', screenInfo.window);

% Wait for 9 Key or terminate on ESCAPE.
keyCode = 0;
nineKey = KbName('9(');
escapeKey = KbName('ESCAPE');

% Wait until 9 key before starting first trial
while keyCode ~= nineKey
    
    [keyDown, KeyTime, keyCode] = KbCheck(-1); % Check keyboard
    keyCode = find(keyCode);                     % Get keycode
        
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

sca;