function [outcomeTable] = fill_outcomeTable(outcomeTable, reelInfo)
% ----------------------------------------------------------------------
% fill_outcomeTable(outcomeTable)
% ----------------------------------------------------------------------
% Goal of the function :
%  - Fill out remaining information in outcome Table given reelstops and
%    CS
% ----------------------------------------------------------------------
% Input(s) :
% outcomeTable
% ----------------------------------------------------------------------
% Output(s):
% outcomeTable
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 21 August 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------

[n, ~] = size(outcomeTable);

for i = 1:n
    % Add reel symbols for each spin to output table
    
    % A bit of nesting here. expandStopINDEX is a custom function.
    % Function returns the index for above and below the stop. 
    % e.g. pass it 60 (and reel length is 60) it will return 59, 60, and 1.
    
    % Then index the reel strip using this vector to grab the symbols and
    % enter them to the output table.
    
    % Two patterns to select columns by name:
    patternL = ["L1","L2", "L3"];
    patternR = ["R1","R2", "R3"];
    
    % Left
    outcomeTable(i, ismember(outcomeTable.Properties.VariableNames, patternL)) = ...
        array2table(reelInfo.reelstrip(expandStopINDEX(reelInfo, outcomeTable.LStop(i), 1, 1), 1)');
    
    % Right 
    outcomeTable(i, ismember(outcomeTable.Properties.VariableNames, patternR)) = ...
        array2table(reelInfo.reelstrip(expandStopINDEX(reelInfo, outcomeTable.RStop(i), 1, 1), 2)');
        
    % Find potential matches, sum and add to output
    [LIA, LOCB] = ismember(... 
        outcomeTable{i, ismember(outcomeTable.Properties.VariableNames, patternL)}, ... 
        outcomeTable{i, ismember(outcomeTable.Properties.VariableNames, patternR)} ... 
        );

    % Number of lines to cue:
    outcomeTable.cueLines(i) = sum(LIA);
    
    % Check if win
    outcomeTable.match(i) = ismember(outcomeTable.CS(i), ... 
        outcomeTable{i, ismember(outcomeTable.Properties.VariableNames, patternL)}(LIA));
    
    % Randomly select a win multiplier (if a match occurs)
    if outcomeTable.match(i) == 1
        
        outcomeTable.multiplier(i) = randsample(reelInfo.multipliers, 1);
        
    end
    
end

end