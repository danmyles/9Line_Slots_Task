function [output] = set_spin(reelInfo, start_value, end_value)
    % This function generates a vector that contains all consecutive
    % integers between the start value and end value. With the added condition
    % that if values become large reel_length they will start again at 1.
    % Order of the vector is then flipped. This is becuase the spin
    % animation need to index backwards through the reelstrip to get the
    % symbols to move from top to bottom.
    
    % Some errors
    
    if start_value > reelInfo.reel_length || start_value <= 0
        error('setSpin:inputError:start_value', 'start_value must be between 1 and 60.', 1)
    end
    
    if end_value > reelInfo.reel_length || end_value <= 0
        error('setSpin:inputError:end_value', 'Input end_value must be between 1 and 60.', 2)
    end
       
    if ~nargin == 3
        error('setSpin:no_inputs', ...
            'Function requires 3 inputs. \n\nCheck for:\nreelInfo, start_value, end_value', 3)
    end
    
    % Get values for output
    
    if (start_value < end_value) && (end_value < reelInfo.reel_length)
        output = [start_value:end_value];
    elseif start_value >= end_value
        output = [start_value:reelInfo.reel_length, 1:end_value];
    end

    output = flip(output);
    
end

