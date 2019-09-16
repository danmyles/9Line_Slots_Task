function [reelInfo] = spin(screenInfo, reelInfo)
    
    % Bump previous reelInfo.outcome to reelInfo.previous
    reelInfo.previous = reelInfo.outcome;
    
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
    
    % Send event marker (Outcome Stimulus)
    
    % Flip to the screen
    Screen('Flip', screenInfo.window);
  
end

