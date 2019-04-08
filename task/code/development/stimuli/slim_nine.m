%% Script to draw a 9 random symbols onscreen
% Slimmed down draw script
% Bibiliogra phy:
% http://peterscarfe.com/ptbtutorials.html

% Create file directories
% TO DO: create a function that creates a struct full of file path names

% Call setup scripts ?> TODO THIS A FUNCTION
[screenInfo] = setup_screen();

% Create reel.Info struct
[reelInfo] = create_reelInfo();

% Set up grid
[gridInfo] = setup_grid(screenInfo);

% May put screen launch here...?

% Give the program maximum priority (limit background programs e.g. antivirus)
priorityLevel = MaxPriority(screenInfo.window);
Priority(priorityLevel);

% Fill reel.Info struct with current spin info
update_reelInfo; % also sets up grid dimensions

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

