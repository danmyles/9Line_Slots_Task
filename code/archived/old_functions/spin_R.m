function [reelInfo] = spin_R(screenInfo, reelInfo, start_from)
    % ----------------------------------------------------------------------
    % spin()
    % ----------------------------------------------------------------------
    % Goal of the function :
    % This function creates an animated transition of the symbols from one
    % reelstrip position to the next. It can be used in loops to create a
    % spinning animation.
    % ----------------------------------------------------------------------
    % Input(s) :
    % screenInfo, reelInfo
    % also takes "start_value". This is the index from which the animation
    % should start. 
    % i.e. it will animate from start_from to start_from + 1
    % ----------------------------------------------------------------------
    % Output(s):
    % reelInfo
    % But purpose is to draw the animation to the screen.
    % ----------------------------------------------------------------------
    % Function created by Dan Myles (dan.myles@monash.edu)
    % Last update : Spetember 2019
    % Project : 9_Line_Slots_Task
    % Version : 2019a
    % ----------------------------------------------------------------------
       
    % NOTE: THESE ANIMATIONS ARE DESIGNED TO PROGRESS 1 PLACE BEYOND
    % THEIR START VALUE. 
    
    %% SPIN RIGHT
    
          
    switch start_from
        case 1
            start_from = [reelInfo.reel_length - 1, reelInfo.reel_length, 1, 2];
        case 2
            start_from = [reelInfo.reel_length, 1:3];
        case reelInfo.reel_length
            start_from = [reelInfo.reel_length - 2:reelInfo.reel_length, 1]; 
        otherwise
            start_from = [start_from - 2, ...
                start_from - 1, ...
                start_from, ...
                start_from + 1];
    end
                
    % fill column 1 with symbol values
    reelInfo.spin(:, 1, 2) = reelInfo.reelstrip(start_from, 2);
    
    % fill column 2 with x values  
    reelInfo.spin(:, 2, 2) = reelInfo.pos.R(1);

    % fill column 3 with y values
    reelInfo.spin(:, 3, 2) = [screenInfo.splitposY - screenInfo.Y_adjust, screenInfo.splitposY(3)];
    
    % create a default value for the draw_rate
    if ~ exist("draw_rate")
        draw_rate = 3;
    end
    
    for i = 1:draw_rate
        
        % Move symbols down by screenInfo.Y_adjust/draw_rate
        reelInfo.spin(:, 3, 2) = reelInfo.spin(:, 3, 2) + (screenInfo.Y_adjust/draw_rate);
        
        % Draw new position to screen
        draw_shapes(screenInfo, reelInfo, reelInfo.spin(:, [2, 3], 2), reelInfo.spin(:, 1, 2))
        
        % Draw grid and stationary right reel
        % draw_shapes(screenInfo, reelInfo, screenInfo.splitpos(7:9, :), reelInfo.reelstrip(reelInfo.oldAllstops(:, 3), 2));
        draw_shapes(screenInfo, reelInfo, reelInfo.pos.L, reelInfo.outcome.dspSymbols(1:3))
        draw_grid(screenInfo);
        
        % Flip to screen
        Screen('Flip', screenInfo.window);
        
    end
    
end

