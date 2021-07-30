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
% Last update : July 2021
% Project : 9_Line_Slots_Task
% Version : 2021a
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

n = 5; % Number of experiment files to generate (sample size plus dropout).

% Block structure
reelInfo.blocksize = 60; % Length of each block
reelInfo.blockN = 6;     % Number of blocks
reelInfo.binsize = 30;   % Number of events in each bin
% Number of bins:
reelInfo.binN = reelInfo.blockN * (reelInfo.blocksize / reelInfo.binsize); 

% Number of trials (length of experiment)
reelInfo.nTrials = reelInfo.blockN .* reelInfo.blocksize;

% Choose bet amounts (per line) on choice screen
reelInfo.lineBet = [10, 10];

% Set maximum number of choices for each condition to maintain 
% 50 / 50 betting choice
reelInfo.betA.n = reelInfo.nTrials/2;
reelInfo.betB.n = reelInfo.betA.n;

% Set multipliers
reelInfo.multipliers = [3, 5, 13, 15, 45; %  bet A
                        1, 7, 11, 17, 45]; % bet B

% Number of each outcome type per block
% CHECK FOR DELETION
% reelInfo.nMinEvent = 3 * 2;

% Minimum number of losses that should occur per choice condition
% CHECK FOR DELETION
% reelInfo.nMinLosses = reelInfo.nBetLow - numel(reelInfo.multipliers) * reelInfo.nMinEvent * (reelInfo.blockN / 2);

% Set credits
reelInfo.credits = 20000;

% Get reel length for easy access and relative scripting for length of the reelstrips
reelInfo.reel_length = length(reelInfo.reelstrip(:, 1));

% Save reelInfo to config directory
save([fileInfo.config 'reelInfo.mat'], 'reelInfo')

% ------------------------------------------------------------------------
% Create a summary to check all outputs:
% ------------------------------------------------------------------------

summaryTable = array2table(zeros(n, 17));
summaryTable.Properties.VariableNames = [...
    'matchA', 'matchB', 'totalA', 'totalB', 'totalNet', ... 
    strcat([0, string(reelInfo.multipliers(1, :))], "A"), ...
    strcat([0, string(reelInfo.multipliers(2, :))], "B")];

% -------------------------------------------------------------------------
%% Generate Experiment Outcomes
% -------------------------------------------------------------------------
% Loop over sample size to produce n x 2 tables of outcomes

% Likely to be fairly time consuming so maybe make a coffee or whatever.

for i = 1:n

% Load in empty outcome tables
% Generate an empty tables for outcomes
[~, betA, betB] = setup_output(reelInfo, 360*2);

% In the end I decided it was better to go for statistcal power rather than
% letting outcomes genuinely vary randomly. So we are bucketing outcomes 
% into groups of reelInfo.binsize to ensure a reasonable balance of outcomes, but still 
% allowing for some variability. 
% See the fill_outcomeTable function for more info.

% Fill reel stops and symbols codes
betA = fill_outcomeTable(betA, reelInfo);
betB = fill_outcomeTable(betB, reelInfo);

% ------------------------------------------------------------------------
% Summarise outcomes on this iteration:
% ------------------------------------------------------------------------

% Count the occurance of each outcome
[C, ~, ic] = unique(betA.multiplier);
H = [C, accumarray(ic, 1)];
H = transpose(H);
H = H(2, :);

[C, ia, ic] = unique(betB.multiplier);
L = [C, accumarray(ic, 1)];
L = transpose(L);
L = L(2, :);

% Add all to summary Table:
% summaryTable(i, :) = array2table([
%     sum(betA.match), ...
%     sum(betB.match), ...
%     sum((betA.multiplier * reelInfo.lineBet(1)) - 9*reelInfo.lineBet(1)), ...
%     sum((betB.multiplier * reelInfo.lineBet(2)) - 9*reelInfo.lineBet(2)), ...
%     reelInfo.credits + ((sum((betA.multiplier * 10) - 90)) + (sum((betB.multiplier) - 9))), ...
%     H, ...
%     L]);

% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
% Save outcomes to file:
% ------------------------------------------------------------------------

output = struct('betA', betA, 'betB', betB, ...
                'outcomeSummary', summaryTable(i, :), ...
                'participantID', i);

filename = ['participant' num2str(i)];

save([fileInfo.input filename '.mat'], '-struct', 'output')

sprintf([filename ' complete'])

end

sprintf('Done')

