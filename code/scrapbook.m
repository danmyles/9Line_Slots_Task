s = serialportlist;

% Select device n (YOU MAY NEED TO CHECK THIS PRIOR TO EACH SESSION)
n = 5;
s = serialport(s(n), 9600);
clear n;

% ----------------------------------------------------------------------
% RUN SETUP SCRIPTS
% ----------------------------------------------------------------------

% Start experiment and run all setup functions
[screenInfo, reelInfo, fileInfo, outputData, ID, sessionInfo, eventInfo] = boot_exp();

side = randsample(1:2, 2, false);

[~, BetChoiceSFT] = Screen('Flip', screenInfo.window);

Screen('FillOval', screenInfo.window, 0, CenterRectOnPoint([0,0,90,90], screenInfo.xCenter, screenInfo.yCenter));
Screen('FillOval', screenInfo.window, 1, CenterRectOnPoint([0,0,81,81], screenInfo.xCenter, screenInfo.yCenter));

%Screen('FillPoly', screenInfo.window, 0, floor(get_dimensions(screenInfo, 5, 2, [0,0,81,81])))
%Screen('FillPoly', screenInfo.window, 1, get_dimensions(screenInfo, 5, 2, reelInfo.payout.small))

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

