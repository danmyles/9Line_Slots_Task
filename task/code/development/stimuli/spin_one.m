%% Script to draw a 9 random symbols onscreen
% Slimmed down "main" script for debugging

% Create file directories
% TO DO: create a function that creates a struct full of file path names

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

for i = 1:150

% Fill reel.Info struct with current spin info
[reelInfo] = update_reelInfo(reelInfo, screenInfo);

% Reset clock
t0 = GetSecs;

% Draw a grid
draw_grid(screenInfo, gridInfo);

% Draw shapes
selectReels = 1:3;
draw_shapes(screenInfo, reelInfo, selectReels);

% Flip to the screen
t1 = Screen('Flip', screenInfo.window);

fprintf(1, "\nTrue duration: %1.3f msec", (t1 - t0)*1000);
delay = [delay, (t1 - t0)*1000];

end

% Fill reel.Info struct with current spin info
[reelInfo] = update_reelInfo(reelInfo, screenInfo);

for i = 1:150

% Fill reel.Info struct with current spin info
[reelInfo] = update_reelInfo(reelInfo, screenInfo);

% Reset clock
t0 = GetSecs;

% Draw a grid
draw_grid(screenInfo, gridInfo);

% Draw shapes
selectReels = [1:3, 7:9];
draw_shapes(screenInfo, reelInfo, selectReels);

% Flip to the screen
t1 = Screen('Flip', screenInfo.window);

fprintf(1, "\nTrue duration: %1.3f msec", (t1 - t0)*1000);
delay = [delay, (t1 - t0)*1000];

end

% Wait for a key press
KbStrokeWait;
   
% Clear the screen
sca;