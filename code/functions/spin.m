function [reelInfo] = spin(screenInfo, reelInfo, gridInfo, start_value)
    % ----------------------------------------------------------------------
    % spin()
    % ----------------------------------------------------------------------
    % Goal of the function :
    % This function creates an animated transition of the symbols from one
    % reelstrip position to the next. It can be used in loops to create a
    % spinning animation
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
    
    % work out 4 reel_strip indexes
                                    
    start_value = [start_value - 2, ... 
                  start_value - 1, ...
                  start_value, ...
                  start_value + 1];
    
    % fill column 1 with symbol values

    reelInfo.spin1(:, 1) = reelInfo.reelstrip1(start_value, 1);
    
    % fill column 2 with x values
    
    reelInfo.spin1(:, 2) = screenInfo.splitposX(1);
    
    % fill column 3 with y values
    
    reelInfo.spin1(:, 3) = [screenInfo.splitposY - screenInfo.Y_adjust, screenInfo.splitposY(3)];
    
    % create a default value for the draw_rate
    if ~ exist("draw_rate")
        draw_rate = 3;
    end
    
    for i = 1:draw_rate
        
        reelInfo.spin1(:, 3) = reelInfo.spin1(:, 3) + (screenInfo.Y_adjust/draw_rate);
        draw_shapes(screenInfo, reelInfo, reelInfo.spin1(:, [2, 3]), reelInfo.spin1(:, 1))
        draw_grid(screenInfo, gridInfo);
        Screen('Flip', screenInfo.window);
        KbStrokeWait;
        
    end

end

