function [] = demo_lines(screenInfo, reelInfo, instructions)
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
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
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


    for i = 1:9

        % Reel Highlights:
        % Get position info
        highlight_pos = screenInfo.gridPos(positionList(i, :)', :);

        % Print large rectangle
        Screen('FrameRect', screenInfo.window, reelInfo.colours(symbolList(i), :)', highlight_pos(1, :)', screenInfo.gridPenWidthPixel.*3);
        Screen('FrameRect', screenInfo.window, reelInfo.colours(symbolList(i), :)', highlight_pos(2, :)', screenInfo.gridPenWidthPixel.*3);
        Screen('FrameRect', screenInfo.window, reelInfo.colours(symbolList(i), :)', highlight_pos(3, :)', screenInfo.gridPenWidthPixel.*3);

        % Trim with black centre (looks nice)
        highlight_pos = [highlight_pos(:, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(:, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos(1, :)', screenInfo.gridPenWidthPixel);
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos(2, :)', screenInfo.gridPenWidthPixel);
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos(3, :)', screenInfo.gridPenWidthPixel);

        % Draw grid
        draw_grid(screenInfo);

        % Draw symbols
        draw_shapes(screenInfo, reelInfo, screenInfo.splitpos(positionList(i, :)', :), repmat(symbolList(i), 1, 3));

        % Draw any key text
        DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);

        % Draw title text
        DrawFormattedText(screenInfo.window, textList{i}, 'center', (screenInfo.screenYpixels - screenInfo.ydot));

        Screen('Flip', screenInfo.window);

        KbWait(-1, 2);

    end      

end
