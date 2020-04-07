function [reelInfo, outputData] = spin(screenInfo, reelInfo, outputData)
    
    % Bump previous reelInfo.outcome to reelInfo.previous
    reelInfo.previous = reelInfo.outcome;
    
    reelInfo.outcome.trialNumber = reelInfo.outcome.trialNumber + 1;
    
    % Update stops
    [reelInfo] = update_stops(reelInfo);

    % Spin first reel.
    
    for i = set_spin(reelInfo, reelInfo.previous.stops(1), reelInfo.outcome.stops(1))'
        [reelInfo] = spin_L(screenInfo, reelInfo, i);
    end
    
    % Send event marker (Reel 1 - Stop)
    
    % Spin the second reel.
    
    for i = set_spin(reelInfo, reelInfo.previous.stops(2), reelInfo.outcome.stops(2))'
        [reelInfo] = spin_R(screenInfo, reelInfo, i);
    end
    
    % Send event marker (Reel 2 - Stop)
    
    % Wait ISI
    WaitSecs(0.5);
    
    if reelInfo.highlight == 2
        
    % Highlight Active Reels
    % [outputData] = highlight_reels(screenInfo, reelInfo, outputData);
    [outputData] = highlight_reels_seq(screenInfo, reelInfo, outputData); 
              
    end
       
    % Wait ISI
    WaitSecs(1);
    
    % Draw a fixation cross
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
    draw_fixation(screenInfo);
    
    % Send event marker (Fixation Cross)
    
    % Flip to the screen
    Screen('Flip', screenInfo.window);
       
    % Wait ISI
    WaitSecs(2.5);
    
    % Display outcome stimulus
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.All, nonzeros(reelInfo.outcome.dspSymbols));
    
    % Check if win
    if sum(nonzeros(ismember(reelInfo.outcome.dspSymbols, reelInfo.outcome.centre))) == 3
        
        if reelInfo.highlight ~= 0
        % Highlight winning grid positions and show payout amount
        highlight_win(screenInfo, reelInfo);
        end
        
        % Display payout
        display_payout(screenInfo, reelInfo);
        
        % Send information to outputData
        if reelInfo.outcome.trialNumber > 0
        outputData.match(reelInfo.outcome.trialNumber) = 1;
        outputData.payout(reelInfo.outcome.trialNumber) = reelInfo.outcome.payout;
        % Output netOutcome
        % outputData.netOutcome(reelInfo.outcome.trialNumber) = reelInfo.outcome.payout;
        end
        
    end
    
    % Send event marker (Outcome Stimulus)
    
    % Flip to the screen (outcome stimulus, payout, reel highlights)
    Screen('Flip', screenInfo.window);
  
end

