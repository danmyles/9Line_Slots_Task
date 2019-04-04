%% ASSIGN GRID POSITION 
% Set grid squares dimensions, this is used to define the size of 
% our rect and oval shapes. The coordinates define the top left and bottom 
% right coordinates of our grid rectangles. 0 0  refers to the top left
% corner of the screen, from there we can move the rectangles to a new
% position. 
% [top-left-x top-left-y bottom-right-x bottom-right-y].

%% SET SIZE OF GRID SQUARES
gridRect = windowRect;
gridRect(3) = gridRect(3) * .20;
gridRect(4) = gridRect(4) * .24;

%% Width of the grid lines.
penWidthPixels = 3;

% Scalar to align grid square locations across the x-axis.
% This is proportional to the x dimension of the grid squares - 
% penWidthline to prevent doubling up of edges.
X_adjust = gridRect(3) - penWidthPixels;
Y_adjust = gridRect(4) - penWidthPixels;


%% DAN CHECK THESE THE Y POSITION MAY NEED TO BE REVERSED...?
% Adjust screen split co-ordinates for penWidth (else they over lap) and
splitYpos = [screenYpixels * 0.5 - Y_adjust, screenYpixels * 0.5, screenYpixels * 0.5 + Y_adjust];
splitXpos = [screenXpixels * 0.5 - X_adjust, screenXpixels * 0.5, screenXpixels * 0.5 + X_adjust];


% SET UP reelInfo.grid
for i = 1:3
    for j = 1:3
        reelInfo.grid_position{j, i} = ...
            CenterRectOnPointd(gridRect, splitXpos(i), splitYpos(j))';
    end
end