function [outputData] = highlight_win(screenInfo, reelInfo, outputData)
    
    % Get the positions for winning symbols
    highlight_pos = ismember(reelInfo.outcome.dspSymbols, reelInfo.outcome.centre);
    highlight_pos = screenInfo.gridPos(highlight_pos, :);
    
    % Print highlighted squares around win positions
    Screen('FrameRect', screenInfo.window, reelInfo.colours(reelInfo.outcome.centre, :)', highlight_pos', screenInfo.gridPenWidthPixel.*3);
    % Place another square on the inside of the highlight square (looks nice)
    highlight_pos = [highlight_pos(:, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(:, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
    Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos', screenInfo.gridPenWidthPixel)
    
    % Draw remaining junk to screen
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.All, nonzeros(reelInfo.outcome.dspSymbols));
    
    % Draw a small bordered shape to display text within:
    
    switch reelInfo.outcome.centre
        case 1
            Screen('FillOval', screenInfo.window, 0, CenterRectOnPoint(reelInfo.payout.rect, screenInfo.xCenter, screenInfo.yCenter));
            Screen('FillOval', screenInfo.window, 1, CenterRectOnPoint(reelInfo.payout.rect - reelInfo.payout.rect/10, screenInfo.xCenter, screenInfo.yCenter));
        case 2
            Screen('FillPoly', screenInfo.window, 0, get_dimensions(screenInfo, 5, 2, reelInfo.payout.rect))
            Screen('FillPoly', screenInfo.window, 1, get_dimensions(screenInfo, 5, 2, reelInfo.payout.rect - reelInfo.payout.rect/10))
        case 3
            Screen('FillPoly', screenInfo.window, 0, get_dimensions(screenInfo, 5, 3, reelInfo.payout.rect))
            Screen('FillPoly', screenInfo.window, 1, get_dimensions(screenInfo, 5, 3, reelInfo.payout.rect - reelInfo.payout.rect/10))
        case 4
            Screen('FillRect', screenInfo.window, 0, get_dimensions(screenInfo, 5, 4, reelInfo.payout.rect))
            Screen('FillRect', screenInfo.window, 1, get_dimensions(screenInfo, 5, 4, reelInfo.payout.rect - reelInfo.payout.rect/10))
        case 5
            Screen('FillPoly', screenInfo.window, 0, get_dimensions(screenInfo, 5, 5, reelInfo.payout.rect))
            Screen('FillPoly', screenInfo.window, 1, get_dimensions(screenInfo, 5, 5, reelInfo.payout.rect - reelInfo.payout.rect/10))
    end  
    
    % Set up text for payout display
    Screen('TextSize', screenInfo.window, reelInfo.payout.textSize);
    Screen('TextFont', screenInfo.window, 'Garamond');
    Screen('TextColor', screenInfo.window, screenInfo.black);
    payoutText = ['<b>', sprintf('%g', reelInfo.outcome.payout)];   

    % Draw winning amount to centre
    [cache] = DrawFormattedText2(payoutText, 'win', screenInfo.window, ...
        'sx', screenInfo.xCenter, 'sy', screenInfo.yCenter, ...
        'xalign','center','yalign','center','xlayout','center');   
     
end

