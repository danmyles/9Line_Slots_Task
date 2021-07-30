function [reelInfo, outputData] = spin(screenInfo, reelInfo, outputData, demo)
    % ----------------------------------------------------------------------
    % spin(screenInfo, reelInfo)
    % ----------------------------------------------------------------------
    % Goal of the function :
    % This function creates an animated transition of the symbols from one
    % reelstrip position to the next. It can be used in loops to create a
    % spinning animation.
    % ----------------------------------------------------------------------
    % Input(s) :
    % screenInfo, reelInfo
    % also takes "start_from". This is the index from which the animation
    % should start.
    % i.e. it will animate from start_from to start_from + 1
    % ----------------------------------------------------------------------
    % Output(s):
    % reelInfo
    % But purpose is to draw the animation to the screen.
    % ----------------------------------------------------------------------
    % Function created by Dan Myles (dan.myles@monash.edu)
    % Last update : June 2020
    % Project : 9_Line_Slots_Task
    % Version : 2020a
    % ----------------------------------------------------------------------
    
    % NOTE: THESE ANIMATIONS ARE DESIGNED TO PROGRESS 1 PLACE BEYOND
    % THEIR START VALUE.
    

          
    % Some notes.
    % I want to re-organise this function so that both reels spin
    % simultaneously, the left reel should stop before the right.
    
    % It should draw ~10 symbols out in front of the next stopping position
    % and then progress them down until the stop is displayed at centre.
    
    % We also use this function for the demo. Which requires that we skip a
    % few operations to simplyfy things.
    
    % Fill in the value if missing:
    if nargin < 4
        demo = 0;
    end
       
    % Get the symbols preceeding outcome on the reel strip to spin
    % through
    left = expandStopINDEX(reelInfo, reelInfo.outcome.stops(1), 1, 20)';
    right = expandStopINDEX(reelInfo, reelInfo.outcome.stops(2), 1, 30)';
    
    % Check if previous position is somewhere in next spin (but let firt 10 symbols go).
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
    
    % create a default value for the draw_rate
    % draw rate is the number of times a symbol is redrawn between
    % reel positions.
    if ~ exist("draw_rate")
        draw_rate = 3;
    end
    
    % Somewhat hacky iterator for spin sequence
    % Number of rows in the right var, minus three because these are
    % already progressed onto the screen.
    
    it = (numel(right(:, 1))-3);
    
    % .* the draw rate because each symbols has to be drawn this many times.
    it = it .* draw_rate;
    
    % Start spin sequence
    for i = 1:it
        
        % Update Y positions until the final symbol reaches top position
        
        if left(1, 3) ~= screenInfo.splitposY(1)
            
            left(:, 3) = left(:, 3) + (screenInfo.Y_adjust/draw_rate);
            
            if demo ~= 1
            % Enter ~ approx LStop timing
            outputData.LStopSF(reelInfo.trialIndex) = GetSecs;
            end
            
        end
        
        % For loop takes care of stopping the right reel.
        right(:, 3) = right(:, 3) + (screenInfo.Y_adjust/draw_rate);
        
        % Draw new values to screen
        draw_shapes(screenInfo, reelInfo, left(:, 2:3), left(:, 1));
        draw_shapes(screenInfo, reelInfo, right(:, 2:3), right(:, 1));
        draw_grid(screenInfo);
        
        % Flip Screen
        [~, OnsetTime] = Screen('Flip', screenInfo.window);
        
    end
    
    if demo ~= 1
    % Enter
    outputData.RStopSF(reelInfo.trialIndex) = OnsetTime;
    end
    
end
