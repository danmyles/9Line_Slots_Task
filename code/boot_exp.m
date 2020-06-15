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
% Version : 2020a
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

% Get directories relative to file location
[fileInfo] = setup_file();

% Load in reelInfo from config file
load([fileInfo.config 'reelInfo.mat'])

% Ask user for session Info:
ID = inputdlg({'Numeric Participant ID:'}, 'Please enter session info', [1, 100]);
ID = ['participant' num2str(ID{1})];

% Load up participant experiment data
outputData = load([fileInfo.config 'experiment.mat'], ID);
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







