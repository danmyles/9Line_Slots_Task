function [screenInfo, reelInfo, fileInfo, outputData] = boot_exp()
% ----------------------------------------------------------------------
% boot_exp()
% ----------------------------------------------------------------------
% Goal of the function :
%  - Housekeeping
%  - Start timer at beginning of experiment
%  - Run all setup functions
% ----------------------------------------------------------------------
% Input(s) :
% NONE
% ----------------------------------------------------------------------
% Output(s):
% screenInfo, reelInfo
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 24 July 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% ----------------------------------------------------------------------

% Clear the workspace and the screen
sca;
close all;
clearvars;
rng shuffle; % See notes below

% It is recomended that the rng be reseeded at the beginning of any MATLAB 
% session if we wish to think of output from the rng as being
% statistically independent. Only needs to be done once at the start of the
% session.

% The deBruijn package notes also recomend reseeding MATLAB rng prior to 
% each session.

% Start a stopwatch
tic; % you can read time elapsed since tic; with toc

% Set up directories relative to file location
[fileInfo.Path, fileInfo.Name] = fileparts(mfilename('fullpath'));
cd(fileInfo.Path); % Change working directory
addpath([fileInfo.Path filesep 'functions' filesep]); % add functions folder top path

% Add remaining directories    
[fileInfo] = setup_file(fileInfo);

% Set up screen
[screenInfo] = setup_screen();


% Set up grid
[screenInfo] = setup_grid(screenInfo);

% Set up reel.Info struct
[reelInfo] = setup_reelInfo(screenInfo);

% May put screen launch here...?

% Prefill and setup outputData table
[outputData] = setup_output();

% Give the program maximum priority (limit background programs e.g. antivirus)
priorityLevel = MaxPriority(screenInfo.window);
Priority(priorityLevel);

end

