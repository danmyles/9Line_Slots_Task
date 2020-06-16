 function [reelInfo] = present_trial(reelInfo)
    % ----------------------------------------------------------------------
    % [reelInfo] = present_trial(reelInfo)
    % ----------------------------------------------------------------------
    % Goal of the function :
    % This function uses the reelInfo iterator to draw out the next reel 
    % stop from the output file and present a trial. Reelstops are used to 
    % index reelstrip 1 and reelstrip 2 to select the symbols
    % to be draw to the screen.
    % Spin animation is handled seperately by the spin functions.
    % 
    %
    % This function then updates the reelInfo.sym_shape matrix with the symbol
    % identities. This information is then passed back to the update_reelInfo
    % function so that position information can be determined for each of the
    % symbols relative to their grid position
    %
    %
    % Symbol codes are loosely assigned by number of sides (exc diam)
    %
    %                       1 = circle
    %                       2 = diamond
    %                       3 = triangle
    %                       4 = rectangle
    %                       5 = pentagon
    %
    % ----------------------------------------------------------------------
    % Input(s) :
    % reelInfo: reelstrips, trialIndex
    % outputData: stop position, win/loss, payout amount
    % ----------------------------------------------------------------------
    % Output(s):
    % reelInfo: provides updated symbol positions to sym_shape
    % outputData: updates shown 0 -> 1
    % ----------------------------------------------------------------------
    % Function created by Dan Myles (dan.myles@monash.edu)
    % Last update : June 2020
    % Project : 9_Line_Slots_Task
    % Version : 2020a
    % ----------------------------------------------------------------------
      
    % Update reelInfo iterator
    reelInfo.trialIndex = reelInfo.trialIndex + 1 ;
    
    % Bump previous reelInfo.outcome to reelInfo.previous
    reelInfo.previous = reelInfo.outcome;
    
    % Get payout amount (if win occurs)
    reelInfo.outcome.payout = outputData.payout(reelInfo.trialIndex);
    
    % Get reel position to for each reelstrip
    reelInfo.outcome.stops(1) = outputData.LStop(reelInfo.trialIndex);
    reelInfo.outcome.stops(2) = outputData.RStop(reelInfo.trialIndex);
       
    % Get centre symbol
    reelInfo.outcome.centre = outputData.CS(reelInfo.trialIndex);
    
    % Find all indices for above and below the stops on reel 1 & 2
    % Then update reel information
    for i = [1, 2]
        reelInfo.outcome.allstops(:, i) = expandStopINDEX(reelInfo, reelInfo.outcome.stops(i), 1, 1);
    end
    
    % Fill out sym_shape from reel w/ allstops
    reelInfo.outcome.dspSymbols(:, 1) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 1), 1);
    reelInfo.outcome.dspSymbols(2, 2) = reelInfo.outcome.centre;
    reelInfo.outcome.dspSymbols(:, 3) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 2), 2);
    
 end

 
 
 
 
 
 
 