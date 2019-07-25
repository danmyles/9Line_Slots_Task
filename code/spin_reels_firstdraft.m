%% Spin Reels

% Start experiment and run all setup functions
[screenInfo, reelInfo, gridInfo, fileInfo] = boot_exp();

% Fill reel.Info struct with current spin info
[reelInfo] = update_reelInfo(reelInfo, screenInfo, 1:9, 1);

selectReels = [1:3];

% Set time of stimuli
stim_sec = .125;
numFrames = stim_sec/(screenInfo.ifi);



for j = length(reelInfo.reelstrip1):-1:1
   
    %% Use J to select symbols from deBruijn Sequence
    for i = 3:-1:1
        reelInfo.sym_shape(i) = reelInfo.reelstrip1{j + (i - 3)}; %% I AM UP TO HERE. YOU WILL NOW HAVE TO SHIFT THE deBruijn reel generator to speak matrix. 
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
