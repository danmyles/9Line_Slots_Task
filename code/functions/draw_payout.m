function [outputData] = draw_payout(screenInfo, reelInfo, win, outputData)
      
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
    
    % Draw text if a win occured (else skip)
    
    if win == 1
    
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
    
end

