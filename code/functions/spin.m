function [reelInfo, outputData, vbl] = spin(screenInfo, reelInfo, outputData, demo)
    % ----------------------------------------------------------------------
    % spin(screenInfo, reelInfo)
    % ----------------------------------------------------------------------
    % Goal of the function :
    % This function creates an animated transition of the symbols from one
    % reelstrip position to the next. It can be used in loops to create a
    % spinning animation.
    % ----------------------------------------------------------------------
    % Input(s) :
    % screenInfo, reelInfo, outputData, demo
    % ----------------------------------------------------------------------
    % Output(s):
    % reelInfo, outputData, vbl
    % But purpose is to draw the animation to the screen.
    % ----------------------------------------------------------------------
    % Function created by Dan Myles (dan.myles@monash.edu)
    % Last update : July 2022
    % Project : 9_Line_Slots_Task
    % Version : 2021a
    % ----------------------------------------------------------------------
      
    % Fill in the demo value if missing:
    if nargin < 4
        demo = 0;
    end
       
    % Get the symbols preceeding outcome on the reel strip to spin
    % through
    left = expandStopINDEX(reelInfo, reelInfo.outcome.stops(1), 1, 20)';
    right = expandStopINDEX(reelInfo, reelInfo.outcome.stops(2), 1, 30)';
    
    % Check if previous position is somewhere in next spin (but let first 10 symbols go).
    [LIA, LOCB] = ismember(reelInfo.previous.dspSymbols(1, 1), reelInfo.reelstrip(left(11:end), 1));
    
    if LIA == 1 % If so slice this into the upcoming symbols
        
        left = [left(1:10+LOCB); reelInfo.previous.allstops(2:3, 1)];
        
    else % else append directly to end
        
        left = [left; reelInfo.previous.allstops(:, 1)];
        
    end
    
    % Same again for RHS
    
    [LIA, LOCB] = ismember(reelInfo.previous.dspSymbols(1, 3), reelInfo.reelstrip(right(21:end), 2));
    
    if LIA == 1 % If so slice this into the upcoming symbols
        
        right = [right(1:20+LOCB); reelInfo.previous.allstops(2:3, 2)];
        
    else % else append directly to end
        
        right = [right; reelInfo.previous.allstops(:, 2)];
        
    end
    
    % fill column 1 with symbol codes
    left(:, 1) = reelInfo.reelstrip(left, 1);
    right(:, 1) = reelInfo.reelstrip(right, 2);
    
    % fill column 2 with x values
    left(:, 2) = reelInfo.pos.L(1);
    right(:, 2) = reelInfo.pos.R(1);
    
    % fill column 3 with y values
    
    % Create vector to adjust Y positions
    [R, ~] = size(left);
    R = [1:R] - 1;
    R = flip(R);
    R = R * screenInfo.Y_adjust;
    
    left(:, 3) = screenInfo.splitposY(3);
    left(:, 3) = left(:, 3) - R';
    
    [R, ~] = size(right);
    R = [1:R] - 1;
    R = flip(R);
    R = R * screenInfo.Y_adjust;
    right(:, 3) = screenInfo.splitposY(3);
    right(:, 3) = right(:, 3) - R';
    
    % These matrices now contain a Y position for each symbol in the reel
    % strip that will be displayed during the spin. 
    
    % I need to iterate over these, adjusting them one step at a time.
    % and then displaying the symbols to the screen to give the appearance
    % of movement.
    
    % Pre-allocating these positions should be a little faster.
        
    % Each symbol will shift position until the top most symbol in the columns
    % falls to the top row position.
    
    % Number of rows in the right var, minus three because these are
    % already progressed onto the screen.
    right_Y = right(:, 3) + (screenInfo.Y_adjust/reelInfo.draw_rate) * (1:((length(right) - 3) * reelInfo.draw_rate));
    left_Y  = left(:, 3)  + (screenInfo.Y_adjust/reelInfo.draw_rate) * (1:((length(left)  - 3) * reelInfo.draw_rate));
        
    % Left reel stops first, so it's a little smaller.
    % Left will now be the same dimensions as right, but with repetitions.
    left_Y(:, (width(left_Y) + 1):width(right_Y)) = repmat(left_Y(:, width(left_Y)), 1, (width(right_Y) - width(left_Y)));
    
    % Some lost precision leading to small errors past the 4th decimal
    % place
    left_Y = round(left_Y, 4);
    right_Y = round(right_Y, 4);
    
    % Find the positions worth drawing:
    select_L = left_Y > 0-(screenInfo.Y_adjust / reelInfo.draw_rate) & left_Y < screenInfo.screenYpixels+(screenInfo.Y_adjust / reelInfo.draw_rate);
    select_R = right_Y > 0-(screenInfo.Y_adjust / reelInfo.draw_rate) & right_Y < screenInfo.screenYpixels+(screenInfo.Y_adjust / reelInfo.draw_rate);
           
    draw_shapes(screenInfo, reelInfo, left(:, 2:3), left(:, 1));
    draw_shapes(screenInfo, reelInfo, right(:, 2:3), right(:, 1));
    draw_grid(screenInfo);
    
    vbl = Screen('Flip', screenInfo.window);
    vbl = vbl + 2 * screenInfo.ifi; % Allow 2 extra frames
    
    % The timing here isn't important, but the vast number of
    % iterations of screen flips that this function produces meant that 
    % I was racking up warnings that made it difficult to 
    % identify issues in more important parts of the script. 
    % I've set up manual timing here in an attempt to minimise these
    % warnings.
    % My setup is a 240Hz monitor (running linux (pop_os)) so the frame 
    % frame rate is super fast and I need to allow a few extra frames to 
    % provide enough time for the script to complete.
    % This also helped to slow the spin animation down.
    
    % Start spin sequence
    for i = 1:width(right_Y)
        
        % Draw new values to screen
        draw_shapes(screenInfo, reelInfo, [repmat(reelInfo.pos.L(1), sum(select_L(:, i)), 1),  left_Y(select_L(:, i), i)],  left(select_L(:, i), 1));
        draw_shapes(screenInfo, reelInfo, [repmat(reelInfo.pos.R(1), sum(select_R(:, i)), 1), right_Y(select_R(:, i), i)], right(select_R(:, i), 1));
        draw_grid(screenInfo);
                
        Screen('DrawingFinished', screenInfo.window);
        
        % Flip Screen
        [vbl, OnsetTime] = Screen('Flip', screenInfo.window, vbl + 2.5 * screenInfo.ifi);
        
    end
    
    if demo ~= 1
    % Enter
    outputData.RStopSF(reelInfo.trialIndex) = OnsetTime;
    end
    
end

