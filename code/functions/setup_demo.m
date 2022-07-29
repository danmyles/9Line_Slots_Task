function [demoSequence] = setup_demo(reelInfo, outputData)
% ----------------------------------------------------------------------
% [demoSequence] = setup_demo(reelInfo, outputData)
% ----------------------------------------------------------------------
% Goal of the function :
% Create a spins sequence for a demontration spins.
% ----------------------------------------------------------------------
% Input(s) :
% reelInfo
% outputData
% ----------------------------------------------------------------------
% Output(s):
% demoSequence — two spins to demonstrate reels during intro
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : June 2021
% Project : 9_Line_Slots_Task
% Version : 2021a
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
%% Demo sequence of spins for instructions
% ----------------------------------------------------------------------
% Get all columns from outputData
demoSequence = array2table(zeros(3, width(outputData)));
demoSequence.Properties.VariableNames = outputData.Properties.VariableNames;

% Set trial payouts
demoSequence.multiplier(1) = reelInfo.multipliers(end);
demoSequence.multiplier(2) = 0;
demoSequence.multiplier(3) = reelInfo.multipliers(1, 3);

if ~contains(char(reelInfo.reelstrip(:, 1)'), char([2 1 3])) | ~contains(char(reelInfo.reelstrip(:, 2)'), char([4 1 5]))
    error("Could not find reel position for demo sequence stops. You may need to re-run create_experiment script to shuffle the reelstrips")
end

% Create a row that wins along the centre.
demoSequence.LStop(1) = strfind(reelInfo.reelstrip(:, 1)', [2 1 3]) + 1;
demoSequence.RStop(1) = strfind(reelInfo.reelstrip(:, 2)', [4 1 5]) + 1;

% Select cols by colnames
pattern = ["L1", "L2", "L3", "CS", "R1", "R2", "R3"];
% Add symbols
demoSequence(1, ismember(demoSequence.Properties.VariableNames, pattern)) = ... 
    table(2, 1, 3, 1, 4, 1, 5);

% Select cols by colnames
pattern = ["cueLines", "match"];
% Set
demoSequence(1, ismember(demoSequence.Properties.VariableNames, pattern)) ...
    = table(1, 1);

% Second trial (loss)
demoSequence.LStop(2) = strfind(reelInfo.reelstrip(:, 1)', [5 1 3]) + 1;
demoSequence.RStop(2) = strfind(reelInfo.reelstrip(:, 2)', [2 1 4]) + 1;

% Select cols by colnames
pattern = ["L1", "L2", "L3", "CS", "R1", "R2", "R3"];
% Add symbols
demoSequence(2, ismember(demoSequence.Properties.VariableNames, pattern)) = ... 
    table(5, 1, 3, 4, 2, 1, 4);

% Select cols by colnames
pattern = ["cueLines", "match"];
% Set
demoSequence(2, ismember(demoSequence.Properties.VariableNames, pattern)) ...
    = table(1, 0);

% Third trial (fixation practice)
demoSequence.LStop(3) = strfind(reelInfo.reelstrip(:, 1)', [1 5 3]) + 1;
demoSequence.RStop(3) = strfind(reelInfo.reelstrip(:, 2)', [3 5 2]) + 1;

% Select cols by colnames
pattern = ["L1", "L2", "L3", "CS", "R1", "R2", "R3"];
% Add symbols
demoSequence(3, ismember(demoSequence.Properties.VariableNames, pattern)) = ... 
    table(1, 5, 3, 5, 3, 5, 2);

% Select cols by colnames
pattern = ["cueLines", "match"];
% Set
demoSequence(3, ismember(demoSequence.Properties.VariableNames, pattern)) ...
    = table(2, 1);

% Assign Trial Numbers
demoSequence.TrialN = [1:height(demoSequence)]';

% Payout
demoSequence.payout = demoSequence.multiplier * 10;