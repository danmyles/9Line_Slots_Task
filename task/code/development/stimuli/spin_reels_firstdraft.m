%% Spin Reels

%% Script to draw a 9 random symbols onscreen
% Script for developing ideas

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

% Call setup scripts ?> TODO THIS AS FUNCTION
[screenInfo] = setup_screen();

% Create reel.Info struct
[reelInfo] = create_reelInfo();

% Set up grid
[gridInfo, screenInfo] = setup_grid(screenInfo);

% Fill reel.Info struct with current spin info
[reelInfo] = update_reelInfo(reelInfo, screenInfo, 1:9, 1);

% Give the program maximum priority (limit background programs e.g. antivirus)
priorityLevel = MaxPriority(screenInfo.window);
Priority(priorityLevel);

%% Set up deBRUIJN DELETE THIS BEFORE MERGE
[reelInfo] = deBruijn_reels(reelInfo);

selectReels = [1:3];

% Set time of stimuli
stim_sec = .125;
numFrames = stim_sec/(screenInfo.ifi);

for j = length(reelInfo.reelstrip1):-1:1
   
    %% Use J to select symbols from deBruijn Sequence
    for i = 3:-1:1
        reelInfo.sym_shape{i}(1,1) = reelInfo.reelstrip1{j + (i - 3)};
    end
    
    [reelInfo] = update_reelInfo(reelInfo, screenInfo, selectReels, 0);
    draw_shapes(screenInfo, reelInfo, selectReels);
    
    % Draw a grid
    draw_grid(screenInfo, gridInfo);

    Screen('Flip', screenInfo.window);
    KbStrokeWait;
end

% % Wait for a key press
% KbStrokeWait;
   
% Clear the screen
sca;
