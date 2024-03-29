function [outcomeTable] = fill_outcomeTable(outcomeTable, reelInfo)
% ----------------------------------------------------------------------
% fill_outcomeTable(outcomeTable)
% ----------------------------------------------------------------------
% Goal of the function :
%  -  Draw a random reel stop
%  -  Fill in symbol codes from reelstops
% ----------------------------------------------------------------------
% Input(s) :
% an outcome table
% ----------------------------------------------------------------------
% Output(s):
% outcome table, filled with symbol codes
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : July 2021
% Project : 9_Line_Slots_Task
% Version : 2021a
% ----------------------------------------------------------------------

%% Get choice 
choice = inputname(1);

if choice == "betA"
    choice = 1;
elseif choice == "betB"
    choice = 2;
else
    error("choice text invalid")
end
    
%% Get reelstop:
% Get stop columns by column name:
pattern = ["LStop","RStop"];

% Draw reel stops and add to table:
outcomeTable(:, ismember(outcomeTable.Properties.VariableNames, pattern)) = ... 
    array2table(randi(reelInfo.reel_length, size(outcomeTable, 1), 2));
    % ^ Randomly draw a stop position for each reel repeat x nTrials

%% Fill in symbols

    for i = 1:height(outcomeTable)
        
        % Add reel symbols for each spin to output table

        % A bit of nesting here. expandStopINDEX is a custom function.
        % Function returns the index for above and below the stop. 
        % e.g. pass it 60 (and reel length is 60) it will return 59, 60, and 1.

        % Then index the reel strip using this vector to grab the symbols and
        % enter them to the output table.

        % Two patterns to select columns by name:
        patternL = ismember(outcomeTable.Properties.VariableNames, ["L1","L2", "L3"]);
        patternR = ismember(outcomeTable.Properties.VariableNames, ["R1","R2", "R3"]);

        % Left
        outcomeTable(i, patternL) = ...
            array2table(reelInfo.reelstrip(expandStopINDEX(reelInfo, outcomeTable.LStop(i), 1, 1), 1)');

        % Right 
        outcomeTable(i, patternR) = ...
            array2table(reelInfo.reelstrip(expandStopINDEX(reelInfo, outcomeTable.RStop(i), 1, 1), 2)');

        % Find potential matches, sum and add to output
        [LIA, LOCB] = ismember(... 
            outcomeTable{i, patternL}, ... 
            outcomeTable{i, patternR} ... 
            );

        % Number of lines to cue:
        outcomeTable.cueLines(i) = sum(LIA);
        
        % Fill centre position
        outcomeTable.CS(i) = Sample(1:5); 
        
        % Check if win
        outcomeTable.match(i) = ismember(outcomeTable.CS(i), ... 
            outcomeTable{i, patternL}(LIA));
        
    end
    
% Set aside the two different outcome classes:
losses = outcomeTable(outcomeTable.match == 0, :);
events = outcomeTable(outcomeTable.match == 1, :);

% Trim to size
% Randomly sample a subset of rows (without replacement)
losses = datasample(losses, reelInfo.nTrials/2, 'Replace', false);
events = datasample(events, reelInfo.nTrials/2, 'Replace', false);

% label bins
losses.binN = repelem([1:12]', 15, 1);
events.binN = repelem([1:12]', 15, 1);

% Three of each event per bin:
binEvents = repelem(reelInfo.multipliers(choice, :)', 3, 1);
%                                        ^ switch to choice row
 
% Fit multiplier
events.multiplier = repmat(binEvents, height(events) / height(binEvents), 1);

[~, outcomeTable, ~] = setup_output(reelInfo);

for i = 1:reelInfo.binN
    
    % Get rows that match bin number from each col
    this = vertcat(losses(losses.binN == i, :), events(events.binN == i, :));
    
    % Shuffle rows
    this = this(randperm(height(this)), :);
    
    % Get row index for outcomeTable
    index = [1:reelInfo.binsize] + reelInfo.binsize*(i - 1);
    
    % fill rows
    outcomeTable(index, :) = this;
    
end

end