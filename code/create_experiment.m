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

repeatSymbols = 0;

[reelstrip] = generate_reelstrip(5, 3, repeatSymbols);

writematrix(reelstrip, 'config/reelstrip.csv')

% Generate Experiment Outcomes

n = 100; % Number of experiments to generate (sample size plus dropout).

nTrials = 375; % Number of trials (length of experiment)

% How much was bet per line
lineBet = 10;

% How much was bet in total
totalBet = lineBet * 9;

% Set multipliers
multipliers = [4, 8, 10, 14, 77.7];

% Set credits
credits = 20000;

% Load in empty output table and add credits
[outputEmpty] = setup_output(nTrials);
outputEmpty.credits(1) = credits;

% Set up tables for each participant
experiment = struct('participant0', outputEmpty);

%% This is an interim solution. 
% I will probably want to come back and generate output for every
% participant.

% for i = 1:n
% experiment.(['participant' num2str(i)]) = outputEmpty;
% experiment.(['participant' num2str(i)]).participantID(:) = i;
% end


for i = 1:nTrials
        
        % Generate random reel symbols for each reel and centre (without replacement)
        outputEmpty(i, 11:17) = array2table([randperm(5, 3), randsample(1:5, 1), randperm(5, 3)]);
        
        % Find potential matches, sum and add to output
        [LIA, LOCB] = ismember(outputEmpty{i, 11:13}, outputEmpty{i, 15:17});
        outputEmpty.cueLines(i) = sum(LIA);
        
        % Check if win
        outputEmpty.match(i) = ismember(outputEmpty{i, 14}, outputEmpty{i, 11:13}(LIA));
        
        % Add data for wins (payout etc)
        if outputEmpty.match(i) == 1
            
            outputEmpty.multiplier(i) = randsample(multipliers, 1);
            outputEmpty.payout(i) = outputEmpty.multiplier(i) .* lineBet;
            outputEmpty.netOutcome(i) = outputEmpty.payout(i) - totalBet;
            
        else
            outputEmpty.netOutcome(i) = outputEmpty.netOutcome(i) - totalBet;
        end
        
        % Update credits
        outputEmpty.credits(i:height(outputEmpty)) = (outputEmpty.credits(i) + outputEmpty.netOutcome(i));
end

% Run the above twice to generate some dummy data.
experiment.participant0 = outputEmpty;
experiment.participant00 = outputEmpty;

save config/experiment.mat -struct experiment

% To load back just a single participant use:
ID = 'participant0';
load('experiment.mat', ID)













