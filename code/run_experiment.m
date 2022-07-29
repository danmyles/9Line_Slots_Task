% -----------------------------------------------------------------------
% Dev notes for experiment
% -----------------------------------------------------------------------

%% TODO
% - TIMING FOR SCREEN FLIPS and IFI:
% - Replace movefile() for participant.mat file to end of script (commented
% out for debugging)`
% - Add instructions to run_experiment file
% — HIDE CURSOR

% -----------------------------------------------------------------------
% 9 Line Slot Task
% -----------------------------------------------------------------------
% Primary script for 9 Line Slot Task
% This script calls all set-up functions and then launches the experiment
%
% See README.txt for a full overview of the run flow, as well as all
% dependencies etc.
%
% NOTE: If this is the first time running this script you will first need 
%       to run the create experiment.m which prepares the following inputs:
%       participant_n.mat, reelInfo.mat, reelstrip.csv
%
% NOTE: This experiment is not designed to record accurate response times
%       Response time data is only recorded for debugging or ball park 
%       measures. Primary timing for EEG measures is done using a TTL 
%       trigger, and confirmed (adjusted) using a photodiode.
% ----------------------------------------------------------------------
% Created by Dan Myles (dan.myles@monash.edu)
% Last update : July 2022
% Project : 9_Line_Slots_Task
% Version : 2021a
% ----------------------------------------------------------------------


% ----------------------------------------------------------------------
%% Clear the workspace and the screen
% ----------------------------------------------------------------------

sca;
close all;
clearvars;

rng shuffle;

% Reseeding the rng at the beginning of any MATLAB prevents (exceedingly mild) 
% depenendcies in the rng such as booting the experiment/computer at the
% same time of day every session.

% ----------------------------------------------------------------------
%% Add functions and config files to path (if not already)
% ----------------------------------------------------------------------
[FILEPATH, ~, ~] = fileparts(which('run_experiment.m'));
addpath(genpath(fullfile(FILEPATH, 'functions')), fullfile(FILEPATH, 'config'))

% ----------------------------------------------------------------------
%% Set-up serial port for triggers
% ----------------------------------------------------------------------

% Use or skip triggers (for debugging/demo)
TRIGGERS_ON = 1;

if TRIGGERS_ON == 1

    % SET MMBT TO SIMPLE MODE

    % Set duration of serial port pulse
    % Should be slightly larger than 2 / sampling rate
    % pulseDuration = 0.004; % 512 Hz
    pulseDuration = 0.002; % 1024 Hz

    % Get list of serial devices
    s = serialportlist;

    % Select device n (YOU MAY NEED TO CHECK THIS PRIOR TO EACH SESSION)
    n = 2;
    s = serialport(s(n), 9600);
    clear n;
    
    % Reset / all triggers off
    write(s, 0, 'uint8');
    
    % Remove dummy / fake trigger function from path
    rmpath(fullfile(FILEPATH, 'functions', 'fake_trigger_code'));
    
else
    % Create an anoymous function to replace the trigger function
    % This will notify the user that the trigger has been skipped and what
    % the trigger code would have been
    
    % Confirm with user
    selection = questdlg('Run script with triggers disabled?', 'TRIGGERS_ON = 0');
    
    if ~strcmp(selection, 'Yes')
        % If No or Cancel then terminate with error:
        error('User terminated script prior to run')
    end
    
    % Set up debugging trigger code
    s = [];
    pulseDuration = .002;
    % Remove trigger function from path
    rmpath(fullfile(FILEPATH, 'functions', 'trigger_code'));
    
end

% ----------------------------------------------------------------------
%% RUN SETUP SCRIPTS
% ----------------------------------------------------------------------

% Start experiment and run all setup functions
[screenInfo, reelInfo, fileInfo, outputData, ID, sessionInfo, eventInfo] = boot_exp();

% Hide the cursor
HideCursor(screenInfo.window); % Off when debugging
% Silence Keyboard
ListenChar(2);

% Get system time
sessionInfo.date = datetime;
sessionInfo.start = GetSecs;

% EVENT MARKER: Experiment Start
send_trigger(s, eventInfo.expStart, pulseDuration);

% Load Screen
loading_screen(screenInfo, reelInfo, 5);

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for anykey
KbWait();

% Get VBL timestamp
FlipTime = Screen('Flip', screenInfo.window);

% ----------------------------------------------------------------------
%% Task Instructions
% ----------------------------------------------------------------------

present_instructions(screenInfo, reelInfo, outputData, FlipTime);

% Ready?
DrawFormattedText(screenInfo.window, ...
    'When you are ready press the 9 key to begin the experiment', ...
    'center', screenInfo.yCenter);

% Flip screen (next frame)
FlipTime = Screen('Flip', screenInfo.window);

% Wait for 9 Key or terminate on ESCAPE.
keyCode = 0;
nineKey = KbName('9(');
escapeKey = KbName('ESCAPE');

% Wait until 9 key before starting first trial
while keyCode ~= nineKey
    
    [keyDown, KeyTime, keyCode] = KbCheck(-1); % Check keyboard
    keyCode = find(keyCode);                   % Get keycode
        
    if keyDown == 0
	keyCode = 0;
    end
     
    % Exit experiment on ESCAPE    
    if keyCode == escapeKey
        sca;
        ShowCursor();
        ListenChar(0);
        error('User entered escape prior to experiment start')
    end
    
    WaitSecs(0.001); % slight delay to prevent CPU hogging
    
end

% Send instructions end time to sessionInfo
sessionInfo.instrEndT = KeyTime - sessionInfo.start;

%% ---------------------- START EXPERIMENT LOOP ----------------------- %%

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
        
        [reelInfo, outputData, FlipTime] = present_trial(s, eventInfo, pulseDuration, screenInfo, sessionInfo, reelInfo, outputData, FlipTime);
        
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
    
    % Show break screen:
    if reelInfo.trialIndex ~= reelInfo.nTrials
    present_break(screenInfo, reelInfo, outputData);
    end
        
    % Send start time to sessionInfo
    sessionInfo.timing{'BreakEnd', ['Block_' num2str(block)]} = sessionInfo.start - GetSecs;

    % EVENT MARKER: BREAK END
    send_trigger(s, eventInfo.breakEnd, pulseDuration);
    
end

% ----------------------- % END EXPERIMENT LOOP % ---------------------- %

% ----------------------------------------------------------------------
% Update sessionInfo
% ----------------------------------------------------------------------

% Session end time
sessionInfo.end = GetSecs;

% EVENT MARKER (EXP END)
send_trigger(s, eventInfo.expEnd, pulseDuration);

% Session duration
sessionInfo.duration = (sessionInfo.end - sessionInfo.start);

% Calculate participant payments
sessionInfo.finalCredits = sprintf('%1.3f', outputData.credits(reelInfo.nTrials) / 1000);
sessionInfo.finalCredits = regexprep(sessionInfo.finalCredits, "\.", ",");
sessionInfo.travelCosts  = 10.00;
% Round payment up to nearest 5 cents
sessionInfo.bonusPayment = (ceil(outputData.credits(reelInfo.nTrials) / 50) * 50) / 1000;
sessionInfo.bonusPayment = round(sessionInfo.bonusPayment, 2);
% Total payment amount
sessionInfo.totalPayment = sessionInfo.travelCosts + sessionInfo.bonusPayment;

% ----------------------------------------------------------------------
% Wrap Up
% ----------------------------------------------------------------------

% Save outputData to output folder:
writetable(outputData, [fileInfo.output fileInfo.fileID '.csv'])

% Save session info to output folder:
save([fileInfo.output fileInfo.fileID 'Info' '.mat'], 'sessionInfo')

% Draw text to centre
DrawFormattedText(screenInfo.window, 'END :)', 'center', 'center');

% Flip to the screen
Screen('Flip', screenInfo.window);

KbWait(-1, 2);

% Close Serial Port
clear s;

% Show Cursor
ShowCursor();

% Return Keyboard
ListenChar(0);

% Clear the screen
sca;

% Move participant InputData file to completed folder:
% script here
source = [fileInfo.input fileInfo.fileID '.mat'];
destination = [fileInfo.output];
movefile(source, destination)

% Open post-experiment survey
system('/usr/bin/firefox -safe-mode --new-window https://monash.az1.qualtrics.com/jfe/form/SV_eniEDceXKnO8FDg');

% Print payment info to command window.
print_payments(sessionInfo);
