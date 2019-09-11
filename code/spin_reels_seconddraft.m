%% Spin Reels

% Start experiment and run all setup functions
[screenInfo, reelInfo, fileInfo] = boot_exp();

% Randomly draws postion at which to stop reels and fill reel_info
[reelInfo] = update_stops(screenInfo, reelInfo);

% Here is an example script to demonstrate rolling the reels from 1:60 then
% waiting for a keypress before rolling again.


while ~KbCheck
   
draw_shapes(screenInfo, reelInfo, screenInfo.splitpos(1:3, :), reelInfo.reelstrip1([59, 60, 1], 1));
draw_grid(screenInfo);
Screen('Flip', screenInfo.window);

for i = flip(1:60)
    spin(screenInfo, reelInfo, i);
end

KbStrokeWait;

end

% Here is some example code to spin between specified values using
% set_spin()

draw_shapes(screenInfo, reelInfo, screenInfo.splitpos(1:3, :), reelInfo.reelstrip1([59, 60, 1], 1));
draw_grid(screenInfo);
Screen('Flip', screenInfo.window);

for i = set_spin(reelInfo, 1, 2)
    spin(screenInfo, reelInfo, i);
    
    KbStrokeWait;
end

KbStrokeWait;


% Set time of stimuli (this was in another script may be useful for working out timing.)
stim_sec = .125;
numFrames = stim_sec/(screenInfo.ifi);


