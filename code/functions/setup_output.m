function [outputData] = setup_output()
% ----------------------------------------------------------------------
% setup_output()
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

%% How many trials are there in total?
% May want to fill this filled using information from trial structures
n = 500;

% Total number of trials
TrialN = [1:n]';

% Block Identifier (0 = Practice, 1 = 1 lines, 9 = 9 lines etc)
blockID = zeros(n, 1);

% Trial number within block
blockN = zeros(n, 1);

% Number of cued lines during reel highlight phase
cueLines = zeros(n, 1);

% Did a match occur? (0 = No, 1 = Yes)
match = zeros(n, 1);

% How much was bet in cents
totalBet = zeros(n, 1);

% What was payout (0:payout_max) in cents
payout = zeros(n, 1);

% net loss or payout (payout - bet) in cents
netOutcome = zeros(n, 1);

% Number of credits remaining (after spin)
credits = zeros(n, 1);

% Time between final stimulus onset and next trial input
PRPTime = zeros(n, 1);

% Symbol codes for each position
L1 = zeros(n, 1); % Top left
L2 = zeros(n, 1); % .
L3 = zeros(n, 1); % .
CS = zeros(n, 1); % Centre position
R1 = zeros(n, 1); % .
R2 = zeros(n, 1); % .
R3 = zeros(n, 1); % Bottom right

% Vector to fill when trial has been displayed
shown = zeros(n, 1);

outputData = table(TrialN, blockID, blockN, cueLines, match, totalBet, ...
    payout, credits, netOutcome, PRPTime, ...
    L1, L2, L3, CS, R1, R2, R3, ...
    shown);

%% Create trial and block structure



end

