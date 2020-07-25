


% ----------------------------------------------------------------------
% Clear the workspace and the screen
% ----------------------------------------------------------------------

sca;
close all;
clearvars;
rng shuffle; % See notes below

% HideCursor % Off when debugging

% It is recomended that the rng be reseeded at the beginning of any MATLAB 
% session if we wish to think of output from the rng as being
% statistically independent. Only needs to be done once at the start of the
% session.

% The deBruijn package notes also recomend reseeding MATLAB rng prior to 
% each session.

% ----------------------------------------------------------------------
% BEGIN TIMING
% ----------------------------------------------------------------------

% Get time
sessionInfo.date = datetime;
sessionInfo.start = GetSecs;

% Event Marker (Start)

% ----------------------------------------------------------------------
% RUN SETUP SCRIPTS
% ----------------------------------------------------------------------

% Start experiment and run all setup functions
[screenInfo, reelInfo, fileInfo, outputData, ID] = boot_exp();

% Load screen
loading_screen(screenInfo, reelInfo, 4);

% Get instructions and demo spins.
[instructions, demoSequence] = setup_instructions(reelInfo, outputData);

% Finished Load screen
loading_screen(screenInfo, reelInfo, 5);

%% TEXT SETUP 
% Setup some default text settings for the window
Screen('TextSize', screenInfo.window, 20);
Screen('TextFont', screenInfo.window, 'Helvetica Neue');
Screen('TextColor', screenInfo.window, screenInfo.black);

% Debugging
DrawFormattedText(screenInfo.window,'End of debugging', 'center', screenInfo.yCenter);
Screen('Flip', screenInfo.window);

KbWait(-1, 2);

% Wait until key comes back up before starting first trial
keyDown = 1;

while keyDown
    [keyDown, KeyUpTime] = KbCheck(-1);
     WaitSecs(0.001); % delay to prevent CPU hogging
end

sessionInfo.instrEndT = sessionInfo.start - KeyUpTime;
% ----------------------------------------------------------------------
%% Practice section
% ----------------------------------------------------------------------

% This should run continously until the experimenter comes in to enter a
% key to begin the experiment. The actual experiment should start from a
% seperate script.

for i = 1:3
    
    [reelInfo, outputData] = present_trial(screenInfo, sessionInfo, reelInfo, outputData);
    
end
