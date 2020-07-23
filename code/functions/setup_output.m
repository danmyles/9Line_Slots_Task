function [outputData] = setup_output(nTrials)
% ----------------------------------------------------------------------
% setup_output(nTrials)
% ----------------------------------------------------------------------
% Goal of the function :
%  - Define total trials
%  - Create outputData table and pre-fill with zeros (preallocate)
%  — Allow the user to pre-allocate the structure of the experiment
% ----------------------------------------------------------------------
% Input(s) :
% NONE
% ----------------------------------------------------------------------
% Output(s):
% outputData — table
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 7th April 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------

% Participant Identifier
participantID = zeros(nTrials, 1);

% Total number of trials
TrialN = [1:nTrials]';

% Block Identifier (0 = Practice, 9 = 9 lines etc)
blockID = zeros(nTrials, 1);

% Trial number within block
blockN = zeros(nTrials, 1);

% Number of cued lines during reel highlight phase ie potential wins
cueLines = zeros(nTrials, 1);

% Did a winning match occur? (0 = No, 1 = Yes)
match = zeros(nTrials, 1);

% Multiplier (if win)
multiplier = zeros(nTrials, 1);

% What was payout (0:payout_max) in cents
payout = zeros(nTrials, 1);

% net loss or payout (payout - bet) in cents
netOutcome = zeros(nTrials, 1);

% Number of credits remaining (after spin)
credits = zeros(nTrials, 1);

% Time between final stimulus onset and next trial input
PRP = zeros(nTrials, 1);

% Duration of each reel spins
LDuration = zeros(nTrials, 1);
RDuration = zeros(nTrials, 1);

% When did trial begin
BeginTime = zeros(nTrials, 1);

% When was outcome presented
CSTime = zeros(nTrials, 1);

% Reel Stoping Indices
LStop = zeros(nTrials, 1);
RStop = zeros(nTrials, 1);

% Symbol codes for each position
L1 = zeros(nTrials, 1); % Top left
L2 = zeros(nTrials, 1); % .
L3 = zeros(nTrials, 1); % .
CS = zeros(nTrials, 1); % Centre position
R1 = zeros(nTrials, 1); % .
R2 = zeros(nTrials, 1); % .
R3 = zeros(nTrials, 1); % Bottom right

% Length of time take to make betChoice
BetChoiceRT = zeros(nTrials, 1);

% Participant choice to bet high/bet low
betChoice = zeros(nTrials, 1);

% betChoice * nLines
totalBet = zeros(nTrials, 1);

% Vector to fill when trial has been displayed
shown = zeros(nTrials, 1);

outputData = table(... 
    participantID, TrialN, blockID, blockN, ...   % Exp Info
    LStop, RStop, L1, L2, L3, CS, R1, R2, R3, ... % Outcome Display Info
    cueLines, match, ...                          % Win/Loss
    betChoice, totalBet, multiplier, payout, netOutcome, credits, ... % Bet Info
    shown, BetChoiceRT, BeginTime, LDuration, RDuration, CSTime, PRP);% Post Display Info

end

