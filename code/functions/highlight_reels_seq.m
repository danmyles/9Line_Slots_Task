function [] = highlight_reels_seq(screenInfo, reelInfo)
    % highlight_reels_seq(screenInfo, reelInfo)
    % intersect() finds the locations in which the values of the two
    % vectors are the same.
    % C contains the identities of the matched elements, in our case the
    % symbol or shape code.
    % IA contains indices for where these matches occur in argument A .
    % IB does the same for argument B.
    % 'stable' returns the indices in IA and IB in the order that they
    % occur in argument A
    
    % Reel 1
    A = reelInfo.outcome.dspSymbols(1:3, 1);
    
    % Reel 2
    B = reelInfo.outcome.dspSymbols(1:3, 3);
    
    [C] = intersect(A, B, 'stable');
    
    %% Send number of matched lines to outpuData
    
    % Print highlighted squares to screen one match at a time
    % Uses intersect output to select colour (C = colour) (IA/IB to index grid posistion)
    
    for i = 1:numel(C)
        
        Ai = ismember(A, C(i));
        Bi = ismember(B, C(i));
        
        % Reel 1 Highlights:
        highlight_pos = screenInfo.gridPos(1:3, :);
        Screen('FrameRect', screenInfo.window, reelInfo.colours(C(i), :)', highlight_pos(Ai, :)', screenInfo.gridPenWidthPixel.*3);
        % Place another square on the inside of the highlight square (looks nice)
        highlight_pos = [highlight_pos(Ai, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(Ai, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos', screenInfo.gridPenWidthPixel)
        
        % Reel 2 Highlights:
        highlight_pos = screenInfo.gridPos(7:9, :);
        Screen('FrameRect', screenInfo.window, reelInfo.colours(C(i), :)', highlight_pos(Bi, :)', screenInfo.gridPenWidthPixel.*3);
        % Place another square on the inside of the highlight square (looks nice)
        highlight_pos = [highlight_pos(Bi, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(Bi, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos', screenInfo.gridPenWidthPixel)
        
        draw_grid(screenInfo);
        draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
        
        % Flip to the screen
        Screen('Flip', screenInfo.window);
        
        % Event Marker
        
        % Wait time between highlighted reels
        WaitSecs(reelInfo.timing.highlight);
        
    end
    
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
    
    % Flip to the screen
    Screen('Flip', screenInfo.window);
    
end



