function [screenInfo, reelInfo, fileInfo, outputData, ID, sessionInfo, eventInfo] = boot_exp()
% ----------------------------------------------------------------------
% [screenInfo, reelInfo, fileInfo, outputData, ID] = boot_exp()
% ----------------------------------------------------------------------
% Goal of the function :
%  - Housekeeping
%  - Start timer at beginning of experiment
%  - Run all setup functions
% ----------------------------------------------------------------------
% Input(s) :
%   NONE
% ----------------------------------------------------------------------
% Output(s):
%   screenInfo : runs the PTB screen setup and returns screen information
%   reelInfo : load in the reelstrips and other info from config .mat file
%   fileInfo : directory information
%   outputData - loaded with user selected .mat file
%   ID : Participant ID
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : July 2021
% Project : 9_Line_Slots_Task
% Version : 2021a
% ----------------------------------------------------------------------

% Check psychtoolbox and stats toolbox are installed:
if ~ license('test','statistics_toolbox')
    warning('Statistics toolbox not installed. Please isntall and try again');
    sca;
end

if ~ contains(matlabpath, 'Psychtoolbox')
    warning('Psychtoolbox was not found in the MATLAB path. Please install/add to path');
    sca;
end

% Get directories relative to file location
[fileInfo] = setup_file();

% Load in reelInfo from config file
load([fileInfo.config 'reelInfo.mat']);

% Ask user to select inputData containing session info:
disp([newline '    **Select Participant Input File**' newline]);
[ID,fileInfo.input] = uigetfile('*.mat', 'Select Participant Input File', fileInfo.input);

if ID == 0 
   error('User cancelled experiment') 
end

% We pulled out the path from the UI selected file. Updates fileInfo if neccesary
% Clean up fileInfo.input
[fileInfo.input, ID, EXT] = fileparts([fileInfo.input ID]);
fileInfo.input = [fileInfo.input filesep];

% Load up experiment data
sessionInfo = load([fileInfo.input ID EXT]);

% Start sessionInfo choice counts.
reelInfo.betAChoices = 0;
reelInfo.betBChoices = 0;

% value for the draw_rate
% draw rate is the number of times a symbol is redrawn between
% reel positions.
reelInfo.draw_rate = 15;

% Create empty data table for output
[outputData] = setup_output(reelInfo);

% Fill in Block N
outputData.blockN = repmat([1:reelInfo.blocksize]', reelInfo.blockN, 1);

% Fill in Block ID
outputData.blockID = kron([1:reelInfo.blockN], ones(1, reelInfo.blocksize))';

% Fill in Participant ID
outputData.participantID(:) = sessionInfo.participantID;

%% Empty Table for block timing info
% Empty table
sessionInfo.timing = array2table(zeros(4, reelInfo.blockN));

% Create and set VarNames
names = num2str([1:reelInfo.blockN]');
names = join([repmat(["Block_"], reelInfo.blockN, 1), names], "");
sessionInfo.timing.Properties.VariableNames = names;
sessionInfo.timing.Properties.RowNames = ["BlockStart", "BlockEnd", "BreakStart", "BreakEnd"];

% Add filename ID to sessionInfo
fileInfo.fileID = ID;

% Set up screen
[screenInfo] = setup_screen();

% % Hide the cursor
HideCursor() % Off when debugging

% Set up grid
[screenInfo] = setup_grid(screenInfo);

% Set up reel.Info struct
[reelInfo] = setup_reelInfo(screenInfo, reelInfo);

% Give the program maximum priority (limit background programs e.g. antivirus)
priorityLevel = MaxPriority(screenInfo.window);
Priority(priorityLevel);


%% TEXT SETUP 
% Setup some default text settings for the window

% Default Font
reelInfo.Font = 'Courier';
% Default Font Size
reelInfo.TextSize = 24;

% Set Font / Text:
Screen('TextSize', screenInfo.window, reelInfo.payout.textSize);
Screen('TextFont', screenInfo.window, reelInfo.Font);
Screen('TextColor', screenInfo.window, screenInfo.black);

% Get Event codes
[eventInfo] = setup_eventInfo();
end







