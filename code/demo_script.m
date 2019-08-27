%% Script to draw a 9 random symbols onscreen one reel at a time
% Simple script for debugging and development

% TO DO: Create config file with all basic settings. For instance you
% should put:
%    - config.repeatSymbols == 1
%    - RGB values for the symbols. 

% TO DO: add output path to setup_file
% TO DO: create a function that sets up all experimental variables etc
% TO DO: make a function that calls all setup scripts

% TO DO: Add launch screen to boot_exp()

% TO DO: Series of tests and checks for all video features to ensure
% accurate timing. For instance checking the recorded inter frame interval
% or refresh rate against those desired.

% TO DO: Create Reel highlighting function

% TO DO: HideCursor; To hide the mouse cursor? but this is annoying when
% debugging. Probably put this in setup_exp?

% TO DO: subjectInfo - Lay out output file and fill in subject details.
%% Set up inter stimulus interval
% Mean ISI e.g 200ms
% Range ISI e.g. +/- 50ms
% So ISI will fall randomly between 150 ms and 250 ms

%% TO DO SET SPEED OF PLAY
% Speed of play - From Harrigan & Dixon 2009
% We estimated the speed of play by using the second hand on a watch. On the two
% traditional mechanical reel slot machine games, the player can play approximately every
% 6 s, which is approximately 10 spins per minute, or 600 spins per hour. On the two video
% slots games, the player can play approximately every 3 s, which is 1,200 spins per hour.

% You will also need to consider the length of time neccesary to avoid
% artifacts from previous stimuli affecting the result. ~1000 ms from
% fixation cross to display of final symbol.

% Start experiment and run all setup functions
[screenInfo, reelInfo, gridInfo, fileInfo] = boot_exp();

% Fill reel.Info struct with current spin info
[reelInfo] = update_reelInfo(reelInfo, screenInfo);

% Draw a grid
draw_grid(screenInfo, gridInfo);

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for a key press
KbStrokeWait;

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

