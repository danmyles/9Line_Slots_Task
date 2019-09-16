function [outputData] = setup_output()
    
    % This is a placeholder to fill out each row.
    % Ultimately will be filled using information from trial structures
    n = 100; 
    
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
        payout, netOutcome, PRPTime, ...
        L1, L2, L3, CS, R1, R2, R3, ...
        shown);
end

