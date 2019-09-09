%% Spin Reels

% Start experiment and run all setup functions
[screenInfo, reelInfo, gridInfo, fileInfo] = boot_exp();

% Randomly draws postion at which to stop reels and fill reel_info
[reelInfo] = update_stops(screenInfo, reelInfo);

% while ~KbCheck
% end

%%

% This is lifted from the update reel section. Consider putting in a
% function if you are likely to re-use it. 

%% DELETE AFTER DEBUGGING
% 
% reelInfo.stops([1, 3]) = randsample(reelInfo.reel_length, 2, true);
% reelInfo.stops(2) = randsample(1:5, 1, true);
% 
% reelInfo.stops(1) = 60; 
% %%

reelInfo = fill_y(screenInfo, reelInfo);

% finds highest and lowest y values
reset = (screenInfo.splitposY(1) - screenInfo.Y_adjust) + (reelInfo.reel_length .* screenInfo.Y_adjust); 
reset2 = reelInfo.reel_length .* screenInfo.Y_adjust;

% Draw shapes
draw_shapes(screenInfo, reelInfo, reelInfo.reelstrip1(:, [2,3]), reelInfo.reelstrip1(:, 1));

% Draw a grid
draw_grid(screenInfo, gridInfo);

Screen('Flip', screenInfo.window);

for i = 1:55
    for i = 1:3
        reelInfo.reelstrip1(:, 3) = reelInfo.reelstrip1(:, 3) + screenInfo.Y_adjust/3;
    end
end

while ~KbCheck
    
    if reelInfo.reelstrip1(1, 3) == reset
        reelInfo.reelstrip1(1, 3) = screenInfo.splitposY(1) - screenInfo.Y_adjust;
    end
       
    reelInfo.reelstrip1(:, 3) = reelInfo.reelstrip1(:, 3) + screenInfo.Y_adjust/3;
    
    % Draw shapes
    draw_shapes(screenInfo, reelInfo, reelInfo.reelstrip1(:, [2,3]), reelInfo.reelstrip1(:, 1));
    
    % Draw a grid
    draw_grid(screenInfo, gridInfo);
    
    Screen('Flip', screenInfo.window);
    
    WaitSecs(0.005);
    
    disp(reelInfo.reelstrip1(reelInfo.reel_length, 3))
    
    if reelInfo.reelstrip1(reelInfo.reel_length, 3) == reset
        reelInfo.reelstrip1(4:reelInfo.reel_length, 3) = ...
            (reelInfo.reelstrip1(4:reelInfo.reel_length, 3) - reset2);
    end
    
    % I'm up to here. It's kind of working but I'll have to add something
    % to fix the updating for positions 2 and 3 (and possibly 1 ...)
    
    % But progress ...
    
end
%%

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



