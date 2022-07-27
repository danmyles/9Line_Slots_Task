function [i, FlipTime] = demo_lines(screenInfo, reelInfo, instructions, i, FlipTime)
% ----------------------------------------------------------------------
% demo_lines(screenInfo)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a grid on screen to containg symbols
%
% Position Numbers:
%   1   4   7
%   2   5   8
%   3   6   9
% ----------------------------------------------------------------------
% Input(s) :
% screenInfo
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : July 2022
% Project : 9_Line_Slots_Task
% Version : 2021a
% ----------------------------------------------------------------------

% We will through this display interatively. This will require a series of
% lists to iterate over:

% Text iterator
textList = {

'Centre line'; ...
'This diagonal'; ...
'And this diagonal'; ...
'Two above'; ...
'Two below'; ...
'Or one in any corner'; ...
'Or one in any corner'; ...
'Or one in any corner'; ...
'Or one in any corner';

};

% Position iterator
positionList = [
    
2, 5, 8; % 'Centre line'
1, 5, 9; % 'This diagonal'
3, 5, 7; % 'And this diagonal'
1, 5, 7; % 'Two above'
3, 5, 9; % 'Two below'
1, 5, 8; % 'Or one in any corner'
3, 5, 8; % 'Or one in any corner'
2, 5, 7; % 'Or one in any corner'
2, 5, 9; % 'Or one in any corner'

];

% Symbol iterator
symbolList = [
    
1; % 'Centre line'
2; % 'This diagonal'
3; % 'And this diagonal'
4; % 'Two above'
5; % 'Two below'
1; % 'Or one in any corner'
2; % 'Or one in any corner'
3; % 'Or one in any corner'
4; % 'Or one in any corner'

];

lines = 1;

    while lines <= 9

        % Reel Highlights:
        % Get position info
        highlight_pos = screenInfo.gridPos(positionList(lines, :)', :);

        % Print large rectangle
        Screen('FrameRect', screenInfo.window, reelInfo.colours(symbolList(lines), :)', highlight_pos(1, :)', screenInfo.gridPenWidthPixel.*3);
        Screen('FrameRect', screenInfo.window, reelInfo.colours(symbolList(lines), :)', highlight_pos(2, :)', screenInfo.gridPenWidthPixel.*3);
        Screen('FrameRect', screenInfo.window, reelInfo.colours(symbolList(lines), :)', highlight_pos(3, :)', screenInfo.gridPenWidthPixel.*3);

        % Trim with black centre (looks nice)
        highlight_pos = [highlight_pos(:, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(:, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos(1, :)', screenInfo.gridPenWidthPixel);
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos(2, :)', screenInfo.gridPenWidthPixel);
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos(3, :)', screenInfo.gridPenWidthPixel);

        % Draw grid
        draw_grid(screenInfo);

        % Draw symbols
        draw_shapes(screenInfo, reelInfo, screenInfo.splitpos(positionList(lines, :)', :), repmat(symbolList(lines), 1, 3));
        
        % Hollow out centre symbol:
        switch symbolList(lines)
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
        
        
        Screen('TextSize', screenInfo.window, reelInfo.payout.textSize);
        Screen('TextFont', screenInfo.window,'Arial', 1);
        
        % Draw line number instead of payout text
        DrawFormattedText(screenInfo.window, num2str(lines), 'center', 'center');
        
        Screen('TextSize', screenInfo.window, reelInfo.TextSize);
        Screen('TextFont', screenInfo.window, reelInfo.Font, 0);
        
        % Draw key prompt
        DrawFormattedText(screenInfo.window, instructions.prompt, 'center', screenInfo.ydot);

        % Draw title text
        DrawFormattedText(screenInfo.window, textList{lines}, 'center', (screenInfo.screenYpixels - screenInfo.ydot));
        
        % Exit function early when lines == 9
        if lines == 9
            return
        end
        
        % Flip to screen on next available frame
        FlipTime = Screen('Flip', screenInfo.window, FlipTime);
        
        [~, keyCode, ~] = KbWait(-1, 2);    % Wait for keypress
        
        % Code participant response
        % If participant pressed back we need to go back one step
        if any(find(keyCode) == KbName('LeftArrow'))
            if lines > 1 % Prevents 0 when i == 1
                lines = lines-1; 
            else
                % Lines == 0
                % Therefore return to main instructions and drop i by 1
                i = i - 1;
                
                return
            end
        % If participant pressed forward we continue
        elseif find(keyCode) == KbName('RightArrow')
            lines = lines+1;
        end
        
        % Schedule next screen flip
        
        % Approx Number of Frames Since last flip
        FramesSince = ceil((GetSecs() - FlipTime) / screenInfo.ifi);
        
        % Schedule Next Screen Flip
        FlipTime = FlipTime + (FramesSince * screenInfo.ifi) + (1.5 * screenInfo.ifi);

    end      

end
