%% Spin Reels

% Start experiment and run all setup functions
[screenInfo, reelInfo, gridInfo, fileInfo] = boot_exp();

% Fill reel.Info struct with current spin info
[reelInfo] = update_reelInfo(reelInfo, screenInfo);

% while ~KbCheck
% end

reel_length = length(reelInfo.reelstrip1);

% The next thing I want to to do is write a function that will draw a shape
% from one position to another so that it appears to move along the Y axis.

% I also want to make the draw shapes and get dimensions functions more
% flexible. For example, I would like the get_dimensions function to take a
% vector of x and y dimensions rather than an index of screen position.

position = screenInfo.splitpos;

reelInfo.reelstrip1(1:9, 2:3) = screenInfo.splitpos;

screenInfo.splitpos(selectLocation, :)

for i = 0:25:800
   
% Draw shapes
draw_shapes(screenInfo, reelInfo, [reelInfo.reelstrip1(:, 2) , reelInfo.reelstrip1(reelInfo.stops(1), 3) + i], reelInfo.reelstrip1(1:9, 1));

% Draw a grid
draw_grid(screenInfo, gridInfo);

%
Screen('Flip', screenInfo.window);

end

Draw shapes
draw_shapes2(screenInfo, reelInfo, screenInfo.splitpos(selectReels, :), [1:5, 5, 5]);

Draw a grid
draw_grid(screenInfo, gridInfo);


Screen('Flip', screenInfo.window);


%% 
selectReels = [1:3, 5, 7:9];

% Draw shapes
draw_shapes2(screenInfo, reelInfo, screenInfo.splitpos(selectReels, :), repmat(1, 1, 7));

% Draw a grid
draw_grid(screenInfo, gridInfo);

%
Screen('Flip', screenInfo.window);

%
KbStrokeWait;

% Draw shapes
draw_shapes2(screenInfo, reelInfo, 3);

% Draw a grid
draw_grid(screenInfo, gridInfo);

%
Screen('Flip', screenInfo.window);

%
KbStrokeWait;



