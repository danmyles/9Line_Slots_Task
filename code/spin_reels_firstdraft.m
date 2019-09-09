%% Spin Reels

% Start experiment and run all setup functions
[screenInfo, reelInfo, gridInfo, fileInfo] = boot_exp();

% Fill reel.Info struct with current spin info
[reelInfo] = update_reelInfo(reelInfo, screenInfo);

reel_length = length(reelInfo.reelstrip1);

% We want our reels to spin from top to bottom
% We need three symbol positions (above, reel_position, below)

for reel_position = reel_length:-1:1
    
    % Next we adjust our reel_position vairable so that it represents three
    % symbol positions rather than one (above, reel_position, below). We 
    % use the original reel_position to find the values above and below 
    % the centre. However, this will cause issues if we select the 1st or 
    % nth position on the reelstrip. So we will use a switch statement
    % to deal with these exceptions.
    
    switch reel_position
        case reel_length % i.e. final position
            reel_position = [reel_position-1, reel_position, 1];
        case 1 % i.e. 1st position
            reel_position = [reel_length, 1, reel_position+1];
        otherwise
            % Use i to subset one above and below stop position
            reel_position = reel_position-1:reel_position+1;
    end
    
    reelInfo.sym_shape(1:3) = reelInfo.reelstrip1(reel_position);
    
    for j = 1:3 % draw position

        reelInfo.sym_position{j} = get_dimensions(screenInfo, j, reelInfo.sym_shape(j));
    end
    
    % Draw shapes
    draw_shapes(screenInfo, reelInfo, 1:3);
    
    % Draw a grid
    draw_grid(screenInfo, gridInfo);
    
    %
    Screen('Flip', screenInfo.window);
    
    %
    KbStrokeWait;
       
end


% Clear the screen
sca;

   

