% ----------------------------------------------------------------------
% create_experiment()
% ----------------------------------------------------------------------
% Goal of this script:
% To generate a set of sequences to use in my 9LST experiment
% ----------------------------------------------------------------------
% Input(s) :
% ----------------------------------------------------------------------
% Output(s): output Tables for high and low bet conditions.
% ----------------------------------------------------------------------
% Created by Dan Myles (dan.myles@monash.edu)
% Last update : August 2020
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

% I did this so that any random sampling would not be biased by the order
% of reel symbols, while disallowing any repeats.

% -------------------------------------------------------------------------
%% Generate Reelstrips
% -------------------------------------------------------------------------

repeatSymbols = 0;

[reelInfo.reelstrip] = generate_reelstrip(5, 3, repeatSymbols);

writematrix(reelInfo.reelstrip, 'config/reelstrip.csv')

% -------------------------------------------------------------------------
%% Experiment Details
% -------------------------------------------------------------------------

n = 40; % Number of experiments to generate (sample size plus dropout).

% Block structure
reelInfo.blocksize = 60; % Length of each block
reelInfo.blockN = 8;     % Number of blocks

% Number of trials (length of experiment)
reelInfo.nTrials = reelInfo.blockN .* reelInfo.blocksize;

% Choose Low bet and high bet amounts
reelInfo.lineBet = [1, 10];

% Set maximum number of each betting choice
reelInfo.nBetHigh = reelInfo.nTrials/2;
reelInfo.nBetLow  = reelInfo.nBetHigh;

% Set multipliers
reelInfo.multipliers = [3, 6, 12, 15, 50];

% Minimum number of each outcome type
reelInfo.nMinEvent = 22;  

% Minimum number of losses that should occur 
reelInfo.nMinLosses = reelInfo.nBetLow - numel(reelInfo.multipliers) * reelInfo.nMinEvent;

% Set credits
reelInfo.credits = 20000;

% Get reel length to allow relative scripting for length of the reelstrips
reelInfo.reel_length = length(reelInfo.reelstrip(:, 1));

% Save reelstrips to config directory
save([fileInfo.config 'reelInfo.mat'], 'reelInfo')

% ------------------------------------------------------------------------
% Create a summary to check all outputs:
% ------------------------------------------------------------------------

summaryTable = array2table(zeros(n, 17));
summaryTable.Properties.VariableNames = [...
    'matchHigh', 'matchLow', 'totalHigh', 'totalLow', 'totalNet', ... 
    strcat([0, string(reelInfo.multipliers)], "H"), ...
    strcat([0, string(reelInfo.multipliers)], "L")];

% -------------------------------------------------------------------------
%% Generate Experiment Outcomes
% -------------------------------------------------------------------------
% Loop over sample size to produce n x 2 tables of outcomes

% Likely to be fairly time consuming so maybe make a coffee or whatever.

for i = 1:n

% Load in empty outcome tables
[~, betHigh, betLow] = setup_output(reelInfo, 900);

% This function is a hacky workaround a result of how I had designed a
% previous script. I orginally designed the task to be truly random 
% (see create_experimentALT). In the end I decided it was better to go for 
% statistcal power so I'm selecting a minimum number of trials for each 
% matching outcome. The function then tops up any remaining rows randomly.

[betHigh] = balanceOutcomes(betHigh, reelInfo);
[betLow] = balanceOutcomes(betLow, reelInfo);

% ------------------------------------------------------------------------
% Summarise outcomes on this iteration:
% ------------------------------------------------------------------------

% Count the occurance of each outcome
[C, ~, ic] = unique(betHigh.multiplier);
H = [C, accumarray(ic, 1)];
H = transpose(H);
H = H(2, :);

[C, ia, ic] = unique(betLow.multiplier);
L = [C, accumarray(ic, 1)];
L = transpose(L);
L = L(2, :);

% Add all to summary Table:
summaryTable(i, :) = array2table([
    sum(betHigh.match), ...
    sum(betLow.match), ...
    sum((betHigh.multiplier * 10) - 90), ...
    sum((betLow.multiplier) - 9), ...
    reelInfo.credits + ((sum((betHigh.multiplier * 10) - 90)) + (sum((betLow.multiplier) - 9))), ...
    H, ...
    L]);

% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
% Save outcomes to file:
% ------------------------------------------------------------------------

output = struct('betHigh', betHigh, 'betLow', betLow, ...
                'outcomeSummary', summaryTable(i, :), ...
                'participantID', i);

filename = ['participant' num2str(i)];

save([fileInfo.input filename '.mat'], '-struct', 'output')

sprintf([filename ' complete'])

end

sprintf('Done')

