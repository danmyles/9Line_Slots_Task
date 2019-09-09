function [reelInfo] = fill_y(screenInfo, reelInfo)
    
    % Function needs a reel select input.
    
    % SOME INFORMATION ABOUT THIS FUNCTION
    
    % Get legnth of the reelstrip
    reelInfo.reel_length = length(reelInfo.reelstrip1);
    
    % Go to stop position and fill with centre y position
    reelInfo.reelstrip1(reelInfo.stops(1), 3) = screenInfo.yCenter;
    
    % Calculate the distance between the central point in each square
    % i.e. distance between central and bottom symbol
    
    % Fill all y information above reel stop
    for i = reelInfo.stops(1)+1:reelInfo.reel_length % from above reel stop to reelInfo.reel_length
        reelInfo.reelstrip1(i, 3) = reelInfo.reelstrip1(i-1, 3) + screenInfo.Y_adjust;
    end
    
    % Fill all below
    for i = reelInfo.stops(1)-1:-1:1 % from below stop to 1st position by -1
        reelInfo.reelstrip1(i, 3) = reelInfo.reelstrip1(i+1, 3) - screenInfo.Y_adjust;
    end
    
    % Handle wrap-around exceptions
    if reelInfo.stops(1) == reelInfo.reel_length % i.e. final position
            
            % If the final place on the reelstrip (reelInfo.reel_length)
            % is drawn as centre stop on the display then we need to
            % wrap the strip around so that the first place on the reel
            % strip is displayed on the bottom stop (i.e. grid position)
            
            reelInfo.reelstrip1(1, 3) = screenInfo.splitposY(3);
            
    elseif reelInfo.stops(1) ==  1 % i.e. 1st position on reelstrip
            
            % If the 1st position on the **reelstrip** is drawn we will need to
            % fill in the final reelstrip position with the y dimensions for
            % the top position on the **screen** so that the strip "wraps around"
            
            reelInfo.reelstrip1(reelInfo.reel_length, 3) = screenInfo.splitposY(1);
    end
end

