function [] = draw_payout(screenInfo, reelInfo)
    
    % Draw a small bordered shape to display text within:    
    switch reelInfo.outcome.centre
        case 1
            Screen('FillOval', screenInfo.window, 1, CenterRectOnPoint(reelInfo.payout.rect, screenInfo.xCenter, screenInfo.yCenter));
            %Screen('FillOval', screenInfo.window, 1, CenterRectOnPoint(reelInfo.payout.small, screenInfo.xCenter, screenInfo.yCenter));
        case 2
            Screen('FillPoly', screenInfo.window, 1, get_dimensions(screenInfo, 5, 2, reelInfo.payout.rect))
            %Screen('FillPoly', screenInfo.window, 1, get_dimensions(screenInfo, 5, 2, reelInfo.payout.small))
        case 3
            Screen('FillPoly', screenInfo.window, 1, get_dimensions(screenInfo, 5, 3, reelInfo.payout.rect))
            %Screen('FillPoly', screenInfo.window, 1, get_dimensions(screenInfo, 5, 3, reelInfo.payout.small))
        case 4
            Screen('FillRect', screenInfo.window, 1, get_dimensions(screenInfo, 5, 4, reelInfo.payout.rect))
            %Screen('FillRect', screenInfo.window, 1, get_dimensions(screenInfo, 5, 4, reelInfo.payout.small))
        case 5
            Screen('FillPoly', screenInfo.window, 1, get_dimensions(screenInfo, 5, 5, reelInfo.payout.rect))
            %Screen('FillPoly', screenInfo.window, 1, get_dimensions(screenInfo, 5, 5, reelInfo.payout.small))
    end  
    
    % Draw payout text
          
    % Set up text for payout display
    payoutText = sprintf('%g', reelInfo.outcome.payout);

    Screen('TextSize', screenInfo.window, reelInfo.payout.textSize);
    Screen('TextFont', screenInfo.window,'Arial', 1);

    % Draw winning amount to centre
    DrawFormattedText(screenInfo.window, payoutText, 'center', 'center');

    Screen('TextFont', screenInfo.window, reelInfo.Font, 0);
    Screen('TextSize', screenInfo.window, reelInfo.TextSize);
    
end

