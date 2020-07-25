function [stop] = expandStopINDEX(reelInfo, stop, nback, nforward)
    % expandStopINDEX(reelInfo, stop, nback, nforward)
    % This function takes a single stop value and expands it nback and n
    % forward to return a vector
    
    % Expand value to vector
    stop = (stop-nback):(stop+nforward);
    
    % Correct edge cases
    for i = 1:length(stop)
        
        if stop(i) > reelInfo.reel_length
            stop(i) = stop(i) - reelInfo.reel_length;
        end
        
        if stop(i) < 1
            stop(i) = reelInfo.reel_length + stop(i);
        end
        
    end
    
end