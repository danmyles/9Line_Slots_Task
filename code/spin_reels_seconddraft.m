%% Spin Reels

% Start experiment and run all setup functions
[screenInfo, reelInfo, fileInfo] = boot_exp();

% Randomly draws postion at which to stop reels and fill reel_info
[reelInfo] = update_stops(screenInfo, reelInfo);

while ~KbCheck
   
draw_shapes(screenInfo, reelInfo, screenInfo.splitpos(1:3, :), reelInfo.reelstrip1([59, 60, 1], 1));
draw_grid(screenInfo);
Screen('Flip', screenInfo.window);

for i = 60:-1:1
    spin(screenInfo, reelInfo, i);
end

KbStrokeWait;

end

%% 
selectReels = [1:3, 5, 7:9];

% Draw shapes
draw_shapes2(screenInfo, reelInfo, screenInfo.splitpos(selectReels, :), repmat(1, 1, 7));

% Draw a grid
draw_grid(screenInfo);

%
Screen('Flip', screenInfo.window);

%
KbStrokeWait;

% Draw shapes
draw_shapes2(screenInfo, reelInfo, 3);

% Draw a grid
draw_grid(screenInfo);

%
Screen('Flip', screenInfo.window);

%
KbStrokeWait;


% Set time of stimuli (this was in another script may be useful for working out timing.)
stim_sec = .125;
numFrames = stim_sec/(screenInfo.ifi);


