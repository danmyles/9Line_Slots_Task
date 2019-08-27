%% Spin Reels

% Start experiment and run all setup functions
[screenInfo, reelInfo, gridInfo, fileInfo] = boot_exp();

% Fill reel.Info struct with current spin info
[reelInfo] = update_reelInfo(reelInfo, screenInfo, 1:9, 1);

selectReels = [1:3];

% Set time of stimuli
stim_sec = .125;
numFrames = stim_sec/(screenInfo.ifi);

while ~KbCheck
    for j = length(reelInfo.reelstrip1):-1:3
        
        %% Use J to select 3 symbols from deBruijn Sequence
        for i = 3:-1:1
            reelInfo.sym_shape(1:3) = reelInfo.reelstrip1(j:-1:j-2); 
        end
        
        [reelInfo] = update_reelInfo(reelInfo, screenInfo, selectReels, 0);
        draw_shapes(screenInfo, reelInfo, selectReels);
        
        % Draw a grid
        draw_grid(screenInfo, gridInfo);
        
        Screen('Flip', screenInfo.window);
    end
end

% Clear the screen
sca;

% % Wait for a key press
% KbStrokeWait;
   

