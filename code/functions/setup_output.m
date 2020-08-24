function [outputEmpty, betHigh, betLow] = setup_output(reelInfo, nTrials)
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

% ---- Trial Info: ----

% Allow user to override size. Otherwise use reelInfo.nTrials
if ~exist('nTrials')
    nTrials = reelInfo.nTrials;
end

% Participant Identifier
participantID = zeros(nTrials, 1);

% Total number of trials
TrialN = [1:nTrials]';

% Block Identifier (Will probably run in blocks of 50 or so with breaks)
blockID = zeros(nTrials, 1);

% Trial number within block
blockN = zeros(nTrials, 1);

% ---- Reel stops and symbols ---- 

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

% Number of cued lines during reel highlight phase ie potential wins
cueLines = zeros(nTrials, 1);

% Did a winning match occur? (0 = No, 1 = Yes)
match = zeros(nTrials, 1);

% ---- Outcome and Betting Info ---- 

% Participant choice to bet high/bet low
betChoice = zeros(nTrials, 1);

% betChoice * nLines
totalBet = zeros(nTrials, 1);

% Multiplier (if win)
multiplier = zeros(nTrials, 1);

% What was the payout in credits
payout = zeros(nTrials, 1);

% net outcome (payout - bet) in credits
netOutcome = zeros(nTrials, 1);

% Number of credits remaining (after bet)
credits = zeros(nTrials, 1);

% ---- Timing Info ----

% Vector to fill when trial has been displayed
shown = zeros(nTrials, 1);

% Time of Bet Choice Screen flip
BetChoiceSFT = zeros(nTrials, 1);

% Length of time take to make betChoice
BetChoiceRT = zeros(nTrials, 1);

% Time of 9lST display screen flip (show reels)
ReelSFT = zeros(nTrials, 1);

% Duration of each reel spin
LStopSF = zeros(nTrials, 1);
RStopSF = zeros(nTrials, 1);

% Reel highlight timing
HighlightEnd = zeros(nTrials, 1);

% When was outcome presented
FCTime = zeros(nTrials, 1);

% When was outcome presented
CSTime = zeros(nTrials, 1);

% Time between final stimulus onset and next trial input
PRP = zeros(nTrials, 1);

% Time at trial end.
TrialEnd = zeros(nTrials, 1);

% ------------------------------------------------------------------------
% Add all of above into empty table to collect data
% ------------------------------------------------------------------------
outputEmpty = table(... 
    participantID, TrialN, blockID, blockN, ...   % Exp Info
    LStop, RStop, L1, L2, L3, CS, R1, R2, R3, ... % Outcome Display Info
    cueLines, match, ...                          % Win/Loss
    betChoice, totalBet, multiplier, payout, netOutcome, credits, ...  % Bet Info
    shown, BetChoiceSFT, BetChoiceRT, ReelSFT, LStopSF, RStopSF, ... 
    HighlightEnd, FCTime, CSTime, PRP, TrialEnd); % Post Display Info

% Outcome Tables
betHigh = table(LStop, RStop, L1, L2, L3, CS, R1, R2, R3, cueLines, match, multiplier);
betLow  = table(LStop, RStop, L1, L2, L3, CS, R1, R2, R3, cueLines, match, multiplier);

end
