% ----------------------------------------------------------------------
% DISPLAY BREAK
% ----------------------------------------------------------------------

% Send start time to sessionInfo
sessionInfo.timing{'BreakStart', ['Block_' num2str(block)]} = sessionInfo.start - GetSecs;

% EVENT MARKER: BREAK START
send_trigger(s, eventInfo.breakStart, pulseDuration);

% Show break screen:
if reelInfo.trialIndex ~= reelInfo.nTrials
present_break(screenInfo, reelInfo, outputData);
end

% Send start time to sessionInfo
sessionInfo.timing{'BreakEnd', ['Block_' num2str(block)]} = sessionInfo.start - GetSecs;

% EVENT MARKER: BREAK END
send_trigger(s, eventInfo.breakEnd, pulseDuration);