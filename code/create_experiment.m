% ----------------------------------------------------------------------
% create_experiment()
% ----------------------------------------------------------------------
% Goal of this script:
% To generate a set of sequences to use in my 9LST experiment
% ----------------------------------------------------------------------
% Input(s) :
% reelInfo ? takes the reelstrips as input
% ----------------------------------------------------------------------
% Output(s):
% reelInfo - provides updated symbol positions to sym_shape
% ----------------------------------------------------------------------
% Created by Dan Myles (dan.myles@monash.edu)
% Last update : June 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------
% Shuffle RNG
rng shuffle;
clear all
clearvars;

%% Get directory
% Add 9LST to path before running!
[fileInfo] = setup_file();

%% Generate the reelstips (pattern of symbols along reel):
% 5 - Number of reel symbols - "alphabet"
% 3 - Number of vertical reel positions - "word length"

% By default generate_reelstrip will generate a sequence of symbols that
% does not include repeats. This feature can be changed as below by
% defining the repeatSymbols setting.

% Determine reelstrip structure
%       0 = no repetition of symbols within subsequences
%       1 = de Bruijn sequence
%       2 = Kautz sequence
% For more information see documentation inside generate_reelstrip function

% -------------------------------------------------------------------------
%% Gerenate Reelstrips
% -------------------------------------------------------------------------

repeatSymbols = 0;

[reelInfo.reelstrip] = generate_reelstrip(5, 3, repeatSymbols);

writematrix(reelInfo.reelstrip, 'config/reelstrip.csv')

% -------------------------------------------------------------------------
%% Generate Experiment Outcomes
% -------------------------------------------------------------------------

n = 40; % Number of experiments to generate (sample size plus dropout).

reelInfo.nTrials = 400; % Number of trials (length of experiment)

% Choose Low bet and high bet amounts
reelInfo.lineBet = [1, 10];

% Set maximum number of each betting choice
reelInfo.nBetLow = reelInfo.nTrials/2;
reelInfo.nBetHigh = reelInfo.nTrials/2;

% Set multipliers
reelInfo.multipliers = [4, 8, 10, 14, 77.7];

% Set credits
reelInfo.credits = 20000;

% Get reel length to allow relative scripting for length of the reelstrips
reelInfo.reel_length = length(reelInfo.reelstrip(:, 1));

%% TODO: Create trial and block structure

% Load in empty output table and add credits
[outputEmpty] = setup_output(reelInfo.nTrials);
outputEmpty.credits(1) = reelInfo.credits;

%% Generate random reel index and fill outputData
% Get stop columns by column name:
outputEmpty(:, contains(outputEmpty.Properties.VariableNames, 'Stop')) = ... 
    array2table(randi(reelInfo.reel_length, reelInfo.nTrials, 2));
    % ^ Randomly draw a stop position for each reel repeat x nTrials ...

% Add central symbol
outputEmpty.CS(:) = randi(5, reelInfo.nTrials, 1);

for i = 1:reelInfo.nTrials
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
    outputEmpty(i, contains(outputEmpty.Properties.VariableNames, patternL)) = ...
        array2table(reelInfo.reelstrip(expandStopINDEX(reelInfo, outputEmpty.LStop(i), 1, 1), 1)');
    
    % Right 
    outputEmpty(i, contains(outputEmpty.Properties.VariableNames, patternR)) = ...
        array2table(reelInfo.reelstrip(expandStopINDEX(reelInfo, outputEmpty.RStop(i), 1, 1), 2)');
        
    % Find potential matches, sum and add to output
    [LIA, LOCB] = ismember(... 
        outputEmpty{i, contains(outputEmpty.Properties.VariableNames, patternL)}, ... 
        outputEmpty{i, contains(outputEmpty.Properties.VariableNames, patternR)} ... 
        );

    % Number of lines to cue:
    outputEmpty.cueLines(i) = sum(LIA);
    
    % Check if win
    outputEmpty.match(i) = ismember(outputEmpty.CS(i), ... 
        outputEmpty{i, contains(outputEmpty.Properties.VariableNames, patternL)}(LIA));
    
    % Randomly select a win multiplier (if a match occurs)
    if outputEmpty.match(i) == 1
        
        outputEmpty.multiplier(i) = randsample(reelInfo.multipliers, 1);
        
    end
    
end

% Save data and (short form) for testing
output.participant0 = outputEmpty;
output.participant0.participantID(:) = 0;

output.participant00 = outputEmpty(1:10, :);
output.participant00.participantID(:) = 00;

filenames = fieldnames(output);

% Save each participant data table to input folder 
% These will be selected by the experimenter at the beginning of the exp.
for i = 1:numel(filenames)
    
    i = filenames{i};
    save([fileInfo.input i '.mat'], '-struct', 'output', char(i) )
    
end

% Save reelstrips to config directory
save([fileInfo.config 'reelInfo.mat'], 'reelInfo')










