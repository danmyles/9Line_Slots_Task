% ----------------------------------------------------------------------
% 1ST BREAK
% ----------------------------------------------------------------------

% Send start time to sessionInfo
sessionInfo.timing{"BreakStart", "Block_1"} = sessionInfo.start - GetSecs;

% Draw 5 symbols.
inArow(screenInfo, reelInfo);                      

% Break Text:
DrawFormattedText(screenInfo.window, ...
    instructions.break{1}, ... % Break:
    'center', screenInfo.yCenter);

% Flip screen
Screen('Flip', screenInfo.window);

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

sessionInfo.timing{"BreakEnd", "Block_1"} = sessionInfo.start - GetSecs;