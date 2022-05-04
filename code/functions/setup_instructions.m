function [instructions, demoSequence] = setup_instructions(reelInfo, outputData)
% ----------------------------------------------------------------------
% [instructions, demoSequence] = setup_instructions(reelInfo, outputData)
% ----------------------------------------------------------------------
% Goal of the function :
% Lay out some text for instructions and create a spins sequence for the
% two demo spins.
% ----------------------------------------------------------------------
% Input(s) :
% reelInfo
% outputData
% ----------------------------------------------------------------------
% Output(s):
% instructions — full of text snippets for intro sequence
% demoSequence — two spins to demonstrate reels during intro
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : July 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
%% Common Phrases
% ----------------------------------------------------------------------
instructions.cont = 'Press any key to continue.';

% ----------------------------------------------------------------------
%% Opening
% ----------------------------------------------------------------------
instructions.opening = {
    'Hello.'; ...
    'Welcome to the 9 Line Slot Task.'; ...
    'In this experiment you will play a simple slot machine.'; ...
    'It looks like this:'; ...
    'Each reel will spin just like a slot machine...'; ...
    'If three symbols line up a win occurs.'; ...
    'Nice!'; ...
    'When a match occurs the centre symbol will display the amount won'; ...
    'If the centre position doesn''t match you do not win credits'; ...
    ':''(';
    };

% ----------------------------------------------------------------------
%% Explain 9 lines
% ----------------------------------------------------------------------

instructions.lines = {
    'There are 5 different symbols:'; ...
    'Match 3 of the same symbol and the machine will payout!'; ...
    'There are 9 different ways that three symbols can match';
    };

% ----------------------------------------------------------------------
%% Explain Betting
% ----------------------------------------------------------------------

instructions.betting = {
    'Before each spin you will be shown your total credits'; ...
    'You will also be given a choice between two slot machine games'; ...
	'Each game is subtly different'; ...
    'Your task is to determine which of the two games is the most advantageous'; ...
    'Every bet will cost 90 credits'; ...
    'That''s 10 credits for each of the 9 ways that a win can occur'
    };

% ----------------------------------------------------------------------
%% Explain Fixation Cross
% ----------------------------------------------------------------------

instructions.fixation = {
    'You may have noticed this symbol during the previous demonstration'; ...
    'It''s is called a ''fixation cross'''; ...
    'The fixation cross will appear moments before the final symbol on each trial'; ...
    'Whenever it appears, try to remain still and gently focus your gaze on that point'; ...
    'This will help to improve the accuracy of the EEG recording'};

% ----------------------------------------------------------------------
%% Introduce Task
% ----------------------------------------------------------------------
instructions.taskIntro = {
    'You have been given '; ...
    ' credits to play'; ...
    '1,000 credits = $1'; ...
    '10 credits = 1c'; ...
    'We will pay you the final credit balance at the end of the experiment'; ...
    'A random process is used to determine the outcome of each spin'; ...
    'So the final credit balance will depend on how many wins and losses occur'; ...
    'And how often you decide to bet on each of the two games'; ...
    'If you have any further questions please ask the experimenter now'};

% ----------------------------------------------------------------------
%% Demo sequence of spins for instructions
% ----------------------------------------------------------------------
% Get all columns from outputData
demoSequence = array2table(zeros(2, width(outputData)));
demoSequence.Properties.VariableNames = outputData.Properties.VariableNames;

% Set jackpot
demoSequence.multiplier(1) = reelInfo.multipliers(end);

% Create a row that wins along the centre.
demoSequence.LStop(1) = strfind(reelInfo.reelstrip(:, 1)', [2 1 3]) + 1;
demoSequence.RStop(1) = strfind(reelInfo.reelstrip(:, 2)', [4 1 5]) + 1;

if demoSequence.LStop(1) == 0 | demoSequence.RStop(1) == 0
    error("Could not find reel position for demo sequence stops. You may need to re-run create_experiment script to shuffle the reelstrips")
end

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

% Second trial
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

% Assign Trial Numbers
demoSequence.TrialN = [1:height(demoSequence)]';

% Payout
demoSequence.payout = demoSequence.multiplier * 10;

% end of function.
end