function [reelInfo] = update_stops(screenInfo, reelInfo)
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

    for i = 1:3 % i Begins as the reel number
        switch i % i will be either 1, 2, or 3
            case 1 % Fill out reel 1
                
                % Draw a random position to index reelstrip 1
                reelInfo.stops(1) = randsample(reelInfo.reel_length, 1, true);
                
                % We will use this stop value to index a position on the
                % the reelstrip. We can then use this position to find the
                % symbol at the stop position, as well as above and below
                % the centre. However, this will cause issues if we select the
                % 1st or nth position on the reelstrip. So we need to build
                % a switch statement to deal with these exceptions.
                
                switch reelInfo.stops(1)
                    case reelInfo.reel_length % i.e. final position
                        i = [reelInfo.stops(1)-1, reelInfo.stops(1), 1];
                    case 1 % i.e. 1st position
                        i = [reelInfo.reel_length, 1, reelInfo.stops(1)+1];
                    otherwise
                        % Use i to subset one above and below stop position
                        i = reelInfo.stops(1)-1:reelInfo.stops(1)+1;
                end
                              
                reelInfo.allstops1 = i;
              
                % Fill out sym_shape from reel w/ subset
                reelInfo.sym_shape(1:3) = reelInfo.reelstrip1(i);
 
                % Add Y positions of symbols to reelstrip so we can use
                % this as starting information for the reel spin
                reelInfo.reelstrip1(i, 3) = screenInfo.splitposY';
                
            case 2 % Randomly draw a symbol for centre reel
                reelInfo.stops(2) = randsample(1:5, 1, true);
                reelInfo.sym_shape(5) = reelInfo.stops(2);
                
            case 3 % Fill out reel 2
                
                % Draw a random stop position to index reelstrip 2
                reelInfo.stops(3) = randsample(reelInfo.reel_length, 1, true);
                                
                % Subset one above and below stop position. Switch
                % statement as before to prevent us trying to select the
                % n + 1 position or 0th position.
                
                switch reelInfo.stops(3)
                    case reelInfo.reel_length % i.e. final position
                        i = [reelInfo.stops(3)-1, reelInfo.stops(3), 1];
                    case 1 % i.e. 1st position
                        i = [reelInfo.reel_length, 1, reelInfo.stops(3)+1];
                    otherwise
                        % Use i to subset one above and below stop position
                        i = reelInfo.stops(3)-1:reelInfo.stops(3)+1;
                end
                
                reelInfo.allstops2 = i;
                
                % Fill out sym_shape from reel w/ subset
                reelInfo.sym_shape(7:9) = reelInfo.reelstrip2(i);
                
                % Add Y positions of symbols to reelstrip so we can use
                % this as starting information for the reel spin
                reelInfo.reelstrip2(i, 3) = screenInfo.splitposY';
        end
    end
end