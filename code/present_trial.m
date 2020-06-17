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
    
    % ----------------------------------------------------------------------
    %% Update with next trial %%
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
    
    % ----------------------------------------------------------------------
    %% Spin reels
    % ----------------------------------------------------------------------
    
    % Wait ISI
    WaitSecs(0.5);
        
	% ----------------------------------------------------------------------
    %% Reel highlighting
    % ----------------------------------------------------------------------
    
    if reelInfo.highlight == 2 || reelInfo.highlight == 3
        
    % Highlight Active Reels
    % [outputData] = highlight_reels(screenInfo, reelInfo, outputData);
    [outputData] = highlight_reels_seq(screenInfo, reelInfo, outputData); 
              
    end
       
    % Wait ISI
    WaitSecs(1);
    
	% ----------------------------------------------------------------------
    %% Fixation cross
    % ----------------------------------------------------------------------
    
    % Draw a fixation cross
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
    draw_fixation(screenInfo);
    
   
    % Flip to the screen
    Screen('Flip', screenInfo.window);

    % Send event marker (Fixation Cross)
    
    % Wait ISI
    WaitSecs(2.5);
    
	% ----------------------------------------------------------------------    
    %% Outcome stimulus
    % ----------------------------------------------------------------------
    
     % Display outcome stimulus
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.All, nonzeros(reelInfo.outcome.dspSymbols));
    
    % Check if win
    if sum(nonzeros(ismember(reelInfo.outcome.dspSymbols, reelInfo.outcome.centre))) == 3
        
        win = 1;
        
        if reelInfo.highlight == 1 || reelInfo.highlight == 2
        % Highlight winning grid positions and show payout amount
        highlight_win(screenInfo, reelInfo);
        end
        
        % Display payout
        draw_payout(screenInfo, reelInfo, win);
        
        % Send information to outputData
        if reelInfo.outcome.trialNumber > 0
        outputData.match(reelInfo.outcome.trialNumber) = 1;
        outputData.payout(reelInfo.outcome.trialNumber) = reelInfo.outcome.payout;
        % Output netOutcome
        % outputData.netOutcome(reelInfo.outcome.trialNumber) = reelInfo.outcome.payout;
        end
    else
        
        % Loss
        win = 0;
        
        % Display payout shape, but not text
        draw_payout(screenInfo, reelInfo, win);
        
    end
      
    % Flip to the screen (outcome stimulus, payout, reel highlights)
    Screen('Flip', screenInfo.window);
    
    % Send event marker (Outcome Stimulus)
    
    % Update outputData w/ 'shown'
       
	% ----------------------------------------------------------------------    
    %% Prompt next trial
    % ----------------------------------------------------------------------
        
 end

 
 
 
 
 
 
 