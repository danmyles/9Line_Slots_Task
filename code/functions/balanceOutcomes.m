function [outcomeTable] = balanceOutcomes(outcomeTable, reelInfo)
% ----------------------------------------------------------------------
% [outcomeTable] = balancedOutcomes(outcomeTable, reelInfo)
% ----------------------------------------------------------------------
% Goal of the function :
%  - To generate an outcome table with a minimum number of each type of
%  trial
% ----------------------------------------------------------------------
% Input(s) :
% outcomeTable
% ----------------------------------------------------------------------
% Output(s):
% outcomeTable
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : August 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------

% I'll want to duplicate the table to draw some top-up events at the end of
% the script:
topUp = outcomeTable;

%% Generate array of random reel stops/index positions and fill tables.

% Get stop columns by column name:
pattern = ["LStop","RStop"];

% BET HIGH

% Draw reel stops and add to table:
outcomeTable(:, ismember(outcomeTable.Properties.VariableNames, pattern)) = ... 
    array2table(randi(reelInfo.reel_length, reelInfo.nTrials, 2));
    % ^ Randomly draw a stop position for each reel repeat x nTrials

% And again for topUp
topUp(:, ismember(topUp.Properties.VariableNames, pattern)) = ...
    array2table(randi(reelInfo.reel_length, reelInfo.nTrials, 2));

% Fill in Centre Symbol
outcomeTable.CS = randi(5, reelInfo.nTrials, 1);
topUp.CS  = randi(5, reelInfo.nTrials, 1);

% Fill in symbol codes and other info (see function)
[outcomeTable] = fill_outcomeTable(outcomeTable, reelInfo);
[topUp]        = fill_outcomeTable(topUp, reelInfo);

% Minimum number of each outcome type (now set outside function)
nMinEvent = reelInfo.nMinEvent;

% Minimum number of losses that should occur (now set outside function)
nMinLosses = reelInfo.nMinLosses;

% Set aside the losses:
losses = outcomeTable(outcomeTable.match == 0, :);
% Randomly sample rows x nMinLosses times (without replacement)
losses = datasample(losses, nMinLosses, 'Replace', false);

% Pre allocate a table for selected outcomes
this = array2table(zeros(0, 12), ... 
    'VariableNames', outcomeTable.Properties.VariableNames);

for j = reelInfo.multipliers
    
    % Subset rows that match multiplier
    that = outcomeTable(outcomeTable.multiplier == j, :);
    
    % Sample nMinEvent rows
    that = datasample(that, nMinEvent, 'Replace', false);
    
    % Add to output
    this = vertcat(this, that);
    
end

% Combine tables
this = vertcat(losses, this);

% Make up total trial number:
n = reelInfo.nBetHigh - size(this, 1);
topUp = datasample(topUp, n);

% topUp Outcome Table:
this = vertcat(this, topUp);

% Shuffle rows:
outcomeTable = this(randperm(reelInfo.nBetHigh), :);

end
