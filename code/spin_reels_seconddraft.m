%% Spin Reels

% Start experiment and run all setup functions
[screenInfo, reelInfo, gridInfo, fileInfo] = boot_exp();

% Randomly draws postion at which to stop reels and fill reel_info
[reelInfo] = update_stops(screenInfo, reelInfo);

% Use the spin function to spin from start position 3 until start position
% 59

for i = 59:-1:3
    spin(screenInfo, reelInfo, gridInfo, i)
end

%% DELETE AFTER DEBUGGING
% 
% reelInfo.stops([1, 3]) = randsample(reelInfo.reel_length, 2, true);
% reelInfo.stops(2) = randsample(1:5, 1, true);
% 
% reelInfo.stops(1) = 60; 
% %%

reelInfo = fill_y(screenInfo, reelInfo);

% We will use this y value on the reelstrip to trigger a reset of all
% position

reset = (screenInfo.splitposY(1) - screenInfo.Y_adjust) + (reelInfo.reel_length .* screenInfo.Y_adjust); 

% Determine how much y_values need to be reset by
reset2 = reelInfo.reel_length .* screenInfo.Y_adjust;

% Draw shapes
draw_shapes(screenInfo, reelInfo, reelInfo.reelstrip1(:, [2,3]), reelInfo.reelstrip1(:, 1));

% Draw a grid
draw_grid(screenInfo, gridInfo);

Screen('Flip', screenInfo.window);

% Temporary loop for advancing reelstrip

for i = 1:57
    for i = 1:3
        reelInfo.reelstrip1(:, 3) = reelInfo.reelstrip1(:, 3) + screenInfo.Y_adjust/3;
    end
end

while ~KbCheck
    
    % When the first position reaches our reset value. 
    % Replace that value with first y_value
    % That is, the value two positions below the centre of the screen.
    % Or splitposY - the Y adjustment.
    
    if reelInfo.reelstrip1(1, 3) == reset
        reelInfo.reelstrip1(1, 3) = screenInfo.splitposY(1) - screenInfo.Y_adjust;
    end
    
    if reelInfo.reelstrip1(reelInfo.reel_length, 3) == reset;
        reelInfo.reelstrip1(1:reelInfo.reel_length, 3) = ...
            (reelInfo.reelstrip1(4:reelInfo.reel_length, 3) - reset2);
    end
        
    % Shift all y values forward
    % Currently using 1/3 of the Y_adjust scalar, but we could break this
    % up to make the animation smoother
    
    reelInfo.reelstrip1(:, 3) = reelInfo.reelstrip1(:, 3) + screenInfo.Y_adjust/3;
    
    % Draw shapes
    draw_shapes(screenInfo, reelInfo, reelInfo.reelstrip1(:, [2,3]), reelInfo.reelstrip1(:, 1));
    
    % Draw a grid
    draw_grid(screenInfo, gridInfo);
    
    % Flip to screen
    Screen('Flip', screenInfo.window);
    
    % Wait a bit
    WaitSecs(0.005);
    
    % Print value at reel_length for debugging
    disp(reelInfo.reelstrip1(reelInfo.reel_length, 3))
    
    % When the final reelstrip position reaches our reset value
    % Select
    
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


% Set time of stimuli (this was in another script may be useful for working out timing.)
stim_sec = .125;
numFrames = stim_sec/(screenInfo.ifi);


