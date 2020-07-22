function [screenInfo, reelInfo, fileInfo, outputData, ID, sessionInfo] = boot_exp()
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
% Last update : June 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------

% Clear the workspace and the screen
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

% Get time
sessionInfo.start = GetSecs;
sessionInfo.date = date;

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

% Load up participant experiment data
outputData = load([fileInfo.input ID EXT], ID);
outputData = outputData.(ID);

% Set up screen
[screenInfo] = setup_screen();

% Set up grid
[screenInfo] = setup_grid(screenInfo);

% Set up reel.Info struct
[reelInfo] = setup_reelInfo(screenInfo, reelInfo);

% Give the program maximum priority (limit background programs e.g. antivirus)
priorityLevel = MaxPriority(screenInfo.window);
Priority(priorityLevel);



end







