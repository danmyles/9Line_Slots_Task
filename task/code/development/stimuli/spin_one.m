%% Script to draw a 9 random symbols onscreen
% Slimmed down "main" script for debugging

% Create file directories
% TO DO: create a function that creates a struct full of file path names

% Call setup scripts ?> TODO THIS A FUNCTION
[screenInfo] = setup_screen();

% Create reel.Info struct
[reelInfo] = create_reelInfo();

% May put screen launch here...?

% Give the program maximum priority (limit background programs e.g. antivirus)
priorityLevel = MaxPriority(screenInfo.window);
Priority(priorityLevel);

% Fill reel.Info struct with current spin info
update_reelInfo; % also sets up grid dimensions

% Draw a grid
draw_grid;

% Draw shapes
% draw_shapes(1:9, reelInfo);
draw_shapes;

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for a key press
KbStrokeWait;
   
% Clear the screen
sca;