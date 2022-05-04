function [outputArg1] = trim_centre(input_Arg1)
    % trim_centre(input_Arg1)
    % This function strips columns from matrices that with a 0 in row 1
    % Useful for passing reelInfo.dspSymbols() to draw shapes without the 
    % need to re-arrange input.
    
    outputArg1 = [];
    
    for i = input_Arg1

        if i > 0
            outputArg1 = [outputArg1, i];
        end
        
    end

