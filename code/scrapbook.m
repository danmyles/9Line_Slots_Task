% -----------------------------------------------------------------------
% Dev notes for experiment
% -----------------------------------------------------------------------

%% TODO
% - TIMING FOR SCREEN FLIPS and IFI: ~5.9 ms
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
%       Behavioural data will be unreliable and is only recorded for
%       debugging or ball park measures. Timing for the initial experiment
%       which utilised this scripts was done using a TTL trigger, and
%       confirmed (adjusted) using a photodiode.
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

% Get system time
sessionInfo.date = datetime;
sessionInfo.start = GetSecs;

% EVENT MARKER: Experiment Start
send_trigger(s, eventInfo.expStart, pulseDuration);

% Load Screen
loading_screen(screenInfo, reelInfo, 5);

% Flip to the screen
FlipTime = Screen('Flip', screenInfo.window);
saveImage = Screen('GetImage', screenInfo.window);

% Wait for anykey

WaitSecs(.8);
Screen('Flip', screenInfo.window);

% Define a simple 4 by 4 checker board
checkerboard = repmat(eye(2), 2, 2);

% Make the checkerboard into a texure (4 x 4 pixels)
checkerTexture = Screen('MakeTexture', screenInfo.window, checkerboard);

% We will scale our texure up to 90 times its current size be defining a
% larger screen destination rectangle
[s1, s2] = size(checkerboard);
dstRect = [0 0 s1 s2] .* 90;
dstRect = CenterRectOnPointd(dstRect, screenInfo.xCenter, screenInfo.yCenter);

% Draw the checkerboard texture to the screen. By default bilinear
% filtering is used. For this example we don't want that, we want nearest
% neighbour so we change the filter mode to zero
filterMode = 0;
Screen('DrawTextures', screenInfo.window, checkerTexture, [],...
    dstRect, 45, filterMode);

% Flip to the screen
WaitSecs(.8);
Screen('Flip', screenInfo.window);
% Wait for anykey
WaitSecs(.8);
% Flip to the screen
Screen('Flip', screenInfo.window);
Screen('DrawTextures', screenInfo.window, checkerTexture, [],...
    dstRect, 45, filterMode);

% Flip to the screen
WaitSecs(.8);
Screen('Flip', screenInfo.window);

% Wait for anykey
WaitSecs(.8);

Time = GetSecs();

Screen('PutImage', screenInfo.window, saveImage);
Screen('Flip', screenInfo.window);

Time = GetSecs() - Time;

fprintf('PutImage takes %f seconds\n', Time)

WaitSecs(1);

Time = GetSecs();

% Load Screen
loading_screen(screenInfo, reelInfo, 5);

% Flip to the screen
FlipTime = Screen('Flip', screenInfo.window);

Time = GetSecs() - Time;

fprintf('Redraw takes %f seconds\n', Time)

% Wait for anykey
WaitSecs(.8);

Time = GetSecs();

Screen('PutImage', screenInfo.window, saveImage);
Screen('Flip', screenInfo.window);

Time = GetSecs() - Time;

fprintf('PutImage takes %f seconds\n', Time)

WaitSecs(1);

Time = GetSecs();

% Load Screen
loading_screen(screenInfo, reelInfo, 5);

% Flip to the screen
FlipTime = Screen('Flip', screenInfo.window);

Time = GetSecs() - Time;

fprintf('Redraw takes %f seconds\n', Time)

% Wait for anykey
WaitSecs(.8);

Time = GetSecs();

Screen('PutImage', screenInfo.window, saveImage);
Screen('Flip', screenInfo.window);

Time = GetSecs() - Time;

fprintf('PutImage takes %f seconds\n', Time)

WaitSecs(1);

Time = GetSecs();

% Load Screen
loading_screen(screenInfo, reelInfo, 5);

% Flip to the screen
FlipTime = Screen('Flip', screenInfo.window);

Time = GetSecs() - Time;

fprintf('Redraw takes %f seconds\n', Time)

sca;