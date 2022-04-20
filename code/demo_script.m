% -----------------------------------------------------------------------
% Dev Script For Experiment
% -----------------------------------------------------------------------

%% TODO
% - SET ALL EVENT MARKERS:
%    i. Be sure to add markers from betChoice
% - CHECK TIMING FOR SCREEN FLIPS and IFI
% - CHECK TRIGGER TIMING 
%   - May want to consider simple mode to reduce trigger latencies.
% - CHECK SPEED:
%     ii) You will also need to consider the length of time neccesary to avoid 
%     artifacts from previous stimuli affecting the result. ~1000 ms from 
%     fixation cross to display of outcome stimulus.
% - Replace movefile() for participant.mat file to end of script (commented out for debugging)
% — HIDE CURSOR

% ----------------------------------------------------------------------
% Clear the workspace and the screen
% ----------------------------------------------------------------------

sca;
close all;
clearvars;
rng shuffle;

% Reseeding the rng at the beginning of any MATLAB prevents (exceedingly mild) 
% depenendcies in the rng such as booting the experiment/computer at the
% same time of day every session.

% HideCursor % Off when debugging

% ----------------------------------------------------------------------
% Set-up serial port for triggers
% ----------------------------------------------------------------------

% SET MMBT TO SIMPLE MODE

% Set duration of serial port pulse
% Should be slightly larger than 2 / sampling rate
pulseDuration = 0.002;

% Get list of serial devices
s = serialportlist;

% Select device n
n = 6;
s = serialport(s(n), 9600);
clear n;

% ----------------------------------------------------------------------
% RUN SETUP SCRIPTS
% ----------------------------------------------------------------------

% Start experiment and run all setup functions
[screenInfo, reelInfo, fileInfo, outputData, ID, sessionInfo, eventInfo] = boot_exp();

% Get system time
sessionInfo.date = datetime;
sessionInfo.start = GetSecs;

% EVENT MARKER: Experiment Start
send_trigger(s, eventInfo.expStart, pulseDuration);

% Load screen
loading_screen(screenInfo, reelInfo, 4);
% All triggers on (Test)
write(s, 255, 'uint8');
WaitSecs(0.5);
% All triggers off (test complete)
write(s, 0, 'uint8');
loading_screen(screenInfo, reelInfo, 5);

% ----------------------------------------------------------------------
% Task Instructions
% ----------------------------------------------------------------------

present_instructions(screenInfo, reelInfo, outputData);

% Ready?
DrawFormattedText(screenInfo.window, ...
    'When you are ready press the 9 key to begin the experiment', ...
    'center', screenInfo.yCenter);
% Flip screen
Screen('Flip', screenInfo.window);

% Alert Experimenter
write(s, 255, 'uint8');

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

% Send end time to sessionInfo
sessionInfo.instrEndT = KeyTime - sessionInfo.start;

% All triggers off
write(s, 0, 'uint8');

% --------------------- % START EXPERIMENT LOOP % ---------------------- %

for block = 1:reelInfo.blockN

    % ----------------------------------------------------------------------
    % DISPLAY BLOCK
    % ----------------------------------------------------------------------

    % Send start time to sessionInfo
    sessionInfo.timing{'BlockStart', ['Block_' num2str(block)]} = sessionInfo.start - GetSecs;

    % EVENT MARKER: BLOCK START
    send_trigger(s, eventInfo.blockStart, pulseDuration);

    for i = (reelInfo.trialIndex + 1):(reelInfo.trialIndex + reelInfo.blocksize)
        
        % EVENT MARKER – TRIAL START
        send_trigger(s, eventInfo.trialStart, pulseDuration);
        
        [reelInfo, outputData] = present_trial(s, eventInfo, pulseDuration, screenInfo, sessionInfo, reelInfo, outputData);
        
        % EVENT MARKER – TRIAL END
        send_trigger(s, eventInfo.trialEnd, pulseDuration);
        
    end

    % Send end time to sessionInfo
    sessionInfo.timing{'BlockEnd', ['Block_' num2str(block)]} = sessionInfo.start - GetSecs;

    % EVENT MARKER: BLOCK END
    send_trigger(s, eventInfo.blockEnd, pulseDuration);

    % ----------------------------------------------------------------------
    % DISPLAY BREAK
    % ----------------------------------------------------------------------

    % Send start time to sessionInfo
    sessionInfo.timing{'BreakStart', ['Block_' num2str(block)]} = sessionInfo.start - GetSecs;

    % EVENT MARKER: BREAK START
    send_trigger(s, eventInfo.breakStart, pulseDuration);
    
    % Alert Experimenter
    write(s, 255, 'uint8');
    
    % Show break screen:
    if reelInfo.trialIndex ~= reelInfo.nTrials
    present_break(screenInfo, reelInfo, outputData);
    end
    
    % Alert Off
    write(s, 0, 'uint8');
        
    % Send start time to sessionInfo
    sessionInfo.timing{'BreakEnd', ['Block_' num2str(block)]} = sessionInfo.start - GetSecs;

    % EVENT MARKER: BREAK END
    send_trigger(s, eventInfo.breakEnd, pulseDuration);
    
end

% ----------------------- % END EXPERIMENT LOOP % ---------------------- %

% Session end time
sessionInfo.end = GetSecs;

% EVENT MARKER (EXP END)
send_trigger(s, eventInfo.expEnd, pulseDuration);

% Session duration
sessionInfo.duration = (sessionInfo.end - sessionInfo.start);

% Alert Experimenter
write(s, 255, 'uint8')

% ----------------------------------------------------------------------
% END text
% ----------------------------------------------------------------------

% Draw text to centre
[cache] = DrawFormattedText2('END :)', 'win', screenInfo.window, ...
    'sx', screenInfo.xCenter, 'sy', screenInfo.yCenter, ...
    'xalign','center','yalign','center','xlayout','center');

% Flip to the screen
Screen('Flip', screenInfo.window);

KbWait(-1, 2);

% All shown?
sessionInfo.shown = sum(outputData.shown);

% End Alert
write(s, 0, 'uint8')

% Close Serial Port
clear s;
% Clear the screen
sca;

% Open notes for experimenter to add details.
sessionInfo.notes = inputdlg({ 'List Any Bad Channels:', 'Notes (e.g. errors, fixed channel at trial x etc):'}, ...
    'Enter Experimenter Notes', [1 150; 10 150]);

sessionInfo.badchannels = sessionInfo.notes{1};
sessionInfo.notes = sessionInfo.notes{2};

% Save outputData to output folder:
writetable(outputData, [fileInfo.output fileInfo.fileID '.csv'])

% Save session info to output folder:
save([fileInfo.output fileInfo.fileID 'Info' '.mat'], 'sessionInfo')

% Move participant InputData file to completed folder:
% script here
source = [fileInfo.input fileInfo.fileID '.mat'];
destination = [fileInfo.output 'completed/' fileInfo.fileID '.mat'];
% movefile(source, destination)