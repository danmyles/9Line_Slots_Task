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
%% Timing Information
% -------------------------------------------------------------------------

% Set timing information for experiment
reelInfo.timing.jitter = 100;
reelInfo.timing.ISI = 200;
reelInfo.timing.fixationcross = 500;

% -------------------------------------------------------------------------
%% Generate Experiment Outcomes
% -------------------------------------------------------------------------

n = 100; % Number of experiments to generate (sample size plus dropout).

reelInfo.nTrials = 375; % Number of trials (length of experiment)

% How much was bet per line
reelInfo.lineBet = 10;

% How much was bet in total
reelInfo.totalBet = reelInfo.lineBet * 9;

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
outputEmpty(:, 11:12) = array2table(randi(reelInfo.reel_length, reelInfo.nTrials, 2));

% Add central symbol
outputEmpty.CS(:) = randi(5, reelInfo.nTrials, 1);

for i = 1:reelInfo.nTrials
    % Add reel symbols for each spin to output table
    
    % A bit of nesting here. expandStopINDEX is a custom function.
    % Function returns the index for above and below the stop. 
    % e.g. pass it 60 (and reel length is 60) it will return 59, 60, and 1.
    
    % Then index the reel strip using this vector to grab the symbols and
    % enter them to the output table.
    
    % Left
    outputEmpty(i, 13:15) = ... 
        array2table(reelInfo.reelstrip(expandStopINDEX(reelInfo, outputEmpty.LStop(i), 1, 1), 1)');
    
    % Right
    outputEmpty(i, 17:19) = ... 
        array2table(reelInfo.reelstrip(expandStopINDEX(reelInfo, outputEmpty.RStop(i), 1, 1), 2)');
        
    % Find potential matches, sum and add to output
    [LIA, LOCB] = ismember(outputEmpty{i, 13:15}, outputEmpty{i, 17:19});
    outputEmpty.cueLines(i) = sum(LIA);
    
    % Check if win
    outputEmpty.match(i) = ismember(outputEmpty.CS(i), outputEmpty{i, 13:15}(LIA));
    
    % Add data for wins (payout etc)
    if outputEmpty.match(i) == 1
        
        outputEmpty.multiplier(i) = randsample(reelInfo.multipliers, 1);
        outputEmpty.payout(i) = outputEmpty.multiplier(i) .* reelInfo.lineBet;
        outputEmpty.netOutcome(i) = outputEmpty.payout(i) - reelInfo.totalBet;
        
    else
        outputEmpty.netOutcome(i) = outputEmpty.netOutcome(i) - reelInfo.totalBet;
    end
    
    % Update credits
    outputEmpty.credits(i:height(outputEmpty)) = (outputEmpty.credits(i) + outputEmpty.netOutcome(i));
    
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










