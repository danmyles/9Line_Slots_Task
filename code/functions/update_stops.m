function [reelInfo] = update_stops(reelInfo)
    % ----------------------------------------------------------------------
    % update_stops()
    % ----------------------------------------------------------------------
    % Goal of the function :
    % This function randomly draws a reel postion at which to stop. This
    % number is used to index reelstrip1 and reelstrip2 to select the symbols
    % to be draw to the screen.
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
    % reelInfo ? takes the reelstrips as input
    % ----------------------------------------------------------------------
    % Output(s):
    % reelInfo - provides updated symbol positions to sym_shape
    % ----------------------------------------------------------------------
    % Function created by Dan Myles (dan.myles@monash.edu)
    % Last update : August 2019
    % Project : 9_Line_Slots_Task
    % Version : 2019a
    % ----------------------------------------------------------------------
    
    % Draw a payout amount (if win occurs)
    reelInfo.outcome.payout = randsample(reelInfo.payout.amounts, 1);
    
    % Draw a random position to index each reelstrip
    reelInfo.outcome.stops(1:2) = randsample(reelInfo.reel_length, 2, true);
    
    % Draw a random symbol (1:5) to display at centre position
    reelInfo.outcome.centre = randsample(1:5, 1, true);
       
    % Find all indices for above and below the stops on reel 1 & 2
    % Then update reel information
    for i = [1, 2]
        switch reelInfo.outcome.stops(i)
            case 1
                reelInfo.outcome.allstops(:, i) = [reelInfo.reel_length, 1, 2];
            case reelInfo.reel_length
                reelInfo.outcome.allstops(:, i) = [reelInfo.reel_length - 1, reelInfo.reel_length, 1];
            otherwise
                reelInfo.outcome.allstops(:, i) = [reelInfo.outcome.stops(i) - 1, ...
                    reelInfo.outcome.stops(i), ...
                    reelInfo.outcome.stops(i) + 1];
        end
    end
    
   % Fill out sym_shape from reel w/ allstops
     reelInfo.outcome.dspSymbols(:, 1) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 1), 1);
     reelInfo.outcome.dspSymbols(2, 2) = reelInfo.outcome.centre;
     reelInfo.outcome.dspSymbols(:, 3) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 2), 2);
          
end