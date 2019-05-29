%% Script to draw a 9 random symbols onscreen one reel at a time
% Simple script for debugging and development

% TO DO: create a function that creates a struct full of file path names
% TO DO: make a function that calls all setup scripts

% TO DO: Series of tests and checks for all video features to ensure
% accurate timing. For instance checking the recorded inter frame interval
% or refresh rate against those desired.

%% TO DO SET SPEED OF PLAY
% Speed of play - From Harrigan & Dixon 2009
% We estimated the speed of play by using the second hand on a watch. On the two
% traditional mechanical reel slot machine games, the player can play approximately every
% 6 s, which is approximately 10 spins per minute, or 600 spins per hour. On the two video
% slots games, the player can play approximately every 3 s, which is 1,200 spins per hour.

% You will also need to consider the length of time neccesary to avoid
% artifacts from previous stimuli affecting the result. ~1000 ms from
% fixation cross to display of final symbol.


%% DELETE THIS SECTION WHEN setup_exp is finished
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

% Setup screen
[screenInfo] = setup_screen();

% Create reel.Info struct
[reelInfo] = create_reelInfo();

% Set up grid
[gridInfo, screenInfo] = setup_grid(screenInfo);

% Give the program maximum priority (limit background programs e.g. antivirus)
priorityLevel = MaxPriority(screenInfo.window);
Priority(priorityLevel);

% Fill reel.Info struct with current spin info
[reelInfo] = update_reelInfo(reelInfo, screenInfo, 1:9, 1);

% Draw a grid
draw_grid(screenInfo, gridInfo);

% Draw shapes
selectReels = 1:3;
draw_shapes(screenInfo, reelInfo, selectReels);

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for a key press
KbStrokeWait;

% Draw a grid
draw_grid(screenInfo, gridInfo);

% Draw shapes
selectReels = [1:3, 7:9];
draw_shapes(screenInfo, reelInfo, selectReels);

% Flip to the screen
Screen('Flip', screenInfo.window);

% Draw a grid
draw_grid(screenInfo, gridInfo);

% Draw shapes
selectReels = [1:3, 7:9];
draw_shapes(screenInfo, reelInfo, selectReels);

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for a key press
KbStrokeWait;

% Draw a grid
draw_grid(screenInfo, gridInfo);

% Draw shapes
selectReels = [1:3, 7:9];
draw_shapes(screenInfo, reelInfo, selectReels);

% Draw a fixation cross
draw_fixation(screenInfo);

% Flip cross the the screen
Screen('Flip', screenInfo.window);

% Wait for a key press
KbStrokeWait;

% Draw a grid
draw_grid(screenInfo, gridInfo);

% Draw shapes
selectReels = [1:9];
draw_shapes(screenInfo, reelInfo, selectReels);

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;

