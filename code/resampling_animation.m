%  % Script to draw a 9 random symbols onscreen
% This script runs a crude animation by resampling the symbols and drawing each
% to the screen.
% Start experiment and run all setup functions
[screenInfo, reelInfo, fileInfo] = boot_exp();

% Set time of stimuli
stim_sec = .125;
numFrames = stim_sec/(screenInfo.ifi);

for i = 1:25 % Roll through 25 different reel updates and display to animate reel
    
    % Fill reel.Info struct with new spin info
    selectReels = [1:3, 7:9];
    [reelInfo] = update_reelInfo(reelInfo, screenInfo, selectReels, 1);
    
    for t = 1:numFrames
        % Draw a grid
        draw_grid(screenInfo);
        
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
        draw_grid(screenInfo);
        
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
