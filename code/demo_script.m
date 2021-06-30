% -----------------------------------------------------------------------
% Dev Script For Experiment
% -----------------------------------------------------------------------

%% TODO
% - SET ALL EVENT MARKERS:
%    i. Be sure to add markers from betChoice
% - CHECK TIMING FOR SCREEN FLIPS and IFI
% - CHECK SPEED: Should match speed of play outlined by Harrigan & Dixon 2009:  
%     i) We estimated the speed of play by using the second hand  
%     on a watch. On the two traditional mechanical reel slot machine games, 
%     the player can play approximately every 6 s, which is approximately 
%     10 spins per minute, or 600 spins per hour. On the two video slots  
%     games, the player can play approximately every 3 s, which is 1,200  
%     spins per hour. 
%     ii) You will also need to consider the length of time neccesary to avoid 
%     artifacts from previous stimuli affecting the result. ~1000 ms from 
%     fixation cross to display of outcome stimulus.
% - ADD MOVE participant.mat file to end of script (commented out for debugging)
% — HIDE CURSOR

% ----------------------------------------------------------------------
% Clear the workspace and the screen
% ----------------------------------------------------------------------

sca;
close all;
clearvars;
rng shuffle;

% Reseeding the rng at the beginning of any MATLAB prevents (exceedingly mild) 
% depenendcies in the rng such as booting the e9xperiment/computer at the
% same time of day every session.

% HideCursor % Off when debugging

% ----------------------------------------------------------------------
% RUN SETUP SCRIPTS
% ----------------------------------------------------------------------

% Start experiment and run all setup functions
[screenInfo, reelInfo, fileInfo, outputData, ID, sessionInfo] = boot_exp();
 
% Get system time
sessionInfo.date = datetime;
sessionInfo.start = GetSecs;

% EVENT MARKER: Experiment Start

% Load screen
loading_screen(screenInfo, reelInfo, 4);
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
sessionInfo.instrEndT = sessionInfo.start - KeyTime;

% --------------------- % START EXPERIMENT LOOP % ---------------------- %

for block = 1:reelInfo.blockN

    % ----------------------------------------------------------------------
    % DISPLAY BLOCK
    % ----------------------------------------------------------------------

    % Send start time to sessionInfo
    sessionInfo.timing{'BlockStart', ['Block_' num2str(block)]} = sessionInfo.start - GetSecs;

    % EVENT MARKER: BLOCK START

    for i = (reelInfo.trialIndex + 1):(reelInfo.trialIndex + reelInfo.blocksize)

        [reelInfo, outputData] = present_trial(screenInfo, sessionInfo, reelInfo, outputData);

    end

    % Send end time to sessionInfo
    sessionInfo.timing{'BlockEnd', ['Block_' num2str(block)]} = sessionInfo.start - GetSecs;

    % EVENT MARKER: BLOCK END

    % ----------------------------------------------------------------------
    % DISPLAY BREAK
    % ----------------------------------------------------------------------

    % Send start time to sessionInfo
    sessionInfo.timing{'BreakStart', ['Block_' num2str(block)]} = sessionInfo.start - GetSecs;

    % EVENT MARKER: BREAK START

    % Show break screen:
    present_break(screenInfo, reelInfo, outputData);

    % Send start time to sessionInfo
    sessionInfo.timing{'BreakEnd', ['Block_' num2str(block)]} = sessionInfo.start - GetSecs;

    % EVENT MARKER: BREAK END

end

% ----------------------- % END EXPERIMENT LOOP % ---------------------- %

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

% EVENT MARKER (END)

% Session end time
sessionInfo.end = GetSecs;

% Session duration
sessionInfo.duration = (sessionInfo.end - sessionInfo.start);

% All shown?
sessionInfo.shown = sum(outputData.shown);

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

