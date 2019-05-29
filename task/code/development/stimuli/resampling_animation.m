%  % Script to draw a 9 random symbols onscreen
% This script runs a crude animation by resampling the symbols and drawing each
% to the screen.

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

% Call setup scripts ?> TODO THIS A FUNCTION
[screenInfo] = setup_screen();

% Create reel.Info struct
[reelInfo] = create_reelInfo();

% Set up grid
[gridInfo, screenInfo] = setup_grid(screenInfo);

% May put screen launch here...?

% Give the program maximum priority (limit background programs e.g. antivirus)
priorityLevel = MaxPriority(screenInfo.window);
Priority(priorityLevel);

% Set time of stimuli
stim_sec = .125;
numFrames = stim_sec/(screenInfo.ifi);

for i = 1:25 % Roll through 25 different reel updates and display to animate reel
    
    % Fill reel.Info struct with new spin info
    selectReels = [1:3, 7:9];
    [reelInfo] = update_reelInfo(reelInfo, screenInfo, selectReels, 1);
    
    for t = 1:numFrames
        % Draw a grid
        draw_grid(screenInfo, gridInfo);
        
        % Draw shapes
        selectReels = [1:3, 7:9];
        draw_shapes(screenInfo, reelInfo, selectReels);
        
        % Flip to the screen
        Screen('Flip', screenInfo.window);
    end
end


for i = 1:25 % Roll through 25 different reel updates and display to animate reel
    
    % Fill reel.Info struct with new spin info
    selectReels = 7:9;
    [reelInfo] = update_reelInfo(reelInfo, screenInfo, selectReels, 1);
    
    for t = 1:numFrames
        % Draw a grid
        draw_grid(screenInfo, gridInfo);
        
        % Draw shapes
        selectReels = [1:3, 7:9];
        draw_shapes(screenInfo, reelInfo, selectReels);
        
        % Flip to the screen
        Screen('Flip', screenInfo.window);
    end
end

% Wait for a key press
KbStrokeWait;
   
% Clear the screen
sca;
