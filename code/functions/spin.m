function [reelInfo] = spin(screenInfo, reelInfo, start_from, reelNumber)
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
    % i.e. it will animate from start_value to start_value + 1
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
    
    % Derive 4 index values to select symbols on reelstrip. 
    
    % The switch function handles the expections at the begining and end of
    % the reel strip, replacing the n-2, n-1, and n+1 values to wrap the
    % reelstrip around itself.
    
    % E.g. if we start at one, we want the last two positions of the 
    % reelstrip, as well as the first two.
    
    % We begin with the previous stop position and move this to the next
    % stop position
    
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

    reelInfo.spin(:, 1) = reelInfo.reelstrip(start_from, reelNumber);
    
    % fill column 2 with x values
    
    reelInfo.spin(:, 2) = screenInfo.splitposX(1);
    
    % fill column 3 with y values
    
    reelInfo.spin(:, 3) = [screenInfo.splitposY - screenInfo.Y_adjust, screenInfo.splitposY(3)];
    
    % create a default value for the draw_rate
    if ~ exist("draw_rate")
        draw_rate = 3;
    end
    
    for i = 1:draw_rate
        
        reelInfo.spin(:, 3) = reelInfo.spin(:, 3) + (screenInfo.Y_adjust/draw_rate);
        draw_shapes(screenInfo, reelInfo, reelInfo.spin(:, [2, 3]), reelInfo.spin(:, 1))
        draw_grid(screenInfo);
        Screen('Flip', screenInfo.window);
        
    end

end

