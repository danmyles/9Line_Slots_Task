function [output] = set_spin(reelInfo, spin_from, spin_to)
    % [output] = set_spin(reelInfo, spin_from, spin_to)
    % This function generates a vector that contains descending consecutive
    % integers between the start value and end value. With the added condition
    % that if values become larger reel_length they will start again at 1.
    
    % Some errors
    
    if spin_from > reelInfo.reel_length || spin_from <= 0
        error('setSpin:inputError:start_value', 'start_value must be between 1 and 60.', 1)
    end
    
    if spin_to > reelInfo.reel_length || spin_to <= 0
        error('setSpin:inputError:end_value', 'Input end_value must be between 1 and 60.', 2)
    end
       
    if ~nargin == 3
        error('setSpin:no_inputs', ...
            'Function requires 3 inputs. \n\nCheck for:\nreelInfo, start_value, end_value', 3)
    end
    
    % Get values for output
    
    if spin_from > spin_to
        
        % If the starting stop is greater than the final stop. We can use
        % the colon to generate a list of numbers between the stop position
        % (spin_to) and the start position (spin_from)
        
        % Because we want our vector to be in descending order, we then
        % flip this vector. 
        % For example if we want to start at 7 and spin to 1
        %              [stop]  1, 2, 3, 4, 5, 6, 7 [start]
        %              [start] 7, 6, 5, 4, 3, 2, 1 [stop]
        
        output = flip(spin_to:spin_from)';
        
    elseif spin_from <= spin_to      
        
        % If the starting stop is less than or equal to the final stop.
        % Things are a little tricker as we have to account for crossing
        % the 59, 60, 1, 2 etc wrap around point
        
        % For example:
        % We want to spin from 7 to 55
        % We want the vector 7 6 5 4 3 2 1 60 59 58 57 56 55
        
        % We can get the 7:1 portion by flipping 1:7
        % Likewise we can get the 60 to 55 portion by flippin 55:60
        % then we just need to join these two fragments and our vector will
        % wrap over from 60 to 1
                
        output = [flip(1:spin_from), flip(spin_to:reelInfo.reel_length)]';
    end
    
    % The spin animation starts from a value and pushes it forward one
    % place along the reel strip. This means that when we pass the stop
    % position to the animation it pushes past it by one place. To account
    % for this we want this function to trim the final value from the
    % vector created.
        
    trim = length(output) - 1;
    
    output = output(1:trim);
end

